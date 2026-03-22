{
  description = "Python project devShell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python312;
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            python
            python.pkgs.pip
            python.pkgs.pytest
            python.pkgs.virtualenv
          ];

          shellHook = ''
            # Auto-create and activate venv
            if [ ! -d .venv ]; then
              echo "Creating venv..."
              virtualenv .venv
            fi
            source .venv/bin/activate

            # Install dependencies based on project type
            if [ -f pyproject.toml ]; then
              echo "Installing dependencies from pyproject.toml..."
              pip install -q -e .
            elif [ -f requirements.txt ]; then
              echo "Installing dependencies from requirements.txt..."
              pip install -q -r requirements.txt
            fi
          '';
        };
      });
}
