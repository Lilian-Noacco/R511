# TP 1 : Conteneurisation - Docker - Récapitulatif

## Objectif
Le but de ce TP est de consolider vos connaissances sur la conteneurisation et les commandes Docker pour gérer les images et les conteneurs.

---

## I. Gestion des images

### 1. Téléchargement des images

#### a. Télécharger l’image du docker `hello-world` depuis le registry officiel
```bash
docker pull hello-world
```

#### b. Donner la commande pour afficher les images Docker disponibles sur votre système.
```bash
docker images
```

#### c. Tester la commande avec l’option `-q`, qu’est-ce que vous obtenez ?
```bash
docker images -q
```
**Réponse :**  
L'option `-q` affiche uniquement les identifiants (IDs) des images présentes sur le système, sans les informations supplémentaires comme le repository, le tag, la taille, etc.

#### d. C’est quoi le rôle du tag ?
**Réponse :**  
Le tag permet de spécifier une version particulière de l'image. Par défaut, le tag est `latest`. Il aide à identifier et gérer différentes versions d'une même image, facilitant ainsi le déploiement de versions spécifiques d'applications ou de services.

#### e. Quelle commande permet de supprimer une image donnée par son nom ou par son identifiant ?
```bash
docker rmi <image_name_or_id>
```
**Exemple :**
```bash
docker rmi hello-world
```

### 2. Gestion des conteneurs

#### a. Lancer un conteneur avec l’image `hello-world`. Quelle commande avez-vous utilisé ?
```bash
docker run hello-world
```
**Explication :**  
Cette commande télécharge (si nécessaire) et exécute l'image `hello-world`, affichant un message de confirmation indiquant que Docker fonctionne correctement.

#### b. Lancer un conteneur en mode interactif avec l’image `python` et le tag `slim`. Vous précisez le nom `python` pour le conteneur. C’est quoi l’invite de commande que vous obtenez ? Comment sortir ?
```bash
docker run -it --name python python:slim
```
**Réponse :**  
L'invite de commande obtenue est celle de l'interpréteur Python. Pour sortir, vous pouvez utiliser la commande `exit()` ou appuyer sur `Ctrl+D`.

#### c. Utiliser l’option `--env VAR=VALUE` pour passer une variable d’environnement.  
**Commande :**
```bash
docker pull alpine
docker run -it --env MESSAGE='Hello from Alpine' alpine /bin/sh
```
**Vérification :**
```bash
echo $MESSAGE
```
**Réponse :**  
La commande `echo $MESSAGE` affichera `Hello from Alpine`, confirmant que la variable d’environnement a été correctement passée et prise en compte par le conteneur.

#### d. Partager un répertoire entre votre hôte et le conteneur avec l’option `--volume`
```bash
docker run -it --volume /path/on/host:/path/in/container alpine /bin/sh
```
**Remarque :**  
Remplacez `/path/on/host` par le chemin absolu du répertoire sur votre machine hôte et `/path/in/container` par le chemin souhaité dans le conteneur.

#### e. Créer un fichier dans le répertoire de partage et vérifier sa persistance
**Dans le conteneur :**
```bash
touch /path/in/container/testfile.txt
exit
```
**Relancer le conteneur :**
```bash
docker run -it --volume /path/on/host:/path/in/container alpine /bin/sh
ls /path/in/container
```
**Réponse :**  
Oui, le fichier `testfile.txt` existe toujours dans le répertoire partagé car les volumes permettent la persistance des données entre les conteneurs et l'hôte.

