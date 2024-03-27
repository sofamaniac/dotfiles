{
  config,
  pkgs,
  nix-colors,
  ...
}: {
  /*
    imports = [
    nix-colors.homeManagerModules.default
  ];

  colorScheme = nix-colors.colorSchemes.catppuccin-macchiato;
  */

  programs.kitty = {
    enable = true;
    /*
       foreground = "#${config.colorScheme.palette.base05}";
    background = "#${config.colorScheme.palette.base00}";
    selection_foreground = "#${config.colorScheme.palette.base00}";
    selection_background = "#${config.colorScheme.palette.base06}";
    cursor = "#${config.colorScheme.palette.base06}";
    cursor_text_color = "#${config.colorScheme.palette.base00}";
    url_color = "#${config.colorScheme.palette.base06}";
    active_border_color = "#${config.colorScheme.palette.base07}";
    inactive_border_color = "#${config.colorScheme.palette.base04}";
    bell_border_color = "#${config.colorScheme.palette.base0A}";
    wayland_titlebar_color = "system";
    macos_titlebar_color = "system";
    active_tab_foreground = "#${config.colorScheme.palette.base0A}";
    */
    extraConfig = builtins.readFile ./kitty.conf;
  };
}
