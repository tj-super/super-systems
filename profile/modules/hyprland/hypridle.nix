{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # Prevents spawning multiple locks
        before_sleep_cmd = "loginctl lock-session"; # Automatically locks before system suspends
        after_sleep_cmd = "hyprctl dispatch dpms on"; # Turns the screen back on waking up
      };

      listener = [
        {
          timeout = 180; # 3 Minutes
          on-timeout = "hyprlock"; # Trigger the lock screen
        }
        {
          timeout = 300; # 5 Minutes
          on-timeout = "hyprctl dispatch dpms off"; # Put screen to sleep / screen saver mode
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
