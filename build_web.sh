#!/usr/bin/env bash
set -e

REPO_NAME=${1:-"Scriptly"}

echo "🚀 Building Scriptly Web for GitHub Pages (base-href: /$REPO_NAME/)..."
cd example
flutter pub get
flutter build web --release --base-href "/$REPO_NAME/"

echo "✅ Web build complete! Output located at: example/build/web"
