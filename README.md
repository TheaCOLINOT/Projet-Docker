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

Ajout de Traefik pour gérer le routage dynamique.
Ajout d'un service pour les mails Mailship

Attribution des tâches :

Théa : Configuration des Dockerfiles pour PHP, Mise en place et tests de la base de données MySQL, connexion via Laravel.
Mariam : Configuration de Nginx et personnalisation des fichiers de configuration.
Danny :  Rédaction et mise en place du fichier docker-compose.yml, Debugging.