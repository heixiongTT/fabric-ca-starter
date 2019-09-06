function createOrderMSPTree() {
	cd /etc/hyperledger/fabric-ca-client
	mkdir -p crypto-config/ordererOrganizations/${CNNAME}/msp
	mkdir -p crypto-config/ordererOrganizations/${CNNAME}/ca
	mkdir -p crypto-config/ordererOrganizations/${CNNAME}/orderers
	mkdir -p crypto-config/peerOrganizations
}

function copyCaToOrderer() {
	
}