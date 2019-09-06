ca_path=`pwd`/fabric-ca-server/ca-cli/
tls_ca_path=`pwd`/fabric-ca-server/tls-ca/
orderer_ca_path=`pwd`/fabric-ca-server/orderer-ca/
diagnose_ca_path=`pwd`/fabric-ca-server/diagnose-ca/

cd fabric-network

mkdir -p crypto-config/ordererOrganizations/test.ejubc.com/ca
mkdir -p crypto-config/ordererOrganizations/test.ejubc.com/msp/cacerts
mkdir -p crypto-config/ordererOrganizations/test.ejubc.com/msp/admincerts
mkdir -p crypto-config/ordererOrganizations/test.ejubc.com/msp/tlscacerts
mkdir -p crypto-config/ordererOrganizations/test.ejubc.com/orderers
mkdir -p crypto-config/ordererOrganizations/test.ejubc.com/tlsca
mkdir -p crypto-config/ordererOrganizations/test.ejubc.com/users

mkdir -p crypto-config/peerOrganizations/diagnose.test.ejubc.com/ca
mkdir -p crypto-config/peerOrganizations/diagnose.test.ejubc.com/msp/cacerts
mkdir -p crypto-config/peerOrganizations/diagnose.test.ejubc.com/msp/admincerts
mkdir -p crypto-config/peerOrganizations/diagnose.test.ejubc.com/msp/tlscacerts
mkdir -p crypto-config/peerOrganizations/diagnose.test.ejubc.com/peers
mkdir -p crypto-config/peerOrganizations/diagnose.test.ejubc.com/tlsca
mkdir -p crypto-config/peerOrganizations/diagnose.test.ejubc.com/users/admin@diagnose.test.ejubc.com//msp/cacerts
mkdir -p crypto-config/peerOrganizations/diagnose.test.ejubc.com/users/admin@diagnose.test.ejubc.com//msp/keystore
mkdir -p crypto-config/peerOrganizations/diagnose.test.ejubc.com/users/admin@diagnose.test.ejubc.com//msp/signcerts
mkdir -p crypto-config/peerOrganizations/diagnose.test.ejubc.com/users/admin@diagnose.test.ejubc.com//msp/admincerts
mkdir -p crypto-config/peerOrganizations/diagnose.test.ejubc.com/users/admin@diagnose.test.ejubc.com//msp/tlscacerts
mkdir -p crypto-config/peerOrganizations/diagnose.test.ejubc.com/users/admin@diagnose.test.ejubc.com//tls

cp ${orderer_ca_path}ca-cert.pem crypto-config/ordererOrganizations/test.ejubc.com/msp/cacerts/ca.test.ejubc.com-cert.pem
cp ${ca_path}orderer/admin/msp/signcerts/cert.pem crypto-config/ordererOrganizations/test.ejubc.com/msp/admincerts/Admin@test.ejubc.com-cert.pem
cp ${tls_ca_path}ca-cert.pem crypto-config/ordererOrganizations/test.ejubc.com/msp/tlscacerts/tlsca.test.ejubc.com-cert.pem

cp ${diagnose_ca_path}ca-cert.pem crypto-config/peerOrganizations/diagnose.test.ejubc.com/msp/cacerts/ca.diagnose.test.ejubc.com-cert.pem
cp ${ca_path}diagnose/admin/msp/signcerts/cert.pem crypto-config/peerOrganizations/diagnose.test.ejubc.com/msp/admincerts/Admin@diagnose.test.ejubc.com-cert.pem
cp ${tls_ca_path}ca-cert.pem crypto-config/peerOrganizations/diagnose.test.ejubc.com/msp/tlscacerts/tlsca.diagnose.test.ejubc.com-cert.pem

