{lib, config, ...}: { 
    options.l.meta.profiles.monitoring-export.enable = 
	lib.mkEnableOption "monotoring agent profile";
    config = lib.mkIf config.l.meta.profiles.monitoring-export.enable {
	security.auditd.enable = true;
	security.audit.enable = true;
	security.audit.rules = [
	    "-a exit,always -F arch=b64 -S execve"
	];
	services.zabbixAgent = {
	    enable = true;
	    server = config.l.services.zabbixServer.ip.default;
	    listen = {
		port = lib.net.getPort "zabbixAgent";
		ip = "0.0.0.0";
	    };
	};
    };
} #zabbix, vulnix, prometheus, different solution for BSDs and qemu VMs?
