{lib, ...}: {
  l.folders = lib.mergeAttrs 
  (lib.genAttrs [
    "/home/alina/ebooks"
    "/home/alina/docs"
    "/home/alina/notes"
    "/home/alina/zet"
    "/home/alina/videos"
    "/home/alina/pics"
    "/home/alina/src"
    "/home/alina/music"
    "/home/alina/masks"
  ] (name: {
    group = "alina";
    user = "alina";
    mode = "770";
  }))
  {
    "/home/alina" = {
      group = "alina";
      user = "alina";
      mode = "550";
    };
    "/home/alina/dl" = {
      group = "alina";
      user = "alina";
      mode = "770";
      persist = false;
    };
  };
}
