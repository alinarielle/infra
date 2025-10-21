{ pkgs, ... }:
{
  home-manager.users.alina = {
    services.swayidle =
      let
        lockCommand = "noctalia-shell ipc call lockScreen toggle";
      in
      {
        enable = true;
        events = [
          {
            event = "before-sleep";
            command = lockCommand;
          }
          {
            event = "lock";
            command = lockCommand;
          }
        ];
        timeouts = [
          {
            timeout = 300;
            command = lockCommand;
          }
        ];
      };
  };
}
