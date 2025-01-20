{lib, pkgs, ...}: {    
  #security.rtkit.enable = true;
  #services.pipewire = {
    #enable = true;
    #alsa.enable = true;
    #alsa.support32Bit = true;
    #pulse.enable = true;
  #};
  environment.systemPackages = with pkgs; [
    alsa-utils
    pavucontrol
  ];
  services.pipewire.enable = false;
  services.pulseaudio.enable = true;
  services.pulseaudio.support32Bit = true;
}
