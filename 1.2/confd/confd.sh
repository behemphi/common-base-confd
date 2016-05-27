#!/bin/sh
# confd does not yet allow for dynamically setting keys in the 
# TOML file. To get around this we will make the substitution here
# ahead of invoking the process.
# 

# Works around https://github.com/kelseyhightower/confd/issues/310
sed s#STACKENGINE_SERVICE_DISCOVERY_KEY#$STACKENGINE_SERVICE_DISCOVERY_KEY# \
    /etc/confd/conf.d/hello-world.toml.template \
    > /etc/confd/conf.d/hello-world.toml

sed s#STACKENGINE_SERVICE_DISCOVERY_KEY#$STACKENGINE_SERVICE_DISCOVERY_KEY# \
    /etc/confd/templates/hello-world.conf.template_orig \
    > /etc/confd/templates/hello-world.conf.template

# Okay now we can run confd 
exec /usr/bin/confd \
    -backend stackengine \
    -node $STACKENGINE_LEADER_IP:$STACKENGINE_LEADER_PORT \
    -scheme https \
    -auth-token $STACKENGINE_API_TOKEN \
    -interval 5
