{lib, config, ...}: config.l.lib.mkLocalModule ./ssh-net.nix "ssh intranet" {
    l.network.sshd.enable = true;
    l.network.sshd.listen = [];
    l.network.wg-mesh.ssh.enable = true;
    programs.ssh.knownHosts = mapAttrs (key: val: 
	with nodes.${key}.config; {
	    extraHostNames = [
		networking.fqdn #FIXME
	    ];
	}
    ) config.network.wg-mesh.ssh.peers;
}
