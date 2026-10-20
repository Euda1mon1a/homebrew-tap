# euda1mon1a/tap

Homebrew formulae.

```console
brew install euda1mon1a/tap/photogrep
brew install euda1mon1a/tap/cac-sign
brew install euda1mon1a/tap/slipper
brew install euda1mon1a/tap/object-healer
brew install euda1mon1a/tap/marquetry
```

| Formula | What it does |
|---|---|
| [photogrep](https://github.com/Euda1mon1a/photogrep) | Search Apple Photos by what is in the picture, and find which photo an image came from. |
| [cac-sign](https://github.com/Euda1mon1a/cac-sign) | Fill, CAC-sign and verify PDFs on a Mac, with Finder Quick Actions. Apple silicon; run `cac-sign --setup` after installing. |
| [slipper](https://github.com/Euda1mon1a/slipper) | Turn a local web app into a Mac app you keep in the Dock: opening it starts the server in Terminal and opens the browser. |
| [object-healer](https://github.com/Euda1mon1a/object-healer) | Repair meshes for 3D printing in headless Blender: merge duplicate vertices, fix normals, fill holes. Needs Blender (`brew install --cask blender`). |
| [marquetry](https://github.com/Euda1mon1a/marquetry) | Turn a flat logo into one-path-per-colour SVGs for multi-colour 3D printing (coasters, signs, keychains). On PyPI as marquetry-svg. |

Homebrew asks you to trust formulae from taps outside its own; installing by the full name above trusts just that formula.

A weekly workflow checks PyPI for new photogrep releases, builds and tests the update on macOS, and opens a pull request. The cac-sign, object-healer and marquetry formulae are generated from each project's lock file at each release with `.github/scripts/wheel_formula.py <formula> <checkout at the tag> <version> Formula/<formula>.rb`.
