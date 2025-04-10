# Guide d'installation et d'utilisation

## Étapes d'installation

1. **Copier le fichier de configuration exemple**
   Copiez le fichier `.env.exemple` en `.env`:
   ```bash
   cp .env.exemple .env
   ```
2. **Modifier les variables**
   Ouvrez le fichier `.env` et remplacez les variables par les valeurs appropriées pour votre environnement.

3. **Exécution selon le mode (dev ou prod)**
   - En **mode développement**, exécutez le script `setup.sh`:
     ```bash
     sh setup.sh
     ```
   - En **mode production**, exécutez le script `setup.sh`:
     ```bash
     sh setup.sh prod
     ```

## Accès aux containers Docker

Pour entrer dans un container spécifique et exécuter des commandes, utilisez la commande suivante `docker compose exec -it <container> bash` en remplaçant `<container>` par l'un des containers suivants :

- **postgres**
- **redis**
- **api**
- **sidekiq**
- **front**

Exemple pour entrer dans le container `api` :

```bash
docker compose exec -it api bash
```

Exemple pour voir les logs (ajouter -f pour follow les logs):

```bash
docker compose logs
```
