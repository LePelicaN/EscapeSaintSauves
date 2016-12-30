#!/bin/bash
#####################################################
#              Système d'alarme laser               #
#                                                   #
#             Développé par  Vulcainreo             #
#                 10 novembre 2013                  #
#             http://blog.vulcainreo.com            #
#####################################################

# Définition des pins

    # mode "entrée" pour la diode photovoltaique
    gpio mode 0 in
    gpio mode 7 out

# Programme

    # Armement du système
    gpio write 7 1
    echo "Système armé ..."
    echo "Détection en cours ..."
    sleep 2

    cp not_correct.inc ../webserv/
    cp image.inc index.png ../webserv/
    cp text.inc ../webserv/
    cp video.inc test.mp4 ../webserv/
    lastEtatDiode=0

    # Processus de détection
    while [ 1 ]
    do
            # Récupération de l'état de la diode
            etatDiode=$(gpio read 0)

            if [ $lastEtatDiode -ne $etatDiode ]
            then
                    if [ $etatDiode -eq 0 ]
                    then
                          cp not_correct.inc ../webserv/
                          cp image.inc index.png ../webserv/
                          cp text.inc ../webserv/
                          cp video.inc test.mp4 ../webserv/
                    else
                          cp invalid.inc ../webserv/not_correct.inc
                          cp invalid.inc ../webserv/image.inc
                          rm ../webserv/index.png
		          cp invalid.inc ../webserv/text.inc
		          cp invalid.inc ../webserv/video.inc
                          rm ../webserv/test.mp4
                    fi
                    lastEtatDiode=$etatDiode
            fi

            # Test d'intrusion
            if test $etatDiode -eq 1
            then

                    # Détection d'un alerte: liste des commandes a effectuer
                    echo "Intrusion !!!"

                    ########################
                    # Commande utilisateur #
                    ########################

                    # Désarmement du système
                    gpio write 7 0
                    # Réarmement du système d'alarme
                    sleep 5
                    gpio write 7 1
                    sleep 2
            fi
    done
