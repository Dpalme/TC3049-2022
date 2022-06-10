rm -fR doc
rdoc -m README.rdoc -o doc -f hanna src/front/*/*.rb  README.rdoc
cp -R img doc/files