cp ${diagnose_ca_path}ca-cert.pem crypto-config/peerOrganizations/diagnose.test.ejubc.com/users/admin@diagnose.test.ejubc.com/msp/cacerts/ca.diagnose.test.ejubc.com-cert.pem
cp ${ca_path}diagnose/admin/msp/keystore/*_sk crypto-config/peerOrganizations/diagnose.test.ejubc.com/users/admin@diagnose.test.ejubc.com/msp/keystore
cp ${ca_path}diagnose/admin/msp/signcerts/cert.pem crypto-config/peerOrganizations/diagnose.test.ejubc.com/users/admin@diagnose.test.ejubc.com/msp/signcerts/Admin@diagnose.test.ejubc.com-cert.pem
cp ${ca_path}diagnose/admin/msp/signcerts/cert.pem crypto-config/peerOrganizations/diagnose.test.ejubc.com/users/admin@diagnose.test.ejubc.com/msp/admincerts/Admin@diagnose.test.ejubc.com-cert.pem
cp ${tls_ca_path}ca-cert.pem crypto-config/peerOrganizations/diagnose.test.ejubc.com/users/admin@diagnose.test.ejubc.com/msp/tlscacerts/tlsca.diagnose.test.ejubc.com-cert.pem

echo '-----------------'

cp ${ca_path}diagnose/admin\@diagnose.test.ejubc.com/tls/msp/cacerts/tls-ca-7054.pem crypto-config/peerOrganizations/diagnose.test.ejubc.com/users/admin@diagnose.test.ejubc.com/tls/ca.crt
cp ${ca_path}diagnose/admin\@diagnose.test.ejubc.com/tls/msp/signcerts/cert.pem crypto-config/peerOrganizations/diagnose.test.ejubc.com/users/admin@diagnose.test.ejubc.com/tls/server.crt
cp ${ca_path}diagnose/admin\@diagnose.test.ejubc.com/tls/msp/keystore/*_sk crypto-config/peerOrganizations/diagnose.test.ejubc.com/users/admin@diagnose.test.ejubc.com/tls/server.key

function cpOrdererCA() {
	C_PATH=$1
    cp ${orderer_ca_path}ca-cert.pem ${C_PATH}
}

function cpOrdererAdminCert() {
	C_PATH=$1
    cp ${ca_path}orderer/admin/msp/signcerts/cert.pem ${C_PATH}
}

function cpTLSCACert() {
	C_PATH=$1
    cp ${tls_ca_path}ca-cert.pem ${C_PATH}
}

function cpOrdererPK() {
	ID=$1
	C_PATH=$2
    cp ${ca_path}orderer/orderer${ID}.test.ejubc.com/msp/keystore/*_sk ${C_PATH}
}

function cpOrdererSignCert() {
	ID=$1
	C_PATH=$2
    cp ${ca_path}orderer/orderer${ID}.test.ejubc.com/msp/signcerts/cert.pem ${C_PATH}
}

function cpOrdererTls() {
	ID=$1
	C_PATH=$2
    cp ${ca_path}orderer/orderer${ID}.test.ejubc.com/tls/msp/cacerts/tls-ca-7054.pem ${C_PATH}/ca.crt
    cp ${ca_path}orderer/orderer${ID}.test.ejubc.com/tls/msp/signcerts/cert.pem ${C_PATH}/server.crt
    cp ${ca_path}orderer/orderer${ID}.test.ejubc.com/tls/msp/keystore/*_sk ${C_PATH}/server.key
}

function cpOrgCA() {
	C_PATH=$1
    cp ${diagnose_ca_path}ca-cert.pem ${C_PATH}
}

function cpOrgAdminCert() {
	C_PATH=$1
    cp ${ca_path}diagnose/admin/msp/signcerts/cert.pem ${C_PATH}
}


function cpPeerPK() {
	ID=$1
	C_PATH=$2
    cp ${ca_path}diagnose.test.ejubc.com/peer${ID}.diagnose.test.ejubc.com/msp/keystore/*_sk ${C_PATH}
}

function cpPeerSignCert() {
	ID=$1
	C_PATH=$2
    cp ${ca_path}diagnose.test.ejubc.com/peer${ID}.diagnose.test.ejubc.com/msp/signcerts/cert.pem ${C_PATH}
}

function cpPeerTls() {
	ID=$1
	C_PATH=$2
    cp ${ca_path}diagnose.test.ejubc.com/peer${ID}.diagnose.test.ejubc.com/tls/msp/cacerts/tls-ca-7054.pem ${C_PATH}/ca.crt
    cp ${ca_path}diagnose.test.ejubc.com/peer${ID}.diagnose.test.ejubc.com/tls/msp/signcerts/cert.pem ${C_PATH}/server.crt
    cp ${ca_path}diagnose.test.ejubc.com/peer${ID}.diagnose.test.ejubc.com/tls/msp/keystore/*_sk ${C_PATH}/server.key
}


cd crypto-config/ordererOrganizations/test.ejubc.com/orderers

for i in 1 2 3 4 5; do
	mkdir -p orderer$i.test.ejubc.com/msp/admincerts
	cpOrdererAdminCert orderer$i.test.ejubc.com/msp/admincerts
	mkdir -p orderer$i.test.ejubc.com/msp/cacerts
	cpOrdererCA orderer$i.test.ejubc.com/msp/cacerts
	mkdir -p orderer$i.test.ejubc.com/msp/keystore
	cpOrdererPK $i orderer$i.test.ejubc.com/msp/keystore
	mkdir -p orderer$i.test.ejubc.com/msp/signcerts
	cpOrdererSignCert $i orderer$i.test.ejubc.com/msp/signcerts
	mkdir -p orderer$i.test.ejubc.com/msp/tlscacerts
	cpTLSCACert orderer$i.test.ejubc.com/msp/tlscacerts
	mkdir -p orderer$i.test.ejubc.com/tls
	cpOrdererTls $i orderer$i.test.ejubc.com/tls
done

cd ../../../../crypto-config/peerOrganizations/diagnose.test.ejubc.com/peers

for i in 0 1; do
	mkdir -p peer$i.diagnose.test.ejubc.com/msp/admincerts
	cpOrgAdminCert peer$i.diagnose.test.ejubc.com/msp/admincerts
	mkdir -p peer$i.diagnose.test.ejubc.com/msp/cacerts
	cpOrgCA peer$i.diagnose.test.ejubc.com/msp/cacerts
	mkdir -p peer$i.diagnose.test.ejubc.com/msp/keystore
	cpPeerPK $i peer$i.diagnose.test.ejubc.com/msp/keystore
	mkdir -p peer$i.diagnose.test.ejubc.com/msp/signcerts
    cpPeerSignCert $i peer$i.diagnose.test.ejubc.com/msp/signcerts
	mkdir -p peer$i.diagnose.test.ejubc.com/msp/tlscacerts
    cpTLSCACert peer$i.diagnose.test.ejubc.com/msp/tlscacerts
	mkdir -p peer$i.diagnose.test.ejubc.com/tls
    cpPeerTls $i peer$i.diagnose.test.ejubc.com/tls
done

