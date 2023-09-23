export NUM_THREADS=1
#$(nproc)
export NEVOCOIN_GUI_PATH=$(pwd)

docker run --rm -it -v $NEVOCOIN_GUI_PATH:/nevocoin-gui -w /nevocoin-gui nevocoin:build-env-windows sh -c 'make depends root=/depends target=x86_64-w64-mingw32 tag=win-x64 -j$NUM_THREADS'
