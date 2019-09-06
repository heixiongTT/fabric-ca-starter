#!/bin/bash

list="orderer tls diagnose"
org_list="diagnose"
CNNAME=test.ejubc.com
AFFILIATION=com.ejubc.test
peer_size=2

function addTls() {
  NAME=$1
  WAY=$2

  mkdir -p /etc/hyperledger/fabric-ca-server/tls/admin
  cd /etc/hyperledger/fabric-ca-server/tls/admin
  cp /etc/hyperledger/fabric-ca-server/peer-config.yaml `pwd`/fabric-ca-client-config.yaml

  echo "register tls for ${NAME}"

  fabric-ca-client register -H `pwd` --id.name ${NAME} --id.secret=password -u http://admin:adminpw@tls-ca:7054

  mkdir -p /etc/hyperledger/fabric-ca-server/${WAY}/${NAME}/tls
  cd /etc/hyperledger/fabric-ca-server/${WAY}/${NAME}/tls

  echo "enroll tls for ${NAME}"
  fabric-ca-client enroll -u http://${NAME}:password@tls-ca:7054 -H `pwd`
}


function createRootCAAdmin() {
	for org in $list; do
		mkdir -p /etc/hyperledger/fabric-ca-server/$org/admin
		cd /etc/hyperledger/fabric-ca-server/$org/admin
		cp /etc/hyperledger/fabric-ca-server/admin-config.yaml `pwd`/fabric-ca-client-config.yaml
		fabric-ca-client enroll -u http://admin:adminpw@$org-ca:7054 -H `pwd`

	done
}

function createAdminTls() {
	for org in $list; do
		echo '-------------------'
		addTls admin@$org.${CNNAME} $org 
	done
}

function createOrdererCert() {
	for orderer in 1 2 3 4 5; do
		registOrderer $orderer

		enrollOrderer $orderer

		addTls orderer$orderer.${CNNAME} 'orderer'
	done
}

function registOrderer() {
  ORG=$1
  cd /etc/hyperledger/fabric-ca-server/orderer/admin
  cp /etc/hyperledger/fabric-ca-server/orderer-ca-client-config.yaml `pwd`/fabric-ca-client-config.yaml

  echo "register orderer for orderer${ORG}"
  fabric-ca-client register -H `pwd` --id.name orderer${ORG}.${CNNAME} --id.secret=ordererPWD -u http://admin:adminpw@orderer-ca:7054
}

function enrollOrderer() {
  ORG=$1

  mkdir -p /etc/hyperledger/fabric-ca-server/orderer/orderer${ORG}.${CNNAME}
  cd /etc/hyperledger/fabric-ca-server/orderer/orderer${ORG}.${CNNAME}

  echo "enroll orderer for orderer${ORG}"
  fabric-ca-client enroll -u http://orderer${ORG}.${CNNAME}:ordererPWD@orderer-ca:7054 -H `pwd`
}

function createPeerCert() {
	for org in $org_list; do
		for (( i = 0; i < $peer_size; i++ )); do
			registPeer $org $i

			enrollPeer $org $i

			addTls peer$i.$org.${CNNAME} $org.${CNNAME}
		done
	done
}

function registPeer() {
  ORG=$1
  PEER=$2
  cd /etc/hyperledger/fabric-ca-server/${ORG}/admin
  cp /etc/hyperledger/fabric-ca-server/peer-config.yaml `pwd`/fabric-ca-client-config.yaml

  echo "register peer for peer${PEER}.${ORG}"
  fabric-ca-client register -H `pwd` --id.name peer${PEER}.${ORG}.${CNNAME} --id.secret=password -u http://admin:adminpw@${ORG}-ca:7054
}

function enrollPeer() {
  ORG=$1
  PEER=$2
  mkdir -p /etc/hyperledger/fabric-ca-server/${ORG}.${CNNAME}/peer${PEER}.${ORG}.${CNNAME}
  cd /etc/hyperledger/fabric-ca-server/${ORG}.${CNNAME}/peer${PEER}.${ORG}.${CNNAME}

  echo "enroll peer for peer${PEER}.${ORG}"
  fabric-ca-client enroll -u http://peer${PEER}.${ORG}.${CNNAME}:password@${ORG}-ca:7054 -H `pwd`
}


createRootCAAdmin

createOrdererCert

createPeerCert

createAdminTls