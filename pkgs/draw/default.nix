{buildGoModule, fetchFromGitHub, lib}: buildGoModule {
  pname = "draw";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "draw";
    rev = "1220ebb8c5411f1eb09a0e87be606a7768180917";
    hash = "";
  };

  vendorHash = "";

  meta = {
    description = "draw in your terminal";
    homepage = "https://github.com/maaslalani/draw";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alina ];
  };
}
