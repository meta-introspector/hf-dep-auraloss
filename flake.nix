{
  description = "Nix flake for auraloss (upstream: csteinmetz1/auraloss)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in {
      packages.${system}.default = pkgs.python3Packages.buildPythonPackage {
        pname = "auraloss";
        version = "pyproject.toml:0.4.0";
        pyproject = true;
        src = ./.;
        build-system = [ pkgs.python3Packages.setuptools ];
        dependencies = with pkgs.python3Packages; [ torch ];
        pythonRelaxDeps = true;
        doCheck = false;
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ (pkgs.python3.withPackages (ps: with ps; [ torch ])) ];
      };
    };
}
