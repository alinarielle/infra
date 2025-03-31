{cfg, opt, lib, nodes, ...}: {
  opt = with lib.types; lib.mkOption { default = {}; type = (submodule {
    options = {
      v4 = lib.mkOption { type = attrs; };
      v6 = lib.mkOption { type = attrs; };
    };
  });};
  config.l.network.ipgen = lib.mapAttrs (key: val: let
    fun = import ../../lib/ip-util.nix { inherit lib; };
    dividend = let 
      abc = (lib.filter (x: x != "") (lib.splitString "" "abcdefghijklmnopqrstuvwxyz")); 
    in lib.toIntBase10 (builtins.substring 0 19 (builtins.replaceStrings
      abc
      (lib.imap (int: v: builtins.toString int) abc)
      (builtins.hashString "sha256" key)));
    v4 = {
      #wan =; don't have an AS yet qwq (and i will probably never be able to afford ipv4 lmao)
      #wanCIDR =;
      private = fun.ipv4.encode (
	(fun.ipv4.decode "10.0.0.0") 
	+ 
	(lib.mod
	  dividend
	  (fun.ipv4.decode "0.255.255.255")
	)
      );
      #privateCIDR = "/32";
    };
    v6 = {
      private = fun.ipv6.encode (
	(fun.ipv6.decode "") #7-bit special ULA range prefix
	+
	(fun.ipv6.decode "") #40-bit Globally Unique ID
	+
	(lib.mod
	  dividend #pseudo-random entropy source
	  (fun.ipv6.decode "") #16-bit Interface ID range
	)
	+
	(lib.mod #48-bit address
	  dividend #pseudo-random entropy source
	  (fun.ipv6.decode "") # address
	)
      );
    };
    #any = if cfg.${key}.preferred == "v4" then v4 else v6;
  in {
    inherit v4 v6;
  }) nodes;
}
#TODO collision detection!!
