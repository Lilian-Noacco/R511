#!/bin/bash

# Mettre à jour la liste des paquets
sudo apt-get update

# Installer MySQL
sudo apt-get install -y mysql-server

# Sécuriser l'installation de MySQL (optionnel, peut nécessiter une interaction)
# Pour automatiser, vous pouvez utiliser debconf-set-selections, mais cela nécessite plus de configurations.

# Activer et démarrer le service MySQL
sudo systemctl enable mysql
sudo systemctl start mysql