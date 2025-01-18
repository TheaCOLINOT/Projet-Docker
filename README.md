# Projet-Docker

1. Objectifs et contexte

Le projet consiste à mettre en place un environnement Docker complet capable de :

Héberger deux instances Laravel (via deux services Nginx et deux services PHP distincts) tout en partageant une base de données MySQL commune.

Automatiser les commandes de démarrage nécessaires à Laravel.
Personnaliser les sites pour afficher "Serveur 1" et "Serveur 2" tout en conservant les fonctionnalités d'inscription et de connexion.

2. Étapes de réalisation

Étape 1 : Création des Dockerfiles pour PHP
Base utilisée : php:8.1-fpm.
Ajout des dépendances nécessaires : Composer, Node.js, et extensions PHP.
Exécution des commandes via le docker-compose.yml et les dockerfiles :
composer install
npm run build
php artisan key:generate
php artisan migrate:fresh --seed

Étape 2 : Configuration de Nginx
Création de deux fichiers de configuration Nginx (nginx1.conf et nginx2.conf) pour rediriger les requêtes HTTP vers les services PHP correspondants.
Exposition des ports pour accéder aux deux serveurs via le navigateur (localhost:8081 pour le serveur 1 et localhost:8082 pour le serveur 2).

Étape 3 : Mise en place de la base de données MySQL
Configuration dans docker-compose.yml pour un service MySQL avec un volume persistant (mysql_data).
Connexion Laravel à MySQL via le fichier .env.
Création de la base et initialisation des tables avec les migrations Laravel.

Étape 4 : Personnalisation des sites
Modification du fichier welcome.blade.php pour afficher "Serveur 1" et "Serveur 2".
Vérification des fonctionnalités d'inscription et de connexion sur les deux serveurs.

Étape 5 : Création du fichier docker-compose.yml
Définition des services :
2 services PHP construits à partir des Dockerfiles personnalisés.
2 services Nginx reliés aux services PHP.
1 service MySQL avec un volume persistant.

Étape 6 : Tests et validation
Vérification de l'accès aux deux serveurs via le navigateur.
Inscription de deux utilisateurs et vérification dans la base de données.
Tests des fonctionnalités automatisées au démarrage (installation des dépendances, migrations, etc.).

Étape 7 : Ajouts personnels
Mariam:

1. Configuration Complète de Nginx pour site1 et site2
   L'implémentation de Nginx a été réalisée pour les deux instances Laravel (site1 et site2). Cette configuration assure une redirection efficace des requêtes HTTP vers les services PHP correspondants, permettant ainsi à chaque site de fonctionner de manière indépendante tout en partageant une base de données commune. Chaque site dispose de son propre fichier de configuration Nginx, garantissant une gestion optimisée des ressources et une séparation claire des environnements.

2. Ajout du Fichier init.sql et Configuration de la Base de Données
   Un fichier init.sql a été ajouté dans le dossier mysql pour automatiser l'initialisation de la base de données MySQL. Ce script SQL crée la base de données example_app ainsi que la table users, essentielle pour les fonctionnalités d'inscription et de connexion des utilisateurs. De plus, le fichier docker-compose.yml a été mis à jour pour inclure ce script lors du démarrage du conteneur MySQL, garantissant que la base de données est correctement initialisée dès le déploiement de l'environnement Docker.

3. Intégration de Traefik avec Certificat Auto-Signé
   Pour gérer le routage dynamique et sécuriser les communications via HTTPS, Traefik a été intégré en tant que reverse proxy dans le projet. Cette intégration permet une gestion simplifiée des routes et facilite l'extension future de l'infrastructure. Afin d'assurer des connexions sécurisées en environnement de développement, un certificat SSL auto-signé a été généré et configuré.

Génération du Certificat Auto-Signé
La commande suivante a été utilisée pour créer le certificat SSL auto-signé, valable pour les domaines locaux site1.local et site2.local :

bash
Copier
openssl req -x509 -newkey rsa:2048 -days 365 -nodes \
 -keyout certs/selfsigned.key \
 -out certs/selfsigned.crt \
 -subj "/CN=site1.local" \
 -addext "subjectAltName=DNS:site1.local,DNS:site2.local"
Cette commande génère les fichiers selfsigned.key et selfsigned.crt dans le dossier certs, permettant à Traefik d'établir des connexions HTTPS sécurisées pour les deux sites locaux.

4. Mise à Jour des Fichiers .env
   Les fichiers .env des deux sites Laravel ont été modifiés pour configurer la connexion à la base de données MySQL partagée. Ces modifications incluent la définition des variables d'environnement nécessaires pour que Laravel puisse se connecter correctement au service MySQL défini dans le docker-compose.yml.

5. Configuration Dynamique de Traefik (traefik_dynamic.yml)
   Un fichier traefik_dynamic.yml a été créé pour spécifier les certificats SSL utilisés par Traefik. Ce fichier permet à Traefik de reconnaître et d'appliquer le certificat auto-signé lors de l'établissement des connexions HTTPS, assurant ainsi que les communications entre les utilisateurs et les services sont sécurisées.

6. Modifications du docker-compose.yml
   Le fichier docker-compose.yml a été étendu pour inclure les services suivants :

Traefik : Configuré en tant que reverse proxy pour gérer le routage dynamique et les connexions HTTPS sécurisées.
Nginx : Deux services Nginx configurés pour site1 et site2, chacun redirigeant les requêtes vers les services PHP correspondants.
PHP : Deux services PHP distincts pour chaque site Laravel.
MySQL : Service MySQL avec un volume persistant et initialisé via le fichier init.sql.
Des labels Traefik ont été ajoutés aux services Nginx pour définir les règles de routage et activer le SSL, facilitant ainsi la gestion centralisée des routes et des certificats.

Thea:
Ajout d'un service pour les mails Mailship

Attribution des tâches :

Théa : Configuration des Dockerfiles pour PHP, Mise en place et tests de la base de données MySQL, connexion via Laravel.

Mariam :
Configurer les fichiers .env1/2 et nginx1/2 pour servir les deux sites Laravel.
S'assurer que les serveurs Nginx pointent vers les bons services PHP (avec fastcgi_pass).
Tester l'accès aux deux serveurs via les navigateurs (http://localhost:8081/ et http://localhost:8082/).
Personnaliser la vue welcome.blade.php pour afficher "Serveur 1" et "Serveur 2".

Danny : Rédaction et mise en place du fichier docker-compose.yml, Debugging.

Installation

Clonez ce dépôt :
git clone https://github.com/TheaCOLINOT/Projet-Docker.git

modifier votre hosts : IP : site1.local IP : site2.local
cd Projet-Docker

Lancez le projet avec Docker Compose :

docker-compose up --build

Accès aux services

Serveur 1 : https://site1.local
Serveur 2 : https://site2.local
