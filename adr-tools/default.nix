{ lib
, stdenv
, fetchFromGitHub
, getopt
, bashInteractive
, ...
} @ args:

stdenv.mkDerivation rec {
  pname = "adr-tools";
  version = args.version or "3.0.0";

  src = args.src or (fetchFromGitHub {
    owner = "npryce";
    repo = "adr-tools";
    rev = "${version}";
    sha256 = "1igssl6853wagi5050157bbmr9j12703fqfm8cd7gscqwjghnk14";
  });


  propagatedBuildInputs = [ getopt bashInteractive ];

  dontBuild = true;

  doCheck = true;


  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/
    cp src/* $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = https://github.com/npryce/adr-tools;
    description = "Command-line tools for working with Architecture Decision Records";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
