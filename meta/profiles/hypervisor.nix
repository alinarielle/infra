{inputs, lib, ...}: {
    imports = [
	inputs.microvm.nixosModules.host
    ];
    networking.useNetworkd = true;
}
