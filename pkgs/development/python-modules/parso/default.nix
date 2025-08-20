{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "parso";
  version = "0.8.4";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    inherit pname version;
    owner = "davidhalter";
    repo = "parso";
    rev = "a73af5c709a292cbb789bf6cab38b20559f166c0";
    hash = "sha256-NNP/gKBA2tvCTV53k8VrnGEYruEsDSVqWVa7uU8Wznc=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    find
    cp parso/python/grammar314.txt parso/python/grammar315.txt
  '';

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    # python changed exception message format in 3.10, 3.10 not yet supported
    "test_python_exception_matches"
  ];

  meta = with lib; {
    description = "Python Parser";
    homepage = "https://parso.readthedocs.io/en/latest/";
    changelog = "https://github.com/davidhalter/parso/blob/master/CHANGELOG.rst";
    license = licenses.mit;
  };
}
