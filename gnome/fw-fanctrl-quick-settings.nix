{ config, pkgs, lib, ... }:

let
  uuid = "fw-fanctrl@sunghyun.dev";
  extPath = ".local/share/gnome-shell/extensions/${uuid}";
in {
  # Install a local GNOME Shell extension that adds a Quick Settings
  # menu for selecting fw-fanctrl strategies.
  home.file."${extPath}/metadata.json".text = ''
    {
      "uuid": "${uuid}",
      "name": "Framework Fan Control",
      "description": "Quick Settings menu to select fw-fanctrl strategy",
      "shell-version": [ "45", "46" ],
      "version": 1,
      "url": "https://github.com/sunghyun-cho/nix"
    }
  '';

  home.file."${extPath}/extension.js".text = ''
    const { Gio, GLib, GObject } = imports.gi;
    const Main = imports.ui.main;
    const PopupMenu = imports.ui.popupMenu;
    const QuickSettings = imports.ui.quickSettings;

    const FW_BIN = '/run/current-system/sw/bin/fw-fanctrl';

    async function runFw(args) {
      // Use Gio.Subprocess for robust async exec
      return await new Promise((resolve) => {
        try {
          const proc = new Gio.Subprocess({
            argv: [FW_BIN, '--output-format', 'JSON', ...args],
            flags: Gio.SubprocessFlags.STDOUT_PIPE | Gio.SubprocessFlags.STDERR_PIPE,
          });
          proc.init(null);
          proc.communicate_utf8_async(null, null, (proc_, res) => {
            try {
              const [, out, err] = proc_.communicate_utf8_finish(res);
              const ok = proc_.get_successful();
              if (!ok) {
                resolve({ ok: false, error: err?.trim() || out?.trim() || 'failed' });
                return;
              }
              try {
                const json = JSON.parse(out);
                resolve({ ok: true, data: json });
              } catch (e) {
                resolve({ ok: false, error: `parse error: ${e}` });
              }
            } catch (e) {
              resolve({ ok: false, error: `${e}` });
            }
          });
        } catch (e) {
          resolve({ ok: false, error: `${e}` });
        }
      });
    }

    async function getStrategies() {
      const res = await runFw(['print', 'list']);
      if (res.ok && Array.isArray(res.data?.strategies))
        return res.data.strategies;
      return [];
    }

    async function getCurrent() {
      const res = await runFw(['print', 'current']);
      if (res.ok)
        return { strategy: res.data?.strategy, isDefault: !!res.data?.default };
      return { strategy: null, isDefault: false };
    }

    async function useStrategy(name) {
      return await runFw(['use', name]);
    }

    async function resetDefault() {
      return await runFw(['reset']);
    }

    const Indicator = GObject.registerClass(
      class Indicator extends QuickSettings.SystemIndicator {
        _init() {
          super._init();

          this._indicator = this._addIndicator();
          this._indicator.icon_name = 'weather-windy-symbolic';

          this._toggle = new QuickSettings.QuickMenuToggle({
            title: 'Fan Control',
            iconName: 'weather-windy-symbolic',
            toggleMode: false,
          });

          // Build initial menu; contents refresh on open
          this._toggle.menu.connect('open-state-changed', (_m, open) => {
            if (open)
              this._refreshMenu();
          });

          this.quickSettingsItems.push(this._toggle);
          Main.panel.statusArea.quickSettings.addExternalIndicator(this);

          this._refreshSubtitle();
        }

        async _refreshSubtitle() {
          const cur = await getCurrent();
          if (cur.strategy) {
            this._toggle.subtitle = cur.isDefault ? `${cur.strategy} (default)` : cur.strategy;
            this._toggle.sensitive = true;
          } else {
            this._toggle.subtitle = 'service unavailable';
            this._toggle.sensitive = false;
          }
        }

        async _refreshMenu() {
          this._toggle.menu.removeAll();

          // Default entry
          const resetItem = new PopupMenu.PopupMenuItem('Use default strategy');
          resetItem.connect('activate', async () => {
            await resetDefault();
            await this._refreshSubtitle();
          });
          this._toggle.menu.addMenuItem(resetItem);

          this._toggle.menu.addMenuItem(new PopupMenu.PopupSeparatorMenuItem());

          // Dynamic strategies
          const strategies = await getStrategies();
          if (strategies.length === 0) {
            const unavailable = new PopupMenu.PopupMenuItem('No strategies available');
            unavailable.setSensitive(false);
            this._toggle.menu.addMenuItem(unavailable);
          } else {
            for (const name of strategies) {
              const item = new PopupMenu.PopupMenuItem(`Use: ${name}`);
              item.connect('activate', async () => {
                await useStrategy(name);
                await this._refreshSubtitle();
              });
              this._toggle.menu.addMenuItem(item);
            }
          }
        }

        destroy() {
          this._toggle?.destroy();
          super.destroy();
        }
      }
    );

    let indicator;

    function init() {}

    function enable() {
      indicator = new Indicator();
    }

    function disable() {
      if (indicator) {
        indicator.destroy();
        indicator = null;
      }
    }
  '';
}

