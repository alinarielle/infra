{ inputs, ... }:
{
  l.network.nginx.vhosts."blog.alina.cx" = {
    root = "${inputs.blog.packages.x86_64-linux.default}/public/";
  };
}