#### f. Exposer un port avec l’option `-p` pour rendre l’application accessible
```bash
docker pull httpd
docker run -d -p 8080:80 --name my_httpd httpd
```
**Accès :**  
Accédez à [http://localhost:8080](http://localhost:8080) dans votre navigateur pour voir le message « It works ! ». Pour tester avec l’adresse IP du conteneur :
```bash
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' my_httpd
```
Puis ouvrez cette adresse IP suivie du port 80 dans votre navigateur.

#### g. Utiliser l’option pour éviter que l’invite de commande reste bloquée
**Réponse :**  
Utilisez l’option `-d` pour lancer le conteneur en mode détaché (background).
```bash
docker run -d -p 8080:80 --name my_httpd httpd
```

#### h. Modifier la page `index.html` dans le conteneur `httpd`
**Étapes :**
1. Accéder au conteneur :
    ```bash
    docker exec -it my_httpd /bin/bash
    ```
2. Installer un éditeur (ex. `nano`) :
    ```bash
    apt-get update && apt-get install -y nano
    ```
3. Modifier le fichier :
    ```bash
    nano /usr/local/apache2/htdocs/index.html
    ```
4. Ajouter votre nom, sauvegarder et quitter (`Ctrl+O`, `Enter`, puis `Ctrl+X`).

**Tester :**  
Rechargez la page web à [http://localhost:8080](http://localhost:8080) pour voir votre nom apparaître.

#### i. Lister les conteneurs en cours d’exécution et les conteneurs arrêtés
```bash
docker ps          # Liste les conteneurs en cours d'exécution
docker ps -a       # Liste tous les conteneurs, y compris ceux arrêtés
```

#### j. Arrêter puis supprimer le conteneur `httpd`
```bash
docker stop my_httpd
docker rm my_httpd
```

#### k. Supprimer tous les conteneurs inactifs
```bash
docker container prune
```
**Réponse :**  
Cette commande supprime tous les conteneurs qui ne sont pas en cours d'exécution. Confirmez l'opération en tapant `y` lorsque vous y êtes invité.

#### l. Supprimer tous les conteneurs affichés avec `docker ps -a`
```bash
docker rm $(docker ps -a -q)
```

### D’autres commandes à tester

- **`docker cp`** : permet de copier des fichiers vers ou depuis le conteneur
  ```bash
  # Copier depuis le conteneur vers l'hôte
  docker cp <conteneur>:<chemin_dans_conteneur> <chemin_sur_hôte>

  # Copier depuis l'hôte vers le conteneur
  docker cp <chemin_sur_hôte> <conteneur>:<chemin_dans_conteneur>
  ```

- **`docker rename`** : permet de renommer un conteneur à posteriori
  ```bash
  docker rename <ancien_nom> <nouveau_nom>
  ```

---

## II. Docker-compose

### 1. Première configuration

#### 1. Créer un fichier YAML avec le contenu suivant
```yaml
services:
  mywebserver:
    image: httpd
    ports:
      - 80:80
  mydb:
    image: mysql
    ports:
      - 3306:3306
    environment:
      MYSQL_ROOT_PASSWORD: Pass123!
```

#### 2. Quelle commande devez-vous utiliser pour faire exécuter le contenu du fichier YAML ?
```bash
docker-compose -f votre-fichier-yml up
```
**Remarque :**  
Remplacez `votre-fichier-yml` par le nom de votre fichier `docker-compose.yaml` si celui-ci porte un autre nom.

#### 3. Visualiser les composants démarrés
```bash
docker-compose -f votre-fichier-yml ps
```
**Remarque :**  
Le nom de fichier attendu par défaut par la commande `docker-compose` est soit `docker-compose.yml`, `docker-compose.yaml`, `compose.yml` ou `compose.yaml`. Si un autre nom est utilisé, il faut utiliser l’option `-f` pour préciser le nom du fichier.

#### 4. Quelle autre commande permet de voir les conteneurs actifs ?
```bash
docker ps
```

#### 5. Quelle commande vous permet de visualiser également les logs de tous les services ?
```bash
docker-compose -f votre-fichier-yml logs
```

#### 6. Connectez-vous sur le conteneur MySQL afin de consulter la base de données créée. Quelle commande allez-vous utiliser ?
```bash
docker exec -it <mysql_container_id> /bin/bash
mysql -u root -p
```
**Après connexion à MySQL :**
```sql
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.01 sec)
```

#### 7. Arrêter vos deux conteneurs avec la commande
```bash
docker-compose -f votre-fichier-yml down
```

### 2. Configuration de services interconnectés

#### 1. Modifier le fichier YAML pour mettre une dépendance entre le conteneur `httpd` et MySQL
```yaml
services:
  mywebserver:
    image: httpd
    ports:
      - 80:80
    depends_on:
      - mydb
  mydb:
    image: mysql
    ports:
      - 3306:3306
    environment:
      MYSQL_ROOT_PASSWORD: Pass123!
```

#### 2. Ajouter dans la stack l’application `adminer` pour visualiser le contenu de la base de données
```yaml
services:
  mywebserver:
    image: httpd
    ports:
      - 80:80
    depends_on:
      - mydb
  mydb:
    image: mysql
    ports:
      - 3306:3306
    environment:
      MYSQL_ROOT_PASSWORD: Pass123!
  adminer:
    image: adminer
    ports:
      - 8080:8080
    depends_on:
      - mydb
```
**Accès :**  
Accédez à [http://localhost:8080](http://localhost:8080) dans votre navigateur pour utiliser Adminer et visualiser le contenu de votre base de données MySQL.

---

## III. Réaliser et publier son image Docker

### 1. Créer un fichier Dockerfile

#### a. Créer un répertoire `afficher-date`, créer le Dockerfile, compiler l'image et l'exécuter
**Dockerfile :**
```Dockerfile
# Dockerfile
FROM alpine
ENTRYPOINT ["date"]
```
**Commandes :**
```bash
mkdir afficher-date
cd afficher-date
echo -e "FROM alpine\nENTRYPOINT [\"date\"]" > Dockerfile
docker build -t afficher-date .
docker images
docker run afficher-date
```

**Résultat :**  
L'image `afficher-date` est créée et exécutée, affichant la date et l'heure actuelles.

#### b. Modifier le Dockerfile pour ajouter `RUN apk update`, installer `vim`, créer le répertoire `rep1`, et commenter `ENTRYPOINT`
**Dockerfile modifié :**
```Dockerfile
# Dockerfile
FROM alpine
RUN apk update
RUN apk add vim
RUN mkdir -p /home/rep1
# ENTRYPOINT ["date"]
```
**Commandes :**
```bash
docker build -t afficher-date .
docker run -it afficher-date /bin/sh
ls /home
vim --version
```
**Vérification :**  
Le répertoire `rep1` est présent dans `/home` et `vim` est installé et fonctionnel.

### 2. Dockerfile – un peu plus loin

#### a. Créer une image nommée `newimage` à partir du fichier `mydockerfile` avec l’option `-f`
**Fichier `mydockerfile` :**
```Dockerfile
# mydockerfile
FROM ubuntu
RUN apt-get update
RUN apt-get install -y apache2 vim
RUN mkdir -p /home/backup
COPY myfile /home/backup/
CMD ["apachectl", "-D", "FOREGROUND"]
```
**Commandes :**
```bash
echo "Contenu de myfile" > myfile
docker build -t newimage -f mydockerfile .
```

#### b. Lancer un conteneur depuis l’image `newimage`
```bash
docker run -d --name my_new_container newimage
```

#### c. Connectez-vous au conteneur et vérifier la présence de `myfile`, puis modifier ce fichier
```bash
docker exec -it my_new_container /bin/bash
cat /home/backup/myfile
echo "Modification du fichier" >> /home/backup/myfile
exit
```

#### d. Arrêter le conteneur et vérifier les modifications sur la machine hôte
```bash
docker stop my_new_container
docker cp my_new_container:/home/backup/myfile ./myfile
cat myfile
```
**Réponse :**  
Si les modifications ne sont pas présentes sur la machine hôte, une solution consiste à monter un volume pour la persistance des données.
```bash
docker run -d --name my_new_container -v /path/on/host:/home/backup newimage
```

#### e. Relancer le conteneur et vérifier le contenu de `myfile`
```bash
docker start my_new_container
docker exec -it my_new_container /bin/bash
cat /home/backup/myfile
```

#### f. Accéder à l’URL `http://@IP_de-votre-conteneur` pour voir la page par défaut d’Apache
**Commandes :**
```bash
docker exec -it my_new_container /bin/bash
service apache2 start
exit
```
**Accès :**  
Ouvrez votre navigateur et accédez à `http://@IP_de-votre-conteneur`. Vous devriez voir la page par défaut d’Apache. Si ce n’est pas le cas, assurez-vous que le service Apache est bien démarré et que les ports sont correctement exposés.

### 3. Publier son image sur un registry privé

#### a. Créer un Dockerfile avec uniquement l’instruction `FROM alpine`
**Dockerfile :**
```Dockerfile
# Dockerfile
FROM alpine
```

#### b. Créer une image avec le nom utilisateur Docker Hub et un tag correspondant à votre prénom
```bash
docker build -t my_dockerhub_username/monprenom .
```
**Remarque :**  
Remplacez `my_dockerhub_username` par votre nom d'utilisateur Docker Hub et `monprenom` par votre prénom.

#### c. Ajouter un 2e tag à votre image avec la valeur `1.0`
```bash
docker tag my_dockerhub_username/monprenom my_dockerhub_username/monprenom:1.0
```

#### d. Pousser l’image avec ces 2 tags sur votre registre Docker Hub
```bash
docker push my_dockerhub_username/monprenom
docker push my_dockerhub_username/monprenom:1.0
```

#### e. Connectez-vous au registry pour vérifier qu’elles sont bien présentes
**Étapes :**
1. Connectez-vous à votre compte Docker Hub via le site web [https://hub.docker.com](https://hub.docker.com).
2. Naviguez jusqu'à votre dépôt personnel et vérifiez que les images avec les tags appropriés (`monprenom` et `monprenom:1.0`) sont bien présentes.

---

## IV. Script d’automatisation bash pour créer et exécuter un conteneur Docker

### Objectif
Créer un script Bash `run_flask.sh` pour automatiser la création et l'exécution d'un conteneur Docker d’une application web basée sur Flask.

### Étapes :

#### 1. Préparation des fichiers de l’application Flask
Assurez-vous d'avoir le dossier `Flask_app` avec la structure suivante :
```
Flask_app/
├── flask_app.py
├── static
│   └── style.css
└── templates
    └── index.html
```
**Contenu de `flask_app.py` :**
```python
from flask import Flask
from flask import request
from flask import render_template

sample = Flask(__name__)

@sample.route("/")
def main():
    return render_template("index.html")

if __name__ == "__main__":
    sample.run(host="0.0.0.0", port=8080)
```

#### 2. Créer le script Bash `run_flask.sh`

**Contenu du script `run_flask.sh` :**
```bash
#!/bin/bash

# 1. Créer une structure de répertoires avec tempdir comme dossier parent pour stocker les fichiers du site Web
mkdir -p tempdir/myapp/static
mkdir -p tempdir/myapp/templates

# 2. Copier les répertoires du site Web et le fichier flask_app.py dans les répertoires respectifs
cp Flask_app/flask_app.py tempdir/myapp/
cp Flask_app/static/style.css tempdir/myapp/static/
cp Flask_app/templates/index.html tempdir/myapp/templates/

# 3. Créer un Dockerfile en utilisant les commandes bash ‘echo’
cat <<EOF > tempdir/myapp/Dockerfile
FROM python:3.8-alpine
RUN apk update && apk add --no-cache build-base
RUN pip install Flask
WORKDIR /home/myapp
COPY . /home/myapp
EXPOSE 8080
CMD ["python", "flask_app.py"]
EOF

# 4. Basculer vers le répertoire tempdir/myapp et créer l’image avec le nom tp1_np (avec np étant vos initiales en minuscule)
cd tempdir/myapp
docker build -t tp1_np .

# 5. Démarrer le conteneur en mode détaché
docker run -d --name run_tp1_np -p 8080:8080 tp1_np

# 6. Vérifier que le conteneur est en cours d’exécution
docker ps -a
```

**Explications :**
- **Shebang (`#!/bin/bash`)** : Indique que le script doit être exécuté avec Bash.
- **Création des répertoires** : Crée la structure nécessaire pour l'application Flask.
- **Copie des fichiers** : Copie les fichiers de l'application Flask dans la structure de répertoires.
- **Création du Dockerfile** : Utilise `cat` avec une redirection pour créer un Dockerfile avec le contenu spécifié.
- **Build de l'image Docker** : Compile le Dockerfile pour créer une image nommée `tp1_np`.
- **Exécution du conteneur** : Lance un conteneur en mode détaché, exposant le port `8080`.
- **Vérification** : Liste tous les conteneurs pour s'assurer que le conteneur est en cours d'exécution.

#### 3. Rendre le script exécutable et l’exécuter
```bash
chmod +x run_flask.sh
./run_flask.sh
```

#### 4. Vérifications après exécution du script

- **Accéder au conteneur en cours d'exécution :**
```bash
docker exec -it run_tp1_np /bin/sh
```
**Réponse :**  
Vous verrez l'invite de commande `root@<containerID>`.

- **Accéder à votre application via un navigateur :**  
Ouvrez votre navigateur et accédez à [http://localhost:8080](http://localhost:8080). Vous devriez voir le message d’accueil défini dans `index.html`.

- **Arrêter puis supprimer votre conteneur :**
```bash
docker stop run_tp1_np
docker rm run_tp1_np
```

- **Personnaliser le fichier `index.html` et le fichier CSS :**  
Modifiez les fichiers dans le dossier `tempdir/myapp/templates/index.html` et `tempdir/myapp/static/style.css` selon vos besoins.

- **Regénérer un nouveau conteneur avec les modifications :**  
Relancez le script `run_flask.sh` pour reconstruire l'image et lancer le nouveau conteneur.
```bash
./run_flask.sh
```

### Exemple de modification de `index.html` et `style.css`

#### Modifier `index.html` :
```html
<!DOCTYPE html>
<html>
<head>
    <title>Bienvenue sur Flask App</title>
    <link rel="stylesheet" type="text/css" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <h1>Bienvenue sur mon application Flask!</h1>
    <p>Développé par [Votre Nom]</p>
</body>
</html>
```

#### Modifier `style.css` :
```css
body {
    background-color: #f0f0f0;
    font-family: Arial, sans-serif;
    text-align: center;
    padding-top: 50px;
}

h1 {
    color: #333333;
}

p {
    color: #666666;
}
```

**Après modifications :**  
Relancez le script `run_flask.sh` pour voir les changements reflétés dans votre application web.

---

## Conclusion

Ce TP vous a permis de vous familiariser avec les concepts de base de Docker, la gestion des images et des conteneurs, ainsi que l'utilisation de Docker Compose pour orchestrer des services interconnectés. Vous avez également appris à créer et publier vos propres images Docker sur un registry privé, ainsi qu'à automatiser le déploiement de conteneurs avec des scripts Bash.

N'hésitez pas à explorer davantage les fonctionnalités avancées de Docker et Docker Compose pour optimiser vos environnements de développement et de déploiement.

---