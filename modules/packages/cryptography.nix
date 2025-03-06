{pkgs, ...}: {
    users.users.alina.packages = with pkgs; [
	pinentry
	tomb
    ];
}
