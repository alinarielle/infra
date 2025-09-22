{fetchzip, stdenv, ...}: stdenv.mkDerivation {
  src = fetchzip {
    url = "https://myrient.erista.me/files/Redump/Nintendo%20-%20Wii%20-%20NKit%20RVZ%20%5Bzstd-19-128k%5D/Super%20Mario%20Galaxy%20%28Europe%2C%20Australia%29%20%28En%2CFr%2CDe%2CEs%2CIt%29.zip";
    hash = "sha256-wNHmELebL/zpQ7+3rgl4oyLsh/Ak+8Yhw6Agx1AGGLk=";
  };
  name = "Mario Galaxy - Nintendo Wii";
  buildphase = ''
    mkdir $out
    mv ./* $out
  '';
}
