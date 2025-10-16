{ pkgs, ... }:
{
  home-manager.users.alina.programs.password-store = {
    enable = true;
    package =
      (pkgs.pass.override {
        gnupg = pkgs.symlinkJoin {
          name = "gnupg";
          paths = [ pkgs.sequoia-chameleon-gnupg ];
          postBuild = ''
            ln -s gpg-sq $out/bin/gpg
          '';
        };
      }).withExtensions
        (
          ext: with ext; [
            pass-otp
            pass-tomb
            pass-file
            pass-audit
            pass-update
            pass-import
            pass-checkup
            pass-genphrase
          ]
        );
    settings = {
      PASSWORD_STORE_DIR = "~/src/keys/";
      # Overrides the default password storage directory.

      PASSWORD_STORE_KEY = "4A1A31190DC52FECA9B747D6331AB4CA826C8D79";
      # Overrides the default gpg key identification set by init. Keys must  not  contain  spaces
      # and thus use of the hexadecimal key signature is recommended.  Multiple keys may be spec‐
      # ified separated by spaces.

      # PASSWORD_STORE_GPG_OPTS
      # Additional options to be passed to all invocations of GPG.

      # PASSWORD_STORE_X_SELECTION
      #        # Overrides  the  selection  passed  to  xclip, by default clipboard. See xclip(1) for more
      #        # info.
      #
      # PASSWORD_STORE_CLIP_TIME
      #        # Specifies the number of seconds to wait before restoring the  clipboard,  by  default  45
      #        # seconds.
      #
      # PASSWORD_STORE_UMASK
      # Sets the umask of all files modified by pass, by default 077.

      PASSWORD_STORE_GENERATED_LENGTH = "69";
      # The default password length if the pass-length parameter to generate is unspecified.

      # PASSWORD_STORE_CHARACTER_SET
      # The character set to be used in password generation for generate. This value is to be in‐
      # terpreted by tr. See tr(1) for more info.

      # PASSWORD_STORE_CHARACTER_SET_NO_SYMBOLS
      # The  character  set  to be used in no-symbol password generation for generate, when --no-
      # symbols, -n is specified. This value is to be interpreted by tr. See tr(1) for more info.

      PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
      # This environment variable must be set to "true" for extensions to be enabled.

      # PASSWORD_STORE_EXTENSIONS_DIR
      # The location to look for executable extension files, by  default  PASSWORD_STORE_DIR/.ex‐
      # tensions.

      # PASSWORD_STORE_SIGNING_KEY
      #  # If  this  environment  variable  is  set, then all .gpg-id files and non-system extension
      #  # files must be signed using a detached signature using the GPG key specified by  the  full
      # 40 character upper-case fingerprint in this variable. If multiple fingerprints are speci‐
      # fied,  each separated by a whitespace character, then signatures must match at least one.
      # The init command will keep signatures of .gpg-id files up to date.

      EDITOR = "nv";
      # The location of the text editor used by edit.
    };
  };
}
