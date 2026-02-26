#!/bin/bash

while true; do
    echo "=== CONFIGURACIÓN DE CONTRASEÑA ==="

    # Solicitar contraseña
    read -sp "Ingresa la contraseña: " pass1
    echo

    # Solicitar confirmación
    read -sp "Confirma la contraseña: " pass2
    echo

    # Comparar contraseñas
    if [ "$pass1" = "$pass2" ]; then
        echo "✅ OK - Contraseña configurada correctamente"
        exit 0
    else
        echo "❌ ERROR - Las contraseñas no coinciden"
        echo "Inténtalo de nuevo"
        echo "------------------------"
    fi
done
