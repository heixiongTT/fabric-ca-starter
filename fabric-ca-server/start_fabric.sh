CHANNEL_NAME='qiushi_channel'

COMPOSE_FILE=docker-compose-cli.yaml

COMPOSE_FILE_COUCH=docker-compose-couch.yaml

COMPOSE_FILE_KAFKA=docker-compose-kafka.yaml

COMPOSE_FILE_RAFT2=docker-compose-etcdraft2.yaml

# default image tag
IMAGETAG="1.4.1"

function networkUp() {
  
  COMPOSE_FILES="-f ${COMPOSE_FILE}"
  COMPOSE_FILES="${COMPOSE_FILES} -f ${COMPOSE_FILE_RAFT2}"
  COMPOSE_FILES="${COMPOSE_FILES} -f ${COMPOSE_FILE_COUCH}"
  
  IMAGE_TAG=$IMAGETAG docker-compose ${COMPOSE_FILES} up -d 2>&1
  docker ps -a
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Unable to start network"
    exit 1
  fi

  if [ "$CONSENSUS_TYPE" == "etcdraft" ]; then
    sleep 1
    echo "Sleeping 15s to allow $CONSENSUS_TYPE cluster to complete booting"
    sleep 14
  fi

  IMAGE_TAG=$IMAGETAG docker-compose ${COMPOSE_FILES} up -d 2>&1

  # now run the end to end script
  docker exec cli scripts/script.sh $CHANNEL_NAME $CLI_DELAY $LANGUAGE $CLI_TIMEOUT $VERBOSE $NO_CHAINCODE
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Test failed"
    exit 1
  fi
}

function generateChannelArtifacts() {
  which configtxgen
  if [ "$?" -ne 0 ]; then
    echo "configtxgen tool not found. exiting"
    exit 1
  fi


  configtxgen -profile SampleMultiNodeEtcdRaft -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block

  echo
  echo "#################################################################"
  echo "### Generating channel configuration transaction 'channel.tx' ###"
  echo "#################################################################"
  set -x
  configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate channel configuration transaction..."
    exit 1
  fi

  echo
  echo "#################################################################"
  echo "#######    Generating anchor peer update for Org1MSP   ##########"
  echo "#################################################################"
  set -x
  configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/DiagnoseMSPanchors.tx -channelID $CHANNEL_NAME -asOrg DiagnoseMSP
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate anchor peer update for DiagnoseMSP..."
    exit 1
  fi

}
generateChannelArtifacts

networkUp