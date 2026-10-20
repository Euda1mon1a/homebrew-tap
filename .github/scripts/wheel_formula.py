"""Write a Formula/<name>.rb that installs a Python app from the exact wheels in its uv.lock.

Usage: python3 .github/scripts/wheel_formula.py <formula> <project checkout at the release tag> <version> \
           Formula/<formula>.rb [python minor, default 3.14]
Needs uv and the `packaging` module. Run it for each release of that project; it is not in the weekly bump.
The resource set is `uv export --frozen` filtered by markers for CPython on macOS arm64; each
resource is the lock's wheel for that Python (cpXY, then abi3, then pure), with the lock's sha256.
The project's own wheel comes from PyPI, so publish there first.
"""
import json, subprocess, sys, tomllib, urllib.request, ssl, os
from packaging.markers import Marker

# Per-formula text. Everything else (resources, install) is shared.
FORMULAS = {
    "cac-sign": {
        "dist": "cac-sign",
        "class": "CacSign",
        "desc": "Fill, CAC-sign and verify PDFs on a Mac, with Finder Quick Actions",
        "license": "MIT",
        "depends": [],
        "comment": """\
  # The exact wheels in cac-sign's uv.lock for Python {py} on Apple silicon, so this installs
  # what the project tests and its security review covered. Several are compiled (cryptography,
  # pikepdf, pyobjc, python-pkcs11, lxml), and their pinned builds are what was tested.
  # Regenerate on each release with .github/scripts/cac_sign_formula.py.
""",
        "link": """\
    bin.install_symlink libexec/"bin/cac-sign"
""",
        "caveats": """\
  def caveats
    <<~EOS
      To add the Finder Quick Actions ("CAC Sign" and "CAC Sign…") and your details for forms, run:
        cac-sign --setup
    EOS
  end
""",
        "test": """\
  test do
    assert_match "usage: cac-sign", shell_output("#{bin}/cac-sign --help")
    assert_match "No signatures recorded yet", shell_output("#{bin}/cac-sign --history")
    system libexec/"bin/python", "-c",
           "import cac_sign_app as a; a._modules(); import cac_sign_editor, cac_sign_finder, pdf_readers, Quartz, Security"
  end
""",
    },
    "marquetry": {
        "dist": "marquetry-svg",
        "class": "Marquetry",
        "desc": "Turn a flat logo into one-path-per-colour SVGs for multi-colour 3D printing",
        "license": "GPL-3.0-or-later",
        "depends": ['depends_on "maturin" => :build', 'depends_on "rust" => :build'],
        # vtracer's wheel is a Rust dylib with no header room, so brew can't rewrite its install
        # name; built here from the locked sdist with room to spare.
        "from_source": ["vtracer"],
        "comment": """\
  # The exact wheels in marquetry's uv.lock for Python {py} on Apple silicon. Several are
  # compiled (numpy, scipy, scikit-learn, pillow, vtracer, PyQt6 and its bundled Qt), and their
  # pinned builds are what the project tests. Regenerate on each release with
  # .github/scripts/wheel_formula.py.
""",
        "link": """\
    # Qt's SQL drivers link to databases that aren't installed (PostgreSQL, Mimer, ODBC), and
    # marquetry doesn't use QtSql, so they go rather than fail the linkage audit.
    rm_r libexec.glob("lib/python*/site-packages/PyQt6/Qt6/plugins/sqldrivers")
    bin.install_symlink libexec/"bin/marquetry"
""",
        "caveats": "",
        "test": """\
  test do
    assert_match version.to_s, shell_output("#{bin}/marquetry --version")
    # A real trace: a red ring on white. vtracer's Python 3.14 build crashes on keyword
    # arguments, so this is the check that catches a regression there.
    system libexec/"bin/python", "-c", <<~PY
      from PIL import Image, ImageDraw
      im = Image.new("RGB", (240, 240), "white")
      ImageDraw.Draw(im).ellipse((40, 40, 200, 200), outline=(200, 30, 30), width=30)
      im.save("ring.png")
    PY
    system bin/"marquetry", "coaster", "ring.png", "--palette", "C81E1E"
    design = (testpath/"ring.png-coaster/ring-design.svg").read
    assert_equal 1, design.scan("<path").length
    assert_path_exists testpath/"ring.png-coaster/ring-coaster.svg"
    system libexec/"bin/python", "-c", "from PyQt6 import QtSvg, QtWidgets; import marquetry_svg.gui"
  end
""",
    },
    "object-healer": {
        "dist": "object-healer",
        "class": "ObjectHealer",
        "desc": "Repair meshes for 3D printing in headless Blender",
        "license": "GPL-3.0-or-later",
        "depends": [],
        "comment": """\
  # The exact wheels in object-healer's uv.lock for Python {py} on Apple silicon (PyQt6 and its
  # bundled Qt are compiled). Floater removal (the PyPI `scan` extra, PyMeshLab) is not included.
  # Regenerate on each release with .github/scripts/wheel_formula.py.
""",
        "link": """\
    # Qt's SQL drivers link to databases that aren't installed (PostgreSQL, Mimer, ODBC), and
    # object-healer doesn't use QtSql, so they go rather than fail the linkage audit.
    rm_r libexec.glob("lib/python*/site-packages/PyQt6/Qt6/plugins/sqldrivers")
    bin.install_symlink libexec/"bin/object-healer"
""",
        "caveats": """\
  def caveats
    <<~EOS
      ObjectHealer runs the repair in Blender 4.0 or later, which it finds in /Applications:
        brew install --cask blender
    EOS
  end
""",
        "test": """\
  test do
    assert_match version.to_s, shell_output("#{bin}/object-healer --version")
    (testpath/"box.obj").write "v 0 0 0\\nv 1 0 0\\nv 0 1 0\\nf 1 2 3\\n"
    output = shell_output("BLENDER=/nonexistent #{bin}/object-healer heal box.obj -o box.stl 2>&1", 2)
    assert_match "not an executable file", output
    system libexec/"bin/python", "-c", "from PyQt6 import QtWidgets; import object_healer.gui"
  end
""",
    },
}

