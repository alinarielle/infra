{config, ...}: {
  l.network.nginx.vhosts.firefly = {
    fqdn = "firefly.alina.dog";
    domain = "alina.dog";
    sub = "firefly";
    root = "${config.services.firefly-iii.package}";
  };
  services.postgres.enable = true;
  services.postgres.ensureDatabases = ["firefly"];
  services. = {
    ensureUsers = [{
      name = "firefly";
    }];
  };
  services.firefly-iii = {
    enable = true;
    enableNginx = false;
    settings = {
      APP_ENV = "production";
      APP_KEY_FILE = "/var/secrets/firefly-iii-app-key.txt";
      SITE_OWNER = "webmistress@alina.cx";
      DB_CONNECTION = "postgres";
      DB_HOST = "localhost";
      DB_PORT = 5432;
      DB_DATABASE = "firefly";
      DB_USERNAME = "firefly";
      DB_PASSWORD_FILE = "/var/secrets/firefly-iii-mysql-password.txt";
    };
  };
}
