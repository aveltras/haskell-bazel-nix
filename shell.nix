let
  pkgs = import ./nixpkgs.nix {};

  haskellTool = tool:
    pkgs.haskell.lib.justStaticExecutables pkgs.haskellPackages.${tool};
  
in pkgs.mkShell {
  packages = [
    pkgs.bazel
    pkgs.compiler
    # (haskellTool "ghcid")
    # (haskellTool "hlint")
    # (haskellTool "haskell-language-server")
    # (haskellTool "hie-bios")
  ];
}
