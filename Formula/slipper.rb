class Slipper < Formula
  desc "Turn a local web app into a Mac app you keep in the Dock"
  homepage "https://github.com/Euda1mon1a/slipper"
  url "https://github.com/Euda1mon1a/slipper/releases/download/v0.1.0/slipper-0.1.0.tar.gz"
  # PLACEHOLDER: replace with the sha256 of the v0.1.0 release asset once it is uploaded.
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"

  depends_on macos: :monterey

  def install
    bin.install "slipper"
    pkgshare.install "templates"
  end

  test do
    assert_match "slipper #{version}", shell_output("#{bin}/slipper --version")

    # 64x64 PNG for the icon
    (testpath/"icon.png").binwrite(
      "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAIAAAAlC+aJAAAAT0lEQVR42u3PQQkAAAgEsEtiTiMaywi+hcEKLNXzWgQEBAQEBAQE" \
      "BAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQELgt9cOE8/JmApAAAAABJRU5ErkJggg==".unpack1("m"),
    )
    system bin/"slipper", "--name", "Test & <App>", "--icon", testpath/"icon.png",
           "--port", "8765", "--start-cmd", "true", "--output", testpath/"Test.app"
    contents = testpath/"Test.app/Contents"
    system "plutil", "-lint", contents/"Info.plist"
    plist_value = lambda do |key|
      Utils.safe_popen_read("plutil", "-extract", key, "raw", "-o", "-", contents/"Info.plist").chomp
    end
    assert_equal "Test & <App>", plist_value.call("CFBundleName")
    assert_match(/\Alocal\.slipper\.\h{8}(-\h{4}){3}-\h{12}\z/, plist_value.call("CFBundleIdentifier"))
    assert_predicate contents/"MacOS/Test__App", :executable?
    assert_predicate contents/"Resources/launcher.command", :executable?
    assert_path_exists contents/"Resources/AppIcon.icns"
    assert_match "APP_START_CMD='true'", (contents/"Resources/slipper.conf").read

    # An app it did not create is left alone.
    (testpath/"Other.app/Contents").mkpath
    output = shell_output("#{bin}/slipper --name Other --port 8765 --start-cmd true " \
                          "--output #{testpath}/Other.app 2>&1", 1)
    assert_match "not created by Slipper", output
  end
end
