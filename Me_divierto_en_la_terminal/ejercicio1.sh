#!/bin/bash

# Script para calcular segundos totales a partir de días, horas y segundos
# Uso: ./segundos.sh <dias> <horas> <segundos>

# Verifica los parametros de entrada 
if [ $# -ne 3 ]; then
    echo "Error: Se requieren exactamente 3 parámetros"
    echo "Uso: $0 <dias> <horas> <segundos>"
    echo "Ejemplo: $0 4 2 200"
    exit 1
fi

# Asignar parámetros para poder imprimirlos por eso usamos el dolar
dias=$1
horas=$2
segundos=$3

for param in "$dias" "$horas" "$segundos"; do
    if ! [[ "$param" =~ ^[0-9]+$ ]]; then
        echo "Error: Todos los parámetros deben ser números enteros no negativos"
        exit 1
    fi
done

# Calcular segundos totales
segundos_totales=$((dias * 24 * 3600 + horas * 3600 + segundos))

# Mostrar el resultado
echo "Segundos totales: $segundos_totales"

# Opcional: Mostrar el desglose del cálculo
echo "Desglose del cálculo:"
echo "  $dias días × 24 horas × 3600 segundos = $((dias * 24 * 3600)) segundos"
echo "  $horas horas × 3600 segundos = $((horas * 3600)) segundos"
echo "  $segundos segundos adicionales"
echo "  Total: $segundos_totales segundos"
