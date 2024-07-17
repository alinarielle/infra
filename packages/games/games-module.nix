{lib, config, name, nodes, pkgs, ...}:
with lib; with builtins;
let
    cfg = l.games;
    opt = mkOption;
in {
    options.l.games = with types; {
	server = {
	    torrentProgram = opt { 
		type = package // check = (x:
		    any (y: x == y) (with pkgs; [ 
			qbittorrent-nox
		    ])
		);
	    };

	};
	install = opt { 
	    default = [];
	    type = listOf (submodule {
		options = {
		    enable = mkEnableOption;
		    
		};
	    });
	};
    };
    config = mkMerge [{
	
    }
    (mkIf cfg.server.torrentProgram == pkgs.qbittorrent-nox {
	# import list of games from dl dir
	# match magnet links
	# output derivation template function for games
    })];
}
