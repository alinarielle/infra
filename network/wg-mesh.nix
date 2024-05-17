{
    net.wg-mesh.infra =
    let
	lilium = {
	    type = "nat";
	    fqdn = null;
	};
	choco.type = "nat";
	tracer = {
	    type = "site";
	    fqdn = "tracer.infra.alina.cx";
	};
	lain = {
	    type = "site";
	    fqdn = "lain.infra.alina.cx";
	};
    in
	with net.wg-mesh.lib;
	mkTunnel lilium tracer //
	mkTunnel choco tracer //
	mkTunnel tracer lain //
	mkTunnel lilium lain //
	mkTunnel choco lain;
}
