{config, nix-dns, ...}:
{
    imports = [
	./alina.cx.nix
    ];
    net.dns = {
	user = "knot";
	group = "knot";
    };
}
