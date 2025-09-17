{
  description = "Readboard: Hyprshot + OCR (Wayland)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };

      # Python with required libs
      py = pkgs.python312.withPackages (ps: [
        ps.pyperclip
        ps.pytesseract
        ps.pillow
      ]);

      # Runtime env: Python + tools needed at runtime
      appEnv = pkgs.buildEnv {
        name = "readboard-env";
        paths = [
          py
          pkgs.hyprshot
          pkgs.wl-clipboard
          pkgs.tesseract
          # pkgs.grim   # optional (hyprshot depends on it)
          # pkgs.slurp  # optional (hyprshot depends on it)
        ];
      };

      # Launcher wrapping your main.py with the env on PATH
      runner = pkgs.writeShellScriptBin "readboard" ''
        export PATH=${appEnv}/bin:$PATH
        exec ${appEnv}/bin/python3 ${self}/main.py "$@"
      '';
    in {
      # nix run github:s-shifat/readboard
      apps.default = {
        type = "app";
        program = "${runner}/bin/readboard";
      };

      # nix profile add github:s-shifat/readboard
      packages = {
        readboard = runner;
        default = runner;
      };

      # nix develop github:s-shifat/readboard
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          py
          uv
          hyprshot
          wl-clipboard
          tesseract
        ];
      };
    });
}

