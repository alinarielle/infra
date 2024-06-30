{lib, config, ...}: 
with lib; with builtins; {
    home-manager.users.alina = {
	programs.librewolf = {
	    enable = true;
	    settings = {
		"identity.fxaccounts.enable" = true;
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
	    };
	};
	environment.etc."librewolf/policies.json" = {
	    text = let
		#the shortId can be found in the extension's URL 
		#(like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
		#the uuid is the extension id in about:debugging#/runtime/this-firefox
		extension = shortId: uuid: {
		    name = uuid;
		    value = {
			install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
			installation_mode = "normal_installed";
		    };
		};
		addSearchEngine = {
		    
		}: {
		    
		};
		policies = {
		# To add additional extensions, find it on addons.mozilla.org, find
		# the short ID in the url 
		# (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
    		# then to find the extension UUID, go to 
		# about:debugging#/runtime/this-firefox in your browser and grab the
		# extension ID, not the Internal UUID
		    policies.ExtensionSettings = listToAttrs [
		    (extension "simple-tab-groups" "simple-tab-groups@drive4ik")
		    (extension "ublock-origin" "uBlock0@raymondhill.net")
		    (extension "umatrix" "uMatrix@raymondhill.net")
		    (extension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
		    (extension "bitwarden-password-manager" 
			"{446900e4-71c2-419f-a6a7-df9c091e268b}")
		    (extension "bonjourr-startpage" 
			"{4f391a9e-8717-4ba6-a5b1-488a34931fcb}")
		    (extension "canvasblocker" "CanvasBlocker@kkapsner.de")
		    (extension "consent-o-matic" "gdpr@cavi.au.dk")
		    (extension "deadname-remover" "deadname-remover@willhaycode.com")
		    (extension "debrid-link-plugin" "jid1-6kU7yIbrTcZvJg@jetpack")
		    (extension "downthemall" "{DDC359D1-844A-42a7-9AA1-88A850A938A8}")
		    (extension "duckduckgo-for-firefox" "ddg@search.mozilla.org")
		    (extension "fastforwardteam" "addon@fastforward.team")
		    (extension "firefox-translations" 
			"firefox-translations-addon@mozilla.org")
		    (extension "localcdn-fork-of-decentraleyes" 
			"{b86e4813-687a-43e6-ab65-0bde4ab75758}")
		    (extension "libredirect" "7esoorv3@alefvanoon.anonaddy.me")
		    (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
		    #(extension "return-youtube-dislikes" 
			#"{762f9885-5a13-4abd-9c77-433dcd38b8fd}")
		    (extension "search_by_image" "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}")
		    (extension "sixindicator" "{8c9cad02-c069-4e93-909d-d874da819c49}")
		    (extension "torproject-snowflake" 
			"{b11bea1f-a888-4332-8d8a-cec2be7d24b9}")
		    (extension "sponsorblock" "sponsorBlocker@ajay.app")
		    (extension "styl-us" "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}")
		    (extension "temp-mail" "{2d97895d-fcd3-41ab-82e6-6a1d4d2243f6}")
		    (extension "terms-of-service-didnt-read" 
			"jid0-3GUEt1r69sQNSrca5p8kx9Ezc3U@jetpack")
		    (extension "user-agent-string-switcher" 
			"{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}")
		    #(extension "violentmonkey" 
			#"{aecec67f-0d10-4fa7-b7c7-609a2db280cf}")
		    #(extension "youtube-window-fullscreen" 
			#"{59c55aed-bdb3-4f2f-b81d-27011a689be6}")
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
			Name = "Wikipedia";
			URLTemplate = ;
			Method = "GET";
			Alias = "";
			Description = "";
			SuggestURLTemplate = "";
		    }
		    {
			Name = "Wikipedia";
			Alias = "wk";
			URLTemplate = "https://en.wikipedia.org/wiki/Special:Search?search={searchTerms}&sourceid=Mozilla-search";
			Description = "one search away from the knowledge of the world!";
			IconURL = ''data:image/x-icon;base64,
AAABAAMAMDAQAAEABABoBgAANgAAACAgEAABAAQA6AIAAJ4GAAAQEBAAAQAEACgBAACGCQAAKAAA
ADAAAABgAAAAAQAEAAAAAAAABgAAAAAAAAAAAAAQAAAAAAAAAAEBAQAXFxcAMDAwAEdHRwBYWFgA
Z2dnAHZ2dgCHh4cAlZWVAKmpqQC3t7cAx8fHANfX1wDo6OgA/v7+AAAAAAD////+7u7u7u7u7u7u
7u7u7u7u7u///////+7u7u7u7u7u7u7u7u7u7u7u7u7u/////u7u7u7u7u7u7u7u7u7u7u7u7u7u
7///7u7u7u7u7u7u7u7u7u7u7u7u7u7u7v/+7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u/+7u7u7u7u
7u7u7u7u7u7u7u7u7u7u7u/+7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u/u7u7u7u7u7u7u7u7u7u7u
7u7u7u7u7u7u7u7u7u7u7sa+7u7u7u1b7u7u7u7u7u7u7u7u7u7u7p9u7u7u7ugG7u7u7u7u7u7u
7u7u7u7u7TAa7u7u7tQBzu7u7u7u7u7u7u7u7u7u6wAF7u7u7pAAju7u7u7u7u7u7u7u7u7u1AAA
ru7u7U//Le7u7u7u7u7u7u7u7u7uz/8RPe7u6gAB+e7u7u7u7u7u7u7u7u7ubw94Ce7u1QAIIu7u
7u7u7u7u7u7u7u7tH/G+Mt7usAAtcL7u7u7u7u7u7u7u7u7n8ATun47uQACO0T7u7u7u7u7u7u7u
7u7hDxnu4x3sAPLO5Qzu7u7u7u7u7u7u7u6P/z7u6wXk/wfu7ATu7u7u7u7u7u7u7u4QAY7u7kCQ
ADzu7kDO7u7u7u7u7u7u7uoA8u7u7sAAAG7u7r9e7u7u7u7u7u7u7uIPB+7u7uUAAs7u7uMd7u7u
7u7u7u7u7rEAHe7u7uQABu7u7un37u7u7u7u7u7u7kAAXu7u7sAPHe7u7u4S3u7u7u7u7u7u7BAA
3u7u7k8AHO7u7u6Aju7u7u7u7u7u5g/07u7u7B8BBe7u7u7RLu7u7u7u7u7u0v/87u7u5QAGQa7u
7u7nCe7u7u7u7u7ugAA+7u7uwQ8dsE7u7u7rBO7u7u7u7u7tP/++7u7uYAB+5Qnu7u7tQa7u7u7u
7u7pH/Lu7u7sLwHe6xPe7u7ur27u7u7u7u7V//ru7u7mAAju7n+e7u7u0yvu7u7u7u6h8C3u7u6y
AB3u7rEs7u7u6Pfu7u7u7u1AAE7u7u5g/27u7tQG3u7u6QHO7u7u7tbwAB3u7ukfAH7u7sIAju7u
5wA97u7utiAAAAF76lAA/wWeyDAA84zqUAABfO7uMiNERDIm4iNERDIrkiNEQybiI0RDJO7u7u7u
7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u
7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u
7u7+7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u/+7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u/+7u7u7u7u
7u7u7u7u7u7u7u7u7u7u7u//7u7u7u7u7u7u7u7u7u7u7u7u7u7u7v///u7u7u7u7u7u7u7u7u7u
7u7u7u7u7////+7u7u7u7u7u7u7u7u7u7u7u7u7u///////+7u7u7u7u7u7u7u7u7u7u7u/////+
AAAAAH8AAPAAAAAADwAA4AAAAAAHAADAAAAAAAMAAIAAAAAAAQAAgAAAAAABAACAAAAAAAEAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAABAACAAAAAAAEA
AIAAAAAAAQAAwAAAAAADAADgAAAAAAcAAPAAAAAADwAA/gAAAAB/AAAoAAAAIAAAAEAAAAABAAQA
AAAAAIACAAAAAAAAAAAAABAAAAAAAAAAAQEBABYWFgAnJycANTU1AEdHRwBZWVkAZWVlAHh4eACI
iIgAmZmZAK6urgDMzMwA19fXAOnp6QD+/v4AAAAAAP//7u7u7u7u7u7u7u7u////7u7u7u7u7u7u
7u7u7u7//u7u7u7u7u7u7u7u7u7u7/7u7u7u7u7u7u7u7u7u7u/u7u7u7u7u7u7u7u7u7u7u7u7u
7u7X3u7u7I7u7u7u7u7u7u7uYF7u7uIK7u7u7u7u7u7u7QAM7u6vBO7u7u7u7u7u7ucABe7uMA/O
7u7u7u7u7u7R8q/O6gCEbu7u7u7u7u7ukAnibuTx6g3u7u7u7u7u7hAe6gzP+O4Y7u7u7u7u7urw
ju4mXx7uge7u7u7u7u7jAd7uoACO7tCe7u7u7u7uoPfu7uEB3u7mPu7u7u7u7k8N7u7QBu7u6wru
7u7u7uwAXu7ufwbu7u407u7u7u7lAM7u7RBQzu7ur87u7u7u0ATu7ucA0l7u7uFu7u7u7n/67u7R
B+oL7u7nHe7u7u0fPu7ucA3uJO7u7Qju7u7o/67u7Q9u7q+u7u5R3u7u0Q/e7ub/vu7PLO7uX13u
4w//Be4v/xnoH/+ekv//Xu7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u
7u7u7u7u7u7u7u7u7u7u7u7u7u7u7u7+7u7u7u7u7u7u7u7u7u7v/u7u7u7u7u7u7u7u7u7u7//u
7u7u7u7u7u7u7u7u7v///+7u7u7u7u7u7u7u7v//8AAAD8AAAAOAAAABgAAAAQAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAGAAAABwAAAA/AAAA8oAAAAEAAAACAAAAAB
AAQAAAAAAMAAAAAAAAAAAAAAABAAAAAAAAAAAQEBABcXFwAnJycAOzs7AElJSQBpaWkAeXl5AIaG
hgCVlZUApqamALOzswDMzMwA2dnZAObm5gD+/v4AAAAAAP/u7u7u7u7//u7u7u7u7u/u7uzu7t7u
7u7u4Y7lTu7u7u6QTtA77u7u7iaoctXu7u7qDOQZ5d7u7uRO5R7rbu7uv77iLu5O7u5D7pGn7pju
7QrtKOTe4+6z+OT40z2RTO7u7u7u7u7u7u7u7u7u7u7+7u7u7u7u7//u7u7u7u7/wAMAD4ABAA8A
AAAPAAAADwAAAA8AAAAPAAAADwAAAA8AAAAPAAAADwAAAA8AAAAPAAAADwAAAA+AAQAPwAMADw==
			'';
		    }
		    ];
		};
		};
		};
	    in toJSON policies;
	};
    };
}
