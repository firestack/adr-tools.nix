{ lib
, stdenv
, fetchFromGitHub
, getopt
, bashInteractive
, which
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

  # doCheck = true;
    # substituteInPlace Makefile
  checkPhase = ''
    set -x
    runHook preCheck;
    mkdir -p ./tmp/adr-tools-build/doc
    touch ./tmp/adr-tools-build/doc/.adr-dir
    substituteInPlace Makefile \
      --replace '/bin/sh' 'sh' \
      --replace '/tmp/adr-tools-build' './tmp/adr-tools-build' \
      --replace 'PATH=/bin:/usr/bin' 'PATH=$(PATH)';
    make check
    runHook postCheck;
    set +x
  '';

  buildInputs = [
    which
  ];

  propagatedBuildInputs = [ getopt bashInteractive ];

  # required by check
  buildPhase = ''
    patchShebangs ./src
  '';

  foundMakefile = 1;
  # checkTarget = "check";
  # checkPhase = ''
  #   runHook preCheck;
  #   make check;
  #   runHook postCheck;
  # '';


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
    # maintainers = [ maintainers.aepsil0n ];
    platforms = platforms.unix;
  };
}
