{ config, pkgs, inputs, ... }:

{
  # Create fcitx5 configuration file
  xdg.configFile."fcitx5/config" = {
    force = true;
    text = ''
      [Hotkey]
      # Trigger Input Method
      TriggerKeys=
      # Enumerate when press trigger key repeatedly
      EnumerateWithTriggerKeys=True
      # Temporally switch between first and current Input Method
      AltTriggerKeys=
      # Enumerate Input Method Forward
      EnumerateForwardKeys=
      # Enumerate Input Method Backward
      EnumerateBackwardKeys=
      # Skip first input method while enumerating
      EnumerateSkipFirst=False
      # Enumerate Input Method Group Forward
      EnumerateGroupForwardKeys=
      # Enumerate Input Method Group Backward
      EnumerateGroupBackwardKeys=
      # Default Previous page
      PrevPage=
      # Default Next page
      NextPage=
      # Default Previous Candidate
      PrevCandidate=
      # Default Next Candidate
      NextCandidate=
      # Toggle embedded preedit
      TogglePreedit=
      # Time limit in milliseconds for triggering modifier key shortcuts
      ModifierOnlyKeyTimeout=250

      [Hotkey/ActivateKeys]
      0=Control+Control_R

      [Hotkey/DeactivateKeys]
      0=Control+Control_L

      [Behavior]
      # Active By Default
      ActiveByDefault=False
      # Reset state on Focus In
      resetStateWhenFocusIn=No
      # Share Input State
      ShareInputState=No
      # Show preedit in application
      PreeditEnabledByDefault=True
      # Show Input Method Information when switch input method
      ShowInputMethodInformation=True
      # Show Input Method Information when changing focus
      showInputMethodInformationWhenFocusIn=False
      # Show compact input method information
      CompactInputMethodInformation=True
      # Show first input method information
      ShowFirstInputMethodInformation=True
      # Default page size
      DefaultPageSize=5
      # Override Xkb Option
      OverrideXkbOption=False
      # Custom Xkb Option
      CustomXkbOption=
      # Force Enabled Addons
      EnabledAddons=
      # Force Disabled Addons
      DisabledAddons=
      # Preload input method to be used by default
      PreloadInputMethod=True
      # Allow input method in the password field
      AllowInputMethodForPassword=False
      # Show preedit text when typing password
      ShowPreeditForPassword=False
      # Interval of saving user data in minutes
      AutoSavePeriod=30
    '';
  };

  xdg.configFile."fcitx5/addon/x11frontend.conf".text = ''
    [Addon]
    Enabled=True
  '';
}
