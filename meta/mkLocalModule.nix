{lib, config, ...}: {
    lib.mkLocalModule = pathInterpolation: optDesc: config: let 
    #example_input = ./some/subdir/MARKER/a/b/c/d/e/f/g;
    marker = "local-modules";
    splitAfterMarker = marker: input: builtins.foldl' (acc: new:
      if acc == false then # marker not found yet
        if new == marker then [] else acc
      else # marker found
        if builtins.typeOf new == "string" 
          then acc ++ [new]
          else acc
    ) false (builtins.split "/" (builtins.toString input));
    path = splitAfterMarker marker pathInterpolation;
    inputs = {
      #optDesc = "enable this";
      inherit optDesc: config;
    };
    mod = {config, ...}: {
      options = lib.setAttrsByPath path (lib.mkEnableOption inputs.optDesc);
      config = lib.mkIf (lib.getAttrByPath path config) inputs.config;
    };
  in mod;
}
