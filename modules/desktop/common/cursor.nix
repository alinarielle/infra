{ pkgs, lib, ... }:
{
  home-manager.users.alina.home.pointerCursor =
    let
      getFrom = hash: name: url: {
        gtk.enable = true;
        x11.enable = true;
        inherit name;
        size = 48;
        package = pkgs.runCommand "moveUp" { } ''
          	mkdir -p $out/share/icons
          	ln -s ${
             pkgs.fetchzip {
               inherit url hash;
             }
           } $out/share/icons/${name}
        '';
      };
    in
    lib.mkForce (
      getFrom "sha256-wCrIjQo7eKO+piIz88TZDpMnc51iCWDYBR7HBV8/CPI=" "Bibita-Modern-Ice"
        "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.6/Bibata-Modern-Ice.tar.xz"
    );
}
