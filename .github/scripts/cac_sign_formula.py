"""Write Formula/cac-sign.rb from cac-sign's uv.lock: the exact wheels it was tested with.

Usage: python3 .github/scripts/cac_sign_formula.py <cac-sign checkout at the release tag> <version> \
           Formula/cac-sign.rb [python minor, default 3.14]
Needs uv and the `packaging` module. Run it for each cac-sign release; it is not in the weekly bump.
The resource set is `uv export --frozen` filtered by markers for CPython on macOS arm64; each
resource is the lock's wheel for that Python (cpXY, then abi3, then pure), with the lock's sha256.
The main wheel comes from PyPI by default. Set CAC_SIGN_WHEEL_SOURCE=github to use the
wheel attached to the matching GitHub release, with its downloaded bytes hashed locally.
"""
import hashlib, json, re, subprocess, sys, tomllib, urllib.request, ssl, os
from packaging.markers import Marker

repo, version, out = sys.argv[1], sys.argv[2], sys.argv[3]
pyminor = sys.argv[4] if len(sys.argv) > 4 else "3.14"
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
    name, _, ver = req.strip().partition("==")
    if marker.strip() and not Marker(marker.strip()).evaluate(env):
        continue
    wanted[name.lower()] = ver

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
        elif plat == "any" and "py3" in pyt.split("."):
            rank = 2
        else:
            continue
        rank = (rank, 0 if "arm64" in plat else 1)
        if best is None or rank < best[0]:
            best = (rank, w)
    if best is None:
        raise SystemExit(f"no usable wheel for {pkg['name']} {pkg['version']} on {cp} arm64")
    return best[1]


resources = []
for name, ver in sorted(wanted.items()):
    pkg = lock[name]
    assert pkg["version"] == ver, (name, pkg["version"], ver)
    w = pick(pkg)
    resources.append((name, w["url"], w["hash"].split(":", 1)[1]))

ctx = ssl.create_default_context(cafile=os.environ.get("SSL_CERT_FILE"))
source = os.environ.get("CAC_SIGN_WHEEL_SOURCE", "pypi")
if source == "github":
    if not re.fullmatch(r"[0-9]+\.[0-9]+\.[0-9]+", version):
        raise SystemExit("GitHub wheel source requires a numeric release version")
    filename = f"cac_sign-{version}-py3-none-any.whl"
    url = f"https://github.com/Euda1mon1a/cac-sign/releases/download/v{version}/{filename}"
    with urllib.request.urlopen(url, context=ctx, timeout=60) as response:
        checksum = hashlib.sha256(response.read()).hexdigest()
    main = {"url": url, "filename": filename, "digests": {"sha256": checksum}}
elif source == "pypi":
    with urllib.request.urlopen(f"https://pypi.org/pypi/cac-sign/{version}/json", context=ctx, timeout=60) as response:
        meta = json.load(response)
    main = next(u for u in meta["urls"] if u["packagetype"] == "bdist_wheel")
else:
    raise SystemExit("CAC_SIGN_WHEEL_SOURCE must be pypi or github")

res_blocks = "\n".join(f'''  resource "{n}" do
    url "{u}"
    sha256 "{h}"
  end
''' for n, u, h in resources)

formula = f'''class CacSign < Formula
  include Language::Python::Virtualenv

  desc "Convert Word forms, detect fields, fill and CAC-sign PDFs"
  homepage "https://github.com/Euda1mon1a/cac-sign"
  url "{main["url"]}"
  sha256 "{main["digests"]["sha256"]}"
  license "MIT"

  depends_on arch: :arm64
  depends_on :macos
  depends_on "python@{pyminor}"

  # The exact wheels in cac-sign's uv.lock for Python {pyminor} on Apple silicon, so this installs
  # what the project tests and its security review covered. Several are compiled (cryptography,
  # pikepdf, pyobjc, python-pkcs11, lxml), and their pinned builds are what was tested.
  # Regenerate on each release with .github/scripts/cac_sign_formula.py.
{res_blocks}
  def install
    venv = virtualenv_create(libexec, "python{pyminor}", system_site_packages: false)
    wheels = buildpath/"wheels"
    wheels.mkpath
    resources.each {{ |r| cp r.cached_download, wheels/File.basename(r.url) }}
    cp cached_download, wheels/File.basename(stable.url)
    system "python{pyminor}", "-m", "pip", "--python=#{{venv.root}}/bin/python", "install",
           "--no-deps", "--no-index", "--no-compile", *wheels.children
    bin.install_symlink libexec/"bin/cac-sign"
  end

  def caveats
    <<~EOS
      To add the Finder Quick Actions ("CAC Sign" and "CAC Sign…") and your details for forms, run:
        cac-sign --setup
      DOCX conversion also needs LibreOffice installed in /Applications or on PATH.
    EOS
  end

  test do
    assert_match "usage: cac-sign", shell_output("#{{bin}}/cac-sign --help")
    assert_match "No signatures recorded yet", shell_output("#{{bin}}/cac-sign --history")
    system libexec/"bin/python", "-c",
           "import cac_sign_app as a; a._modules(); import cac_sign_editor, cac_sign_finder, pdf_readers, document_inputs, field_detection, Quartz, Security"
  end
end
'''
open(out, "w").write(formula)
print(f"{len(resources)} resources; main {main['filename']} from {source}")
