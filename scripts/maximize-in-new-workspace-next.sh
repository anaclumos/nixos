#!/usr/bin/env bash
gdbus call --session \
  --dest org.gnome.Shell \
  --object-path /org/gnome/Shell \
  --method org.gnome.Shell.Eval "
const { workspace_manager: wm } = global;
const Meta   = imports.gi.Meta;
const idx    = wm.get_active_workspace_index() + 1;   // insert *after* current
Main.wm.insertWorkspace(idx);

const win    = global.display.get_focus_window();
if (win) {
    const newWs = wm.get_workspace_by_index(idx);
    Main.wm.actionMoveWindow(newWs, win);             // move + follow
    win.maximize(Meta.MaximizeFlags.BOTH);            // maximise
}
"  >/dev/null
