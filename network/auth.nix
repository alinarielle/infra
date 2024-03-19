# TODO improve this by letting sops handle keys
{lib, ...}:
let
    SSH_KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINz9IXSb6I5uzk+tl4HAiBeCFwB+hD2owIvLyIirER/D alina@duck.com";
in
{
    users.users.root.openssh.authorizedKeys.keys = [ "${SSH_KEY}" ];
    users.users.alina.openssh.authorizedKeys.keys = [ "${SSH_KEY}"];
    services.openssh.enable = true;
    services.openssh.settings = {
	PermitRootLogin = lib.mkDefault "prohibit-password";
	PasswordAuthentication = lib.mkForce false;
    };
}
