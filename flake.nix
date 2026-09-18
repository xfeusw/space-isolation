{
  description = "Space Isolation GRUB theme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { pkgs, ... }:
        let
          resolutions = [
            "1920x1080"
            "1920x1200"
            "2560x1440"
          ];

          mkTheme =
            resolution:
            pkgs.stdenvNoCC.mkDerivation {
              pname = "space-isolation-${resolution}";
              version = "unstable";

              src = ./.;

              installPhase = ''
                mkdir -p $out
                cp -r ${resolution}/* $out/
              '';

              meta = {
                description = "Space Isolation GRUB theme for ${resolution}";
                homepage = "https://github.com/xfeusw/space-isolation";
                license = pkgs.lib.licenses.mit;
                platforms = pkgs.lib.platforms.linux;
              };
            };

          themes = builtins.listToAttrs (
            map (resolution: {
              name = "theme-${resolution}";
              value = mkTheme resolution;
            }) resolutions
          );
        in
        {
          packages = themes;

          treefmt = {
            programs.nixfmt.enable = true;
          };
        };
    };
}
