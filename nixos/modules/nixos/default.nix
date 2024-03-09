{ config, pkgs, inputs, nikspkg, ... }:
let 
	# cf docs for more info on how it works https://nixos.org/guides/nix-pills/callpackage-design-pattern.html
	callPackage = path: overrides:
    let f = import path;
    in f ((builtins.intersectAttrs (builtins.functionArgs f) pkgs) // overrides);

	# Compiling the keyboard layout helps catching error in config at build time
	compiledLayout = pkgs.runCommand "keyboard-layout" {} ''
    ${pkgs.xorg.xkbcomp}/bin/xkbcomp ${../../keymaps/azerty} $out
  '';

in
{

	# Enabling flakes
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# I'm just trying to build a rust app :((((
	programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [

    # Add any missing dynamic libraries for unpackaged programs

    # here, NOT in environment.systemPackages

  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
	hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
	services.blueman.enable = true;

	# Enable OpenGL
	hardware.opengl.enable = true;
	hardware.opengl.driSupport32Bit = true;

	# Enable steam
	nixpkgs.config.allowUnfree = true;
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
		dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
	};

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

	# Enable geoclue2 for redshift
	services.geoclue2.enable = true;

	services.udisks2.enable = true;

	# Tailscale configuration
	services.tailscale.enable = true;
	services.tailscale.useRoutingFeatures = "client";  # required to use exit node cf wiki for more info

  # Enable the X11 windowing system.
	services.xserver = {
		enable = true;
		# touchpad configuration
		libinput = {
			enable = true;
			touchpad = {
				naturalScrolling = true;
				clickMethod = "buttonareas";
			};
		};
		# Configuring sddm
		displayManager = {
			sddm = {
				enable = true;
				theme = "catppuccin-macchiato";
			};
		};
  	# Configure keymap in X11
		xkb = {
			layout = "fr";
			variant = "";
		};
		sessionCommands = "${pkgs.xorg.xkbcomp}/bin/xkbcomp ${compiledLayout} $DISPLAY";
  	# Enabling i3
		windowManager = {
			i3 = { 
				enable = true;
				extraPackages = with pkgs; [
					rofi
					polybarFull
					jgmenu
					picom
					feh
				];
			};
		};
	};
	services.dunst = {
		enable = true;
		configFile = ../../../config/dunst/dunstrc
	}

  # Configure console keymap
  # console.keyMap = "fr";
	# use same config as xserver
	console.useXkbConfig

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sofamaniac = {
    isNormalUser = true;
    description = "sofamaniac";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
		#  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
		#  wget
		kitty
		sddm
		git	
		xorg.xkbcomp
		playerctl
		clang
		oh-my-zsh
		tmux
		neofetch
		bat
		btop
		zsh-powerlevel10k
		ctags
		jq
		python3
		ctags
		# required by YAMA #
		yt-dlp
		openssl
		mpv
		ffmpeg
		# ================ #
		rustup
		home-manager
		wineWowPackages.stable  # wine with 32 and 64 bits support
		xclip  # required for clipboard support in vim
		ripgrep
		(callPackage ./sddm-catppuccin.nix {}).sddm-catppuccin
    pkgs.catppuccin-gtk
  ];

	# Setting up fonts 
	fonts.packages = with pkgs; [
		noto-fonts
		noto-fonts-cjk
		noto-fonts-emoji
		noto-fonts-extra
		(nerdfonts.override { fonts = [ "Hack" ]; })
	];
	fonts.fontDir.enable = true;
	# Set default fonts
  fonts.fontconfig.defaultFonts = {
    monospace = [
      "Hack Nerd Font"
      "Noto Sans Mono CJK JP"
    ];

    sansSerif = [
      "Noto Sans"
      "Noto Sans CJK JP"
    ];

    serif = [
      "Noto Serif"
      "Noto Serif CJK JP"
    ];
	};

	# Enable neovim
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;
		withPython3 = true;
		withNodeJs = true;
	};

	# Enabling zsh
	programs.zsh.enable = true;
	users.defaultUserShell = pkgs.zsh;

	# Gtk theming
	# This next stuff is technically not necessary if you're going to use
  # a theme chooser or set it in your user settings, but if you go
  # through all this effort might as well set it system-wide.
  #
  # Oddly, NixOS doesn't have a module for this yet.

  environment.etc."xdg/gtk-2.0/gtkrc".text = ''
    gtk-theme-name = "catppuccin-macchiato"
  '';

  environment.etc."xdg/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name = catppuccin-macchiato
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
	services.openssh.settings.PasswordAuthentication = false;
	users.users.sofamaniac.openssh.authorizedKeys.keyFiles = [ ../../../../.ssh/id_rsa.pub ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
