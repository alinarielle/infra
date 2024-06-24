{lib, config, name,...}:
with lib; with builtins;
let
    cfg = config.l.network.sshd;
    opt = mkOption;
in
{
    options.l.network.sshd = with types; {
	enable = mkEnableOption "sshd";
	listenAddresses = opt {
	    default = {};
	    type = listOf (submodule {
		options = {
		    address = opt { default = ""; type = str; };
		    port = opt { 
			default = config.lib.network.getPort "ssh"; 
			type = port; 
		    };
		};
	    });
	};
    };
    config = mkIf cfg.enable {
	services.logind.killUserProcesses = true;
	services.openssh = {
	    enable = true;
	    openFirewall = true;#true=default
	    hostKeys = mkDefault [{
		bits = 4096;
		path = "/secrets/${name}/sshd/ssh_host_rsa.key";
	    }];
	    settings = {
		UseDns = true;
		PrintMotd = true;
		PermitRootLogin = "prohibit-password";
		AllowUsers = ["root" "alina"];
		PasswordAuthentication = false;
		listenAddresses = map (x: {
		    addr = x.address; 
		    port = x.port
		;}) cfg.listenAddresses;
		#fail2ban
	    };
	};
    };
}
