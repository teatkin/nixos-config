{
    description = "NixOS configurations for Tom Atkinson's systems";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    };

    outputs = { self, nixpkgs, home-manager, nixos-hardware }: {
        nixosConfigurations.mojave = nixpkgs.lib.nixosSystem {
            system = "86_64-linux";
            modules = [
                # Hardware configuration for ThinkPad X390
                nixos-hardware.nixosModules.lenovo-thinkpad-x390

                # Main configuration
                ./configuration.nix

                # Home Manager
                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.tom = import ./home.nix;
                }
            ];
        };
    };
}
