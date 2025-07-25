{
  l.filesystem.rclone.enable = true;
  home-manager.users.alina = {
    xdg.userDirs.music = "/home/alina/mnt/tigris/music";
    services.mpd = {
      enable = true;
      dataDir = "/home/alina/mnt/tigris/mpd_data";
      musicDirectory = "/home/alina/mnt/tigris/music";
      network = {
        listenAddress = "[::]";
        port = 6600;
        startWhenNeeded = true;
      };
      extraConfig = ''
        restore_paused = "yes"
        
        # audio visualizer setup
        audio_output {
          type = "fifo"
          name = "visualizer"
          path "/tmp/mpd.fifo"
          format "44100:16:2"
        }
      '';
    };
    services.mpd-mpris.enable = true;
    programs.rmpc = {
      enable = true;
      config = ''
        (
          address: "[::]:6600",
          password: None,
          theme: None,
          cache_dir: None
          enable_mouse: true,
          enable_config_hot_reload: true,
          max_fps: 30,
        )
      '';
    };
    programs.cava = {
      enable = true;
    };
  };
}
