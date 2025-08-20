{
  lib,
  buildPythonPackage,
  pythonOlder,
  python,
  fetchFromGitHub,
  setuptools-scm,
  toml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pure-eval";
  version = "0.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = "pure_eval";
    rev = "v${version}";
    hash = "sha256-gdP8/MkzTyjkZaWUG5PoaOtBqzbCXYNYBX2XBLWLh18=";
  };

  doCheck = lib.versionOlder python.pythonVersion "3.15";

  postPatch = ''
		cat > pure_eval/my_getattr_static.py <<- 'PY'
			from inspect import getattr_static  # use the stdlib implementation
			__all__ = ["getattr_static"]
		PY
	'';

  build-system = [ setuptools-scm ];

  dependencies = [ toml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pure_eval" ];

  meta = with lib; {
    description = "Safely evaluate AST nodes without side effects";
    homepage = "https://github.com/alexmojaki/pure_eval";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
