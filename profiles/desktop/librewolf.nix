{
home-manager.users.alina = {
    programs.librewolf = {
	enable = true;
	settings = {
	    "identity.fxaccounts.enable" = true;
	    "browser.tabs.insertAfterCurrent" = true;
	    "browser.bookmarks.editDialog.showForNewBookmarks" = false;
	    "browser.search.suggest.enabled" = true;
	};
    };
};
}
