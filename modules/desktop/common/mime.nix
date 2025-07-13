{lib, ...}: {
  xdg.mime = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "zathura.desktop";
    } // lib.genAttrs 
    [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ]
    (x: "librewolf.desktop");
  };
}
