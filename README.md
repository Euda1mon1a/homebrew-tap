# euda1mon1a/tap

Homebrew formulae.

```console
brew install euda1mon1a/tap/photogrep
brew install euda1mon1a/tap/cac-sign
brew install euda1mon1a/tap/slipper
```

| Formula | What it does |
|---|---|
| [photogrep](https://github.com/Euda1mon1a/photogrep) | Search Apple Photos by what is in the picture, and find which photo an image came from. |
| [cac-sign](https://github.com/Euda1mon1a/cac-sign) | Fill, CAC-sign and verify PDFs on a Mac, with Finder Quick Actions. Apple silicon; run `cac-sign --setup` after installing. |
| [slipper](https://github.com/Euda1mon1a/slipper) | Turn a local web app into a Mac app you keep in the Dock: opening it starts the server in Terminal and opens the browser. |

Homebrew asks you to trust formulae from taps outside its own; installing by the full name above trusts just that formula.

A weekly workflow checks PyPI for new photogrep releases, builds and tests the update on macOS, and opens a pull request. The cac-sign formula is generated from that project's lock file at each release with `.github/scripts/cac_sign_formula.py`.
