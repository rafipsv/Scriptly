# Scriptly Web Application (Polyglot Transliterator Demo)

An interactive, responsive Flutter Web application demonstrating the capabilities of the `scriptly` package.

Built with **Clean Architecture**, **BLoC** state management, and **Material 3 Design**. Ready for deployment on **GitHub Pages**.

---

## Features

- **Universal Any-to-Any Transliteration**: Supports live text conversion across 17+ languages and scripts.
- **Modern Dual Capsule Dropdowns**: Custom dropdown cards displaying script badges (`Latn`, `Beng`, `Deva`, `Jpan`, etc.) and language family categories.
- **One-Tap Swap**: Instantly switch between Source and Target languages.
- **Quick Sample Pills**: Single-click testing with curated multi-script sample phrases.
- **Theme Switcher**: Smooth Light and Dark mode transitions via `ThemeCubit`.
- **Digit Policy Controls**: Toggle between native script digits and Latin ASCII digits on the fly.
- **Responsive Layout**: Adapts gracefully across mobile, tablet, and desktop viewports.

---

## Project Architecture

```
example/lib/
├── main.dart                          # App entry point (38 lines)
└── src/
    ├── core/
    │   ├── constants/app_constants.dart # Supported language matrix & samples
    │   └── theme/app_theme.dart        # Material 3 light/dark themes
    └── presentation/
        ├── bloc/
        │   ├── transliterator/        # TransliteratorBloc, events, and states
        │   └── theme/theme_cubit.dart # ThemeCubit
        ├── pages/
        │   └── transliterator_page.dart # Responsive page layout
        └── widgets/
            ├── app_header.dart          # Header with branding & theme toggle
            ├── language_selector_bar.dart # Dual capsule dropdowns
            ├── quick_samples_bar.dart   # Interactive quick test chips
            ├── settings_footer.dart     # Digit policy & action bar
            ├── source_card.dart         # Input card with clear & paste actions
            └── target_card.dart         # Output card with copy & info badges
```

---

## Running Locally

### Option 1: Fast Production Release Server

```bash
# Build release web bundle from root:
./build_web.sh

# Run local HTTP server:
python3 -m http.server 8080 --directory "example/build/web"
```

Open your browser at: **`http://localhost:8080/`**

### Option 2: Flutter Dev Server (Hot-Reload)

```bash
cd example
flutter run -d chrome

# Or run with specific port:
flutter run -d web-server --web-port=8080
```

---

## Deploying to GitHub Pages

This repository includes an automated GitHub Actions deployment workflow at `.github/workflows/deploy.yml`.

To deploy:

1. Push your code to your GitHub repository on the `main` branch.
2. In your repository settings on GitHub, navigate to **Settings > Pages**.
3. Under **Build and deployment > Source**, select **GitHub Actions**.
4. The workflow will automatically compile the web app with the proper `--base-href` and deploy it to your GitHub Pages URL!
