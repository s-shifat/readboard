{
  description = "Readboard: Hyprshot + OCR (Wayland)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
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

    # Runtime env: Python + tools needed at runtime
    appEnv = pkgs.buildEnv {
      name = "readboard-env";
      paths = [
        py
        pkgs.hyprshot
        pkgs.wl-clipboard
        pkgs.tesseract
        # pkgs.grim   # not required explicitly
        # pkgs.slurp  # not required explicitly
      ];
    };

    # Launcher wrapping your main.py with the env on PATH
    runner = pkgs.writeShellScriptBin "readboard" ''
      export PATH=${appEnv}/bin:$PATH
      exec ${appEnv}/bin/python3 ${self}/main.py "$@"
    '';
  in {
    # nix run .
    apps.${system}.default = {
      type = "app";
      program = "${runner}/bin/readboard";
    };

    # nix profile add .  /  nix profile add github:user/repo
    packages.${system} = {
      readboard = runner;
      default = runner;
    };

    # nix develop  (shell for hacking)
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        py
        uv
        hyprshot
        wl-clipboard
        tesseract
      ];

      # Optional: helpful env hints
      shellHook = ''
        echo "Readboard dev shell:"
        echo "  - run: python main.py"
        echo "  - or:  readboard"
      '';
    };
  };
}

