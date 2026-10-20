class Marquetry < Formula
  include Language::Python::Virtualenv

  desc "Turn a flat logo into one-path-per-colour SVGs for multi-colour 3D printing"
  homepage "https://github.com/Euda1mon1a/marquetry"
  url "https://files.pythonhosted.org/packages/fc/ea/14ba8d83f751fd769f0ac66ffe6d8b7376304797acecca6d3048c44f5511/marquetry_svg-0.1.0-py3-none-any.whl"
  sha256 "8a1929893d402696bfff6267caaeda78c18bbfed61932a645457426897991e3f"
  license "GPL-3.0-or-later"

  depends_on arch: :arm64
  depends_on "maturin" => :build
  depends_on "rust" => :build
  depends_on :macos
  depends_on "python@3.14"

  # The exact wheels in marquetry's uv.lock for Python 3.14 on Apple silicon. Several are
  # compiled (numpy, scipy, scikit-learn, pillow, vtracer, PyQt6 and its bundled Qt), and their
  # pinned builds are what the project tests. Regenerate on each release with
  # .github/scripts/wheel_formula.py.
  resource "cloudpickle" do
    url "https://files.pythonhosted.org/packages/88/39/799be3f2f0f38cc727ee3b4f1445fe6d5e4133064ec2e4115069418a5bb6/cloudpickle-3.1.2-py3-none-any.whl"
    sha256 "9acb47f6afd73f60dc1df93bb801b472f05ff42fa6c84167d25cb206be1fbf4a"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/18/53/84099323c2ec4be98d935f63c033ac4151ee83836ca1050ede3b3aadf155/joblib-1.6.0-py3-none-any.whl"
    sha256 "3dbbf9f6e4b592a2357b854608e980fe6390d131d7a82f011a377ef2ebef7aba"
  end

  resource "narwhals" do
    url "https://files.pythonhosted.org/packages/d1/89/5d4c86da1130d9059681e5b6cd7645df5c10279a6a079c5c37dcb2cc6f3f/narwhals-2.27.1-py3-none-any.whl"
    sha256 "d057df13f5852b8e157596e82eb5e955fad267425df5e420e0ee9863da483b31"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/f3/49/fee7587c33ee35f7977f9051d7f2023d4e7246d62710c80f20c2361ea232/numpy-2.5.4-cp314-cp314-macosx_11_0_arm64.whl"
    sha256 "ffa6ce09a1c6a08e9667dd9c97aa0b14184e8d18f2a14b78b2a2328c9147f076"
  end

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/b5/f4/0bf6f1ac9ba7ee2ffe9914aeb410a1035a0c1a3c42f122388d7fc950bc4b/pillow-13.0.0-cp314-cp314-macosx_11_0_arm64.whl"
    sha256 "d9b0a2bee3f3e03e9f29057aedb807dbf1e1d96ee1b9d0f422d9db6c8583271d"
  end

  resource "pyqt6" do
    url "https://files.pythonhosted.org/packages/33/44/fcd3dd3f64c83c96bf9bce76ec16cca64bd9b91702c3d08fd8e3dafc73d9/pyqt6-6.11.0-cp310-abi3-macosx_10_14_universal2.whl"
    sha256 "f7100bc7f72b12581ec479a733f4ad11b8002668e6786e8a445ab6f4d1c743d4"
  end

  resource "pyqt6-qt6" do
    url "https://files.pythonhosted.org/packages/a0/72/f49e11b46eaa887e1250658b9c038f13c654ca7478c7c904ada13bb5133e/pyqt6_qt6-6.11.2-py3-none-macosx_11_0_arm64.whl"
    sha256 "4f21ff2ffaacfb8a8df6ab1d619d0da7aa4e808e86f41b6daa1a7bff9c0d6eab"
  end

  resource "pyqt6-sip" do
    url "https://files.pythonhosted.org/packages/ef/52/2ff2181c360501fa530e2f223442946d0f7bc4ce8b58af42ed17cb0268e8/pyqt6_sip-13.13.0-cp314-cp314-macosx_10_15_universal2.whl"
    sha256 "10ed8841786fe1a26c72cef8de070a56a495388ab2938b8cffff87ac1a104044"
  end

  resource "scikit-learn" do
    url "https://files.pythonhosted.org/packages/9b/ed/d68115577c8b42b0442ebd8180945d4008880a33176094640e00b585128e/scikit_learn-1.9.1-cp314-cp314-macosx_12_0_arm64.whl"
    sha256 "8893bc6331f60f18d4ac75e12ed356e2dcf6a564bf767918b5b7ca54c8c8be49"
  end

  resource "scipy" do
    url "https://files.pythonhosted.org/packages/2a/49/59ea385dc3a62ff498ddf3cfff7c2b41b0f9f9d3c4122b3f1dcb6d6327fe/scipy-1.18.1-cp314-cp314-macosx_12_0_arm64.whl"
    sha256 "9554bcc6d715ee87a633a3cc8e7703c6628b100dd29cb8a2efc4c0533c7ff729"
  end

  resource "threadpoolctl" do
    url "https://files.pythonhosted.org/packages/43/3f/f88a53f60a472b46f4023f56d204dd7de33d34c5d2acbfa0d70a674e639e/threadpoolctl-3.7.0-py3-none-any.whl"
    sha256 "cd8b60b5641b45c67bbf73c64c843235fc2d8a480c87389f52f5dbee893b86be"
  end

  resource "vtracer" do
    url "https://files.pythonhosted.org/packages/e4/62/c3c23511ebe3d76dc679db0bb045dfd20ed3452bec12dcbbe8d655498a7d/vtracer-0.6.15.tar.gz"
    sha256 "f7f39943d1fc8e9dc82f5360a40e941aaf4c9166d8df30c3f6a2da8cc21dfc52"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14", system_site_packages: false)
    wheels = buildpath/"wheels"
    wheels.mkpath
    from_source = ["vtracer"]
    resources.each do |r|
      next if from_source.include?(r.name)

      cp r.cached_download, wheels/File.basename(r.url)
    end
    ENV.append "RUSTFLAGS", "-C link-arg=-Wl,-headerpad_max_install_names"
    from_source.each do |name|
      resource(name).stage do
        system "maturin", "build", "--release", "--locked", "--interpreter", "python3.14",
               "--out", wheels
      end
    end
    cp cached_download, wheels/File.basename(stable.url)
    system "python3.14", "-m", "pip", "--python=#{venv.root}/bin/python", "install",
           "--no-deps", "--no-index", "--no-compile", *wheels.children
    # Qt's SQL drivers link to databases that aren't installed (PostgreSQL, Mimer, ODBC), and
    # marquetry doesn't use QtSql, so they go rather than fail the linkage audit.
    rm_r libexec.glob("lib/python*/site-packages/PyQt6/Qt6/plugins/sqldrivers")
    bin.install_symlink libexec/"bin/marquetry"
  end

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
end
