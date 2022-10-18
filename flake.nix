{
	description = "Flake utils demo";

	inputs.flake-utils.url = "github:numtide/flake-utils";
	inputs.adr-tools-src = {
		type = "github";
		owner = "npryce";
		repo = "adr-tools";
		ref = "3.0.0";
		# url = "github.com/npryce/adr-tools/issues/72";
		flake = false;
	};

	outputs = { self, nixpkgs, flake-utils, adr-tools-src }:
		flake-utils.lib.eachDefaultSystem (system:
			let pkgs = nixpkgs.legacyPackages.${system}; in
			{
				packages = rec {
					adr-tools = pkgs.callPackage ./adr-tools {
						src = adr-tools-src.outPath;
						version = adr-tools-src.shortRev or adr-tools-src.lastModifiedDate;
					};
					default = adr-tools;
				};
				# apps = rec {
				# 	hello = flake-utils.lib.mkApp { drv = self.packages.${system}.hello; };
				# 	default = hello;
				# };
			}
		);
}
