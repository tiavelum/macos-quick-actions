# macOS Quick Actions

Finder-Schnellaktionen zum Vergleichen von Dateien in VS Code.

## Aktionen

| Aktion | Zweck |
|---|---|
| `Compare - Select First` | Merkt sich die markierte Datei in `~/.vscode-diff-first` |
| `Compare - With This` | Vergleicht die gemerkte Datei mit der markierten in VS Code |

Für zwei Dateien im selben Ordner reicht die separate Aktion `Compare in VS Code`
(nimmt beide markierten Dateien direkt entgegen).

## Verwendung

1. Ordner A → Rechtsklick auf Datei 1 → **Schnellaktionen → Compare: Select First**
2. Ordner B → Rechtsklick auf Datei 2 → **Schnellaktionen → Compare: With This**

VS Code öffnet die Diff-Ansicht, der gemerkte Pfad wird danach gelöscht.

## Installieren

```bash
./install.sh
```

Kopiert alle `.workflow`-Bundles nach `~/Library/Services`, leert den Dienste-Cache
und startet den Finder neu.

## Neu bauen

```bash
./build.sh
```

`build.sh` erzeugt die `.workflow`-Bundles aus Templates. Ein Bundle ist lediglich
ein Ordner mit zwei XML-Property-Lists:

```
Compare - Select First.workflow/
└── Contents/
    ├── Info.plist        # Menüname, Kontext (Finder), akzeptierte Dateitypen
    └── document.wflow    # Der Automator-Workflow inkl. Shell-Skript
```

Das Shell-Skript steht im `document.wflow` unter
`actions[0].action.ActionParameters.COMMAND_STRING`. Wer nur das Skript ändern will,
kann es dort direkt editieren — oder `build.sh` anpassen und neu erzeugen.

## Hinweise

- `~/Library` ist im Finder ausgeblendet: ⇧⌘G und `~/Library/Services` eingeben,
  oder dauerhaft mit `chflags nohidden ~/Library`.
- Neue Dienste sind gelegentlich deaktiviert: Systemeinstellungen → Tastatur →
  Tastaturkurzbefehle → Dienste → „Dateien und Ordner".
- Dort lässt sich den Aktionen auch ein Tastaturkurzbefehl zuweisen.
- Fehlersuche: Bundle mit Automator öffnen und **Ausführen** drücken — das
  Protokoll zeigt die konkrete Fehlermeldung.

## Warum Git sinnvoll ist

Beide Dateien im Bundle sind reiner XML-Text, also gut versionierbar und diffbar.
Finder zeigt `.workflow` als Paket an, Git behandelt es aber als normalen Ordner.
