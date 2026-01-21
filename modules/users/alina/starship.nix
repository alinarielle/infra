{ lib, ... }:
{
  home-manager.users.alina.programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$hostname"
        "$os"
        "$all"
      ];
      username = {
        show_always = false;
        format = "[$user]($style)::";
        style_root = "bold red";
        style_user = "bold cyan";
      };
      hostname = {
        ssh_only = false;
        style = "bold blue";
      };
      git_branch.style = "bold purple";
      os = {
        disabled = false;
        style = "bold cyan";
        format = " ($style)";
      };
      sudo = {
        disabled = false;
        symbol = " root ";
        style = "bold red";
      };
      custom.jj = {
        command = "";
        when = "jj --ignore-working-copy root";
        symbol = "";
      };
      time = {
        disabled = false;
      };
    };
  };
}
