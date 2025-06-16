{
  inputs,
  outputs,
  stateVersion,
  self,
  ...
}:
let
  helpers = import ./setup-darwin.nix { inherit inputs outputs stateVersion self; };
in
{
  inherit (helpers)
    mkDarwin
    ;
}
