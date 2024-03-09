{ config, pkgs, ... }:
{

	home.file = {
		# ".config/picom/picom.conf".source = ./picom.conf;
	};

	services.picom = {
		enable = true;
		# TODO convert picom.conf to attrset
		settings = import ./picom.nix {} ;
	};

}
