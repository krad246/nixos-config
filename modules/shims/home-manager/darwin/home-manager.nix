# https://github.com/nix-community/home-manager/issues/1341#issuecomment-1716147796
{ config, pkgs, lib, ... }@args:
let inherit (args) username inputs;
in
{
  # home.activation = {
  #   trampolineApps =
  #     let
  #       apps = pkgs.buildEnv {
  #         name = "home-manager-applications";
  #         paths = config.home.packages;
  #         pathsToLink = "/Applications";
  #       };

  #       mac-app-util = "${inputs.mac-app-util.packages.${pkgs.stdenv.system}.default}/bin/mac-app-util";
  #     in
  #     lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #       dest="/Users/${username}/Applications/Home Manager Trampolines/"
  #       src="${apps}/Applications/"
  #       rm -rf "$dest" && mkdir -p "$dest"
  #       export dest
  #       find "$src" -name "*.app" -exec sh -c '
  #         for file do

  #           # escape the filename because space separated filenames suck
  #           filename="''${file@Q}"
  #           appname="$(basename "$file")"
  #           out="$dest/$appname"

  #           # This is basically going to be the script body
  #           open_cmd=(
  #             "open"
  #             \"$file\"
  #           )
  #           open_cmd="''${open_cmd[@]}"

  #           # generate a wrapper app visible to spotlight
  #           wrapper=(
  #             "do"
  #             "shell"
  #             "script"
  #             "$open_cmd"
  #           )
  #           wrapper="''${wrapper[@]}"
  #           /usr/bin/osacompile -o "$out" -e "$wrapper" 2>/dev/null

  #           # time to make stuff visible in spotlight
  #           plutil=/usr/bin/plutil
  #           contents=/Contents
  #           resources="$contents/Resources"
  #           plist="$contents/Info.plist"

  #           # splice in the icon
  #           icon="$("$plutil" -extract CFBundleIconFile raw "$file/$plist")"
  #           icon="''${icon%.icns}.icns"
  #           icon_src="$file/$resources/$icon"
  #           mkdir -p "$out/$resources" && cp "$icon_src" "$_/applet.icns"
  #         done
  #       ' {} +
  #     '';
  # };
}
