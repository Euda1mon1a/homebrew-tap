"""Point Formula/photogrep.rb at a photogrep release on PyPI.

    bump_formula.py latest FORMULA                    # prints changed/version/url/sha256 lines
    bump_formula.py apply FORMULA VERSION URL SHA256  # rewrites url and sha256

Every value taken from PyPI is checked against a strict pattern before it is used.
"""
import json
import re
import sys
import urllib.request


def current(text: str) -> str:
    return re.search(r"photogrep-([0-9][^/]*)\.tar\.gz", text).group(1)


def validate(version: str, url: str, sha256: str) -> None:
    if not re.fullmatch(r"[0-9]+(\.[0-9]+)*", version):
        sys.exit(f"unexpected version {version!r}")
    if not re.fullmatch(r"https://files\.pythonhosted\.org/packages/[0-9a-f/]+/photogrep-"
                        + re.escape(version) + r"\.tar\.gz", url):
        sys.exit(f"unexpected url {url!r}")
    if not re.fullmatch(r"[0-9a-f]{64}", sha256):
        sys.exit(f"unexpected sha256 {sha256!r}")


def newer(a: str, b: str) -> bool:
    return tuple(map(int, a.split("."))) > tuple(map(int, b.split(".")))


def main() -> None:
    mode, path = sys.argv[1], sys.argv[2]
    text = open(path).read()
    if mode == "latest":
        data = json.load(urllib.request.urlopen("https://pypi.org/pypi/photogrep/json", timeout=30))
        version = data["info"]["version"]
        sdist = next(u for u in data["urls"] if u["packagetype"] == "sdist")
        url, sha256 = sdist["url"], sdist["digests"]["sha256"]
        validate(version, url, sha256)
        print(f"changed={'true' if newer(version, current(text)) else 'false'}")
        print(f"version={version}\nurl={url}\nsha256={sha256}")
    elif mode == "apply":
        version, url, sha256 = sys.argv[3:6]
        validate(version, url, sha256)
        text = re.sub(r'^  url ".*"$', f'  url "{url}"', text, count=1, flags=re.M)
        text = re.sub(r'^  sha256 ".*"$', f'  sha256 "{sha256}"', text, count=1, flags=re.M)
        open(path, "w").write(text)
    else:
        sys.exit(__doc__)


if __name__ == "__main__":
    main()
