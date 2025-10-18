{
  perSystem =
    {
      pkgs,
      config,
      inputs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        strictDeps = true;
        buildInputs = with pkgs; [ zellij kitty ];
        # shellHook = ''
        #    kitty --class dmenu -d ~/infra/ --detach --session --hold --listen-on=unix:@dmenu --override allow_remote_control=socket-only --grab-keyboard --start-as=fullscreen --config ${inputs.infra.nixosConfigurations.x86_64-linux.arielle.home-manager.users.alina.xdg.configFile."kitty/kitty.conf".source -T dmenu zellij }
        # '';
      };
    };
}
