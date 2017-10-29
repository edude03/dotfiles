with import ./nixpkgs {}; 

# I just hacked this together and it worked, but what do I do if I need to import multiple?
let 
    nix-home = import ./nix-home.nix { inherit python; inherit fetchFromGitHub; inherit stdenv; };
    dotfiles = stdenv.mkDerivation {
      name = "mathiasbynens-dotfiles";
      src = fetchgit {
        url = "https://github.com/edude03/dotfiles.git";
        rev = "953a9cf383c02cdf0fd8d796381511ea04b7840a";
        sha256 = "0x167i9b95v7vpd88dqmh5n8k6b7v6cgbf7hp6miiik6hq3lai7b";
      };
      installPhase = ''
        mkdir $out
        cp -a . $out
      '';
  };

in {
  infraEnv = stdenv.mkDerivation {
    name = "infrastructure";
    buildInputs = [
      nix-home
    ];
  };
}

