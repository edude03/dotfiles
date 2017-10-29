let
  _nixpkgs = import <nixpkgs> {};
  nixpkgs = _nixpkgs.fetchFromGitHub (_nixpkgs.lib.importJSON ./src.json);
in
  import nixpkgs