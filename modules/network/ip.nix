{cfg, opt, lib, name, ...}: {
  opt = with lib.types; lib.mkOption { default = {}; type = (submodule {
    options = {
      protocols = lib.mkOption { type = listOf str; default = ["v4" "v6"]; };
      preferred = lib.mkOption { type = str; default = "v6"; };
      port = lib.mkOption { type = nullOr port; };
      NATed = lib.mkOption { type = bool; default = true; };
      any = lib.mkOption { type = attrs; };
      v4 = lib.mkOption { type = attrs; };
      v6 = lib.mkOption { type = attrs; };
    };
  });};
  config = lib.mkMerge (lib.mapAttrsToList (key: val: let
    fun = import ../../lib/ip-util.nix { inherit lib; };
    dividend = let 
      abc = (lib.filter (x: x != "") (lib.splitString "" "abcdefghijklmnopqrstuvwxyz")); 
    in lib.toIntBase10 (builtins.substring 0 19 (builtins.replaceStrings
      abc
      (lib.imap (int: v: builtins.toString int) abc)
      (builtins.hashString "sha256" key)));
    port = (lib.mod dividend (65000 - 50000)) + 50000;
    v4 = {
      #wan =; don't have an AS yet qwq (and i will probably never be able to afford ipv4 lmao)
      #wanCIDR =;
      internal = fun.ipv4.encode (
	(fun.ipv4.decode "10.0.0.0") 
	+ 
	(lib.mod
	  dividend
	  (fun.ipv4.decode "0.255.255.255")
	)
      );
      internalCIDR = "/32";
    };
    v6 = {
      #wan =; don't have an AS yet qwq
      #wanCIDR =;
      internal =;
      internalCIDR =;
    };
    any = if cfg.${key}.preferred == "v4" then v4 else v6;
  in {
    assertions = [{
      assertion = name != key;
      message = "stop breaking my horrible hack":
    }];
    l.ip.${key} = lib.recursiveUpdate { 
      inherit port any v4 v6; 
      NATed = lib.mkIf (cfg ? v4.wan || cfg ? v6.wan) false;
    } (lib.mkIf (cfg ? name) {
      protocols = cfg.${name}.protocols;
      preferred = cfg.${name}.preferred;
      NATed = cfg.${name}.NATed;
      any = cfg.${name}.any or any;
      v4 = cfg.${name}.v4 or v4;
      v6 = cfg.${name}.v6 or v6;
    });
  }) cfg);
}
