let
  githubTarball = owner: repo: rev:
    builtins.fetchTarball { url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz"; };

  compiler = "ghc8104";

  baseNixpkgs = githubTarball "NixOS" "nixpkgs" "21.05";
  haskellNixpkgs = githubTarball "NixOS" "nixpkgs" "d00b5a5fa6fe8bdf7005abb06c46ae0245aec8b5";
  staticHaskellNixpkgs = githubTarball "nh2" "static-haskell-nix" "bd66b86b72cff4479e1c76d5916a853c38d09837";
  
  haskellPkgsOverlay = (self: super: {
    haskell = super.haskell // {
      packages = super.haskell.packages // {
        "${compiler}" = super.haskell.packages."${compiler}".override {
          overrides = final: prev: 
            let
              effectfulSrc = githubTarball "arybczak" "effectful" "1d35ef1ddebe8d8689a0a9ba97c4cd6d6968691b";
            in {
              cabal2nix = self.haskell.lib.dontCheck prev.cabal2nix;
              effectful = self.haskell.lib.dontCheck (self.haskellPackages.callCabal2nix "effectful" effectfulSrc {});
            };
        };
      };
    };
  });

  staticHaskellPkgs = (import (staticHaskellNixpkgs + "/survey/default.nix") {
    inherit compiler;
    normalPkgs = import haskellNixpkgs { overlays = [haskellPkgsOverlay]; };
  }).approachPkgs;

  localOverlays = [

    (self: super: {

      # replace staticHaskell lndir with default one
      # xorg = super.xorg // {
      #   lndir = super.xorg.lndir;
      # };
      
      staticHaskell = staticHaskellPkgs.extend (selfSH: superSH: {
        ghc = (superSH.ghc.override {
          enableRelocatedStaticLibs = true;
          enableShared = false;
        }).overrideAttrs (oldAttrs: {
          preConfigure = ''
            ${oldAttrs.preConfigure or ""}
            echo "GhcLibHcOpts += -fPIC -fexternal-dynamic-refs" >> mk/build.mk
            echo "GhcRtsHcOpts += -fPIC -fexternal-dynamic-refs" >> mk/build.mk
          '';
        });
      });
    })
    
    # override ghc adding all project dependencies as toolchain packages
    (self: super: {
      compiler = super.staticHaskell.haskellPackages.ghcWithPackages (p: with p; [
        bytestring
        lens
      ]);
    })

    (self: super: {
      raw-haskell-base-image =
        let haskellBase = super.dockerTools.buildLayeredImage {
          name = "haskell-base-image";
          created = "now";
          contents = with super; [
            # gmp
            # libffi
          ];
        };
        in super.runCommand "haskell-base-image" { } ''
          mkdir -p $out
          gunzip -c ${haskellBase} > $out/image
        '';
    })
  ];

in args@{ overlays ? [], ... }:
    import baseNixpkgs (args // {
      overlays = localOverlays ++ overlays;
    })
