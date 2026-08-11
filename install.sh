#!/bin/bash
# Installiert alle .workflow-Bundles aus diesem Verzeichnis als Finder-Schnellaktionen.
set -e
cd "$(dirname "$0")"
mkdir -p ~/Library/Services
for wf in *.workflow; do
  [ -e "$wf" ] || continue
  rm -rf ~/Library/Services/"$wf"
  cp -R "$wf" ~/Library/Services/
  echo "installiert: $wf"
done
/System/Library/CoreServices/pbs -flush
killall Finder
echo "fertig - Finder wurde neu gestartet"
