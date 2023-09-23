NUM_THREADS=$(nproc)

docker build --tag monero:build-env-linux --build-arg THREADS=$NUM_THREADS --file Dockerfile.linux .