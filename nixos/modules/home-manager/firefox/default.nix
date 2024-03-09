{ config, pkgs, ... }:
{
	programs.firefox.enable = true;
	programs.firefox.profiles = {
		sofamaniac = {
			id = 0;
			name = "sofamaniac";
			search.default = "DuckDuckGo";
			userChrome = builtins.readFile ./userChrome.css;
			settings = {
				"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
				"media.ffmpeg.vaapi.enabled" = true;
			};
		};
	};
}
