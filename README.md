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

## Troubleshooting

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

## Control Center Toggle.app

The repository also carries `control-center-toggle.applescript` and builds it
into `/Applications/Control Center Toggle.app`. It lives here despite the
repository's name for the same reason the Quick Actions do: it is a small
macOS integration generated from plain text that is worth versioning.

The application exists only to **hold a permission**. macOS grants
Accessibility to an application, never to a script, so driving the menu bar
needs a bundle for the grant to attach to. `install.sh` compiles it:

```bash
./install.sh              # builds it if it is not already there
./install.sh --rebuild    # replaces it
```

Two steps stay manual and cannot be scripted:

1. Launch the app once. macOS prompts; grant it under **Privacy & Security →
   Accessibility**. Do not test it from Automator — that grants the
   permission to Automator instead of to this app.
2. **Shortcuts** → new shortcut → action **Open App** → *Control Center
   Toggle* → ⓘ → **Details → Run with** → press your key combination.

⚠️ `--rebuild` costs you the grant. macOS binds it to the application's
contents as well as its path, so a recompiled bundle is a different
application to the permission system. The toggle still looks switched on and
the hotkey silently does nothing. Re-grant it after any rebuild — and never
move the app after granting, for the same reason.

⚠️ Match menu bar items on their `AXIdentifier`, not their label. The visible
label is locale-dependent and is not the element's name, so
`click menu bar item "Control Center"` fails.
