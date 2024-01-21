# iKut annotation

A simple annotation tool for image classification.

<img src="https://raw.githubusercontent.com/tfandkusu/ikut_annotation/main/doc/movie.gif">

# How to build

Install a specific version of flutter by [asdf](https://github.com/asdf-vm/asdf).

```sh
asdf plugin add flutter
asdf install
asdf reshim
```

Build project.

```sh
flutter pub get
dart run build_runner build
```

# How to run

```sh
flutter run -d macos
```

# Settings

| File or directory | Explanation　|
| --- | --- |
| label.txt | up to 4 classes labels to edit label. Line break must be CRLF. |
| image/ | images for labeling. |
|result.csv | image file names and these labels. Line break must be CRLF. |

# How to operate

| Operation | Key |
| --- | --- |
| Select next image | `]` key |
| Select previous image | `[` keys |
| Set label 1 | `Z` key |
| Set label 2 | `X` key |
| Set label 3 | `C` key |
| Set label 4 | `V` key |
| Select 100 images ahead | `P` key |
| Select 100 previous image | `O` key |

# References

- [Food 101](https://data.vision.ee.ethz.ch/cvl/datasets_extra/food-101/)

# Previous repository

- [tfandkusu/ikut_annotation](https://github.com/tfandkusu/ikut_annotation)
