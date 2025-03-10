# Intro

ICAP request handler hangs (gets stuck) as if waiting on remote end.

The issue manifests under specific circumstances only:

- the ICAPeg server does not crash, and no error is logged; a request simply gets stuck
- non-deterministic - sometimes there is no issue; it occurs more often the faster the connection between the components is
- only reproduced with Squid as the ICAP client

# Test
    git clone https://github.com/tenyko/icapeg-issue.git
    cd icapeg-issue
    docker compose build --no-cache --progress=plain
    docker compose up --build

Note: If using `podman` instead of `docker`, remove the `--progress=plain` parameter.

To repeat the test, run:

    docker compose run icapeg-test

# The issue demo walk-through

- starts NGINX, Squid, and ICAPeg in a Docker container
- curl downloads small file directly from NGINX - OK
- curl downloads large file directly from NGINX - OK
- curl downloads small file via Squid and ICAP /echo - OK
- curl downloads large file via Squid and ICAP /echo - FAIL: connection hangs; i.e. gets stuck

# Expected Output
    icapeg-test-1  | Testing download of small file (sample.pdf) directly from NGINX
    icapeg-test-1  | bfd009f500c057195ffde66fae64f92fa5f59b72  -
    icapeg-test-1  | WORKS OK
    icapeg-test-1  | 
    icapeg-test-1  | Testing download of large file (ICAPeg-DS.pdf) directly from NGINX
    icapeg-test-1  | 3ec1067264b53f5744202ba967147978e4034da0  -
    icapeg-test-1  | WORKS OK
    icapeg-test-1  | 
    icapeg-test-1  | Setting http_proxy to redirect traffic via Squid to ICAPeg /echo service
    icapeg-test-1  | 
    icapeg-test-1  | Testing download of small file (sample.pdf) from NGINX via Squid and ICAPeg /echo
    icapeg-test-1  | bfd009f500c057195ffde66fae64f92fa5f59b72  -
    icapeg-test-1  | WORKS OK
    icapeg-test-1  | 
    icapeg-test-1  | THE NEXT TEST GETS STUCK AND NEVER PRINTS 'WORKS OK'
    icapeg-test-1  | 
    icapeg-test-1  | Testing download of large file (ICAPeg-DS.pdf) from NGINX via Squid and ICAPeg /echo
    icapeg-test-1  | WORKS OK

# Actual Output
    icapeg-test-1  | Testing download of small file (sample.pdf) directly from NGINX
    icapeg-test-1  | bfd009f500c057195ffde66fae64f92fa5f59b72  -
    icapeg-test-1  | WORKS OK
    icapeg-test-1  | 
    icapeg-test-1  | Testing download of large file (ICAPeg-DS.pdf) directly from NGINX
    icapeg-test-1  | 3ec1067264b53f5744202ba967147978e4034da0  -
    icapeg-test-1  | WORKS OK
    icapeg-test-1  | 
    icapeg-test-1  | Setting http_proxy to redirect traffic via Squid to ICAPeg /echo service
    icapeg-test-1  | 
    icapeg-test-1  | Testing download of small file (sample.pdf) from NGINX via Squid and ICAPeg /echo
    icapeg-test-1  | bfd009f500c057195ffde66fae64f92fa5f59b72  -
    icapeg-test-1  | WORKS OK
    icapeg-test-1  | 
    icapeg-test-1  | THE NEXT TEST GETS STUCK AND NEVER PRINTS 'WORKS OK'
    icapeg-test-1  | 
    icapeg-test-1  | Testing download of large file (ICAPeg-DS.pdf) from NGINX via Squid and ICAPeg /echo

Note: the last test did not output "WORKS OK" - it gets stuck. There is no explicit error.
Squid is waiting on ICAPeg, and ICAPeg is waiting on Squid.
Higher network speed between the components makes the issue more frequent.
This Dockerized environment, where everything is on the same host, almost always reproduces the issue.

# Versions
- Rocky Linux 8.9 (docker image rockylinux:8.9)
- Squid 4.15 OpenSSL 1.1.1k  FIPS 25 Mar 2021.
- nginx 1.14.1
- curl 7.61.1
- Egirna ICAPeg master v1.0.0 (8eb8bb09)
- Docker Engine Community 27.3.1

# What's What
- `config.toml` - ICAPeg config
- `squid.conf` - Squid configured /w ICAP RESPMOD /echo service
- `static.conf` - NGINX file server config - serves sample.pdf and ICAPeg-DS.pdf over HTTP
- `test.bash` - issue demo bash script
- `Dockerfile` - dockerized test environment
- `compose.yaml` - docker compose helper
- `README.md` - this file
