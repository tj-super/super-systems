{ pkgs, ... }:
{
  programs.vscodium = {
    enable = true;

    profiles.default = {
      enableUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        bierner.markdown-mermaid
        bierner.markdown-preview-github-styles
        mkhl.direnv
      ];
      userSettings = {
        "terminal.integrated.env.linux" = {
          "DIRENV_LOG_FORMAT" = "";
        };
      };
    };
  };
}
