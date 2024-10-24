Étape 6 : Répondre aux Questions

1. Quelle adresse IP avez-vous utilisée pour accéder à la page par défaut de Nginx ?
   • J’ai utilisé l'ip de mon server sur le port 8081 pour accéder à Nginx en utilisant monm VPN pour me connecter au meme reseau. Donc, l’adresse IP utilisée est 192.168.1.252.
2. Quelle commande vous permet de savoir l’adresse IP de la VM sans y accéder ?
   • vagrant ssh -c "hostname -I"
3. Quel dossier s’est rajouté dans le dossier de partage ?
   • Le dossier /var/www dans la VM est maintenant synchronisé avec le répertoire courant sur la machine hôte (./). Tout fichier ajouté dans le répertoire hôte sera automatiquement disponible dans la VM dans /var/www.
