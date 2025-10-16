{
  pkgs,
  lib,
  cfg,
  opt,
  ...
}:
let
  format = pkgs.formats.toml;
  configFile = format.generate "conduit.toml" cfg.settings;
in
{
  opt = with lib.types; {
    package = lib.mkPackageOption pkgs "continuwuity" {
      default = pkgs.matrix-continuwuity;
    };
    settings = lib.mkOption {
      type = submodule {
        freeformType = format.type;
        options = {
          global.enable_lightning_bolt = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Whether to add a lightning bolt emoji to the end of a user's display name.
            '';
          };
          global.new_user_displayname_suffix = lib.mkOption {
            type = str;
            default = "";
            description = ''
              Text which will be added to the end of the user's displayname upon 
              registration with a space before the text. In Conduit, this was the lightning
              bolt emoji.
              To disable, set this to "" (an empty string).
            '';
          };
          global.db_cache_capacity_mb = lib.mkOption {
            type = float;
            description = ''
              Set this to any float value in megabytes for conduwuit to tell the database 
              engine that this much memory is available for database read caches. 
              May be useful if you have significant memory to spare to increase performance.
              Similar to the individual LRU caches, this is scaled up with your CPU core 
              count. This defaults to 128.0 + (64.0 * CPU core count).
            '';
          };
          global.db_write_buffer_capacity_mb = lib.mkOption {
            type = float;
            description = ''
              Set this to any float value in megabytes for conduwuit to tell the database 
              engine that this much memory is available for database write caches.
              May be useful if you have significant memory to spare to increase performance.
              Similar to the individual LRU caches, this is scaled up with your CPU core 
              count. This defaults to 48.0 + (4.0 * CPU core count).
            '';
          };
          global.cache_capacity_modifier = lib.mkOption {
            type = float;
            default = 1.0;
            description = ''
              Set this to any float value to multiply conduwuit's in-memory LRU caches with 
              such as "auth_chain_cache_capacity". 
              May be useful if you have significant memory to spare to increase performance.
              If you have low memory, reducing this may be viable.
              By default, the individual caches such as "auth_chain_cache_capacity" 
              are scaled by your CPU core count.
            '';
          };
          global.rocksdb_max_open_files = lib.mkOption {
            type = int;
            default = 1000;
          };
          global.pdu_cache_capacity = lib.mkOption {
            type = int;
            default = 150000;
            description = ''The maximum number of Persisted Data Units (PDUs) to cache.'';
          };
          global.auth_chain_cache_capacity = lib.mkOption {
            type = int;
            description = ''???'';
          };
          global.shorteventid_cache_capacity = lib.mkOption {
            type = int;
            description = ''???'';
          };
          global.eventidshort_cache_capacity = lib.mkOption {
            type = int;
            description = ''???'';
          };
          global.eventid_pdu_cache_capacity = lib.mkOption {
            type = int;
            description = ''???'';
          };
          global.shortstatekey_cache_capacity = lib.mkOption {
            type = int;
            description = ''???'';
          };
          global.statekeyshort_cache_capacity = lib.mkOption {
            type = int;
            description = ''???'';
          };
          global.servernameevent_data_cache_capacity = lib.mkOption {
            type = int;
            description = ''???'';
          };
          global.server_visibility_cache_capacity = lib.mkOption {
            type = int;
            description = ''???'';
          };
          global.user_visibility_cache_capacity = lib.mkOption {
            type = int;
            description = ''???'';
          };
          global.stateinfo_cache_capacity = lib.mkOption {
            type = int;
            description = ''???'';
          };
          global.roomid_spacehierarchy_cache_capacity = lib.mkOption {
            type = int;
            description = ''???'';
          };
          global.dns_cache_entries = lib.mkOption {
            type = int;
            default = 32768;
            description = ''
              Maximum entries stored in DNS memory-cache. The size of an entry may vary so 
              please take care if raising this value excessively. Only decrease this when 
              using an external DNS cache. Please note that systemd-resolved does *not* count
              as an external cache, even when configured to do so.
            '';
          };
          global.dns_min_ttl = lib.mkOption {
            type = int;
            description = ''
              Minimum time-to-live in seconds for entries in the DNS cache. The default may 
              appear high to most administrators; this is by design as the majority of 
              NXDOMAINs are correct for a long time (e.g. the server is no longer running 
              Matrix). Only decrease this if you are using an external DNS cache.
            '';
          };
          global.dns_min_ttl_nxdomain = lib.mkOption {
            type = int;
            default = 259200;
            description = ''
              Minimum time-to-live in seconds for NXDOMAIN entries in the DNS 
              cache. This value is critical for the server to federate efficiently. NXDOMAIN's
              are assumed to not be returning to the federation and aggressively cached rather 		
              than constantly rechecked. Defaults to 3 days as these are *very rarely* false 
              negatives.
            '';
          };
          global.dns_attempts = lib.mkOption {
            type = int;
            default = 10;
            description = ''Number of DNS nameserver retries after a timeout or error.'';
          };
          global.dns_timeout = lib.mkOption {
            type = int;
            default = 10;
            description = ''
              The number of seconds to wait for a reply to a DNS query. Please note that 
              recursive queries can take up to several seconds for some domains, so this value
              should not be too low, especially on slower hardware or resolvers.
            '';
          };
          global.dns_tcp_fallback = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Fallback to TCP on DNS errors. Set this to false if unsupported by nameserver.
            '';
          };
          global.query_all_nameservers = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Enable to query all nameservers until the domain is found. Referred to as 
              "trust_negative_responses" in hickory_resolver. This can avoid useless DNS 
              queries if the first nameserver responds with NXDOMAIN or an empty NOERROR 
              response.
            '';
          };
          global.query_over_tcp_only = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Enable using *only* TCP for querying your specified nameservers instead of UDP.
              If you are running conduwuit in a container environment, this config option may 
              need to be enabled. For more details, see: 
              https://conduwuit.puppyirl.gay/troubleshooting.html#potential-dns-issues-when-using-docker  '';
          };
          global.ip_lookup_strategy = lib.mkOption {
            type = int;
            default = 4;
            description = ''
              DNS A/AAAA record lookup strategy
              Takes a number of one of the following options:
              1 - Ipv4Only (Only query for A records, no AAAA/IPv6)

              2 - Ipv6Only (Only query for AAAA records, no A/IPv4)

              3 - Ipv4AndIpv6 (Query for A and AAAA records in parallel, uses whatever
              returns a successful response first)

              4 - Ipv6thenIpv4 (Query for AAAA record, if that fails then query the A
              record)

              5 - Ipv4thenIpv6 (Query for A record, if that fails then query the AAAA
              record)

              If you don't have IPv6 networking, then for better DNS performance it
              may be suitable to set this to Ipv4Only (1) as you will never ever use
              the AAAA record contents even if the AAAA record is successful instead
              of the A record.
            '';
          };
          global.max_request_size = lib.mkOption {
            type = int;
            default = 20971520;
            description = ''
              Max request size for file uploads in bytes. Defaults to 20MB.
            '';
          };
          global.max_fetch_prev_events = lib.mkOption {
            type = int;
            default = 192;
            description = ''???'';
          };
          global.request_conn_timeout = lib.mkOption {
            type = int;
            default = 10;
            description = ''
              Default/base connection timeout (seconds). This is used only by URL previews 
              and update/news endpoint checks.
            '';
          };
          global.request_total_timeout = lib.mkOption {
            type = int;
            default = 320;
            description = ''
              Default/base request total timeout (seconds). The time limit for a whole 
              request. This is set very high to not cancel healthy requests while serving as
              a backstop. This is used only by URL previews and update/news endpoint checks.
            '';
          };
          global.request_timeout = lib.mkOption {
            type = int;
            default = 35;
            description = ''
              Default/base request timeout (seconds). The time waiting to receive more data 
              from another server. This is used only by URL previews, update/news, and misc
              endpoint checks.
            '';
          };
          global.request_idle_timeout = lib.mkOption {
            type = int;
            default = 5;
            description = ''
              Default/base idle connection pool timeout (seconds). This is used only by URL
              previews and update/news endpoint checks.
            '';
          };
          global.request_idle_per_host = lib.mkOption {
            type = int;
            default = 1;
            description = ''
              Default/base max idle connections per host. This is used only by URL previews
              and update/news endpoint checks. Defaults to 1 as generally the same open 
              connection can be re-used.
            '';
          };
          global.well_known_conn_timeout = lib.mkOption {
            type = int;
            default = 6;
            description = ''
              Federation well-known resolution connection timeout (seconds).
            '';
          };
          global.well_known_timeout = lib.mkOption {
            type = int;
            default = 10;
            description = ''
              Federation HTTP well-known resolution request timeout (seconds).
            '';
          };
          global.federation_timeout = lib.mkOption {
            type = int;
            default = 300;
            description = ''
              Federation client request timeout (seconds). You most definitely want this to
              be high to account for extremely large room joins, slow homeservers, your own
              resources etc.
            '';
          };
          global.federation_idle_timeout = lib.mkOption {
            type = int;
            default = 25;
            description = ''
              Federation client idle connection pool timeout (seconds).
            '';
          };
          global.federation_idle_per_host = lib.mkOption {
            type = int;
            default = 1;
            description = ''
              Federation client max idle connections per host. Defaults to 1 as generally 
              the same open connection can be re-used.
            '';
          };
          global.sender_timeout = lib.mkOption {
            type = int;
            default = 100;
            description = ''
              Federation sender request timeout (seconds). The time it takes for the remote
              server to process sent transactions can take a while.
            '';
          };
          global.sender_idle_timeout = lib.mkOption {
            type = int;
            default = 180;
            description = ''
              Federation sender idle connection pool timeout (seconds).
            '';
          };
          global.sender_retry_backoff_limit = lib.mkOption {
            type = int;
            default = 86400;
            description = ''
              Federation sender transaction retry backoff limit (seconds).
            '';
          };
          global.appservice_timeout = lib.mkOption {
            type = int;
            default = 35;
            description = ''
              Appservice URL request connection timeout. Defaults to 35 seconds as generally
              appservices are hosted within the same network.
            '';
          };
          global.appservice_idle_timeout = lib.mkOption {
            type = int;
            default = 300;
            description = ''
              Appservice URL idle connection pool timeout (seconds).
            '';
          };
          global.pusher_idle_timeout = lib.mkOption {
            type = int;
            default = 15;
            description = ''
              Notification gateway pusher idle connection pool timeout.
            '';
          };
          global.client_receive_timeout = lib.mkOption {
            type = int;
            default = 75;
            description = ''
              Maximum time to receive a request from a client (seconds).
            '';
          };
          global.client_request_timeout = lib.mkOption {
            type = int;
            default = 180;
            description = ''
              Maximum time to process a request received from a client (seconds).
            '';
          };
          global.client_response_timeout = lib.mkOption {
            type = int;
            default = 120;
            description = ''
              Maximum time to transmit a response to a client (seconds).
            '';
          };
          global.client_shutdown_timeout = lib.mkOption {
            type = int;
            default = 10;
            description = ''
              Grace period for clean shutdown of client requests (seconds).
            '';
          };
          global.sender_shutdown_timeout = lib.mkOption {
            type = int;
            default = 5;
            description = ''
              Grace period for clean shutdown of federation requests (seconds).
            '';
          };
          global.allow_registration = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Enables registration. If set to false, no users can register on this server.
              If set to true without a token configured, users can register with no form of
              2nd-step only if you set the following option to true:
              `yes_i_am_very_very_sure_i_want_an_open_registration_server_prone_to_abuse`
              If you would like registration only via token reg, please configure 
              `registration_token` or `registration_token_file`.
            '';
          };
          global.yes_i_am_very_very_sure_i_want_an_open_registration_server_prone_to_abuse = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Enabling this setting opens registration to anyone without restrictions. 
              This makes your server vulnerable to abuse.
            '';
          };
          global.registration_token = lib.mkOption {
            type = str; # TODO
            default = "o&^uCtes4HPf0Vu@F20jQeeWE7";
            description = ''
              A static registration token that new users will have to provide when creating 
              an account. If unset and `allow_registration` is true, you must set 
              `yes_i_am_very_very_sure_i_want_an_open_registration_server_prone_to_abuse` 
              to true to allow open registration without any conditions. 
              YOU NEED TO EDIT THIS OR USE registration_token_file.
            '';
          };
          global.registration_token_file = lib.mkOption {
            type = str;
            example = "/etc/conduwuit/.reg_token";
            description = ''
              Path to a file on the system that gets read for additional registration 
              tokens. Multiple tokens can be added if you separate them with whitespace 
              conduwuit must be able to access the file, and it must not be empty.
            '';
          };
          global.federation_loopback = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              ???
            '';
          };
          global.require_auth_for_profile_requests = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Set this to true to require authentication on the normally unauthenticated 
              profile retrieval endpoints (GET) "/_matrix/client/v3/profile/{userId}".
              This can prevent profile scraping.
            '';
          };
          global.allow_public_room_directory_over_federation = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Set this to true to allow your server's public room directory to be federated.
              Set this to false to protect against /publicRooms spiders, but will forbid 
              external users from viewing your server's public room directory. If federation
              is disabled entirely (`allow_federation`), this is inherently false.
            '';
          };
          global.allow_public_room_directory_without_auth = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Set this to true to allow your server's public room directory to be queried 
              without client authentication (access token) through the Client APIs. Set this
              to false to protect against /publicRooms spiders.
            '';
          };
          global.turn_allow_guests = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Allow guests/unauthenticated users to access TURN credentials.
              This is the equivalent of Synapse's `turn_allow_guests` config option.
              This allows any unauthenticated user to call the endpoint
              `/_matrix/client/v3/voip/turnServer`.

              It is unlikely you need to enable this as all major clients support
              authentication for this endpoint and prevents misuse of your TURN server
              from potential bots.
            '';
          };
          global.lockdown_public_room_directory = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Set this to true to lock down your server's public room directory and only 
              allow admins to publish rooms to the room directory. Unpublishing is still 
              allowed by all users with this enabled.
            '';
          };
          global.allow_device_name_federation = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Set this to true to allow federating device display names / allow external
              users to see your device display name. If federation is disabled entirely 
              (`allow_federation`), this is inherently false. 
              For privacy reasons, this is best left disabled.
            '';
          };
          global.allow_inbound_profile_lookup_federation_requests = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Config option to allow or disallow incoming federation requests that obtain 
              the profiles of our local users from `/_matrix/federation/v1/query/profile`
              Increases privacy of your local user's such as display names, but some remote
              users may get a false "this user does not exist" error when they try to invite
              you to a DM or room. Also can protect against profile spiders. 
              This is inherently false if `allow_federation` is disabled
            '';
          };
          global.allow_room_creation = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Allow standard users to create rooms. Appservices and admins are always 
              allowed to create rooms.
            '';
          };
          global.allow_unstable_room_versions = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Set to false to disable users from joining or creating room versions that 
              aren't officially supported by conduwuit. conduwuit officially supports room 
              versions 6 - 11.
              conduwuit has slightly experimental (though works fine in practice) 
              support for versions 3 - 5.
            '';
          };
          global.default_room_version = lib.mkOption {
            type = int;
            default = 10;
            description = ''
              Default room version conduwuit will create rooms with. Per spec, room version 
              10 is the default.
            '';
          };
          global.allow_jaeger = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              ???
            '';
          };
          global.jaeger_filter = lib.mkOption {
            type = str;
            default = "info";
            description = ''
              ???
            '';
          };
          global.tracing_flame = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              If the 'perf_measurements' compile-time feature is enabled, enables collecting
              folded stack trace profile of tracing spans using tracing_flame. The resulting
              profile can be visualized with inferno[1], speedscope[2], or a number of other
              tools.
              [1]: https://github.com/jonhoo/inferno
              [2]: www.speedscope.app
            '';
          };
          global.tracing_flame_filter = lib.mkOption {
            type = str;
            default = "info";
            description = ''
              ???
            '';
          };
          global.tracing_flame_output_path = lib.mkOption {
            type = str;
            default = "./tracing.folded";
            description = ''
              ???
            '';
          };
          global.proxy = lib.mkOption {
            type = str;
            default = "none";
            description = ''
              Examples:
              - No proxy (default): 
              proxy = "none"

              - For global proxy, create the section at the bottom of this file:
              [global.proxy]
              global = { url = "socks5h://localhost:9050" }

              - To proxy some domains:
              [global.proxy]
              [[global.proxy.by_domain]]
              url = "socks5h://localhost:9050"
              include = ["*.onion", "matrix.myspecial.onion"]
              exclude = ["*.myspecial.onion"]

              Include vs. Exclude:

              - If include is an empty list, it is assumed to be `["*"]`.

              - If a domain matches both the exclude and include list, the proxy will
              only be used if it was included because of a more specific rule than
              it was excluded. In the above example, the proxy would be used for
              `ordinary.onion`, `matrix.myspecial.onion`, but not
              `hello.myspecial.onion`.
            '';
          };
          global.trusted_servers = lib.mkOption {
            type = listOf str;
            default = [
              "matrix.org"
              "kescher.at"
              "fef.moe"
            ];
            example = [
              "matrix.org"
              "envs.net"
              "constellatory.net"
              "tchncs.de"
            ];
            description = ''
              Servers listed here will be used to gather public keys of other servers 
              (notary trusted key servers).
              Currently, conduwuit doesn't support inbound batched key requests, so this 
              list should only contain other Synapse servers.
            '';
          };
          global.query_trusted_key_servers_first = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Whether to query the servers listed in trusted_servers first or query the 
              origin server first. For best security, querying the origin server first is 
              advised to minimize the exposure to a compromised trusted server. For maximum 
              federation/join performance this can be set to true, however other options 
              exist to query trusted servers first under specific high-load circumstances 
              and should be evaluated before setting this to true.
            '';
          };
          global.query_trusted_key_servers_first_on_join = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Whether to query the servers listed in trusted_servers first specifically on 
              room joins. This option limits the exposure to a compromised trusted server to
              room joins only. The join operation requires gathering keys from many origin 
              servers which can cause significant delays. Therefor this defaults to true to 
              mitigate unexpected delays out-of-the-box. The security-paranoid or those 
              willing to tolerate delays are advised to set this to false. Note that setting
              query_trusted_key_servers_first to true causes this option to be ignored.
            '';
          };
          global.only_query_trusted_key_servers = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Only query trusted servers for keys and never the origin server. This is 
              intended for clusters or custom deployments using their trusted_servers as 
              forwarding-agents to cache and deduplicate requests. Notary servers do not act
              as forwarding-agents by default, therefor do not enable this unless you know 
              exactly what you are doing.
            '';
          };
          global.trusted_server_batch_size = lib.mkOption {
            type = int;
            default = 1024;
            description = ''
              Maximum number of keys to request in each trusted server batch query.
            '';
          };
          global.log = lib.mkOption {
            type = str;
            default = "info";
            description = ''
              Max log level for conduwuit. Allows debug, info, warn, or error.
              See also:
              https://docs.rs/tracing-subscriber/latest/tracing_subscriber/filter/struct.EnvFilter.html#directives
              **Caveat**:
              For release builds, the tracing crate is configured to only implement levels 
              higher than error to avoid unnecessary overhead in the compiled binary from 
              trace macros. For debug builds, this restriction is not applied.
            '';
          };
          global.log_colors = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Output logs with ANSI colours.
            '';
          };
          global.log_span_events = lib.mkOption {
            type = str;
            default = "none";
            description = ''
              Configures the span events which will be outputted with the log.
            '';
          };
          global.log_filter_regex = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Configures whether CONDUWUIT_LOG EnvFilter matches values using regular 
              expressions. See the tracing_subscriber documentation on Directives.
            '';
          };
          global.log_thread_ids = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Toggles the display of ThreadId in tracing log output.
            '';
          };
          global.openid_token_ttl = lib.mkOption {
            type = int;
            default = 3600;
            description = ''
              OpenID token expiration/TTL in seconds.
              These are the OpenID tokens that are primarily used for Matrix account 
              integrations (e.g. Vector Integrations in Element), *not* OIDC/OpenID
              Connect/etc.
            '';
          };
          global.login_via_existing_session = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Allow an existing session to mint a login token for another client.
              This requires interactive authentication, but has security ramifications
              as a malicious client could use the mechanism to spawn more than one session.
              Enabled by default.
            '';
          };
          global.login_token_ttl = lib.mkOption {
            type = int;
            default = 120000;
            description = ''
              Login token expiration/TTL in milliseconds.
              These are short-lived tokens for the m.login.token endpoint.
              This is used to allow existing sessions to create new sessions. 
              see login_via_existing_session.
            '';
          };
          global.turn_username = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Static TURN username to provide the client if not using a shared secret
              ("turn_secret"), It is recommended to use a shared secret over static 
              credentials.
            '';
          };
          global.turn_password = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Static TURN password to provide the client if not using a shared secret 
              ("turn_secret"). It is recommended to use a shared secret over static 
              credentials.
            '';
          };
          global.turn_uris = lib.mkOption {
            type = listOf str;
            default = [ ];
            example = [
              "turn:example.turn.uri?transport=udp"
              "turn:example.turn.uri?transport=tcp"
            ];
            description = ''
              Vector list of TURN URIs/servers to use.
              Replace "example.turn.uri" with your TURN domain, such as the coturn "realm" 
              config option. If using TURN over TLS, replace the URI prefix "turn:" with 
              "turns:".
            '';
          };
          global.turn_secret = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              TURN secret to use for generating the HMAC-SHA1 hash apart of username and 
              password generation. This is more secure, but if needed you can use 
              traditional static username/password credentials.
            '';
          };
          global.turn_secret_file = lib.mkOption {
            type = str;
            example = "/etc/conduwuit/.turn_secret";
            description = ''
              TURN secret to use that's read from the file path specified. 
              This takes priority over "turn_secret" first, and falls back to "turn_secret"
              if invalid or failed to open.
            '';
          };
          global.turn_ttl = lib.mkOption {
            type = int;
            default = 86400;
            description = ''
              TURN TTL, in seconds.
            '';
          };
          global.auto_join_rooms = lib.mkOption {
            type = listOf str;
            default = [ ];
            example = [
              "#conduwuit:puppygock.gay"
              "!eoIzvAvVwY23LPDay8:puppygock.gay"
            ];
            description = ''
              List/vector of room IDs or room aliases that conduwuit will make newly 
              registered users join. The rooms specified must be rooms that you have joined 
              at least once on the server, and must be public.
            '';
          };
          global.auto_deactivate_banned_room_attempts = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              	      
                            Config option to automatically deactivate the account of any user who attempts		  to join a:
                            - banned room
                            - forbidden room alias
                            - room alias or ID with a forbidden server name

                            This may be useful if all your banned lists consist of toxic rooms or
                            servers that no good faith user would ever attempt to join, and
                            to automatically remediate the problem without any admin user intervention.

                            This will also make the user leave all rooms. Federation (e.g. remote
                            room invites) are ignored here.

                            Defaults to false as rooms can be banned for non-moderation-related
                            reasons and this performs a full user deactivation.
            '';
          };
          global.rocksdb_log_level = lib.mkOption {
            type = str;
            default = "error";
            description = ''
              RocksDB log level. This is not the same as conduwuit's log level. This is the 
              log level for the RocksDB engine/library which show up in your database 
              folder/path as `LOG` files. conduwuit will log RocksDB errors as normal 
              through tracing or panics if severe for safety.
            '';
          };
          global.rocksdb_log_stderr = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              ???
            '';
          };
          global.rocksdb_max_log_file_size = lib.mkOption {
            type = int;
            default = 4194304;
            description = ''
              Max RocksDB `LOG` file size before rotating in bytes. Defaults to 4MB in bytes
            '';
          };
          global.rocksdb_log_time_to_roll = lib.mkOption {
            type = int;
            default = 0;
            description = ''
              Time in seconds before RocksDB will forcibly rotate logs.
            '';
          };
          global.rocksdb_optimize_for_spinning_disks = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Set this to true to use RocksDB config options that are tailored to HDDs 
              (slower device storage).

              It is worth noting that by default, conduwuit will use RocksDB with Direct IO 
              enabled. *Generally* speaking this improves performance as it bypasses 
              buffered I/O (system page cache). However there is a potential chance that 
              Direct IO may cause issues with database operations if your setup is uncommon.
              This has been observed with FUSE filesystems, and possibly ZFS filesystem. 
              RocksDB generally deals/corrects these issues but it cannot account for all 
              setups. If you experience any weird RocksDB issues, try enabling this option 
              as it turns off Direct IO and feel free to report in the conduwuit Matrix room
              if this option fixes your DB issues.
              For more information, see:
              https://github.com/facebook/rocksdb/wiki/Direct-IO
            '';
          };
          global.rocksdb_direct_io = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Enables direct-io to increase database performance via unbuffered I/O.
              For more details about direct I/O and RockDB, see:
              https://github.com/facebook/rocksdb/wiki/Direct-IO

              Set this option to false if the database resides on a filesystem which does 
              not support direct-io like FUSE, or any form of complex filesystem setup such
              as possibly ZFS.
            '';
          };
          global.rocksdb_parallelism_threads = lib.mkOption {
            type = int;
            default = 0;
            description = ''
              Amount of threads that RocksDB will use for parallelism on database 
              operations such as cleanup, sync, flush, compaction, etc. Set to 0 to use all
              your logical threads. Defaults to your CPU logical thread count.
            '';
          };
          global.rocksdb_max_log_files = lib.mkOption {
            type = int;
            default = 3;
            description = ''
              Maximum number of LOG files RocksDB will keep. This must *not* be set to 0. 
              It must be at least 1. Defaults to 3 as these are not very useful unless 
              troubleshooting/debugging a RocksDB bug.
            '';
          };
          global.rocksdb_compression_algo = lib.mkOption {
            type = str;
            default = "zstd";
            description = ''
              Type of RocksDB database compression to use.
              Available options are "zstd", "zlib", "bz2", "lz4", or "none".
              It is best to use ZSTD as an overall good balance between speed/performance, 
              storage, IO amplification, and CPU usage. For more performance but less 
              compression (more storage used) and less CPU usage, use LZ4. 
              For more details, see:
              https://github.com/facebook/rocksdb/wiki/Compression "none" will disable 
              compression.
            '';
          };
          global.rocksdb_compression_level = lib.mkOption {
            type = int;
            example = 32767;
            description = ''
              Level of compression the specified compression algorithm for RocksDB to use.
              Default is 32767, which is internally read by RocksDB as the default magic 
              number and translated to the library's default compression level as they all 
              differ. See their `kDefaultCompressionLevel`. Note when using the default 
              value we may override it with a setting tailored specifically conduwuit.
            '';
          };
          global.rocksdb_bottommost_compression_level = lib.mkOption {
            type = int;
            example = 32767;
            description = ''
              Level of compression the specified compression algorithm for the bottommost 
              level/data for RocksDB to use. Default is 32767, which is internally read by
              RocksDB as the default magic number and translated to the library's default
              compression level as they all differ. See their `kDefaultCompressionLevel`.

              Since this is the bottommost level (generally old and least used data), 
              it may be desirable to have a very high compression level here as it's less 
              likely for this data to be used. Research your chosen compression algorithm.

              Note when using the default value we may override it with a setting tailored 
              specifically to conduwuit.
            '';
          };
          global.rocksdb_bottommost_compression = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Whether to enable RocksDB's "bottommost_compression". 
              At the expense of more CPU usage, this will further compress the database to 
              reduce more storage. It is recommended to use ZSTD compression with this for
              best compression results. This may be useful if you're trying to reduce 
              storage usage from the database.

              See https://github.com/facebook/rocksdb/wiki/Compression for more details.
            '';
          };
          global.rocksdb_recovery_mode = lib.mkOption {
            type = int;
            default = 1;
            description = ''
              Database recovery mode (for RocksDB WAL corruption).

              Use this option when the server reports corruption and refuses to start.
              Set mode 2 (PointInTime) to cleanly recover from this corruption. The server 
              will continue from the last good state, several seconds or minutes prior to 
              the crash. Clients may have to run "clear-cache & reload" to account for the
              rollback. Upon success, you may reset the mode back to default and restart 
              again. Please note in some cases the corruption error may not be cleared for
              at least 30 minutes of operation in PointInTime mode.

              As a very last ditch effort, if PointInTime does not fix or resolve anything,
              you can try mode 3 (SkipAnyCorruptedRecord) but this will leave the server in
              a potentially inconsistent state.

              The default mode 1 (TolerateCorruptedTailRecords) will automatically drop the
              last entry in the database if corrupted during shutdown, but nothing more. 
              It is extraordinarily unlikely this will desynchronize clients. To disable 
              any form of silent rollback set mode 0 (AbsoluteConsistency).

              The options are:
              0 = AbsoluteConsistency
              1 = TolerateCorruptedTailRecords (default)
              2 = PointInTime (use me if trying to recover)
              3 = SkipAnyCorruptedRecord (you now voided your Conduwuit warranty)

              For more information on these modes, see:
              https://github.com/facebook/rocksdb/wiki/WAL-Recovery-Modes
              For more details on recovering a corrupt database, see:
              https://conduwuit.puppyirl.gay/troubleshooting.html#database-corruption
            '';
          };
          global.rocksdb_paranoid_file_checks = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Enables or disables paranoid SST file checks. This can improve RocksDB 
              database consistency at a potential performance impact due to further safety 
              checks ran.
              For more information, see:
              https://github.com/facebook/rocksdb/wiki/Online-Verification#columnfamilyoptionsparanoid_file_checks
            '';
          };
          global.rocksdb_checksum = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Enables or disables checksum verification in rocksdb at runtime. 
              Checksums are usually hardware accelerated with low overhead; they are 
              enabled in rocksdb by default. Older or slower platforms may see gains 
              from disabling.
            '';
          };
          global.rocksdb_repair = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Database repair mode (for RocksDB SST corruption).
              Use this option when the server reports corruption while running or panics. 
              If the server refuses to start use the recovery mode options first. 
              Corruption errors containing the acronym 'SST' which occur after startup will
              likely require this option.

              - Backing up your database directory is recommended prior to running the 
              repair.

              - Disabling repair mode and restarting the server is recommended after 
              running the repair.

              See https://conduwuit.puppyirl.gay/troubleshooting.html#database-corruption for more details on recovering a corrupt database.
            '';
          };
          global.rocksdb_read_only = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              ???
            '';
          };
          global.rocksdb_secondary = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              ???
            '';
          };
          global.rocksdb_compaction_prio_idle = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Enables idle CPU priority for compaction thread. This is not enabled by 
              default to prevent compaction from falling too far behind on busy systems.
            '';
          };
          global.rocksdb_compaction_ioprio_idle = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Enables idle IO priority for compaction thread. This prevents any unexpected 
              lag in the server's operation and is usually a good idea. Enabled by default.
            '';
          };
          global.rocksdb_compaction = lib.mkOption {
            type = bool;
            description = ''
              Disables RocksDB compaction. You should never ever have to set this option to
              true. If you for some reason find yourself needing to use this option as part
              of troubleshooting or a bug, please reach out to us in the conduwuit Matrix 
              room with information and details.
              Disabling compaction will lead to a significantly bloated and explosively 
              large database, gradually poor performance, unnecessarily excessive disk 
              read/writes, and slower shutdowns and startups.
            '';
          };
          global.rocksdb_stats_level = lib.mkOption {
            type = bool;
            default = 1;
            description = ''
              Level of statistics collection. Some admin commands to display database 
              statistics may require this option to be set. Database performance may be 
              impacted by higher settings.

              Option is a number ranging from 0 to 6:
              0 = No statistics.
              1 = No statistics in release mode (default).
              2 to 3 = Statistics with no performance impact.
              3 to 5 = Statistics with possible performance impact.
              6 = All statistics.
            '';
          };
          global.emergency_password = lib.mkOption {
            type = str;
            example = "F670$2CP@Hw8mG7RY1$%!#Ic7YA";
            description = ''
              This is a password that can be configured that will let you login to the 
              server bot account (currently `@conduit`) for emergency troubleshooting 
              purposes such as recovering/recreating your admin room, or inviting yourself 
              back. 
              See 
              https://conduwuit.puppyirl.gay/troubleshooting.html#lost-access-to-admin-room 		 
              for other ways to get back into your admin room.

              Once this password is unset, all sessions will be logged out for security 
              purposes.
            '';
          };
          global.notification_push_path = lib.mkOption {
            type = str;
            default = "/_matrix/push/v1/notify";
            description = ''
              ???
            '';
          };
          global.allow_local_presence = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Allow local (your server only) presence updates/requests.
              Note that presence on conduwuit is very fast unlike Synapse's. If using
              outgoing presence, this MUST be enabled.
            '';
          };
          global.allow_incoming_presence = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Allow incoming federated presence updates/requests.
              This option receives presence updates from other servers, but does not send 
              any unless `allow_outgoing_presence` is true. Note that presence on conduwuit
              is very fast unlike Synapse's.
            '';
          };
          global.allow_outgoing_presence = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Allow outgoing presence updates/requests.
              This option sends presence updates to other servers, but does not receive any
              unless `allow_incoming_presence` is true. Note that presence on conduwuit is
              very fast unlike Synapse's. If using outgoing presence, you MUST enable 
              `allow_local_presence` as well.
            '';
          };
          global.presence_idle_timeout_s = lib.mkOption {
            type = int;
            default = 300;
            description = ''
              How many seconds without presence updates before you become idle.
              Defaults to 5 minutes.
            '';
          };
          global.presence_offline_timeout_s = lib.mkOption {
            type = int;
            default = 1800;
            description = ''
              How many seconds without presence updates before you become offline. 
              Defaults to 30 minutes.
            '';
          };
          global.presence_timeout_remote_users = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Enable the presence idle timer for remote users.
              Disabling is offered as an optimization for servers participating in many 
              large rooms or when resources are limited. Disabling it may cause incorrect 
              presence states (i.e. stuck online) to be seen for some remote users.
            '';
          };
          global.allow_incoming_read_receipts = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Allow receiving incoming read receipts from remote servers.
            '';
          };
          global.allow_outgoing_read_receipts = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Allow sending read receipts to remote servers.
            '';
          };
          global.allow_outgoing_typing = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Allow outgoing typing updates to federation.
            '';
          };
          global.allow_incoming_typing = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Allow incoming typing updates from federation.
            '';
          };
          global.typing_federation_timeout_s = lib.mkOption {
            type = int;
            default = 30;
            description = ''
              Maximum time federation user can indicate typing.
            '';
          };
          global.typing_client_timeout_min_s = lib.mkOption {
            type = int;
            default = 15;
            description = ''
              Minimum time local client can indicate typing. This does not override a 
              client's request to stop typing. It only enforces a minimum value in case of
              no stop request.
            '';
          };
          global.typing_client_timeout_max_s = lib.mkOption {
            type = int;
            default = 45;
            description = ''
              Maximum time local client can indicate typing.
            '';
          };
          global.zstd_compression = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Set this to true for conduwuit to compress HTTP response bodies using zstd. 
              This option does nothing if conduwuit was not built with `zstd_compression` 
              feature. Please be aware that enabling HTTP compression may weaken TLS. 
              Most users should not need to enable this.
              See https://breachattack.com/ and https://wikipedia.org/wiki/BREACH 
              before deciding to enable this.
            '';
          };
          global.gzip_compression = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Set this to true for conduwuit to compress HTTP response bodies using gzip. 
              This option does nothing if conduwuit was not built with `gzip_compression` 
              feature. Please be aware that enabling HTTP compression may weaken TLS. 
              Most users should not need to enable this.
              See https://breachattack.com/ and https://wikipedia.org/wiki/BREACH before
              deciding to enable this.

              If you are in a large amount of rooms, you may find that enabling this 
              is necessary to reduce the significantly large response bodies.
            '';
          };
          global.brotli_compression = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Set this to true for conduwuit to compress HTTP response bodies using brotli.
              This option does nothing if conduwuit was not built with `brotli_compression`
              feature. Please be aware that enabling HTTP compression may weaken TLS. Most
              users should not need to enable this.
              See https://breachattack.com/ and https://wikipedia.org/wiki/BREACH 
              before deciding to enable this.
            '';
          };
          global.allow_guest_registration = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Set to true to allow user type "guest" registrations. Some clients like 
              Element attempt to register guest users automatically.
            '';
          };
          global.log_guest_registrations = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Set to true to log guest registrations in the admin room. Note that these may
              be noisy or unnecessary if you're a public homeserver.
            '';
          };
          global.allow_guests_auto_join_rooms = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Set to true to allow guest registrations/users to auto join any rooms 
              specified in `auto_join_rooms`.
            '';
          };
          global.allow_legacy_media = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Enable the legacy unauthenticated Matrix media repository endpoints.
              These endpoints consist of:
              - /_matrix/media/*/config
              - /_matrix/media/*/upload
              - /_matrix/media/*/preview_url
              - /_matrix/media/*/download/*
              - /_matrix/media/*/thumbnail/*
              The authenticated equivalent endpoints are always enabled.
              Defaults to true for now, but this is highly subject to change, likely in the
              next release.
            '';
          };
          global.freeze_legacy_media = lib.mkOption {
            type = bool;
            example = true;
            description = ''
              ???
            '';
          };
          global.media_startup_check = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Check consistency of the media directory at startup:
              1. When `media_compat_file_link` is enabled, this check will upgrade media 
              when switching back and forth between Conduit and conduwuit. 
              Both options must be enabled to handle this.

              2. When media is deleted from the directory, this check will also delete its 
              database entry.
              If none of these checks apply to your use cases, and your media directory 
              is significantly large setting this to false may reduce startup time.
            '';
          };
          global.media_compat_file_link = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Enable backward-compatibility with Conduit's media directory by creating 
              symlinks of media. 
              This option is only necessary if you plan on using Conduit again. Otherwise 
              setting this to false reduces filesystem clutter and overhead for managing 
              these symlinks in the directory. This is now disabled by default. You may 
              still return to upstream Conduit but you have to run conduwuit at least once 
              with this set to true and allow the media_startup_check to take place before 
              shutting down to return to Conduit.
            '';
          };
          global.prune_missing_media = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Prune missing media from the database as part of the media startup checks. 

              This means if you delete files from the media directory the corresponding 
              entries will be removed from the database. This is disabled by default 
              because if the media directory is accidentally moved or inaccessible, the
              metadata entries in the database will be lost with sadness.
            '';
          };
          global.prevent_media_downloads_from = lib.mkOption {
            type = listOf str;
            default = [ ];
            description = ''
              Vector list of servers that conduwuit will refuse to download remote media 
              from.
            '';
          };
          global.forbidden_remote_server_names = lib.mkOption {
            type = listOf str;
            default = [ ];
            description = ''
              List of forbidden server names that we will block incoming AND outgoing 
              federation with, and block client room joins / remote user invites.

              This check is applied on the room ID, room alias, sender server name, sender 
              user's server name, inbound federation X-Matrix origin, and outbound 
              federation handler. 

              Basically "global" ACLs.
            '';
          };
          global.forbidden_remote_room_directory_server_names = lib.mkOption {
            type = listOf str;
            default = [ ];
            description = ''
              List of forbidden server names that we will block all outgoing federated room
              directory requests for. Useful for preventing our users from wandering into 
              bad servers or spaces.
            '';
          };
          global.ip_range_denylist = lib.mkOption {
            type = listOf str;
            default = [
              "127.0.0.0/8"
              "10.0.0.0/8"
              "172.16.0.0/12"
              "192.168.0.0/16"
              "100.64.0.0/10"
              "192.0.0.0/24"
              "169.254.0.0/16"
              "192.88.99.0/24"
              "198.18.0.0/15"
              "192.0.2.0/24"
              "198.51.100.0/24"
              "203.0.113.0/24"
              "224.0.0.0/4"
              "::1/128"
              "fe80::/10"
              "fc00::/7"
              "2001:db8::/32"
              "ff00::/8"
              "fec0::/10"
            ];
            description = ''
              Vector list of IPv4 and IPv6 CIDR ranges / subnets *in quotes* that you do 
              not want conduwuit to send outbound requests to. Defaults to RFC1918, 
              unroutable, loopback, multicast, and testnet addresses for security. 

              Please be aware that this is *not* a guarantee. You should be using a 
              firewall with zones as doing this on the application layer may have bypasses.

              Currently this does not account for proxies in use like Synapse does.
              To disable, set this to be an empty vector (`[]`).
            '';
          };
          global.url_preview_bound_interface = lib.mkOption {
            type = str;
            example = "eth0";
            description = ''
              Optional IP address or network interface-name to bind as the source of URL 
              preview requests. If not set, it will not bind to a specific address or 
              interface. 
              Interface names only supported on Linux, Android, and Fuchsia platforms; 
              all other platforms can specify the IP address. To list the interfaces on 
              your system, use the command `ip link show`.
            '';
          };
          global.url_preview_domain_contains_allowlist = lib.mkOption {
            type = listOf str;
            default = [ ];
            description = ''
              Vector list of domains allowed to send requests to for URL previews. 
              This is a *contains* match, not an explicit match. Putting "google.com" 
              will match "https://google.com" and 
              "http://mymaliciousdomainexamplegoogle.com" Setting this to "*" will allow 
              all URL previews. Please note that this opens up significant attack surface 
              to your server, you are expected to be aware of the risks by doing so.
            '';
          };
          global.url_preview_domain_explicit_allowlist = lib.mkOption {
            type = listOf str;
            default = [ ];
            description = ''
              Vector list of explicit domains allowed to send requests to for URL previews.
              This is an *explicit* match, not a contains match. Putting "google.com" will 
              match "https://google.com", "http://google.com", but not 
              "https://mymaliciousdomainexamplegoogle.com". Setting this to "*" will allow 
              all URL previews. Please note that this opens up significant attack surface 
              to your server, you are expected to be aware of the risks by doing so.
            '';
          };
          global.url_preview_domain_explicit_denylist = lib.mkOption {
            type = listOf str;
            default = [ ];
            description = ''
              Vector list of explicit domains not allowed to send requests to for URL 
              previews. This is an *explicit* match, not a contains match. Putting 
              "google.com" will match "https://google.com", "http://google.com", but not 
              "https://mymaliciousdomainexamplegoogle.com". The denylist is checked first 
              before allowlist. Setting this to "*" will not do anything.
            '';
          };
          global.url_preview_url_contains_allowlist = lib.mkOption {
            type = listOf str;
            default = [ ];
            description = ''
              Vector list of URLs allowed to send requests to for URL previews.
              Note that this is a *contains* match, not an explicit match. Putting 
              "google.com" will match "https://google.com/",
              "https://google.com/url?q=https://mymaliciousdomainexample.com", and
              "https://mymaliciousdomainexample.com/hi/google.com" Setting this to "*" will
              allow all URL previews. Please note that this opens up significant attack 
              surface to your server, you are expected to be aware of the risks by doing so
            '';
          };
          global.url_preview_max_spider_size = lib.mkOption {
            type = int;
            default = 256000;
            description = ''
              Maximum amount of bytes allowed in a URL preview body size when spidering. 
              Defaults to 256KB in bytes.
            '';
          };
          global.url_preview_check_root_domain = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Option to decide whether you would like to run the domain allowlist checks 
              (contains and explicit) on the root domain or not. Does not apply to URL 
              contains allowlist. Defaults to false.
              Example usecase: If this is enabled and you have "wikipedia.org" allowed
              in the explicit and/or contains domain allowlist, it will allow all
              subdomains under "wikipedia.org" such as "en.m.wikipedia.org" as the root 
              domain is checked and matched. Useful if the domain contains allowlist is 
              still too broad for you but you still want to allow all the subdomains under 
              a root domain.
            '';
          };
          global.forbidden_alias_names = lib.mkOption {
            type = listOf str;
            default = [ ];
            description = ''
              List of forbidden room aliases and room IDs as strings of regex patterns.

              Regex can be used or explicit contains matches can be done by just specifying
              the words (see example).

              This is checked upon room alias creation, custom room ID creation if used, 
              and startup as warnings if any room aliases in your database have a forbidden
              room alias/ID.
              example: ["19dollarfortnitecards", "b[4a]droom"]
            '';
          };
          global.forbidden_usernames = lib.mkOption {
            type = listOf str;
            default = [ ];
            description = ''
              List of forbidden username patterns/strings.
              Regex can be used or explicit contains matches can be done by just specifying
              the words (see example).
              This is checked upon username availability check, registration, and startup 
              as warnings if any local users in your database have a forbidden username.
              xample: ["administrator", "b[a4]dusernam[3e]"]
            '';
          };
          global.startup_netburst = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Retry failed and incomplete messages to remote servers immediately upon 
              startup. This is called bursting. If this is disabled, said messages may 
              not be delivered until more messages are queued for that server. Do not 
              change this option unless server resources are extremely limited or the 
              scale of the server's deployment is huge. Do not disable this unless you 
              know what you are doing.
            '';
          };
          global.startup_netburst_keep = lib.mkOption {
            type = int;
            default = 50;
            description = ''
              Messages are dropped and not reattempted. The `startup_netburst` option must 
              be enabled for this value to have any effect. Do not change this value unless
              you know what you are doing. Set this value to -1 to reattempt every message 
              without trimming the queues; this may consume significant disk. Set this 
              value to 0 to drop all messages without any attempt at redelivery.
            '';
          };
          global.block_non_admin_invites = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Block non-admin local users from sending room invites (local and remote), and
              block non-admin users from receiving remote room invites. 
              Admins are always allowed to send and receive all room invites.
            '';
          };
          global.admin_escape_commands = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Allow admins to enter commands in rooms other than "#admins" (admin room) by 
              prefixing your message with "\!admin" or "\\!admin" followed up a normal 
              conduwuit admin command. The reply will be publicly visible to the room, 
              originating from the sender. example: \\!admin debug ping puppygock.gay
            '';
          };
          global.admin_console_automatic = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Automatically activate the conduwuit admin room console / CLI on startup. 
              This option can also be enabled with `--console` conduwuit argument.
            '';
          };
          global.admin_execute = lib.mkOption {
            type = listOf str;
            default = [ ];
            description = ''
              List of admin commands to execute on startup. 
              This option can also be configured with the `--execute` conduwuit argument 
              and can take standard shell commands and environment variables 

              For example: `./conduwuit --execute "server admin-notice conduwuit has 
              started up at $(date)"`

              example: admin_execute = ["debug ping puppygock.gay", "debug echo hi"]`
            '';
          };
          global.admin_execute_errors_ignore = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Ignore errors in startup commands. If false, conduwuit will error and fail to
              start if an admin execute command (`--execute` / `admin_execute`) fails.
            '';
          };
          global.admin_signal_execute = lib.mkOption {
            type = listOf str;
            default = [ ];
            description = ''
              List of admin commands to execute on SIGUSR2.
              Similar to admin_execute, but these commands are executed when the server 
              receives SIGUSR2 on supporting platforms.
            '';
          };
          global.admin_log_capture = lib.mkOption {
            type = str;
            default = "info";
            description = ''
              Controls the max log level for admin command log captures (logs generated 
              from running admin commands). Defaults to "info" on release builds, else 
              "debug" on debug builds.
            '';
          };
          global.admin_room_tag = lib.mkOption {
            type = str;
            default = "m.server_notice";
            description = ''
              The default room tag to apply on the admin room. On some clients like 
              Element, the room tag "m.server_notice" is a special pinned room at the very
              bottom of your room list. The conduwuit admin room can be pinned here so you
              always have an easy-to-access shortcut dedicated to your admin room.
            '';
          };
          global.sentry = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Sentry.io crash/panic reporting, performance monitoring/metrics, etc. 
              This is NOT enabled by default. conduwuit's default Sentry reporting endpoint
              domain is `o4506996327251968.ingest.us.sentry.io`.
            '';
          };
          global.sentry_endpoint = lib.mkOption {
            type = str;
            description = ''
              Sentry reporting URL, if a custom one is desired.
            '';
          };
          global.sentry_send_server_name = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Report your conduwuit server_name in Sentry.io crash reports and metrics.
            '';
          };
          global.sentry_traces_sample_rate = lib.mkOption {
            type = float;
            default = 0.15;
            description = ''
              Performance monitoring/tracing sample rate for Sentry.io. 
              Note that too high values may impact performance, and can be disabled by 
              setting it to 0.0 (0%) This value is read as a percentage to Sentry, 
              represented as a decimal. Defaults to 15% of traces (0.15)
            '';
          };
          global.sentry_attach_stacktrace = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Whether to attach a stacktrace to Sentry reports.
            '';
          };
          global.sentry_send_panic = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Send panics to Sentry. This is true by default, but Sentry has to be enabled.
              The global `sentry` config option must be enabled to send any data.
            '';
          };
          global.sentry_send_error = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Send errors to sentry. This is true by default, but sentry has to be enabled.
              This option is only effective in release-mode; forced to false in debug-mode.
            '';
          };
          global.sentry_filter = lib.mkOption {
            type = str;
            default = "info";
            description = ''
              Controls the tracing log level for Sentry to send things like breadcrumbs and
              transactions.
            '';
          };
          global.tokio_console = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Enable the tokio-console. This option is only relevant to developers.
              For more information, see:
              https://conduwuit.puppyirl.gay/development.html#debugging-with-tokio-console
            '';
          };
          global.test = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              ???
            '';
          };
          global.admin_room_notices = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Controls whether admin room notices like account registrations, password 
              changes, account deactivations, room directory publications, etc will be sent
              to the admin room. Update notices and normal admin command responses will
              still be sent.
            '';
          };
          global.db_pool_affinity = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Enable database pool affinity support. On supporting systems, block device 
              queue topologies are detected and the request pool is optimized for the 
              hardware; db_pool_workers is determined automatically.
            '';
          };
          global.db_pool_workers = lib.mkOption {
            type = int;
            description = ''
              Sets the number of worker threads in the frontend-pool of the database. 
              This number should reflect the I/O capabilities of the system, such as the 
              queue-depth or the number of simultaneous requests in flight. Defaults to 32
              or four times the number of CPU cores, whichever is greater. 

              Note: This value is only used if db_pool_affinity is disabled or not detected
              on the system, otherwise it is determined automatically.
            '';
          };
          global.db_pool_workers_limit = lib.mkOption {
            type = int;
            default = 64;
            description = ''
              When db_pool_affinity is enabled and detected, the size of any worker group 
              will not exceed the determined value. This is necessary when thread-pooling 
              approach does not scale to the full capabilities of high-end hardware; using
              detected values without limitation could degrade performance. 

              The value is multiplied by the number of cores which share a device queue, 
              since group workers can be scheduled on any of those cores.
            '';
          };
          global.db_pool_queue_mult = lib.mkOption {
            type = int;
            default = 4;
            description = ''
              	      
                            Determines the size of the queues feeding the database's frontend-pool.
                            The size of the queue is determined by multiplying this value with the
                            number of pool workers. When this queue is full, tokio tasks conducting
                            requests will yield until space is available; this is good for
                            flow-control by avoiding buffer-bloat, but can inhibit throughput if too low.
            '';
          };
          global.stream_width_default = lib.mkOption {
            type = int;
            default = 32;
            description = ''
              Sets the initial value for the concurrency of streams. This value simply 
              allows overriding the default in the code. The default is 32, which is the 
              same as the default in the code. Note this value is itself overridden by the
              computed stream_width_scale, unless that is disabled; this value can serve 
              as a fixed-width instead.
            '';
          };
          global.stream_width_scale = lib.mkOption {
            type = float;
            default = 1.0;
            description = ''
              Scales the stream width starting from a base value detected for the specific 
              system. The base value is the database pool worker count determined from the 
              hardware queue size (e.g. 32 for SSD or 64 or 128+ for NVMe). This float 
              allows scaling the width up or down by multiplying it (e.g. 1.5, 2.0, etc). 
              The maximum result can be the size of the pool queue 
              (see: db_pool_queue_mult) as any larger value will stall the tokio task. 
              The value can also be scaled down (e.g. 0.5)  to improve responsiveness for 
              many users at the cost of throughput for each. 

              Setting this value to 0.0 causes the stream width to be fixed at the value of
              stream_width_default. The default scale is 1.0 to match the capabilities 
              detected for the system.
            '';
          };
          global.stream_amplification = lib.mkOption {
            type = int;
            default = 1024;
            description = ''
              Sets the initial amplification factor. This controls batch sizes of requests 
              made by each pool worker, multiplying the throughput of each stream. 
              This value is somewhat abstract from specific hardware characteristics and 
              can be significantly larger than any thread count or queue size. This is 
              because each database query may require several index lookups, thus many 
              database queries in a batch may make progress independently while also 
              sharing index and data blocks which may or may not be cached. It is 
              worthwhile to submit huge batches to reduce complexity. The maximum value is
              32768, though sufficient hardware is still advised for that.
            '';
          };
          global.sender_workers = lib.mkOption {
            type = int;
            default = 0;
            description = ''
              Number of sender task workers; determines sender parallelism. Default is '0'
              which means the value is determined internally, likely matching the number of
              tokio worker-threads or number of cores, etc. Override by setting a non-zero
              value.
            '';
          };
          global.listening = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              Enables listener sockets; can be set to false to disable listening. This 
              option is intended for developer/diagnostic purposes only.
            '';
          };
          global.config_reload_signal = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Enables configuration reload when the server receives SIGUSR1 on supporting 
              platforms.
            '';
          };
          global.tls.dual_protocol = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Whether to listen and allow for HTTP and HTTPS connections (insecure!)
            '';
          };
          global.well_known.client = lib.mkOption {
            type = str;
            example = "https://matrix.example.com";
            default = "https://matrix.alina.dog";
            description = ''
              The server URL that the client well-known file will serve. This should not 
              contain a port, and should just be a valid HTTPS URL.
            '';
          };
          global.well_known.server = lib.mkOption {
            type = str;
            example = "matrix.example.com:443";
            default = "matrix.alina.dog:433";
            description = ''
              The server base domain of the URL with a specific port that the server 
              well-known file will serve. This should contain a port at the end, and should
              not be a URL.
            '';
          };
          global.well_known.support_page = lib.mkOption {
            type = str;
            description = ''
              ???
            '';
          };
          global.well_known.support_role = lib.mkOption {
            type = str;
            description = ''
              ???
            '';
          };
          global.well_known.support_email = lib.mkOption {
            type = str;
            description = ''
              ???
            '';
          };
          global.well_known.support_mxid = lib.mkOption {
            type = str;
            description = ''
              ???
            '';
          };
          global.blurhashing.components_x = lib.mkOption {
            type = int;
            default = 4;
            description = ''
              Blurhashing x component, 4 is recommended by https://blurha.sh/
            '';
          };
          global.blurhashing.components_y = lib.mkOption {
            type = int;
            default = 3;
            description = ''
              Blurhashing y component, 3 is recommended by https://blurha.sh/
            '';
          };
          global.blurhashing.blurhash_max_raw_size = lib.mkOption {
            type = int;
            default = 33554432;
            description = ''
              Max raw size that the server will blurhash, this is the size of the image 
              after converting it to raw data, it should be higher than the upload limit 
              but not too high. The higher it is the higher the potential load will be for
              clients requesting blurhashes. The default is 33.55MB. Setting it to 0 
              disables blurhashing.
            '';
          };
          global.cleanup_second_interval = lib.mkOption {
            type = int;
            default = 60;
            description = ''How often conduit should clean up the database, in seconds'';
          };
          global.unix_socket_path = lib.mkOption {
            type = str;
            default = "/run/continuwuity/continuwuity.sock";
            description = ''
              The UNIX socket conduwuit will listen on.

              Conduwuit cannot listen on both an IP address and a UNIX socket. If listening 
              on a UNIX socket, you MUST remove/comment the `address` key.

              Remember to make sure that your reverse proxy has access to this socket file, 
              either by adding your reverse proxy to the 'continuwuity' group or granting world
              R/W permissions with `unix_socket_perms` (666 minimum).
            '';
          };
          global.unix_socket_perms = lib.mkOptiom {
            type = str;
            default = 660;
            description = ''
              The default permissions (in octal) to create the UNIX socket with.
            '';
          };
          global.server_name = lib.mkOption {
            type = str;
            default = "alina.dog";
            description = ''
              The server_name is the name of this server. 
              It is used as a suffix for user # and room ids.
            '';
          };
          global.allow_encryption = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Whether new encrypted rooms can be created. 
              Note: existing rooms will continue to work.
            '';
          };
          global.allow_federation = lib.mkOption {
            type = bool;
            default = true;
            description = ''
              Whether this server federates with other servers.
            '';
          };
          global.database_path = lib.mkOption {
            type = str;
            default = "/var/lib/continuwuity";
            description = ''
              Path to the conduit database, the directory where conduit will save its data.
              Note that due to using the DynamicUser feature of systemd, this value should 
              not be changed and is set to be read only.

              (this description is irrevelant, #TODO change)
            '';
          };
          global.database_backend = lib.mkOption {
            type = enum [
              "sqlite"
              "rocksdb"
            ];
            default = "rocksdb";
            description = ''
              The database backend for the service. Switching it on an existing
              instance will require manual migration of data.
            '';
          };
          global.database_backup_path = lib.mkOption {
            type = str;
            example = "/opt/conduwuit-db-backups";
            description = ''
              Conduwuit supports online database backups using RocksDB's Backup engine API.
              To use this, set a database backup path that conduwuit can write to.
              For more information, see:
              https://conduwuit.puppyirl.gay/maintenance.html#backups
            '';
          };
          global.database_backups_to_keep = lib.mkOption {
            type = int;
            example = 1;
            description = ''
              The amount of online RocksDB database backups to keep/retain, if using 
              "database_backup_path", before deleting the oldest one.
            '';
          };
          global.allow_check_for_updates = lib.mkOption {
            type = bool;
            default = false;
            description = ''
              If enabled, conduwuit will send a simple GET request periodically to
              `https://pupbrain.dev/check-for-updates/stable` for any new announcements 
              made. Despite the name, this is not an update check endpoint, it is simply an
              announcement check endpoint.
              This is disabled by default as this is rarely used except for security 
              updates or major updates.
            '';
          };
        };
      };
    };
  };
  l.network.nginx = {
    vhosts."matrix.alina.dog" = {
      locations."/" = {
        proxyPass = "http://continuwuity";
      };
    };
    upstreams."continuwuity" = {
      servers."unix:/run/continuwuity/continuwuity.sock" = { };
      extraConfig = ''
        keepalive 16;
      '';
    };
  };
  l.tasks.tasks.continuwuity = {
    enable = true;
    exec = [ "${lib.getExe cfg.package}" ];
    env = {
      CONTINUWUITY_CONFIG = configFile;
    };
    dataDir = "/var/lib/continuwuity";
    paths = {
      exec = lib.getExe cfg.package;
      rw = [
        "/run/continuwuity"
      ];
    };
  };
  users.users.nginx.extraGroups = [ "continuwuity" ];
}
