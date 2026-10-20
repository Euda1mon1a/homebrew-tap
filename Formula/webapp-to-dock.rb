class WebappToDock < Formula
  desc "Turn a local web app into a Dock app that starts its server and opens it"
  homepage "https://github.com/Euda1mon1a/webapp-to-dock"
  url "https://github.com/Euda1mon1a/webapp-to-dock/archive/refs/tags/v0.1.0.tar.gz"
  # PLACEHOLDER: replace with the sha256 of the v0.1.0 tag archive once the tag exists.
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"

  depends_on :macos

  def install
    bin.install "webapp-to-dock"
    pkgshare.install "templates"
  end

  test do
    assert_match "webapp-to-dock #{version}", shell_output("#{bin}/webapp-to-dock --version")

    # 64x64 PNG for the icon
    (testpath/"icon.png").binwrite(
      "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAIAAAAlC+aJAAAAT0lEQVR42u3PQQkAAAgEsEtiTiMaywi+hcEKLNXzWgQEBAQEBAQE" \
      "BAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQELgt9cOE8/JmApAAAAABJRU5ErkJggg==".unpack1("m"),
    )
    system bin/"webapp-to-dock", "--name", "Test & <App>", "--icon", testpath/"icon.png",
           "--port", "8765", "--start-cmd", "true", "--output", testpath/"Test.app"
    contents = testpath/"Test.app/Contents"
    system "plutil", "-lint", contents/"Info.plist"
    name = Utils.safe_popen_read("plutil", "-extract", "CFBundleName", "raw", "-o", "-", contents/"Info.plist")
    assert_equal "Test & <App>", name.chomp
    assert_predicate contents/"Resources/launcher.command", :executable?
    assert_path_exists contents/"Resources/AppIcon.icns"
    assert_match "APP_START_CMD='true'", (contents/"Resources/webapp.conf").read

    # An app it did not create is left alone.
    (testpath/"Other.app/Contents").mkpath
    output = shell_output("#{bin}/webapp-to-dock --name Other --port 8765 --start-cmd true " \
                          "--output #{testpath}/Other.app 2>&1", 1)
    assert_match "not created by webapp-to-dock", output
  end
end
