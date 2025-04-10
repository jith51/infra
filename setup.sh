#!/bin/bash

ENV=$1

COMPOSE_FLAGS=""

if [ "$ENV" = "prod" ]; then
    COMPOSE_FLAGS="-f docker-compose.yaml"
    echo "Mode production"
else
    echo "Mode développement"
fi

# Lancer les containers en arrière-plan
docker compose $COMPOSE_FLAGS up --build --wait

# Exécution des commandes Rails
echo "Création de la base de données..."
docker compose exec api rails db:create

echo "Migration de la base de données..."
docker compose exec api rails db:migrate

echo "Toutes les opérations sont terminées !"