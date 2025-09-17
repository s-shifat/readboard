{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };

    # Python with required libs
    py = pkgs.python312.withPackages (ps: [
      ps.pyperclip
      ps.pytesseract
      ps.pillow
    ]);

    # App runtime env: python + tools your script calls at runtime
    appEnv = pkgs.buildEnv {
      name = "readboard-env";
      paths = [
        py
        pkgs.hyprshot
        pkgs.grim
        pkgs.slurp
        pkgs.wl-clipboard
        pkgs.tesseract      # pytesseract needs this binary
      ];
    };

    # Launcher
    runner = pkgs.writeShellScriptBin "readboard" ''
      # Ensure the app env is used (python + tools in PATH)
      export PATH=${appEnv}/bin:$PATH
      exec ${appEnv}/bin/python3 ${self}/main.py
    '';
  in {
    apps.${system}.default = {
      type = "app";
      program = "${runner}/bin/readboard";
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        py
        uv
        hyprshot grim slurp wl-clipboard tesseract
      ];
    };
  };
}

