{
  description = "Space Isolation GRUB theme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem = { pkgs, ... }: {
        packages.default = pkgs.stdenvNoCC.mkDerivation {
          pname = "space-isolation";
          version = "unstable";

          src = ./.;

          installPhase = ''
            mkdir -p $out/share/grub/themes/space-isolation

            cp -r \
              1920x1080 \
              1920x1200 \
              2560x1440 \
              $out/share/grub/themes/space-isolation/
          '';

          meta = {
            description = "GRUB theme based on Alien: Isolation";
            homepage = "https://github.com/xfeusw/space-isolation";
            license = pkgs.lib.licenses.mit;
            platforms = pkgs.lib.platforms.linux;
          };
        };
      };
    };
}
