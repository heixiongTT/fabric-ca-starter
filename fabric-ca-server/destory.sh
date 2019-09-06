docker-compose -f docker-compose-rootca.yaml down

sleep 10

cp docker-compose-rootca.yaml.tmp docker-compose-rootca.yaml

rm -rf ca-cli
rm -rf orderer-ca
rm -rf root-ca
rm -rf diagnose-ca
rm -rf tls-ca