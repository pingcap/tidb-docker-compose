docker-compose stop

rm -rf logs/*
rm -rf cert/*.pem
rm -rf cert/*.csr
sudo rm -rf data/*

cd cert
cfssl gencert -initca ca-csr.json | cfssljson -bare ca -

echo '{"CN":"tidb-server","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=server -hostname="tidb,127.0.0.1" - | cfssljson -bare tidb-server 
echo '{"CN":"tikv-server","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=server -hostname="tikv0,tikv1,tikv2,127.0.0.1" - | cfssljson -bare tikv-server 
echo '{"CN":"pd-server","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=server -hostname="pd0,pd1,pd2,127.0.0.1" - | cfssljson -bare pd-server

echo '{"CN":"client","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=client -hostname="" - | cfssljson -bare client

cd ..

docker-compose up -d
