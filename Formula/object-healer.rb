class ObjectHealer < Formula
  include Language::Python::Virtualenv

  desc "Repair meshes for 3D printing in headless Blender"
  homepage "https://github.com/Euda1mon1a/object-healer"
  url "https://files.pythonhosted.org/packages/f9/93/fc82e0a76b6e8d6d3e3820b2157c3b13494f2dd5ed93868773105e5992d4/object_healer-0.1.1-py3-none-any.whl"
  sha256 "8b00aacd387e2945545be9808a5ac5e925c63ff28ca41f03acf810883913a56b"
  license "GPL-3.0-or-later"

  depends_on arch: :arm64
  depends_on :macos
  depends_on "python@3.14"

  # The exact wheels in object-healer's uv.lock for Python 3.14 on Apple silicon (PyQt6 and its
  # bundled Qt are compiled). Floater removal (the PyPI `scan` extra, PyMeshLab) is not included.
  # Regenerate on each release with .github/scripts/wheel_formula.py.
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

  def install
    venv = virtualenv_create(libexec, "python3.14", system_site_packages: false)
    wheels = buildpath/"wheels"
    wheels.mkpath
    resources.each { |r| cp r.cached_download, wheels/File.basename(r.url) }
    cp cached_download, wheels/File.basename(stable.url)
    system "python3.14", "-m", "pip", "--python=#{venv.root}/bin/python", "install",
           "--no-deps", "--no-index", "--no-compile", *wheels.children
    # Qt's SQL drivers link to databases that aren't installed (PostgreSQL, Mimer, ODBC), and
    # object-healer doesn't use QtSql, so they go rather than fail the linkage audit.
    rm_r libexec.glob("lib/python*/site-packages/PyQt6/Qt6/plugins/sqldrivers")
    bin.install_symlink libexec/"bin/object-healer"
  end

  def caveats
    <<~EOS
      ObjectHealer runs the repair in Blender 4.0 or later, which it finds in /Applications:
        brew install --cask blender
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/object-healer --version")
    (testpath/"box.obj").write "v 0 0 0\nv 1 0 0\nv 0 1 0\nf 1 2 3\n"
    output = shell_output("BLENDER=/nonexistent #{bin}/object-healer heal box.obj -o box.stl 2>&1", 2)
    assert_match "not an executable file", output
    system libexec/"bin/python", "-c", "from PyQt6 import QtWidgets; import object_healer.gui"
  end
end
