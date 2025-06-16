{ config, pkgs, ... }:

{
  # Enable fw-fanctrl
  programs.fw-fanctrl.enable = true;

  # Add a custom config
  programs.fw-fanctrl.config = {
    defaultStrategy = "Gentle";
    strategies = {
      "Turbo" = {
        fanSpeedUpdateFrequency = 5;
        movingAverageInterval = 30;
        speedCurve = [
          {
            temp = 0;
            speed = 20;
          }
          {
            temp = 10;
            speed = 40;
          }
          {
            temp = 20;
            speed = 60;
          }
          {
            temp = 30;
            speed = 80;
          }
          {
            temp = 40;
            speed = 100;
          }
        ];
      };
      "Gentle" = {
        fanSpeedUpdateFrequency = 5;
        movingAverageInterval = 30;
        speedCurve = [
          {
            temp = 0;
            speed = 0;
          }
          {
            temp = 20;
            speed = 20;
          }
          {
            temp = 40;
            speed = 40;
          }
          {
            temp = 60;
            speed = 60;
          }
          {
            temp = 80;
            speed = 80;
          }
          {
            temp = 100;
            speed = 100;
          }
        ];
      };
    };
  };
}
