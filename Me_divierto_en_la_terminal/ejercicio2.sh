#!/bin/bash

# Script para automatizar git add, commit y push
# Uso: ./commit.sh <mensaje del commit>

# Verificar que se proporcionó un mensaje para el commit
if [ $# -eq 0 ]; then
    echo "Error: Debes proporcionar un mensaje para el commit"
    echo "Uso: $0 <mensaje del commit>"
    echo "Ejemplo: $0 'Actualización del README'"
    exit 1
fi

# El mensaje del commit es todo lo que se pasa como parámetros
mensaje="$*"

echo "📦 Iniciando proceso de git..."

#Mostrar el estado actual antes de continuar
echo "📊 Estado actual del repositorio:"
git status 

# Preguntar si desea continuar (opcional)
echo
read -p "¿Continuar con add, commit y push? (s/N): " confirmacion
if [[ ! "$confirmacion" =~ ^[Ss]$ ]]; then
    echo "❌ Operación cancelada"
    exit 0
fi

# Realizar git add (añade todos los cambios)
echo "📝 Añadiendo cambios... (git add .)"
git add .

# Verificar si git add tuvo éxito
if [ $? -ne 0 ]; then
    echo "❌ Error al ejecutar git add"
    exit 1
fi

# Realizar git commit
echo "💬 Realizando commit con mensaje: '$mensaje'"
git commit -m "$mensaje"

# Verificar si git commit tuvo éxito
if [ $? -ne 0 ]; then
    echo "❌ Error al ejecutar git commit"
    exit 1
fi

# Realizar git push
echo "⬆️  Subiendo cambios al repositorio remoto... (git push)"
git push

# Verificar si git push tuvo éxito
if [ $? -eq 0 ]; then
    echo "✅ ¡Proceso completado exitosamente!"
    
    # Opcional: Mostrar el último commit
    echo
    echo "📌 Último commit:"
    git log -1 --oneline
else
    echo "❌ Error al ejecutar git push"
    echo "Los cambios están commiteados localmente pero no se pudieron subir al remoto"
    exit 1
fi
