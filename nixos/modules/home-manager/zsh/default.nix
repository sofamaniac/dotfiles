{
  config,
  pkgs,
  ...
}: {
  home.file = {
    ".p10k.zsh".source = ./.p10k.zsh;
  };

  # configure zsh
  programs.zsh = {
    enable = true;
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    # Enabling oh-my-zsh
    oh-my-zsh = {
      enable = true;
    };

    initExtra = ''
         neofetch
         [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # adding cargo bin to PATH
      export PATH="$PATH:/home/sofamaniac/.cargo/bin"

         # direnv setup
         eval "$(direnv hook zsh)"
    '';

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    shellAliases = {
      update = "sudo nixos-rebuild switch";
      vim = "nvim";
    };
  };
}
