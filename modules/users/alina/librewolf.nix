{
  lib,
  config,
  name,
  pkgs,
  ...
}:
{
  # services.privoxy = {
  #   enable = true;
  #   enableTor = true;
  #   settings = {
  #     enable-edit-actions = lib.mkForce true;
  #     forward-socks5 = lib.mkForce ".onion [::]:9150 .";
  #     listen-address = "[::]:8118";
  #   };
  # };
  home-manager.users.alina = {
    programs.librewolf = {
      enable = true;
      settings = {
        "accessibility.typeaheadfind" = true;
        "app.normandy.user_id" = "0e3a1639-7478-4888-aa29-3abf483853dd";
        "browser.bookmarks.defaultLocation" = "1KCyr_fRt7-D";
        "browser.bookmarks.editDialog.confirmationHintShowCount" = 3;
        "browser.bookmarks.editDialog.showForNewBookmarks" = false;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.showMobileBookmarks" = true;
        "browser.contentblocking.category" = "off";
        "browser.contextual-services.contextId" = "b016524a-080e-4db0-b8e0-699a61b84031";
        "browser.dom.window.dump.enabled" = true;
        "browser.download.autohideButton" = true;
        "browser.download.dir" = "/home/alina/sort";
        "browser.download.folderList" = 2;
        "browser.download.lastDir" = "/home/alina/sort";
        "browser.download.panel.shown" = true;
        "browser.download.save_converter_index" = 0;
        "browser.download.useDownloadDir" = true;
        "browser.download.viewableInternally.typeWasRegistered.avif" = true;
        "browser.download.viewableInternally.typeWasRegistered.webp" = true;
        "browser.eme.ui.firstContentShown" = true;
        "browser.formfill.enable" = true;
        "browser.ml.enable" = false;
        "browser.newtabpage.activity-stream.asrouter.devtoolsEnabled" = true;
        "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.impressionId" = "";
        "browser.newtabpage.activity-stream.topSitesRows" = 0;
        "browser.newtabpage.blocked" =
          ''{"JXL+aK9F49vqamiUgDBMew==":1,"HxuLLvFts8CF9xiN6mlvjw==":1,"U1Q7azjZY3qZXPsrFyRvAg==":1,"/3SEo1ZtnEJOSRN9WJu8RA==":1,"FDbC6KNDInDavAHigtONBA==":1,"tifhq27ZM7UyZlxWWP4t0g==":1,"QgHbFUbmJuY3fl0l9wYzKg==":1,"HpNnn4X7x63zgqw0t9UjNA==":1,"AI7ERT/zFRP0OJPLp6oxyA==":1,"ddpK6zJ5J14twl3q1dgcPg==":1,"ER2Urnj4G4QO/e+IxHRStg==":1,"CFj1fz8AnbRVmD6f/vFOVw==":1,"0A0nnxMvBtygzWp+s7M20A==":1,"eiBTvu0N4ZXqfABy3NzQ+Q==":1,"ma3j2Ycz8XEVGPF2bDYzIw==":1,"JsXDxHf2zatU+EF75O5+tg==":1,"liU5nX2WxICX0/ybTwdLog==":1,"meEqpdxKYq84DxyXABgOPg==":1,"Eg/rlXk651Pur1WJxtoOEg==":1,"v/yeFlmgWHA848xjWjFNWQ==":1,"ihlKRI8T0yIkT2Q1uI2Hvg==":1,"pQ/WgUy966a/oOWbc6lByw==":1,"+acIB5/uCOtZOzu2R2uEMQ==":1,"grJ6pb1sxJx3pq6jPguUxw==":1,"aiVzfVWEHSpIFElfRK1P3w==":1}'';
        "browser.newtabpage.pinned" =
          ''[{"url":"https://element.catgirl.cloud/#/room/#users:nixos.org","label":"Element | catgirl.cloud [3] | Nix / NixOS","baseDomain":"element.catgirl.cloud"},{"url":"https://www.youtube.com/","label":"YouTube","baseDomain":"youtube.com"},{"url":"https://proxer.me/","label":"Proxer","baseDomain":"proxer.me"},{"url":"https://mail.proton.me/u/5/inbox","label":"mail","baseDomain":"mail.proton.me"},{"url":"https://excalidraw.com/","baseDomain":"excalidraw.com"},{"url":"https://cloud.finallycoffee.eu/","label":"Coffee Cloud","baseDomain":"cloud.finallycoffee.eu"},{"url":"https://jellyfin.heroin.trade/","label":"Heroin Jellyfin","baseDomain":"jellyfin.heroin.trade"},{"url":"https://1337x.to/","label":"1337x","baseDomain":"1337x.to"},{"url":"https://dht.kyouma.net/torrents","label":"magnetico","baseDomain":"dht.kyouma.net"},{"url":"https://redacted.sh/","label":"redacted","baseDomain":"redacted.sh"},{"url":"https://eu.doubledouble.top/","label":"double double top","baseDomain":"eu.doubledouble.top"},{"url":"https://trainsear.ch/","baseDomain":"trainsear.ch"},{"url":"https://travelynx.de/","label":"travelynx","baseDomain":"travelynx.de"},{"url":"https://bahn.expert/","label":"bahn.expert","baseDomain":"bahn.expert"},null,{"url":"https://www.mydealz.de/","label":"mydealz","baseDomain":"mydealz.de"},{"url":"https://tboi.com/","label":"Isaac","baseDomain":"tboi.com"}]'';
        "browser.pageActions.persistedActions" =
          ''{"ids":["bookmark","_3c078156-979c-498b-8990-85f7987dd929_","canvasblocker_kkapsner_de"],"idsInUrlbar":["_3c078156-979c-498b-8990-85f7987dd929_","canvasblocker_kkapsner_de","bookmark"],"idsInUrlbarPreProton":[],"version":1}'';
        "browser.policies.applied" = true;
        "browser.policies.runOncePerModification.extensionsInstall" =
          ''["https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"]'';
        "browser.policies.runOncePerModification.extensionsUninstall" =
          ''["google@search.mozilla.org","bing@search.mozilla.org","amazondotcom@search.mozilla.org","ebay@search.mozilla.org","twitter@search.mozilla.org"]'';
        "browser.policies.runOncePerModification.removeSearchEngines" =
          ''["Google","Bing","Amazon.com","eBay","Twitter"]'';
        "browser.policies.runOncePerModification.setDefaultSearchEngine" = "Kagi";
        "browser.preferences.experimental.hidden" = false;
        "browser.protections_panel.infoMessage.seen" = true;
        "browser.region.network.url" = "";
        "browser.region.update.enabled" = false;
        "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
        "browser.safebrowsing.downloads.remote.block_uncommon" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.safebrowsing.downloads.remote.url" = "";
        "browser.safebrowsing.provider.google4.dataSharingURL" = "";
        "browser.startup.homepage" = "https://kagi.com";
        "browser.startup.homepage_override.extensionControlled" = false;
        "browser.startup.homepage_override.privateAllowed" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.translations.neverTranslateLanguages" = "de";
        "browser.uiCustomization.state" =
          ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["_ddc359d1-844a-42a7-9aa1-88a850a938a8_-browser-action","passff_invicem_pro-browser-action","deadname-remover_willhaycode_com-browser-action","jid1-6ku7yibrtczvjg_jetpack-browser-action","jid0-3guet1r69sqnsrca5p8kx9ezc3u_jetpack-browser-action","_8c9cad02-c069-4e93-909d-d874da819c49_-browser-action","_3c078156-979c-498b-8990-85f7987dd929_-browser-action","sponsorblocker_ajay_app-browser-action","jid1-mnnxcxisbpnsxq_jetpack-browser-action","_12cf650b-1822-40aa-bff0-996df6948878_-browser-action","_74145f27-f039-47ce-a470-a662b129930a_-browser-action","_0981817c-71b3-4853-a801-481c90af2e8e_-browser-action","gdpr_cavi_au_dk-browser-action","wayback_machine_mozilla_org-browser-action","atbc_easonwong-browser-action","_4f391a9e-8717-4ba6-a5b1-488a34931fcb_-browser-action","_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action","addon_fastforward_team-browser-action","canvasblocker_kkapsner_de-browser-action","_2d97895d-fcd3-41ab-82e6-6a1d4d2243f6_-browser-action","_b86e4813-687a-43e6-ab65-0bde4ab75758_-browser-action","search_kagi_com-browser-action"],"nav-bar":["back-button","forward-button","vertical-spacer","stop-reload-button","urlbar-container","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","addon_darkreader_org-browser-action","ublock0_raymondhill_net-browser-action","downloads-button","developer-button","fullscreen-button","sync-button","screenshot-button","unified-extensions-button","firefox_tampermonkey_net-browser-action","umatrix_raymondhill_net-browser-action","_46551ec9-40f0-4e47-8e18-8e5cf550cfb8_-browser-action","_2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c_-browser-action","_73a6fe31-595d-460b-a920-fcc0f8843232_-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"vertical-tabs":[],"PersonalToolbar":["personal-bookmarks"]},"seen":["developer-button","ublock0_raymondhill_net-browser-action","screenshot-button","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","firefox_tampermonkey_net-browser-action","_12cf650b-1822-40aa-bff0-996df6948878_-browser-action","jid0-3guet1r69sqnsrca5p8kx9ezc3u_jetpack-browser-action","_74145f27-f039-47ce-a470-a662b129930a_-browser-action","_0981817c-71b3-4853-a801-481c90af2e8e_-browser-action","gdpr_cavi_au_dk-browser-action","sponsorblocker_ajay_app-browser-action","wayback_machine_mozilla_org-browser-action","atbc_easonwong-browser-action","_4f391a9e-8717-4ba6-a5b1-488a34931fcb_-browser-action","_8c9cad02-c069-4e93-909d-d874da819c49_-browser-action","_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action","addon_fastforward_team-browser-action","_2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c_-browser-action","_3c078156-979c-498b-8990-85f7987dd929_-browser-action","jid1-mnnxcxisbpnsxq_jetpack-browser-action","addon_darkreader_org-browser-action","canvasblocker_kkapsner_de-browser-action","_2d97895d-fcd3-41ab-82e6-6a1d4d2243f6_-browser-action","_b86e4813-687a-43e6-ab65-0bde4ab75758_-browser-action","search_kagi_com-browser-action","deadname-remover_willhaycode_com-browser-action","jid1-6ku7yibrtczvjg_jetpack-browser-action","umatrix_raymondhill_net-browser-action","passff_invicem_pro-browser-action","_ddc359d1-844a-42a7-9aa1-88a850a938a8_-browser-action","_46551ec9-40f0-4e47-8e18-8e5cf550cfb8_-browser-action","_73a6fe31-595d-460b-a920-fcc0f8843232_-browser-action"],"dirtyAreaCache":["nav-bar","vertical-tabs","toolbar-menubar","TabsToolbar","PersonalToolbar","unified-extensions-area"],"currentVersion":23,"newElementCount":10}'';
        "browser.urlbar.showSearchTerms.enabled" = true;
        "browser.urlbar.suggest.engines" = true;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.searches" = true;
        "browser.urlbar.suggest.topsites" = false;
        "captivedetect.canonicalURL" = "http://captive"; # TODO: setup nginx upstream for captive portals to this
        "datareporting.dau.cachedUsageProfileGroupID" = "";
        "datareporting.dau.cachedUsageProfileID" = "";
        "devtools.aboutdebugging.collapsibilities.processes" = true;
        "devtools.aboutdebugging.collapsibilities.tab" = true;
        "devtools.aboutdebugging.showReduxActionsInConsole" = true;
        "devtools.aboutdebugging.tmpExtDirPath" = "/home/alina/src/octane";
        "devtools.accessibility.enabled" = false;
        "devtools.application.enabled" = false;
        "devtools.browserconsole.enableNetworkMonitoring" = true;
        "devtools.browserconsole.filter.css" = true;
        "devtools.browserconsole.filter.net" = true;
        "devtools.browserconsole.filter.netxhr" = true;
        "devtools.browserconsole.input.editor" = true;
        "devtools.cache.disabled" = true;
        "devtools.command-button-measure.enabled" = true;
        "devtools.command-button-noautohide.enabled" = true;
        "devtools.command-button-rulers.enabled" = true;
        # devtools.command-button-screenshot.enabled" = true;
        # devtools.console.stdout.chrome" = true;
        # devtools.console.stdout.content" = true;
        # devtools.custom-formatters.enabled" = true;
        # devtools.debugger.auto-pretty-print" = true;
        # devtools.debugger.features.code-folding" = true;
        # devtools.debugger.features.javascript-tracing" = true;
        # devtools.debugger.remote-enabled" = true;
        # devtools.debugger.show-content-scripts" = true;
        # devtools.debugger.xhr-breakpoints-visible" = true;
        # devtools.dom.enabled" = true;
        # devtools.editor.keymap" = "vim";
        # devtools.inspector.chrome.three-pane-enabled" = true;
        # devtools.inspector.showAllAnonymousContent = true;
        # devtools.inspector.showUserAgentStyles = true;
        # devtools.inspector.three-pane-enabled = false;
        # devtools.layout.boxmodel.highlightProperty = true;
        # devtools.layout.boxmodel.opened = false;
        # devtools.layout.flex-container.opened = false;
        # devtools.layout.flex-item.opened = false;
        # devtools.layout.flexbox.opened = false;
        # devtools.layout.grid.opened = false;
        # devtools.markup.beautifyOnCopy = true;
        # devtools.markup.collapseAttributes = false;
        # devtools.memory.enabled = false;
        # devtools.netmonitor.columnsData = ''[{"name":"override","minWidth":20,"width":2},{"name":"status","minWidth":30,"width":12.33},{"name":"method","minWidth":30,"width":11.36},{"name":"domain","minWidth":30,"width":17.03},{"name":"file","minWidth":30,"width":17.98},{"name":"url","minWidth":30,"width":55.81},{"name":"initiator","minWidth":30,"width":12.44},{"name":"type","minWidth":30,"width":8.05},{"name":"transferred","minWidth":30,"width":22.18},{"name":"contentSize","minWidth":30,"width":12.45},{"name":"waterfall","minWidth":150,"width":5.65},{"name":"cookies","minWidth":30,"width":5.4},{"name":"setCookies","minWidth":30,"width":5.33},{"name":"remoteip","minWidth":30,"width":6.4},{"name":"path","minWidth":30,"width":14.03},{"name":"protocol","minWidth":30,"width":7.41},{"name":"scheme","minWidth":30,"width":7.41}]'';
        # devtools.netmonitor.filters = ''["xhr","other"]'';
        # devtools.netmonitor.har.compress = true;
        # devtools.netmonitor.har.defaultLogDir = "/home/alina/log/web";
        # devtools.netmonitor.har.enableAutoExportToFile = true;
        # devtools.netmonitor.har.forceExport = true;
        # devtools.netmonitor.har.jsonp = true;
        # devtools.netmonitor.har.multiple-pages = true;
        # devtools.netmonitor.msg.visibleColumns = ''["data","time"]'';
        # devtools.netmonitor.panes-network-details-width = 492;
        # devtools.netmonitor.persistlog = true;
        # devtools.netmonitor.visibleColumns = ''["status","method","url","type","contentSize","waterfall"]'';
        # devtools.performance.enabled = false;
        # devtools.screenshot.clipboard.enabled = true;
        # devtools.selfxss.count = 5;
        # devtools.serviceWorkers.testing.enabled = true;
        # devtools.storage.enabled = false;
        # devtools.theme = "dark";
        # devtools.toolbox.host = "window";
        # devtools.toolbox.previousHost = "window";
        # devtools.toolbox.selectedTool = "netmonitor";
        # devtools.toolbox.zoomValue = 1.2;
        # dom.forms.autocomplete.formautofill = true;
        # dom.push.userAgentID = "c5f2621662f7454aab4dd5b748d18cef";
        # dom.security.https_only_mode_ever_enabled = true;
        # dom.security.https_only_mode_ever_enabled_pbm = true;
        # #extensions.activeThemeID =	"firefox-compact-dark@mozilla.org";
        # extensions.pictureinpicture.enable_picture_in_picture_overrides = false;
        # extensions.ui.dictionary.hidden = false;
        # extensions.ui.extension.hidden = false;
        # extensions.ui.locale.hidden = false;
        # extensions.ui.plugin.hidden = false;
        # extensions.ui.sitepermission.hidden = false;
        # extensions.ui.theme.hidden = false;
        # extensions.webcompat.enable_shims = true;
        # extensions.webcompat.perform_injections = true;
        # # extensions.webextensions.ExtensionStorageIDB.migrated.ATBC@EasonWong	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.CanvasBlocker@kkapsner.de	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.addon@darkreader.org	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.addon@fastforward.team	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.deadname-remover@willhaycode.com	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.firefox@tampermonkey.net	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.gdpr@cavi.au.dk	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.jid0-3GUEt1r69sQNSrca5p8kx9Ezc3U@jetpack	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.jid1-6kU7yIbrTcZvJg@jetpack	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.jid1-MnnxcxisBPnSXQ@jetpack	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.passff@invicem.pro	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.sponsorBlocker@ajay.app	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.uBlock0@raymondhill.net	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.wayback_machine@mozilla.org	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.{0981817c-71b3-4853-a801-481c90af2e8e}	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.{2d97895d-fcd3-41ab-82e6-6a1d4d2243f6}	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.{3c078156-979c-498b-8990-85f7987dd929}	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.{446900e4-71c2-419f-a6a7-df9c091e268b}	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.{46551EC9-40F0-4e47-8E18-8E5CF550CFB8}	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.{4f391a9e-8717-4ba6-a5b1-488a34931fcb}	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.{73a6fe31-595d-460b-a920-fcc0f8843232}	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.{74145f27-f039-47ce-a470-a662b129930a}	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.{8c9cad02-c069-4e93-909d-d874da819c49}	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.{DDC359D1-844A-42a7-9AA1-88A850A938A8}	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}	true
        # # extensions.webextensions.ExtensionStorageIDB.migrated.{b86e4813-687a-43e6-ab65-0bde4ab75758}	true
        # extensions.webextensions.uuids = ''{"formautofill@mozilla.org":"d0b2b0fe-3f5a-47b7-86e9-bc62d021f9c5","newtab@mozilla.org":"94121165-2b5e-485f-8dd1-0898fa377bc8","pictureinpicture@mozilla.org":"f18d5604-48eb-4223-af7a-67671f9570b3","addons-search-detection@mozilla.com":"16e09d63-d26b-4b0f-9c7b-816b2e839b3a","webcompat@mozilla.org":"9a310967-e580-48bf-b3e8-4eafebbc122d","default-theme@mozilla.org":"deb98097-bfb0-4d89-8f2d-6f64872cb44f","uBlock0@raymondhill.net":"fa62f6ad-b409-48cb-9497-4f0b8d93d2fb","firefox-compact-dark@mozilla.org":"c0139ff7-0129-4975-9011-87a970d8fa9d","{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}":"d860513b-ad42-4b3c-a2a5-5632141b4dad","{446900e4-71c2-419f-a6a7-df9c091e268b}":"f4a0a1b0-5000-41ef-b8e9-d4130b05e1d6","firefox@tampermonkey.net":"ae92079c-a1a7-4eb4-9817-04c6a3de98e0","{12cf650b-1822-40aa-bff0-996df6948878}":"238f8872-b4aa-4631-a3ea-4e2e645580e8","jid1-ZAdIEUB7XOzOJw@jetpack":"f58a9440-580a-4bdf-8c46-74987cb821bb","jid0-3GUEt1r69sQNSrca5p8kx9Ezc3U@jetpack":"3f7d5aa3-8561-4c38-a22b-6f0daa595215","{74145f27-f039-47ce-a470-a662b129930a}":"3c1e79a8-71d9-46d1-938f-2ef406ee106f","{0981817c-71b3-4853-a801-481c90af2e8e}":"61a2d3a8-b627-433b-9156-4f64ed1fe3f1","wappalyzer@crunchlabz.com":"5d4a9e95-ee83-40ee-b48a-885300b39a77","gdpr@cavi.au.dk":"7c7b3ffb-9a00-4369-81ce-6ba9c533313b","simple-tab-groups@drive4ik":"5854b6a4-5c03-4c33-8a2b-ba47f8232327","sponsorBlocker@ajay.app":"fcca04af-5679-4f49-a237-29831dd600b5","wayback_machine@mozilla.org":"c7799ba2-834f-4af0-8d85-09c549580b45","ATBC@EasonWong":"6836a917-fd90-43ef-90e6-50bb68782eeb","{4f391a9e-8717-4ba6-a5b1-488a34931fcb}":"bca01fe3-9bea-4e04-b606-4248f1b5986e","{8c9cad02-c069-4e93-909d-d874da819c49}":"c85213dd-28cb-4db0-aeed-f2c829622db5","{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}":"3f17d76d-6fac-49e3-8a3f-1501df21821d","addon@fastforward.team":"5e95cff4-d162-4756-9548-6130eb6a0837","ipvfoo@pmarks.net":"8c374a88-eca0-49e0-852b-0337eeea456e","7esoorv3@alefvanoon.anonaddy.me":"2660c1a5-638d-43dd-9291-c388f1097019","{73a6fe31-595d-460b-a920-fcc0f8843232}":"9845bad3-cfd6-4a88-a492-a795fd3ccae5","{3c078156-979c-498b-8990-85f7987dd929}":"38804940-7d28-4ba1-8b05-f870d42cf9db","jid1-MnnxcxisBPnSXQ@jetpack":"5069b42f-264d-4f0d-86ee-149229903675","lean-tab-limiter@etienneguerlain.fr":"b44526b7-d428-44a6-aaea-bd765ff90228","addon@darkreader.org":"035664e9-c3f7-4a25-99fe-6219b9e1c2a7","CanvasBlocker@kkapsner.de":"425aadd5-008d-4832-b806-19ef59450c28","{2d97895d-fcd3-41ab-82e6-6a1d4d2243f6}":"98d22a89-cfd6-47d9-9d21-ceb2487fb7ed","{b86e4813-687a-43e6-ab65-0bde4ab75758}":"dab50314-653f-4358-a66b-f93b1d976bc7","{aecec67f-0d10-4fa7-b7c7-609a2db280cf}":"4951f424-e6b8-4d98-9de1-0a5b780c42a6","deadname-remover@willhaycode.com":"09cc41a4-2425-416e-a0d9-24140f62a7ec","jid1-6kU7yIbrTcZvJg@jetpack":"296767bb-aee1-469c-ad67-aea23aa516fa","passff@invicem.pro":"149e629f-ba0b-4119-bb7b-2cd4c722056c","ipp-activator@mozilla.com":"3fdb7e67-e363-4564-8848-8d693b19a045","{DDC359D1-844A-42a7-9AA1-88A850A938A8}":"796939a0-7aa4-4a2c-9f7c-6e14de1dc35d","hi@alina.cx":"668e7f1d-22c2-4705-8455-68da1338f16e","{46551EC9-40F0-4e47-8E18-8E5CF550CFB8}":"48b26f63-8d51-4bf3-ab02-289545933b4d","data-leak-blocker@mozilla.com":"5328e0e3-162f-4199-a60b-76c74e410dfd"}'';
        # findbar.highlightAll = true;
        # identity.fxaccounts.account.device.name = "arielle";
        # identity.fxaccounts.account.telemetry.sanitized_uid = "86eedc6e3830f1b68d4ecdf73538e7de";
        # identity.fxaccounts.lastSignedInUserHash = "WjTxgIrvgnH6548E+M5TXWatlPv5eLInNLN9bJnpDJE=";
        # intl.accept_languages = "en-US, en, de";
        # layout.css.prefers-color-scheme.content-override = 1;
        # network.captive-portal-service.enabled = true;
        # network.connectivity-service.enabled = false;
        # network.http.speculative-parallel-limit = 10;
        # network.prefetch-next = true;
        # network.trr.excluded-domains = "";
        # network.trr.mode = 3;
        # network.trr.uri = "https://doh.libredns.gr/noads";
        # pdfjs.enableAltText = true;
        # pdfjs.enableAltTextForEnglish = true;
        # privacy.disable_button.cookie_exceptions = false;
        # privacy.annotate_channels.strict_list.enabled = true;
        # privacy.clearOnShutdown.formdata = false;
        # privacy.clearOnShutdown_v2.downloads = false;
        # privacy.donottrackheader.enabled = true;
        # privacy.fingerprintingProtection = true;
        # privacy.globalprivacycontrol.was_ever_enabled = true;
        # privacy.history.custom = true;
        # privacy.query_stripping.enabled = true;
        # "privacy.query_stripping.enabled.pbmode" = true;
        # privacy.resistFingerprinting = false;
        # privacy.trackingprotection.allow_list.baseline.enabled = false;
        # privacy.trackingprotection.allow_list.convenience.enabled = false;
        # privacy.trackingprotection.allow_list.hasMigratedCategoryPrefs = true;
        # privacy.trackingprotection.consentmanager.skip.pbmode.enabled = false;
        # privacy.trackingprotection.emailtracking.enabled = true;
        # privacy.trackingprotection.enabled = true;
        # privacy.trackingprotection.socialtracking.enabled = true;
        # privacy.userContext.extension = "passff@invicem.pro";
        # security.OCSP.enabled = 0;
        # security.disable_button.openDeviceManager = false;
        # security.tls.enable_0rtt_data = true;
        # services.sync.username = "alina@duck.com";
        # sidebar.installed.extensions = "{3c078156-979c-498b-8990-85f7987dd929},{446900e4-71c2-419f-a6a7-df9c091e268b}";
        # sidebar.main.tools = "history,{3c078156-979c-498b-8990-85f7987dd929},{446900e4-71c2-419f-a6a7-df9c091e268b}";
        # sidebar.old-sidebar.has-used = true;
        # sidebar.visibility = "hide-sidebar";
        # webgl.disabled = false;
        # widget.gtk.overlay-scrollbars.enabled = true;

        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "identity.fxaccounts.enable" = true;
        "identity.fxaccounts.enabled" = true;
        "identity.fxaccounts.device.name" = "alina's librewolf on " + name;
        #"identity.fxaccounts.autoconfig.uri" = "https://ffsync.alina.cx/";
        #"identity.fxaccounts.remote.root = "https://ffsync.alina.cx/";
        #"identity.fxaccounts.auth.uri" = "https://api.ffsync.alina.cx/v1";

        "browser.tabs.insertAfterCurrent" = true;
        "browser.search.suggest.enabled" = true;
        "pdfjs.viewerCssTheme" = 2;
        "network.http.referer.XOriginPolicy" = 2;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.downloads" = false;
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
              urls = [
                {
                  template = "https://noogle.dev/q";
                  params = [
                    {
                      name = "term";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "noo" ];
            };
            nixos-options = {
              name = "NixOS Options";
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "nixon" ];
            };
            arch-wiki = {
              name = "Arch Wiki";
              urls = [
                {
                  template = "https://wiki.archlinux.org/index.php";
                  params = [
                    {
                      name = "title";
                      value = "Special%3ASearch";
                    }
                    {
                      name = "wprov";
                      value = "acrw1_-1";
                    }
                    {
                      name = "search";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconMapObj."16" = "https://wiki.archlinux.org/favicon.ico";
              definedAliases = [ "aw" ];
            };
            nix-packages = {
              name = "Nix Packages";
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "nixp" ];
            };
            nixos-wiki = {
              name = "NixOS Wiki";
              urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
              iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
              definedAliases = [ "nw" ];
            };

            bing.metaData.hidden = true;
            google.metaData.hidden = true;
            metager.metaData.hidden = true;

            youtube = {
              name = "Youtube";
              urls = [
                {
                  template = "https://youtube.com/results";
                  params = [
                    {
                      name = "search_query";
                      value = "{searchTerms}";
                    }
                  ];
                  definedAliases = [ "yt" ];
                  iconMapObj."16" = "https://youtube.com/favicon.ico";
                }
              ];
            };
            kagi = {
              name = "Kagi";
              urls = [
                {
                  template = "https://kagi.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                  definedAliases = [ "kagi" ];
                  iconMapObj."16" = "https://kagi.com/favicon.ico";
                }
              ];
            };
            nixvim = {
              name = "Nixvim";
              definedAliases = [ "nv" ];
              urls = [
                {
                  template = "https://nix-community.github.io/nixvim/search/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "option";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconMapObj."16" = "https://nix-community.github.io/favicon.ico";
            };
            crates = {
              name = "crates.io";
              definedAliases = [ "crate" ];
              urls = [
                {
                  template = "https://crates.io/search/?q={searchTerms}";
                }
              ];
              iconMapObj."16" = "https://crates.io/favicon.ico";
            };
            hm = {
              name = "Home Manager Options";
              definedAliases = [ "nixo" ];
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "release";
                      value = "master";
                    }
                  ];
                }
              ];
              iconMapObj."16" = "https://home-manager-options.extranix.com/favicon.ico";
            };
            rfc = {
              name = "IETF datatracker";
              definedAliases = [ "rfc" ];
              urls = [
                {
                  template = "https://datatracker.ietf.org/doc/html/rfc{searchTerms}";
                }
              ];
              iconMapObj."16" = "https://ietf.org/favicon.ico";
            };
            "1337x" = {
              name = "1337x.to";
              definedAliases = [ "arr" ];
              urls = [
                {
                  template = "https://1337x.to/search/{searchTerms}/1/";
                }
              ];
              iconMapObj."16" = "https://1337x.to/favicon.ico";
            };
          };
        };
        userChrome = ''
          @-moz-document domain(bahn.expert) {
              :root { 
                --mui-palette-common-blue: ${config.l.users.alina.theme.colors.blue} !important;
                --mui-palette-primary-main: ${config.l.users.alina.theme.colors.purple} !important;
              }
          }
          /* Hide scrollbar in FF Quantum */
          *{scrollbar-width: 2px !important}

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
              --uc-window-drag-space-width: 1px; 
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
    text =
      let
        extension = shortId: uuid: {
          name = uuid;
          value = {
            install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
            installation_mode = "normal_installed";
          };
        };
      in
      builtins.toJSON {
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
              "Google"
              "Bing"
              "Amazon.com"
              "eBay"
              "Twitter"
              "MetaGer"
              "StartPage"
              "4get.ca (captcha)"
              "DuckDuckGo Lite"
            ];
            Default = "DuckDuckGo";
            Add = [
              {
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
              }
            ];
          };
        };
      };
  };
}
