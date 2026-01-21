{
  opt,
  cfg,
  pkgs,
  lib,
  ...
}:
{
  opt.ensure =
    with lib.types;
    lib.mkOption {
      default = { };
      type = attrsOf (submodule {
        options = {
          user = lib.mkOption {
            default = null;
            type = nullOr str;
          };
          database = lib.mkOption {
            default = null;
            type = nullOr str;
          };
          password = lib.mkOption {
            default = null;
            type = nullOr path;
          };
          DBOwnership = lib.mkEnableOption "whether to grant all privileges";
        };
      });
    };
  config =
    let

      ensure = lib.mapAttrs (
        key: val:
        val
        // {
          user = if (val.user != null) then val.user else key;
          database = if (val.database != null) then val.user else key;
          password = if (val.password != null) then val.password else "/run/secrets/${key}_db";
        }
      ) cfg.ensure;

    in
    {
      services.postgresql = {
        enable = true;

        ensureUsers = map (elem: { name = elem.user; }) (lib.attrValues ensure);

        ensureDatabases = lib.foldl' (acc: elem: acc ++ [ elem.database ]) [ ] (lib.attrValues ensure);

        package =
          with pkgs;
          (postgresql_18_jit.withPackages (
            ext: with ext; [
              ip4r # IPv4/v6 and IPv4/v6 range index type for PostgreSQL
              pgtap # Unit testing framework for PostgreSQL
              pgjwt # PostgreSQL implementation of JSON Web Tokens
              pgddl # DDL eXtractor functions for PostgreSQL
              repmgr # Replication manager for PostgreSQL cluster
              #pg_net # Async networking for Postgres
              pg_ivm # Materialized views with IVM (Incremental View Maintenance) for PostgreSQL
              pg_csv # Flexible CSV processing for Postgres
              hypopg # Hypothetical Indexes for PostgreSQL
              postgis # Geographic Objects for PostgreSQL
              pgrouting # geospatial routing for PostGIS
              audit # Open Source PostgreSQL Audit Logging
              pg_topn # Efficient querying of 'top values' for PostgreSQL
              periods # PostgreSQL extension implementing SQL standard functionality for PERIODs and SYSTEM VERSIONING
              wal2json # PostgreSQL JSON output plugin for changeset extraction
              #pgx_ulid # Universally Unique Lexicographically Sortable Identifiers
              pgsodium # Modern cryptography using libsodium
              pg_uuidv7 # version 7 UUIDs
              pg-semver # Semantic version data type for PostgreSQL
              pg_repack # Reorganize tables in PostgreSQL databases with minimal locks
              pg_squeeze # PostgreSQL extension for automatic bloat cleanup
              #pg_ed25519 # PostgreSQL extension for signing and verifying ed25519 signatures
              #vectorchord # Scalable, fast, and disk-friendly vector search in Postgres, the successor of pgvecto.rs
              #timescaledb # Scales PostgreSQL for time-series data via automatic partitioning across time and space
              pg_relusage # discover and log the relations used in your statements
              temporal_tables # Temporal Tables PostgreSQL Extension
              #pg_auto_failover # PostgreSQL extension and service for automated failover and high-availability
            ]
          ));
        settings = {
          log_connections = true;
          log_statement = "all";
          logging_collector = true;
          log_disconnections = true;
        };
      };
    };
}
