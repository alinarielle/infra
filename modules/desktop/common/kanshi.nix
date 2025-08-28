{
  home-manager.users.alina.services.kanshi = {
    enable = true;
    profiles = {
      default = {
        outputs = [
          {
            criteria = "eDP-1";
            position = "0,0";
            status = "enable";
          }
        ];
      };
      afra = {
        outputs = [
          {
            criteria = "LG Electronics LG HDR 4K 0x000081B5";
            mode = "3840x2160@59.997";
            position = "0,0";
            scale = 1.5;
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      };
    };
  };
}
