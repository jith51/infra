git pull
docker compose -f docker-compose.yaml build --no-cache front
docker compose -f docker-compose.yaml up -d --force-recreate --no-deps front