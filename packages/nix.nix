{ pkgs, config, ... }:
let
  dotnet =
    with pkgs.dotnetCorePackages;
    combinePackages [
      # Needed for azure-functions-core-tools
      aspnetcore_8_0-bin

      # Needed for zed bicep extension
      sdk_10_0-bin
    ];
  workPkgs = [
    dotnet
    pkgs.azure-functions-core-tools
    pkgs.azurite
    pkgs.nodejs
    pkgs.pnpm_10
  ];
  personalPkgs = [
    # Needed for zed pkl extension
    pkgs.javaPackages.compiler.temurin-bin.jre-25
    pkgs.pkl
    pkgs.go
  ];
in
{
  environment.systemPackages = [
    # cli tools
    pkgs.bat
    pkgs.eza
    pkgs.gh
    pkgs.uv
    pkgs.delta
    pkgs.nil
    pkgs.nixd
    pkgs.git-absorb
  ]
  ++ (if config.isWork then workPkgs else personalPkgs);

  # Needed for zed bicep extension
  environment.etc =
    if config.isWork then
      {
        "dotnet/install_location_arm64".text = "${dotnet}/share/dotnet";
      }
    else
      { };

  fonts.packages = with pkgs; [
    maple-mono.NF-CN-unhinted
  ];
}
