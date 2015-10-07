# Overview

This container builds on `stackhub/base-runit` to include a demonstrable 
"hello world" for the use of `confd` and StackEngine Service Discovery.

# Usage

## Building from this Image

```Dockerfile
# Sample Dockerfile
FROM stackhub/base-confd
MAINTAINER awesome_communitymember <myaddress@example.com>

# Add a process to be supervised by runit
RUN \
    apk add haproxy

# Add template definition for `confd`. This is configuration for `confd`, not
# the service (haproxy) that is being watched.
# Assumes there is an haproxy directory in the root of your project with the
# `toml` file present
ADD \  
    haproxy/haproxy.toml.template \
    /etc/confd/conf.d/haproxy.toml.template

# Add the haproxy configuration template
# Assumes there is a `cfg` file in the `haproxy` directory in the root of your 
# project
ADD \  
    haproxy/haproxy.cfg.template \
    /etc/confd/templates/haproxy.cfg.template

# Drop the init script for haproxy in the /etc/sv/haproxy directory.  Runit
# will see it within 5 seconds and start the process.

RUN \  
    mkdir -pv /etc/sv/haproxy 

ADD \
    haproxy/initscript.sh \
    /etc/sv/haproxy/run

# This once the directory where the script lives is linked in /service, runit 
# will supervise it.
RUN \ 
    chmod +x /etc/sv/haproxy/run && \
    ln -sv /etc/sv/haproxy /service
```

For an example, see our
[`stackhub/service-haproxy`](https://github.com/stackhub/service-haproxy/blob/master/Dockerfile)
image that makes it easy to load balance multiple volatile backends.

## Developing Interactively with this Image

If you woudld like to build your own dynamic service leveraging the
StackEngine Container Application Center's (CAC) built in Service Discovery, or play
directly with the `confd` process, 

* Create a key "apps/hello-world/containers/howdy" and value "HELLO-WORLD" 
  in the CAC
* Create run the container from component setting the following environment 
  variables:

  * SE_SERVICE_DISCOVERY_KEY: hello-world
  * SE_LEADER_IP: 172.31.41.14 <- Needs to be your own mesh leader
  * SE_API_TOKEN: 232b0bec4411b8c5 <- Needs to be your own token

Here is a sample YAML:

```YAML
containers:
  base-confd:
    scheduler: random
    availability: per-pool
    instances:
      min: 1
      max: 1
      default: 1
    config:
      image: "stackhub/base-confd:latest"
      env:
        SE_SERVICE_DISCOVERY_KEY: hello-world
        SE_LEADER_IP: 172.31.41.14
        SE_API_TOKEN: 232b0bec4411b8c5
      ports: []
    host_config:
      restart_policy: {}
```

Shell in to the host where the container is running and see the config:

```
host %>docker exec -it berserk_thompson sh
container/ #> cat hello-world.conf 
# Configures the /dev/null highly scalable write-only database.

database:
  cluster:
    targets: 
        [ 
        gratuitous text = <no value>
        
        'HELLO-WORLD',
        ]
/ # 
```

# Compatibility 

* [x] StackEngine Ecosystem
* [] General Docker Ecosystem

This images directly leverages the StackEngine CAC's Service Discovery 
as a backend to `confd`.

# License

MIT