{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixd
    nixfmt
  ];

  programs.vscodium = {
    enable = true;

    profiles.default = {
      enableUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        bierner.markdown-mermaid
        bierner.markdown-preview-github-styles
        jnoortheen.nix-ide
        mkhl.direnv
      ];
      userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = [
                "nixfmt"
              ];
            };
          };
        };
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.formatOnSave" = true;
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
        };
      };
    };
  };
}
