{
  description = "Wine Wineland with native Wayland cross-process presentation support";

  inputs = {
    flake-lib = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:jgus-org/flake-lib/v1";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      flake-lib,
      nixpkgs,
      ...
    }:
    let
      pin = import ./pin.nix;
      source = {
        branch = "salkim";
        owner = "nanomatters";
        repo = "wine-salkim";
        track = "commit";
        type = "github";
      };
    in
    flake-lib.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        orgFormatting = flake-lib.lib.mkFormatting {
          inherit self system;
        };
      in
      {
        checks.formatting = orgFormatting.check;
        formatter = orgFormatting.formatter;
        packages = rec {
          default = wine-wineland;
          update-version = flake-lib.lib.mkUpdateVersion {
            inherit pkgs source;
          };
          wine-wineland = (pkgs.winePackagesFor "wineWow").base.overrideAttrs (oldAttrs: {
            inherit (pin) version;
            nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
              pkgs.autoconf
              pkgs.perl
              pkgs.python3
            ];
            patches = [
              ./cert-path.patch
              ./gcc-15.patch
              ./standalone-user.patch
              ./test-initguid.patch
              ./test-linkage.patch
              ./test-stdarg.patch
            ];
            pname = "wine-wineland";
            postPatch = (oldAttrs.postPatch or "") + ''
              export HOME="''${TMP}"
              patchShebangs autogen.sh tools/make_requests tools/make_specfiles dlls/winevulkan/make_vulkan
              ./autogen.sh
            '';
            src = pkgs.fetchFromGitHub {
              inherit (source) owner repo;
              hash = pin.sourceHash;
              rev = pin.sourceRev;
            };
          });
        };
      }
    );
}
