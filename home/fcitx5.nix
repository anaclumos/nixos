{ config, pkgs, inputs, ... }:

{
  xdg.configFile."fcitx5/config" = {
    force = true;
    text = ''
      [Hotkey]
      TriggerKeys=
      EnumerateWithTriggerKeys=True
      AltTriggerKeys=
      EnumerateForwardKeys=
      EnumerateBackwardKeys=
      EnumerateSkipFirst=False
      EnumerateGroupForwardKeys=
      EnumerateGroupBackwardKeys=
      PrevPage=
      NextPage=
      PrevCandidate=
      NextCandidate=
      TogglePreedit=
      ModifierOnlyKeyTimeout=250

      [Hotkey/ActivateKeys]
      0=Control+Control_R

      [Hotkey/DeactivateKeys]
      0=Control+Control_L

      [Behavior]
      ActiveByDefault=False
      resetStateWhenFocusIn=No
      ShareInputState=No
      PreeditEnabledByDefault=True
      ShowInputMethodInformation=True
      showInputMethodInformationWhenFocusIn=False
      CompactInputMethodInformation=True
      ShowFirstInputMethodInformation=True
      DefaultPageSize=5
      OverrideXkbOption=False
      CustomXkbOption=
      EnabledAddons=
      DisabledAddons=
      PreloadInputMethod=True
      AllowInputMethodForPassword=False
      ShowPreeditForPassword=False
      AutoSavePeriod=30
    '';
  };

  xdg.configFile."fcitx5/addon/x11frontend.conf".text = ''
    [Addon]
    Enabled=True
  '';

  xdg.configFile."fcitx5/profile" = {
    force = true;
    text = ''
      [Groups/0]
      Name=Default
      Default Layout=us
      DefaultIM=hangul

      [Groups/0/Items/0]
      Name=keyboard-us
      Layout=

      [Groups/0/Items/1]
      Name=hangul
      Layout=

      [GroupOrder]
      0=Default
    '';
  };

  xdg.configFile."fcitx5/conf/hangul.conf" = {
    force = true;
    text = ''
      Keyboard=Dubeolsik
      AutoReorder=True
      WordCommit=False
      HanjaMode=False

      [HanjaModeToggleKey]
      0=Hangul_Hanja
      1=F9

      [PrevPage]
      0=Up

      [NextPage]
      0=Down

      [PrevCandidate]
      0=Shift+Tab

      [NextCandidate]
      0=Tab
    '';
  };
  xdg.configFile."fcitx5/conf/notifications.conf" = {
    force = true;
    text = ''
      HiddenNotifications=
    '';
  };
  xdg.configFile."fcitx5/conf/xim.conf" = {
    force = true;
    text = ''
      UseOnTheSpot=True
    '';
  };
}
