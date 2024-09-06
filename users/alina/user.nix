{lib, config, ...}: config.l.lib.mkLocalModule ./user.nix "alina user system config" {
    users.users.alina = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "adb" ];
    initialHashedPassword = "$6$PUIyRPFQMYLriq3g$05Qvh6stb9i47nXFb8o3/u8/iVemY3.s4tGP/znbqV246SLHTd5Qxk/VMjL1RVeOVsB7tIbW9AMFvuOeLEtic.";
}
