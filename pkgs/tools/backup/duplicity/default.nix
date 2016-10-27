{ stdenv, fetchurl, python2Packages, librsync, ncftp, gnupg, rsync, makeWrapper
}:

let
  version = "0.7.07.1";
  inherit (python2Packages) boto cffi cryptography ecdsa enum idna ipaddress lockfile paramiko pyasn1 pycrypto python setuptools six;
in stdenv.mkDerivation {
  name = "duplicity-${version}";

  src = fetchurl {
    url = "http://code.launchpad.net/duplicity/0.7-series/${version}/+download/duplicity-${version}.tar.gz";
    sha256 = "594c6d0e723e56f8a7114d57811c613622d535cafdef4a3643a4d4c89c1904f8";
  };

  installPhase = ''
    python setup.py install --prefix=$out
    wrapProgram $out/bin/duplicity \
      --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${idna}):$(toPythonPath ${cffi}):$(toPythonPath ${ipaddress}):$(toPythonPath ${pyasn1}):$(toPythonPath ${six}):$(toPythonPath ${enum}):$(toPythonPath ${setuptools}):$(toPythonPath ${cryptography}):$(toPythonPath ${pycrypto}):$(toPythonPath ${ecdsa}):$(toPythonPath ${paramiko}):$(toPythonPath ${boto}):$(toPythonPath ${lockfile})" \
      --prefix PATH : "${stdenv.lib.makeBinPath [ gnupg ncftp rsync ]}"
    wrapProgram $out/bin/rdiffdir \
      --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${idna}):$(toPythonPath ${cffi}):$(toPythonPath ${ipaddress}):$(toPythonPath ${pyasn1}):$(toPythonPath ${six}):$(toPythonPath ${enum}):$(toPythonPath ${setuptools}):$(toPythonPath ${cryptography}):$(toPythonPath ${pycrypto}):$(toPythonPath ${ecdsa}):$(toPythonPath ${paramiko}):$(toPythonPath ${boto}):$(toPythonPath ${lockfile})"
  '';

  buildInputs = [ python librsync makeWrapper setuptools ];

  meta = {
    description = "Encrypted bandwidth-efficient backup using the rsync algorithm";
    homepage = "http://www.nongnu.org/duplicity";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric peti];
    platforms = with stdenv.lib.platforms; linux;
  };
}
