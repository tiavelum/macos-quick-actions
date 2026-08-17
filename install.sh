#!/bin/bash
# install.sh — put this repo's Finder Quick Actions and hotkey application
# in place.
#
#   ./install.sh            install the Quick Actions, build the app if absent
#   ./install.sh --rebuild  rebuild the app even if it already exists
#
# ⚠️ --rebuild costs you the Accessibility grant. macOS binds the grant to
# the application at its path *and* to its contents, so a recompiled bundle
# is a different application as far as permissions are concerned. You will
# have to re-grant it, and nothing will tell you: the hotkey simply stops
# doing anything.

set -e
cd "$(dirname "$0")"

REBUILD=0
[ "${1:-}" = "--rebuild" ] && REBUILD=1

# --- Finder Quick Actions ----------------------------------------------
mkdir -p ~/Library/Services
count=0
for wf in *.workflow; do
  [ -e "$wf" ] || continue
  rm -rf ~/Library/Services/"$wf"
  cp -R "$wf" ~/Library/Services/
  echo "installed: $wf"
  count=$((count + 1))
done

if [ "$count" -eq 0 ]; then
  echo "!! no .workflow bundles found — run ./build.sh first" >&2
else
  /System/Library/CoreServices/pbs -flush
  killall Finder
  echo "Finder restarted"
fi

# --- Control Center Toggle.app -----------------------------------------
# Lives here despite the repository's name: it is the same kind of thing —
# a small macOS integration built from plain text kept under version
# control. It must land in /Applications, because moving it after the
# Accessibility grant silently invalidates the grant.
APP="/Applications/Control Center Toggle.app"
SRC="control-center-toggle.applescript"

if [ ! -f "$SRC" ]; then
  echo "!! $SRC missing — hotkey application not built" >&2
elif [ -d "$APP" ] && [ "$REBUILD" -eq 0 ]; then
  echo "Control Center Toggle.app already present — left alone (--rebuild to replace)"
else
  [ -d "$APP" ] && rm -rf "$APP"
  osacompile -o "$APP" "$SRC"
  echo "built: $APP"
  cat <<'NOTE'

  Two manual steps remain for the hotkey, and neither can be scripted:
    1. Double-click the app once. macOS prompts for Accessibility; grant it
       under Privacy & Security → Accessibility. Do not test it from
       Automator — that grants the permission to Automator instead.
    2. Shortcuts → new shortcut → action "Open App" → Control Center Toggle
       → ⓘ → Details → Run with → press your key combination.
NOTE
fi

echo "done"
