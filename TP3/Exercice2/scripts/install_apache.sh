#!/bin/bash

# Mettre à jour la liste des paquets
sudo apt-get update

# Installer Apache
sudo apt-get install -y apache2

# Activer et démarrer le service Apache
sudo systemctl enable apache2
sudo systemctl start apache2
