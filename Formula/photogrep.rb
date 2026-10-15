class Photogrep < Formula
  include Language::Python::Virtualenv

  desc "Search Apple Photos by what is in the picture and find where an image came from"
  homepage "https://github.com/Euda1mon1a/photogrep"
  url "https://files.pythonhosted.org/packages/08/87/11e4f80741f55fb84b9247bd8376a643c3a35c7c9b208b2829d7bff4f884/photogrep-0.1.1.tar.gz"
  sha256 "b28747e151369301c34d7df48f07cbc094395964e5c7e101daff1f07814cf9bc"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "libheif"
  depends_on :macos
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.14"

  resource "pillow-heif" do
    url "https://files.pythonhosted.org/packages/44/c1/82145984920ca055675af2c2795bd30da6f7461215c41f3c1eacb3d66353/pillow_heif-1.8.1.tar.gz"
    sha256 "521ebffb8a181d56c3904e5a61f20903edee0d9d3275967b8fb345f866215c06"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "photogrep #{version}", shell_output("#{bin}/photogrep --version")
    # exit status 2 is an error; 1 would mean "nothing found"
    output = shell_output("#{bin}/photogrep search --library #{testpath}/none.photoslibrary 2>&1", 2)
    assert_match "no Photos library", output
    system libexec/"bin/python", "-c", "import numpy, PIL, pillow_heif, photogrep.match"
  end
end
