NUM_THREADS=$(nproc)

docker build --tag nevocoin:build-env-windows --build-arg THREADS=$NUM_THREADS --file Dockerfile.windows .
