{ self, ... }:
let
  agesPath = "${self}/ages";
in
{
  age.secrets.user-password.file = "${agesPath}/user-password.age";
}
