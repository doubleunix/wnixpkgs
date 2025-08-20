{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  mypy,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "charset-normalizer";
  version = "3.4.2";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Ousret";
    repo = "charset_normalizer";
    tag = version;
    hash = "sha256-PkFmNEMdp9duDCqMTKooOLAOCqHf3IjrGlr8jKYT2WE=";
  };

  build-system = [
    mypy
    setuptools
    setuptools-scm
  ];

  env.CHARSET_NORMALIZER_USE_MYPYC = "1";

  NIX_CFLAGS_COMPILE = lib.optionals (lib.versionAtLeast python.pythonVersion "3.15") [
    "-Wno-error=deprecated-declarations"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "charset_normalizer" ];

  passthru.tests = {
    inherit aiohttp requests;
  };

  meta = with lib; {
    description = "Python module for encoding and language detection";
    mainProgram = "normalizer";
    homepage = "https://charset-normalizer.readthedocs.io/";
    changelog = "https://github.com/Ousret/charset_normalizer/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
