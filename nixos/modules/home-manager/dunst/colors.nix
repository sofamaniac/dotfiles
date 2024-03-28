{
  config,
  pkgs,
  ...
}: {
  # Catppuccin https://github.com/catppuccin/dunst
  services.dunst.settings = {
    global = {
      # Defines color of the frame around the notification window.
      frame_color = "#8AADF4";
      # Define a color for the separator.
      # possible values are:
      #  * auto: dunst tries to find a color fitting to the background;
      #  * foreground: use the same color as the foreground;
      #  * frame: use the same color as the frame;
      #  * anything else will be interpreted as a X color.
      separator_color = "frame";
    };
    urgency_low = {
      background = "#24273A";
      foreground = "#CAD3F5";
      timeout = 10;
    };
    urgency_normal = {
      background = "#24273A";
      foreground = "#CAD3F5";
      timeout = 10;
    };
    urgency_critical = {
      background = "#24273A";
      foreground = "#CAD3F5";
      frame_color = "#F5A97F";
      timeout = 0;
    };
  };
}
