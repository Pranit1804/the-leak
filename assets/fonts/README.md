# Fonts (all SIL Open Font License 1.1, free for commercial apps)

Downloaded from the official Google Fonts repository (github.com/google/fonts). Licences are the *-OFL.txt files.

| File | Family | Use |
|---|---|---|
| Anton-Regular.ttf | Anton | Headlines, buttons, big numbers |
| LibreFranklin-VariableFont_wght.ttf | Libre Franklin (variable, 100–900) | UI text, labels |
| LibreCaslonText-Italic-VariableFont_wght.ttf | Libre Caslon Text Italic (variable) | Voice lines, subtitles, captions |
| LibreCaslonText-VariableFont_wght.ttf | Libre Caslon Text (variable) | Role card body text |

## pubspec.yaml
```yaml
flutter:
  fonts:
    - family: Anton
      fonts:
        - asset: assets/fonts/Anton-Regular.ttf
    - family: LibreFranklin
      fonts:
        - asset: assets/fonts/LibreFranklin-VariableFont_wght.ttf
    - family: LibreCaslonText
      fonts:
        - asset: assets/fonts/LibreCaslonText-VariableFont_wght.ttf
        - asset: assets/fonts/LibreCaslonText-Italic-VariableFont_wght.ttf
          style: italic
```
Libre Franklin is a variable font: pick weights with `fontVariations: [FontVariation('wght', 800)]` alongside `fontWeight`.
Show the OFL licences on an in-app Licences screen (`LicenseRegistry.addLicense`).
