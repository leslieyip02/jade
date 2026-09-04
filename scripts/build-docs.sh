#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
SITE_DIR=${1:-site}

if [ -n "${PYTHON:-}" ]; then
  PYTHON_BIN=$PYTHON
elif command -v python >/dev/null 2>&1; then
  PYTHON_BIN=python
elif command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN=python3
else
  printf 'Error: Python is required to build the documentation site.\n' >&2
  exit 1
fi

case "$SITE_DIR" in
  /*) ;;
  *) SITE_DIR="$REPO_ROOT/$SITE_DIR" ;;
esac

cd "$REPO_ROOT"

./gradlew dokkaHtml --no-daemon
"$PYTHON_BIN" -m mkdocs build --strict --site-dir "$SITE_DIR"

mkdir -p "$SITE_DIR/api"
cp -R build/dokka/html/. "$SITE_DIR/api/"

printf 'Documentation site built at %s\n' "$SITE_DIR"
