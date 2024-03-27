{
  stdenv,
  fetchFromGitHub,
}: {
  sddm-catppuccin = stdenv.mkDerivation rec {
    pname = "sddm-catppuccin";
    version = "53f81e3";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src/src/catppuccin-macchiato $out/share/sddm/themes/catppuccin-macchiato
    '';
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "sddm";
      rev = "f3db13cbe8e99a4ee7379a4e766bc8a4c2c6c3dd";
      sha256 = "0zoJOTFjQq3gm5i3xCRbyk781kB7BqcWWNrrIkWf2Xk=";
    };
  };
}
