#!/bin/sh
# confd does not yet allow for dynamically setting keys in the 
# TOML file. To get around this we will make the substitution here
# ahead of invoking the process.
# 

# Works around https://github.com/kelseyhightower/confd/issues/310
sed s#SE_SERVICE_DISCOVERY_KEY#$SE_SERVICE_DISCOVERY_KEY# \
    /etc/confd/conf.d/hello-world.toml.template \
    > /etc/confd/conf.d/hello-world.toml

sed s#SE_SERVICE_DISCOVERY_KEY#$SE_SERVICE_DISCOVERY_KEY# \
    /etc/confd/templates/hello-world.conf.template_orig \
    > /etc/confd/templates/hello-world.conf.template

# Okay now we can run confd 
exec /usr/bin/confd \
    -backend stackengine \
    -node $SE_LEADER_IP:$SE_LEADER_PORT \
    -scheme https \
    -auth-token $SE_API_TOKEN \
    -interval 5
