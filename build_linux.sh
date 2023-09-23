NUM_THREADS=$(nproc)
NEVOCOIN_GUI_PATH=$(pwd)

docker run --rm -it -v $NEVOCOIN_GUI_PATH:/nevocoin-gui -w /nevocoin-gui nevocoin:build-env-linux sh -c 'make release-static -j$NUM_THREADS'
