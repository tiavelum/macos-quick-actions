# macOS Quick Actions

Finder quick actions for comparing files in VS Code.

## Actions

| Action | Purpose |
|---|---|
| `Compare - Select First` | Remembers the selected file in `~/.vscode-diff-first` |
| `Compare - With This` | Compares the remembered file with the selected one in VS Code |

The names contain a hyphen, not a colon — that is the exact string to look for
in the Services list.

For two files in the same folder the separate `Compare in VS Code` action is
enough (it takes both selected files directly).

## Usage

1. Folder A → right-click file 1 → **Quick Actions → Compare - Select First**
2. Folder B → right-click file 2 → **Quick Actions → Compare - With This**

VS Code opens the diff view; the remembered path is deleted afterwards.

## Install

```bash
./install.sh
```

Copies all `.workflow` bundles to `~/Library/Services`, flushes the services
cache and restarts the Finder.

## Rebuild

```bash
./build.sh
```

`build.sh` generates the `.workflow` bundles from templates. A bundle is merely
a folder holding two XML property lists:

```
Compare - Select First.workflow/
└── Contents/
    ├── Info.plist        # menu name, context (Finder), accepted file types
    └── document.wflow    # the Automator workflow including the shell script
```

The shell script sits in `document.wflow` under
`actions[0].action.ActionParameters.COMMAND_STRING`. To change only the script,
edit it there directly — or adjust `build.sh` and regenerate.

## Notes

- `~/Library` is hidden in Finder: ⇧⌘G and enter `~/Library/Services`, or
  unhide it permanently with `chflags nohidden ~/Library`.
- **A newly installed service can arrive disabled**, so it never appears in the
  context menu even though the bundle is in place. Enable it — and assign a
  keyboard shortcut while you are there — under System Settings → Keyboard →
  Keyboard Shortcuts → **Services** → *Files and Folders*, where it is listed
  under its exact name above.
- If the action still does not appear, flush the cache and restart the Finder
  again: `/System/Library/CoreServices/pbs -flush` then `killall Finder`.
- Troubleshooting: open the bundle with Automator and press **Run** — the log
  shows the actual error message instead of a silent failure.

## Why git makes sense here

Both files in the bundle are plain XML text, so they version and diff well.
Finder displays `.workflow` as a package, but git treats it as an ordinary
folder.
