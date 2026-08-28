let
  secretsPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJw/WVjq//fZjsr9RG/x4esgH7s2rot2BVK5noTq3gkp secrets@super-systems";
  satellitePublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPhXYxoD0qOmpPabvfVykMG+GYip90qqUeGO+g+qBW4J root@super-satellite";
  stationPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9MF0ces+d0AlXjcoIA3WBwqrgD55C7AxRsyZpW5cVU root@super-station";
  superPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIo0rqolIwrG9+2xM6nQSDmPkEAprLEstESby+KtwoDa super@super-systems";

  publicKeys = [
    superPublicKey
    secretsPublicKey
    satellitePublicKey
    stationPublicKey
  ];
in
{
  "host/satellite/secrets/ssh_host_ed25519_key.age".publicKeys = publicKeys;
  "host/station/secrets/ssh_host_ed25519_key.age".publicKeys = publicKeys;
  "host/secrets/hhg_nas.age".publicKeys = publicKeys;
  "profile/secrets/id_ed25519.age".publicKeys = publicKeys;
  "profile/secrets/user-password.age".publicKeys = publicKeys;
}
