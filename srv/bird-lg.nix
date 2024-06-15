{
    services.bird-lg = {
	enable = true;
	user = "bird-lg";
	group = "bird-lg";
	frontend = {
	    enable = true;
	    domain = "lg.alina.cx";
	};
    };
    users.users.${services.bird-lg.user} = {
	isSystemUser = true;
	group = ${services.bird-lg.group};
    };
} #TODO dns entry, nginx
