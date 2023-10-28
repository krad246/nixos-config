{ pkgs, lib, ... }: {
  # home.packages = with pkgs; [
  #   discord
  #   spotify
  #   zoom-us

  #   helix
  #   obsidian
  #   vscode

  #   bitwarden-cli

  #   pico-sdk
  #   openfpgaloader
  #   cmake
  #   gcc-arm-embedded
  # ] ++ lib.optionals stdenv.isLinux [ ] ++ lib.optionals stdenv.isDarwin [ ];

  # home.sessionVariables = {
  #   PICO_SDK_PATH = "${pkgs.pico-sdk}/lib/pico-sdk";
  #   PICO_TOOLCHAIN_PATH = "${pkgs.gcc-arm-embedded}";
  #   CMAKE_MAKE_PROGRAM = "${pkgs.gnumake}/bin/make";
  # };
}
