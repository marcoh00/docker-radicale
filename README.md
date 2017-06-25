# What is this?
This is a docker image for the popular [Radicale](http://radicale.org) DAV server. It includes the [radicale-auth-ldap](https://github.com/marcoh00/radicale-auth-ldap) module, so you can authenticate your users against an LDAP server.

# How to use it
You need to write a radicale configuration file (`config`) and mount it as `/data/config/config`. You should use the `/data/db` directory for storing your collections, as it is created just for this purpose and it is made sure that the sub-elements beneath it will have the proper access rights.

Example:

```
[server]

# CalDAV server hostnames separated by a comma
# IPv4 syntax: address:port
# IPv6 syntax: [address]:port
# For example: 0.0.0.0:9999, [::]:9999
hosts = 0.0.0.0:5232

# Daemon flag
daemon = False

[storage]

# Storage backend
# Value: multifilesystem
type = multifilesystem

# Folder for storing local collections, created if not present
filesystem_folder = /data/db


# In case you want to use another "rights" file, mounted to /data/config/rights (otherwise, skip this):
# ------------------------------
[rights]

# Rights backend
# Value: none | authenticated | owner_only | owner_write | from_file
type = from_file

# File for rights management from_file
file = /data/config/rights
# ------------------------------

# In case you want to use LDAP authentication (otherwise, skip this):
# ------------------------------
[auth]

type = radicale_auth_ldap

# LDAP server URL, with protocol and port
ldap_url = ldap://ldap:389

# LDAP base path
ldap_base = ou=Users,dc=TESTDOMAIN

# LDAP login attribute
ldap_attribute = uid

# LDAP filter string
# placed as X in a query of the form (&(...)X)
# example: (objectCategory=Person)(objectClass=User)(memberOf=cn=calenderusers,ou=users,dc=example,dc=org)
ldap_filter = (objectClass=person)

# LDAP dn for initial login, used if LDAP server does not allow anonymous searches
# Leave empty if searches are anonymous
ldap_binddn = cn=admin,dc=TESTDOMAIN

# LDAP password for initial login, used with ldap_binddn
ldap_password = verysecurepassword

# LDAP scope of the search
ldap_scope = LEVEL
# ------------------------------

# In case you want to be able to access the server from a web service running on another domain (otherwise, skip this):
# ------------------------------
[headers]

Access-Control-Allow-Origin = *
Access-Control-Allow-Methods = GET, POST, OPTIONS, PROPFIND, PROPPATCH, REPORT, PUT, MOVE, DELETE, LOCK, UNLOCK
Access-Control-Allow-Headers = User-Agent, Authorization, Content-type, Depth, DNT, If-match, If-None-Match, Lock-Token, Timeout, Destination, Overwrite, Prefer, X-client, X-Requested-With
Access-Control-Expose-Headers = Etag
# ------------------------------
```
