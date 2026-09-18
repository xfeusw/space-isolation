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

      perSystem = { pkgs, ... }:
        let
          mkTheme = resolution: pkgs.stdenvNoCC.mkDerivation {
            pname = "space-isolation-${resolution}";
            version = "unstable";

            src = ./.;

            installPhase = ''
              mkdir -p $out/share/grub/themes/space-isolation
              cp -r ${resolution}/* $out/share/grub/themes/space-isolation/
            '';

            meta = {
              description = "Space Isolation GRUB theme for ${resolution}";
              homepage = "https://github.com/xfeusw/space-isolation";
              license = pkgs.lib.licenses.mit;
              platforms = pkgs.lib.platforms.linux;
            };
          };
        in {
          packages = {
            theme-1920x1080 = mkTheme "1920x1080";
            theme-1920x1200 = mkTheme "1920x1200";
            theme-2560x1440 = mkTheme "2560x1440";
          };
        };
    };
}
