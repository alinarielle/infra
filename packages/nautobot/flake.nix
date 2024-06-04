{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nautobot";
  version = "2.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nautobot";
    repo = "nautobot";
    rev = "v${version}";
    hash = "sha256-yJiW4M6MUsBFLJS/96LI3UcDbxg5SoCDrlDCARZtcz0=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    celery
    django
    django-ajax-tables
    django-celery-beat
    django-celery-results
    django-constance
    django-cors-headers
    django-db-file-storage
    django-extensions
    django-filter
    django-health-check
    django-jinja
    django-prometheus
    django-redis
    django-silk
    django-tables2
    django-taggit
    django-timezone-field
    django-tree-queries
    django-webserver
    djangorestframework
    drf-react-template-framework
    drf-spectacular
    emoji
    gitpython
    graphene-django
    graphene-django-optimizer
    jinja2
    jsonschema
    markdown
    markupsafe
    netaddr
    netutils
    nh3
    packaging
    pillow
    prometheus-client
    psycopg2-binary
    python-slugify
    pyuwsgi
    pyyaml
    social-auth-app-django
    svgwrite
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    all = [
      django-auth-ldap
      django-storages
      mysqlclient
      napalm
      social-auth-core
    ];
    ldap = [
      django-auth-ldap
    ];
    mysql = [
      mysqlclient
    ];
    napalm = [
      napalm
    ];
    remote_storage = [
      django-storages
    ];
    sso = [
      social-auth-core
    ];
  };

  pythonImportsCheck = [ "nautobot" ];

  meta = with lib; {
    description = "Network Source of Truth & Network Automation Platform";
    homepage = "https://nautobot.com";
    changelog = "https://github.com/nautobot/nautobot/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "nautobot";
  };
}
