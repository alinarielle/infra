# provision fly.io machine
# ssh into machine
# gather hardware facts
# gather network facts
# kexec into prebuilt minimal image
# spawn microvm.nix with GPU passthrough
# mount S3 bucket inside VM
# use nvme slice as cache
# establish wireguard connection to VM
#
# args;
# - name for VM
# - S3 mounts
# - fly API access token

def main [] {
  fly deploy
}
