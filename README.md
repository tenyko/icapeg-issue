
# Test
git clone https://github.com/tenyko/icapeg-issue.git
cd icapeg-issue
docker compose up --build

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

