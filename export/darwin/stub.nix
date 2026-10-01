# Stands in for the NixOS/nix-darwin options that the shared modules touch, so they
# can be evaluated without a system around them. Only hjem.users and
# environment.variables are read back out by ./default.nix.
{
  lib,
  pkgs,
  hjem,
  hjem-lib,
  ...
}:
let
  inherit (lib) mkOption types;
  ignored = mkOption {
    type = types.submodule { freeformType = types.attrsOf types.anything; };
    default = { };
  };
in
{
  options = {
    acme = {
      core.username = mkOption { type = types.str; };
      # Unlike the NixOS version in modules/common/home.nix, this keeps the path in the
      # repo so ./default.nix can tell repo files apart from generated ones.
      hjemImpureSource = mkOption {
        readOnly = true;
        type = types.functionTo types.str;
        default = toString;
      };
    };
    hjem.users = mkOption {
      type = types.attrsOf (
        types.submoduleWith {
          class = "hjem";
          specialArgs = { inherit pkgs hjem-lib; };
          modules = [
            "${hjem}/modules/common/user.nix"
            (
              { name, ... }:
              {
                user = lib.mkDefault name;
                clobberFiles = lib.mkDefault true;
              }
            )
          ];
        }
      );
      default = { };
    };
    environment = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf types.anything;
        options.variables = mkOption {
          type = types.attrsOf types.str;
          default = { };
        };
      };
      default = { };
    };
    programs = ignored;
  };
}
