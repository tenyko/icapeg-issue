# run NGINX to serve the PDF files
/usr/sbin/nginx

# run Squid
/usr/sbin/squid -f /opt/icapeg/squid.conf

# run ICAPeg
./icapeg &

echo "Testing download of small file (sample.pdf) directly from NGINX"
SHA_SMALL_FILE=$(sha1sum /usr/share/nginx/html/sample.pdf | awk '{print $1}')
for i in {1..10}; do curl --silent -o - http://127.0.0.1:9080/sample.pdf | sha1sum | grep "$SHA_SMALL_FILE" && echo "WORKS OK"; done
echo
echo "Testing download of large file (ICAPeg-DS.pdf) directly from NGINX"
SHA_LARGE_FILE=$(sha1sum /usr/share/nginx/html/ICAPeg-DS.pdf | awk '{print $1}')
for i in {1..10}; do curl --silent -o - http://127.0.0.1:9080/ICAPeg-DS.pdf | sha1sum | grep "$SHA_LARGE_FILE" && echo "WORKS OK"; done
echo
echo "Setting http_proxy to redirect traffic via Squid to ICAPeg /echo service"
export http_proxy=127.0.0.1:3128
echo
echo "Testing download of small file (sample.pdf) from NGINX via Squid and ICAPeg /echo"
SHA_SMALL_FILE=$(sha1sum /usr/share/nginx/html/sample.pdf | awk '{print $1}')
for i in {1..10}; do curl --silent -o - http://127.0.0.1:9080/sample.pdf | sha1sum | grep "$SHA_SMALL_FILE" && echo "WORKS OK"; done
echo
echo "THE NEXT TEST GETS STUCK AND NEVER PRINTS 'WORKS OK'"
echo
echo "Testing download of large file (ICAPeg-DS.pdf) from NGINX via Squid and ICAPeg /echo"
SHA_LARGE_FILE=$(sha1sum /usr/share/nginx/html/ICAPeg-DS.pdf | awk '{print $1}')
for i in {1..10}; do curl --silent -o - http://127.0.0.1:9080/ICAPeg-DS.pdf | sha1sum | grep "$SHA_LARGE_FILE" && echo "WORKS OK"; done

# NOTES:
#
# to stop squid run:
#	pkill -f /usr/sbin/squid
#
# to view relevant logs run:
#	tail -F /var/log/squid/*.log /var/log/nginx/* /opt/icapeg/logs/logs.json &
