{
  description = "maxhallinan/shell-scripts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        packageName = "shell-scripts";
      in
      {
        formatter = pkgs.nixfmt-rfc-style;

        packages.worktree-create = pkgs.writeShellApplication {
          name = "worktree-create";

          runtimeInputs = [ pkgs.git ];

          text = builtins.readFile ./scripts/worktree-create.sh;
        };
        packages.git-sweep-stage = pkgs.writeShellApplication {
          name = "git-sweep-stage";

          runtimeInputs = [ pkgs.git ];

          text = builtins.readFile ./scripts/git-sweep-stage.sh;
        };
        packages.fix-homebrew-postmasterpid = pkgs.writeShellApplication {
          name = "fix-homebrew-postmasterpid";

          runtimeInputs = [ ];

          text = builtins.readFile ./scripts/fix-homebrew-postmasterpid.sh;
        };
        packages.create-filepath = pkgs.writeShellApplication {
          name = "create-filepath";

          runtimeInputs = [ ];

          text = builtins.readFile ./scripts/create-filepath.sh;
        };
        packages.python-hello-world = pkgs.python3Packages.buildPythonApplication rec {
          pname = "hello-world";
          version = "0.0.1";
          src = ./scripts/hello-world.py;
          build-system = with pkgs.python3Packages; [
            setuptools
            wheel
          ];

        };
        packages.bash-hello-world = pkgs.writeShellApplication {
          name = "hello-world";

          runtimeInputs = [ pkgs.cowsay ];

          text = builtins.readFile ./scripts/hello-world.sh;
        };
      }
    );
}
