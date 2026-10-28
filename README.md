# euda1mon1a/tap

Homebrew formulae.

```console
brew install euda1mon1a/tap/photogrep
brew install euda1mon1a/tap/cac-sign
```

| Formula | What it does |
|---|---|
| [photogrep](https://github.com/Euda1mon1a/photogrep) | Search Apple Photos by what is in the picture, and find which photo an image came from. |
| [cac-sign](https://github.com/Euda1mon1a/cac-sign) | Convert Word forms to PDF, detect printed fields, fill and CAC-sign locally. Apple silicon; run `cac-sign --setup` after installing. DOCX intake needs LibreOffice. |

Homebrew asks you to trust formulae from taps outside its own; installing by the full name above trusts just that formula.

A weekly workflow checks PyPI for new photogrep releases, builds and tests the update on macOS, and opens a pull request. The cac-sign formula is generated from that project's lock file at each release with `.github/scripts/cac_sign_formula.py`.

The cac-sign generator takes its main wheel from PyPI by default. Set
`CAC_SIGN_WHEEL_SOURCE=github` to use the wheel attached to the matching public
GitHub release instead. It downloads and hashes that wheel; dependency resources
still come from the project's lock file. Version 0.2.0 uses the checksummed GitHub
release wheel, which is the same artifact tested by the upstream project.
