class CacSign < Formula
  include Language::Python::Virtualenv

  desc "Fill, CAC-sign and verify PDFs on a Mac, with Finder Quick Actions"
  homepage "https://github.com/Euda1mon1a/cac-sign"
  url "https://files.pythonhosted.org/packages/da/5b/cb7fa9f9657220b92bfef048765382e565e3d7cefdf2968b235ea543a212/cac_sign-0.1.0-py3-none-any.whl"
  sha256 "b1f0e3784b64aec17d80b740142bc43fa8ffcfa2a68160125266142d7355e5aa"
  license "MIT"

  depends_on arch: :arm64
  depends_on :macos
  depends_on "python@3.14"

  # The exact wheels in cac-sign's uv.lock for Python 3.14 on Apple silicon, so this installs
  # what the project tests and its security review covered. Several are compiled (cryptography,
  # pikepdf, pyobjc, python-pkcs11, lxml), and their pinned builds are what was tested.
  # Regenerate on each release with .github/scripts/cac_sign_formula.py.
  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/c9/7f/09065fd9e27da0eda08b4d6897f1c13535066174cc023af248fc2a8d5e5a/asn1crypto-1.5.1-py2.py3-none-any.whl"
    sha256 "db4e40728b728508912cbb3d44f19ce188f218e9eba635821bb4b68564f8fd67"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/ef/2f/c5464532e965badff2f4c4c1a3a83f5697f0d7c407ed0cda44aaa99bb451/certifi-2026.6.17-py3-none-any.whl"
    sha256 "2227dcbaafe0d2f59279d1762ddddc37783ed4354594f194ffc31d20f41fc3db"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/59/dd/27e9fa567a23931c838c6b02d0764611c62290062a6d4e8ff7863daf9730/cffi-2.0.0-cp314-cp314-macosx_11_0_arm64.whl"
    sha256 "c654de545946e0db659b3400168c9ad31b5d29593291482c43e3564effbcee13"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/97/c8/c67cb8c70e19ef1960b97b22ed2a1567711de46c4ddf19799923adc836c2/charset_normalizer-3.4.7-cp314-cp314-macosx_10_15_universal2.whl"
    sha256 "c36c333c39be2dbca264d7803333c896ab8fa7d4d6f0ab7edb7dfd7aea6e98c0"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9b/22/adf66990e63584a68dfb50c24f48a125c07b1699899381c8151e63ed458c/cryptography-49.0.0-cp311-abi3-macosx_11_0_arm64.whl"
    sha256 "966fe0e9c67490071f14c0d2b1cb2dfb3023c5ce39457343931415f08382f2db"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/1e/5e/d4e9f1a599fb8e573b7b87160658329fbf28d19eac2718f51fc3def3aa5a/idna-3.18-py3-none-any.whl"
    sha256 "7f952cbe720b688055e3f87de14f5c3e5fdaa8bc3928985c4077ca689de849a2"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/13/e2/2e325795566de01d0d7c3bb57d3c370616b2d07b01214e84eec5d3b10963/lxml-6.1.1-cp314-cp314-macosx_10_15_universal2.whl"
    sha256 "19b7ab10b210b0b3ad7985d9ac4eb66ab09a90b20fe6e2f7ba55d01a234345d0"
  end

  resource "oscrypto" do
    url "https://files.pythonhosted.org/packages/01/7c/fa07d3da2b6253eb8474be16eab2eadf670460e364ccc895ca7ff388ee30/oscrypto-1.3.0-py2.py3-none-any.whl"
    sha256 "2b2f1d2d42ec152ca90ccb5682f3e051fb55986e1b170ebde472b133713e7085"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/b2/87e62e8c3e2f4b32e5fe99e0b86d576da1312593b39f47d8ceef365e95ed/packaging-26.2-py3-none-any.whl"
    sha256 "5fc45236b9446107ff2415ce77c807cee2862cb6fac22b8a73826d0693b0980e"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/36/a8/551a73c191c8742fd0436051ed542b245aeea517eb7ee2d91215b9a4047e/pikepdf-10.9.1-cp314-abi3-macosx_14_0_arm64.whl"
    sha256 "3f9c79dc03ee8a44b8c4265baced60b8dd2c79bfa447a22eec67f9deade5d535"
  end

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/ba/8c/1a9e46228571de18f8e28f16fabdfc20212a5d019f3e3303452b3f0a580d/pillow-12.2.0-cp314-cp314-macosx_11_0_arm64.whl"
    sha256 "80b2da48193b2f33ed0c32c38140f9d3186583ce7d516526d462645fd98660ae"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0c/c3/44f3fbbfa403ea2a7c779186dc20772604442dde72947e7d01069cbe98e3/pycparser-3.0-py3-none-any.whl"
    sha256 "b727414169a36b7d524c1c3e31839a521725078d7b2ff038656844266160a992"
  end

  resource "pyhanko" do
    url "https://files.pythonhosted.org/packages/4a/1a/bea014b55c45c98c63dffd34d2dd01eed0a73ce5b175bd7b1ba798d13558/pyhanko-0.35.1-py3-none-any.whl"
    sha256 "57c085f29d7f87334be2a5fbd38a1ca3c987f40f51aea38bde628497d6d9ef2e"
  end

  resource "pyhanko-certvalidator" do
    url "https://files.pythonhosted.org/packages/f4/99/722e90c586455733fa860d092722ef074f3a65449fe9787b7b7e2dafcd1f/pyhanko_certvalidator-0.31.1-py3-none-any.whl"
    sha256 "0aabe25b536ed555f3b18e5eb2c62ff46adeff9d15e27f0c9d5d81952d956f45"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/13/37/486d38a173b0b8dce973a3e13c74cf402ed1b8621586b5963bc9efd49a48/pyobjc_core-12.2.2-cp314-cp314-macosx_10_15_universal2.whl"
    sha256 "2062e8ad30a310441cd022544a897553408bebeaa7820d5edba3c96fd7fd693b"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/1f/1a/b99521999b9f54b89aad928ddff0faad507abfe33bc46599454bfa48a4b2/pyobjc_framework_cocoa-12.2.2-cp314-cp314-macosx_10_15_universal2.whl"
    sha256 "889d7bbd4ba2d4941078bfbbfb882138e51dbead27df006abfe0f2e0d49b5b2e"
  end

  resource "pyobjc-framework-quartz" do
    url "https://files.pythonhosted.org/packages/b1/33/230ae7777b0909fe2c24f28413c51c860faebf762d824b097a0e2fb48304/pyobjc_framework_quartz-12.2.2-cp314-cp314-macosx_10_15_universal2.whl"
    sha256 "1f7f3d9010e38f03ea1fa266664c10ea349cd7492bd603b403584f49d713dbed"
  end

  resource "pyobjc-framework-security" do
    url "https://files.pythonhosted.org/packages/47/b5/4040d093b67a155041325b518148cc432fe17de9968d4ed6f0279140b2a3/pyobjc_framework_security-12.2.2-cp314-cp314-macosx_10_15_universal2.whl"
    sha256 "c4726b41c96a611fa13880bcfcb38a32ac9256239adb5b48d559dc4d0c9d0b99"
  end

  resource "python-pkcs11" do
    url "https://files.pythonhosted.org/packages/e8/04/aa4c33e3d14612d3855dd3f6f72f6ef9db82d1575a387fce8a22678fe908/python_pkcs11-0.9.4-cp314-cp314-macosx_10_15_universal2.whl"
    sha256 "0e1c88481eeada4fd81cfefe117413137a2868cc072e588c05972aca92020cc8"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/bd/9c/4d95bb87eb2063d20db7b60faa3840c1b18025517ae857371c4dd55a6b3a/pyyaml-6.0.3-cp314-cp314-macosx_11_0_arm64.whl"
    sha256 "34d5fcd24b8445fadc33f9cf348c1047101756fd760b4dacb5c3e99755703310"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/a3/07/70085c17a369605f15e301d10ab902115019b1126c7253d964afc230c7d6/reportlab-5.0.0-py3-none-any.whl"
    sha256 "9d5a3affa84919e1111ede580031266a570e93b1ce388219621347965ff1d93c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a0/f4/c67b0b3f1b9245e8d266f0f112c500d50e5b4e83cb6f3b71b6528104182a/requests-2.34.2-py3-none-any.whl"
    sha256 "2a0d60c172f83ac6ab31e4554906c0f3b3588d37b5cb939b1c061f4907e278e0"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/42/28/fc144409c71569e928585f8f3c629d80d1ca3ef40175e9222f01588f98c9/tzlocal-5.4.3-py3-none-any.whl"
    sha256 "24ce97bb58e2a973f7640ec2553ab4e6f6d5a0d0d1aa9dc43bca21d89e1feb82"
  end

  resource "uritools" do
    url "https://files.pythonhosted.org/packages/7b/3f/44a8c5de526ad21bd540015fd44987da69469ea9f51b7c9ac6a8b475a4a8/uritools-6.1.2-py3-none-any.whl"
    sha256 "5682f8c58e96e379224fd72aec227a45432740c1fa860a06b3024d47c2968601"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7f/3e/5db95bcf282c52709639744ca2a8b149baccf648e39c8cc87553df9eae0c/urllib3-2.7.0-py3-none-any.whl"
    sha256 "9fb4c81ebbb1ce9531cce37674bbc6f1360472bc18ca9a553ede278ef7276897"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14", system_site_packages: false)
    wheels = buildpath/"wheels"
    wheels.mkpath
    resources.each { |r| cp r.cached_download, wheels/File.basename(r.url) }
    cp cached_download, wheels/File.basename(stable.url)
    system "python3.14", "-m", "pip", "--python=#{venv.root}/bin/python", "install",
           "--no-deps", "--no-index", "--no-compile", *wheels.children
    bin.install_symlink libexec/"bin/cac-sign"
  end

  def caveats
    <<~EOS
      To add the Finder Quick Actions ("CAC Sign" and "CAC Sign…") and your details for forms, run:
        cac-sign --setup
    EOS
  end

  test do
    assert_match "usage: cac-sign", shell_output("#{bin}/cac-sign --help")
    assert_match "No signatures recorded yet", shell_output("#{bin}/cac-sign --history")
    system libexec/"bin/python", "-c",
           "import cac_sign_app as a; a._modules(); import cac_sign_editor, cac_sign_finder, pdf_readers, Quartz, Security"
  end
end
