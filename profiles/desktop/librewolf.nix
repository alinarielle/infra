{
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
	};
    };
};
}
