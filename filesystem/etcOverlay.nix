{lib, config, ...}: config.l.lib.mkLocalModule 
    ./etcOverlay.nix 
    "generating /etc with an overlay instead of perl" 
    {
    system.etc.overlay = {
	enable = true;
	mutable = false;
    };
}
