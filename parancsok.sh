#!/bin/bash
wget -O /tmp/book --no-check-certificate --content-disposition https://raw.githubusercontent.com/1NSN-egyenesen/1NSN/main/book
wget -O /tmp/side --no-check-certificate --content-disposition https://raw.githubusercontent.com/1NSN-egyenesen/1NSN/main/side
wget -O /tmp/trixi --no-check-certificate --content-disposition https://raw.githubusercontent.com/1NSN-egyenesen/1NSN/main/trixi
wget -O /tmp/daeda --no-check-certificate --content-disposition https://raw.githubusercontent.com/1NSN-egyenesen/1NSN/main/daeda

chmod 777 /tmp/book
chmod 777 /tmp/side
chmod 777 /tmp/trixi
chmod 777 /tmp/daeda

echo ""
echo "****Script by .:1NSN:.******"
echo "*Scriptek letoltese kesz...*"
echo "****************************"
echo ""
