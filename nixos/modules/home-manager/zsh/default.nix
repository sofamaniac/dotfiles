{ config, pkgs, ... }:
{

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

			# update hwmon path for polybar
			for i in /sys/class/hwmon/hwmon*/temp*_input; do 
			if [ "$(<$(dirname $i)/name): $(cat ''${i%_*}_label 2>/dev/null || echo $(basename ''${i%_*}))" = "coretemp: Core 0" ]; then
					export HWMON_PATH="$i"
			fi
			done

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