name, repo, version, out = sys.argv[1:5]
pyminor = sys.argv[5] if len(sys.argv) > 5 else "3.14"
cfg = FORMULAS[name]
cp = "cp" + pyminor.replace(".", "")
env = {"sys_platform": "darwin", "platform_system": "Darwin", "os_name": "posix", "platform_machine": "arm64",
       "platform_python_implementation": "CPython", "implementation_name": "cpython",
       "python_version": pyminor, "python_full_version": pyminor + ".0"}

exported = subprocess.run(["uv", "export", "--frozen", "--no-dev", "--no-emit-project", "--no-hashes",
                           "--format", "requirements-txt"], cwd=repo, capture_output=True, text=True, check=True).stdout
wanted = {}
for line in exported.splitlines():
    line = line.strip()
    if not line or line.startswith("#"):
        continue
    req, _, marker = line.partition(";")
    pkgname, _, ver = req.strip().partition("==")
    if marker.strip() and not Marker(marker.strip()).evaluate(env):
        continue
    wanted[pkgname.lower()] = ver

lock = {p["name"].lower(): p for p in tomllib.load(open(os.path.join(repo, "uv.lock"), "rb"))["package"]}


def pick(pkg):
    best = None
    for w in pkg.get("wheels", []):
        fn = w["url"].rsplit("/", 1)[1]
        pyt, abi, plat = fn[:-4].split("-")[-3:]
        if abi.endswith("t"):
            continue  # free-threaded build
        if not (plat == "any" or ("macosx" in plat and ("arm64" in plat or "universal2" in plat))):
            continue
        if pyt == cp and abi == cp:
            rank = 0
        elif abi == "abi3" and int(pyt[2:]) <= int(cp[2:]):
            rank = 1
        elif abi == "none" and "py3" in pyt.split("."):
            rank = 2  # pure, or py3-none built for macOS (e.g. pyqt6-qt6, which bundles Qt)
        else:
            continue
        rank = (rank, 0 if "arm64" in plat else 1)
        if best is None or rank < best[0]:
            best = (rank, w)
    if best is None:
        raise SystemExit(f"no usable wheel for {pkg['name']} {pkg['version']} on {cp} arm64")
    return best[1]


from_source = cfg.get("from_source", [])
resources = []
for pkgname, ver in sorted(wanted.items()):
    pkg = lock[pkgname]
    assert pkg["version"] == ver, (pkgname, pkg["version"], ver)
    w = pkg["sdist"] if pkgname in from_source else pick(pkg)
    resources.append((pkgname, w["url"], w["hash"].split(":", 1)[1]))

ctx = ssl.create_default_context(cafile=os.environ.get("SSL_CERT_FILE"))
meta = json.load(urllib.request.urlopen(f"https://pypi.org/pypi/{cfg['dist']}/{version}/json", context=ctx))
main = next(u for u in meta["urls"] if u["packagetype"] == "bdist_wheel")

res_blocks = "\n".join(f'''  resource "{n}" do
    url "{u}"
    sha256 "{h}"
  end
''' for n, u, h in resources)
depends = "".join(f"  {d}\n" for d in cfg["depends"])
if from_source:
    names = ", ".join(f'"{n}"' for n in from_source)
    copy_block = (f"    from_source = [{names}]\n"
                  "    resources.each do |r|\n"
                  "      next if from_source.include?(r.name)\n\n"
                  "      cp r.cached_download, wheels/File.basename(r.url)\n"
                  "    end\n"
                  '    ENV.append "RUSTFLAGS", "-C link-arg=-Wl,-headerpad_max_install_names"\n'
                  "    from_source.each do |name|\n"
                  "      resource(name).stage do\n"
                  "        # vtracer ships its Cargo.lock, so cargo builds the locked crate versions and checksums.\n"
                  "        # Not --locked: newer cargo rewrites the lock file's format, which --locked refuses.\n"
                  f'        system "maturin", "build", "--release", "--interpreter", "python{pyminor}", "--out", wheels\n'
                  "      end\n"
                  "    end\n")
else:
    copy_block = "    resources.each { |r| cp r.cached_download, wheels/File.basename(r.url) }\n"
caveats = "\n" + cfg["caveats"] if cfg["caveats"] else ""

formula = f'''class {cfg["class"]} < Formula
  include Language::Python::Virtualenv

  desc "{cfg["desc"]}"
  homepage "https://github.com/Euda1mon1a/{cfg.get("repo", name)}"
  url "{main["url"]}"
  sha256 "{main["digests"]["sha256"]}"
  license "{cfg["license"]}"

  depends_on arch: :arm64
{depends}  depends_on :macos
  depends_on "python@{pyminor}"

{cfg["comment"].format(py=pyminor)}{res_blocks}
  def install
    venv = virtualenv_create(libexec, "python{pyminor}", system_site_packages: false)
    wheels = buildpath/"wheels"
    wheels.mkpath
{copy_block}    cp cached_download, wheels/File.basename(stable.url)
    system "python{pyminor}", "-m", "pip", "--python=#{{venv.root}}/bin/python", "install",
           "--no-deps", "--no-index", "--no-compile", *wheels.children
{cfg["link"]}  end
{caveats}
{cfg["test"]}end
'''
open(out, "w").write(formula)
print(f"{len(resources)} resources; main {main['filename']}")
