{ pkgs, ... }: {
  imports = [ ./shims ] ++ [ ./darwin ];
}
