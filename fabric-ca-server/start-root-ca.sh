#!/bin/bash

list="orderer tls diagnose"

	for org in $list; do
		echo "  $org-ca:
         image: hyperledger/fabric-ca
         container_name: $org-ca
         environment:
           - FABRIC_CA_SERVER_HOME=/etc/hyperledger/fabric-ca-server
           - FABRIC_CA_SERVER_TLS_ENABLED=false
           - FABRIC_CA_SERVER_DEBUG=false
         volumes:
           - './$org-ca:/etc/hyperledger/fabric-ca-server'
         command: sh -c 'fabric-ca-server start -b admin:adminpw'
         networks:
           - ca-network
           " >> docker-compose-rootca.yaml
	done
	docker-compose -f docker-compose-rootca.yaml up -d

cp admin-config.yaml ./ca-cli/
cp orderer-ca-client-config.yaml ./ca-cli/
cp peer-config.yaml ./ca-cli/
cp create-certs.sh ./ca-cli/
