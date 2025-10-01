{
  home-manager.users.alina.services.kanshi = {
    enable = true;
    settings = [
      {
        output = {
          criteria = "eDP-1";
          alias = "main";
          scale = 1.5;
        };
      }
      {
        profile = {
          name = "undocked";
          outputs = [ { criteria = "eDP-1"; } ];
        };
      }
      {
        profile = {
          name = "afra";
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "LG Electronics LG HDR 4K 0x000081B5";
              mode = "3840x2160@59.997";
              position = "0,0";
              scale = 1.5;
            }
          ];
        };
      }
    ];
  };
}
