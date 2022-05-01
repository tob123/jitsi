---- global prosody settings start ----
--todo: also log to files?
--s2s not needed according to docker jitsi on github
modules_disabled = {
        "s2s"; -- Handle server-to-server connections
};
pidfile = "/var/run/prosody/prosody.pid"
c2s_require_encryption = false
--see also https://prosody.im/doc/network_backend
--network_backend = "epoll"
--plugin path for jitsi plugins for prosody
plugin_paths = { "/jitsi/prosody-plugins/" };
--set default http host to xmpp domain
http_default_host = "meet.jitsi";
--insert more configuration based on environment variables during container startup:
--bosh is used for jitsi. no tls / ssl needed due to reverse proxy elsewhere with tls
consider_bosh_secure = true
--internal_hashed for authentication seems default but we set it here globally to be sure.
--deactivate https listening on ports
https_ports = { };
authentication = "internal_hashed";
modules_enabled = {
        "bosh";
        "ping";
        "speakerstats";
        "conference_duration";
--      "tls";
        -- Generally required
                "roster"; -- Allow users to have a roster. Recommended ;)
                "saslauth"; -- Authentication for clients and servers. Recommended if you want to log in.
                --
                "tls"; -- Add support for secure TLS on c2s/s2s connections
                "dialback"; -- s2s dialback support
                "disco"; -- Service discovery

        -- Not essential, but recommended
                "private"; -- Private XML storage (for room bookmarks, etc.)
                "vcard"; -- Allow users to set vCards
                "limits"; -- Enable bandwidth limiting for XMPP connections
                -- Nice to have
                "version"; -- Replies to server version requests
                "uptime"; -- Report how long server has been running
                "time"; -- Let others know the time here on this server
                "ping"; -- Replies to XMPP pings with pongs
                "pep"; -- Enables users to publish their mood, activity, playing music and more
                "register"; -- Allow users to register on this server using a client and change passwords
                -- Admin interfaces
                "admin_adhoc"; -- Allows administration via an XMPP client that supports ad-hoc commands
                -- Other specific functionality
                "posix"; -- POSIX functionality, sends server to background, enables syslog, etc.
}
limits = {
  c2s = {
    rate = "10kb/s";
  };
  s2sin = {
    rate = "30kb/s";
  };
}

unlimited_jids = {
        "focus@auth.meet.jitsi",
        "jvb@auth.meet.jitsi"
}

muc_mapper_domain_base = "meet.jitsi";
muc_mapper_domain_prefix = "muc";
component_interface = { "*" }
--define admins for jicofo and videobridge jvb:
--
admins = {
        "focus@auth.meet.jitsi",
        "jvb@auth.meet.jitsi"
}
--httports and interfaces need to be defined for version 0.12
http_ports = { 5280 }
http_interfaces = { "*", "::" }
Include "/etc/prosody/global.cfg.lua";
Include "conf.d/*.cfg.lua"
