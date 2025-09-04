{lib, config, name, pkgs,  ...}: {
  home-manager.users.alina = {
    programs.librewolf = {
      enable = true;
      settings = {
        "identity.fxaccounts.enable" = true;
        "identity.fxaccounts.enabled" = true;
        "identity.fxaccounts.device.name" = "alina's librewolf on " + name;
        #"identity.fxaccounts.autoconfig.uri" = "https://ffsync.alina.cx/";
        #"identity.fxaccounts.remote.root = "https://ffsync.alina.cx/";
        #"identity.fxaccounts.auth.uri" = "https://api.ffsync.alina.cx/v1";

        "browser.tabs.insertAfterCurrent" = true;
        "browser.bookmarks.editDialog.showForNewBookmarks" = false;
        "browser.search.suggest.enabled" = true;
        "pdfjs.viewerCssTheme" = 2;
        "network.http.referer.XOriginPolicy" = 2;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.downloads" = false;
        "security.OCSP.require" = false;
        "privacy.clearOnShutdown.cookies" = true;
        "svg.context-properties.content.enabled" = true;
        "browser.display.background_color" = "#000000";
        "browser.display.foreground_color" = "ffffff";

        # force enable GPU acceleration
        "gfx.webrender.all" = true;

        # Hide the "sharing indicator", it's especially annoying
        # with tiling WMs on wayland
        "privacy.webrtc.legacyGlobalIndicator" = false;
      };
      profiles.default = {
        search = {
          enable = true;
          force = true;
          default = "kagi";
          engines = {
            noogle = {
              name = "nixpkgs lib";
              urls = [{
                template = "https://noogle.dev/q";
                params = [
                  { name = "term"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "nixon" ];
            };
            nixos-options = {
              name = "NixOS Options";
              urls = [{
                template = "https://search.nixos.org/options";
                params = [
                  { name = "channel"; value = "unstable"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "nixon" ];
            };
            nix-packages = {
              name = "Nix Packages";
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "nixp" ];
            };
            nixos-wiki = {
              name = "NixOS Wiki";
              urls = [{ template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; }];
              iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
              definedAliases = [ "nw" ];
            };

            bing.metaData.hidden = true;
            google.metaData.hidden = true;
            metager.metaData.hidden = true;

            kagi = {
              name = "Kagi";
              urls = [{
                template = "https://kagi.com/search";
                params = [{
                  name = "q"; value = "{searchTerms}";
                }];
                definedAliases = [ "kagi" ];
                iconMapObj."16" = "https://kagi.com/favicon.ico";
              }];
            };
            nixvim = {
              name = "Nixvim";
              definedAliases = ["nv"];
              urls = [{
                template = "https://nix-community.github.io/nixvim/search/";
                params = [
                  { name = "query"; value = "{searchTerms}"; }
                  { name = "option"; value = "{searchTerms}"; }
                ];
              }];
              iconMapObj."16" = "https://nix-community.github.io/favicon.ico";
            };
            crates = {
              name = "crates.io";
              definedAliases = ["crate"];
              urls = [{
                template = "https://crates.io/search/?q={searchTerms}";
              }];
              iconMapObj."16" = "https://crates.io/favicon.ico";
            };
            hm = {
              name = "Home Manager Options";
              definedAliases = ["nixo"];
              urls = [{
                template = "https://home-manager-options.extranix.com/";
                params = [
                  { name = "query"; value = "{searchTerms}"; }
                  { name = "release"; value = "master"; }
                ];
              }];
              iconMapObj."16" = "https://home-manager-options.extranix.com/favicon.ico"; 
            };
            rfc = {
              name = "IETF datatracker";
              definedAliases = ["rfc"];
              urls = [{
                template = "https://datatracker.ietf.org/doc/html/rfc{searchTerms}";
              }];
              iconMapObj."16" = "https://ietf.org/favicon.ico";         
            };
            "1337x" = {
              name = "1337x.to";
              definedAliases = ["arr"];
              urls = [{
                template = "https://1337x.to/search/{searchTerms}/1/";
              }];
              iconMapObj."16" = "https://1337x.to/favicon.ico";
            };
          };
        };
        userChrome = ''
          #sidebar-splitter, so #sidebar-splitter { display: none; }
          /* Hide scrollbar in FF Quantum */
          *{scrollbar-width:none !important}

          /* Hide tab bar in FF Quantum */
          @-moz-document url(chrome://browser/content/browser.xul), url(chrome://browser/content/browser.xhtml) {
            #TabsToolbar {
              visibility: collapse !important;
              margin-bottom: 21px !important;
            }
          
            #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
              visibility: collapse !important;
            }
          }
          #main-window #TabsToolbar {
              visibility: initial;
          }

          #main-window #TabsToolbar {
              visibility: collapse !important;
          }

          #main-window #tabbrowser-tabs {
              z-index: 0 !important;
          }
          :root {
              --autohide-sidebar-width: 0px;
              --uc-window-control-width: 0x; /* Space reserved for window controls */
              --uc-window-drag-space-width: 0px; 
              /* Extra space reserved on both sides of the nav-bar to be able to drag the window */
              --uc-toolbar-height: 0px;
              --autohide-sidebar-toolbar-height: var(--uc-toolbar-height, 0px); /* variable from hide_titlebar.css */
          }
          :root[sizemode="normal"] {
              --autohide-sidebar-toolbar-height: var(--uc-toolbar-height, 0px); /* variable from hide_titlebar.css */
          }
        '';
      };
    };
  };
  environment.etc."librewolf/policies.json" = {
    text = let
      extension = shortId: uuid: {
	name = uuid;
	value = {
	  install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
	  installation_mode = "normal_installed";
	};
      }; 
    in builtins.toJSON { 
      policies = {
	# To add additional extensions, find it on addons.mozilla.org, find
	# the short ID in the url 
	# (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
    	# then to find the extension UUID, go to 
	# about:debugging#/runtime/this-firefox in your browser and grab the
	# extension ID, not the Internal UUID
	ExtensionSettings = lib.listToAttrs [
	  (extension "simple-tab-groups" "simple-tab-groups@drive4ik")
	  (extension "ublock-origin" "uBlock0@raymondhill.net")
	  (extension "umatrix" "uMatrix@raymondhill.net")
	  (extension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
	  (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
	  (extension "bonjourr-startpage" "{4f391a9e-8717-4ba6-a5b1-488a34931fcb}")
	  (extension "canvasblocker" "CanvasBlocker@kkapsner.de")
	  (extension "consent-o-matic" "gdpr@cavi.au.dk")
	  (extension "deadname-remover" "deadname-remover@willhaycode.com")
	  (extension "debrid-link-plugin" "jid1-6kU7yIbrTcZvJg@jetpack")
	  (extension "downthemall" "{DDC359D1-844A-42a7-9AA1-88A850A938A8}")
	  (extension "duckduckgo-for-firefox" "ddg@search.mozilla.org")
	  (extension "fastforwardteam" "addon@fastforward.team")
	  (extension "firefox-translations" "firefox-translations-addon@mozilla.org")
	  (extension "localcdn-fork-of-decentraleyes" "{b86e4813-687a-43e6-ab65-0bde4ab75758}")
	  (extension "libredirect" "7esoorv3@alefvanoon.anonaddy.me")
	  (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
	  (extension "search_by_image" "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}")
	  (extension "sixindicator" "{8c9cad02-c069-4e93-909d-d874da819c49}")
	  (extension "torproject-snowflake" "{b11bea1f-a888-4332-8d8a-cec2be7d24b9}")
	  (extension "sponsorblock" "sponsorBlocker@ajay.app")
	  (extension "styl-us" "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}")
	  (extension "temp-mail" "{2d97895d-fcd3-41ab-82e6-6a1d4d2243f6}")
	  (extension "terms-of-service-didnt-read" "jid0-3GUEt1r69sQNSrca5p8kx9Ezc3U@jetpack")
          (extension "user-agent-string-switcher" "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}")
	  (extension "darkreader" "addon@darkreader.org")
        ];
	SearchEngines = {
	  PreventInstalls = false;
	  Remove = [
	    "Google" "Bing" "Amazon.com" "eBay" "Twitter"
	    "MetaGer" "StartPage" "4get.ca (captcha)" "DuckDuckGo Lite"
	  ];
	  Default = "DuckDuckGo";
	  Add = [{
	    Name = "PsychonautWiki";
	    Description = "search for anything psychoactive";
	    Alias = "psy";
	    Method = "GET";
	    URLTemplate = "https://psychonautwiki.org/w/index.php?title=Special:Search&search={searchTerms}";
	    IconURL = "https://psychonautwiki.org/favicon.org";
	  }
	  {
	    Name = "MELPA";
	    Description = "Milkypostman’s Emacs Lisp Package Archive";
	    Alias = "melpa";
	    Method = "GET";
	    URLTemplate = "https://melpa.org/#/?q={searchTerms}";
	    IconURL = "https://melpa.org/favicon.ico";
	  }
	  {
	    Name = "NixOS packages";
	    Description = "the largest software collection in the world";
	    Alias = "nixp";
	    Method = "GET";
	    URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
	    IconURL = "https://search.nixos.org/favicon.ico";
	  }
	  {
	    Name = "NixOS options";
	    Description = "search NixOS options by name or description";
	    Alias = "nixon";
	    Method = "GET";
	    URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
	    IconURL = "https://search.nixos.org/favicon.org";
	  }
	  {
	    Name = "ArchWiki";
	    Description = "i use arch btw";
	    Alias = "aw";
	    Method = "GET";
	    URLTemplate = "https://wiki.archlinux.org/index.php?title=Special:Search&search={searchTerms}";
	    IconURL = "https://wiki.archlinux.org/favicon.ico";
	  }
	  {
	    Name = "YouTube";
	    Description = "Search for videos on YouTube.";
	    Alias = "y";
	    Method = "GET";
	    URLTemplate = "https://www.youtube.com/results?search_query={searchTerms}&page={startPage?}&utm_source=opensearch";
	    IconURL = "https://youtube.com/favicon.ico";
	  }
	  {
	    Name = "YouTube Music";
	    Description = "search for songs on YouTube Music";
	    Alias = "ym";
	    Method = "GET";
	    URLTemplate = "https://music.youtube.com/search?q={searchTerms}&utm_source=opensearch";
	    IconURL = "https://music.youtube.com/favicon.ico";
	  }
	  {
	    Name = "GitHub";
	    description = "Search GitHub";
	    Alias = "gh";
	    Method = "GET";
	    URLTemplate = "https://github.com/search?q={searchTerms}&ref=opensearch";
	    IconURL = "https://github.com/favicon.ico";
	  }
	  {
	    Name = "Noogle";
	    Description = "Search for nix functions by name.";
	    Alias = "noo";
	    Method = "GET";
	    URLTemplate = "https://noogle.dev/q?term={searchTerms}";
	    IconURL = "https://noogle.dev/favicon.ico";
 	  }
	  {
	    Name = "Home Manager Options Search";
	    Description = "Search for home manager options by name.";
	    Alias = "nixo";
	    Method = "GET";
	    URLTemplate = "https://home-manager-options.extranix.com/?query={searchTerms}";
	    IconURL = "https://home-manager-options.extranix.com/favicon.ico";
	  }
	  {
	    Name = "crates.io";
	    Description = "Search for crates in the official Rust package registry.";
	    Alias = "crate";
	    Method = "GET";
	    URLTemplate = "https://crates.io/search?q={searchTerms}";
	    IconURL = "https://crates.io/favicon.ico";
	  }
	  {
	    Name = "Wikipedia";
	    Alias = "wk";
	    Method = "GET";
	    URLTemplate = "https://en.wikipedia.org/wiki/Special:Search?search={searchTerms}&sourceid=Mozilla-search";
	    Description = "one search away from the knowledge of the world!";
	  }];
	};
      };
    };
  };
}
