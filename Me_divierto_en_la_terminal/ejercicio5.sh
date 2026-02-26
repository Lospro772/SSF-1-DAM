#!/bin/bash

while true; do
    clear
    echo "=================================="
    echo "           MENÚ DE SISTEMA"
    echo "=================================="
    echo "1. Espacio libre en disco (%)"
    echo "2. Espacio libre (tamaño)"
    echo "3. Usuario actual y nombre de la máquina"
    echo "4. Número de usuarios en la máquina"
    echo "5. Espacio usado en tu carpeta"
    echo "6. Salir"
    echo "=================================="
    echo -n "Elija una opción: "
    read opcion
    
    case $opcion in
        1)
            echo "----------------------------------"
            echo "Espacio libre en disco (%)"
            df -h | awk 'NR==1 || /^\/dev/ {print $1 " - Libre: " $5 " usado, " 100-$5 "% libre"}'
            ;;
        2)
            echo "----------------------------------"
            echo "Espacio libre (tamaño)"
            df -h
            ;;
        3)
            echo "----------------------------------"
            echo "Usuario actual:"
            whoami
            echo "Nombre de la máquina:"
            hostname
            ;;
        4)
            echo "----------------------------------"
            echo "Número de usuarios en la máquina:"
            cat /etc/passwd | wc -l
            ;;
        5)
            echo "----------------------------------"
            echo "Espacio usado en tu carpeta:"
            du -sh ~
            ;;
        6)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opción no válida"
            ;;
    esac
    
    echo ""
    echo "Presione Enter para continuar..."
    read pausa
done
