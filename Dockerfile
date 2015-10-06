FROM stackhub/base-runit:latest
MAINTAINER Boyd Hemphill <boyd@stackengine.com>

#
# Install and configure confd
#

# This is a temporary hack until we can get our PR accepted in the `confd`
# project
ADD \
    confd/confd \
    /usr/bin/confd

ADD \
    confd/confd.sh \
    /etc/sv/confd/run

RUN \
    mkdir -pv /etc/sv/confd && \
    chmod +x /etc/sv/confd/run && \
    chmod +x /usr/bin/confd && \
    mkdir -pv /etc/confd/conf.d && \
    mkdir -pv /etc/confd/templates && \
    ln -sv /etc/sv/confd /service

#
# Write out a config to demonstrate that it works
#

# The TOML file serves to let confd know where to find and place various 
# assests (e.g. the service key, the template used to write out the final
# config file, the restart command, etc)
ADD \
    hello-world/hello-world.toml.template \
    /etc/confd/conf.d/

ADD \
    hello-world/hello-world.conf.template_orig \
    /etc/confd/templates/

