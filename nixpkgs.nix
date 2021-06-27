let
  githubTarball = owner: repo: rev:
    builtins.fetchTarball { url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz"; };

  nixpkgsSrc = githubTarball "NixOS" "nixpkgs" "e85975942742a3728226ac22a3415f2355bfc897";

  localOverlays = [

    # make ghc8104 the default package set for haskell
    (self: super: {
      haskellPackages = super.haskell.packages.ghc8104.override {
        overrides = self: super:
          let
            effectfulSrc = githubTarball "arybczak" "effectful" "1d35ef1ddebe8d8689a0a9ba97c4cd6d6968691b";
          in {
            effectful = super.callCabal2nix "effectful" effectfulSrc {};
          };
      };
    })
    
    # override ghc adding all project dependencies as toolchain packages
    (self: super: {
      compiler = super.haskellPackages.ghcWithPackages (p: with p; [
        effectful
      ]);
    })

    (self: super: {
      raw-haskell-base-image =
        let haskellBase = super.dockerTools.buildLayeredImage {
          name = "haskell-base-image";
          created = "now";
          contents = with super; [
            gmp
            libffi
          ];
        };
        in super.runCommand "haskell-base-image" { } ''
          mkdir -p $out
          gunzip -c ${haskellBase} > $out/image
        '';
    })
  ];

in args@{ overlays ? [], ... }:
    import nixpkgsSrc (args // {
      overlays = localOverlays ++ overlays;
    })
