#!/bin/bash

# Script para calcular el Índice de Masa Corporal (IMC)
# Uso: ./calculaimc.sh <altura_cm> <peso_kg>
# Ejemplo: ./calculaimc.sh 182 72

# Verificar que se recibieron exactamente 2 parámetros
if [ $# -ne 2 ]; then
    echo "Error: Se requieren exactamente 2 parámetros"
    echo "Uso: $0 <altura_cm> <peso_kg>"
    echo "Ejemplo: $0 182 72"
    exit 1
fi

# Asignar parámetros a variables
altura_cm=$1
peso_kg=$2

# Validar que los parámetros sean números positivos
for param in "$altura_cm" "$peso_kg"; do
    if ! [[ "$param" =~ ^[0-9]+(\.[0-9]+)?$ ]] || (( $(echo "$param <= 0" | bc) )); then
        echo "Error: Los parámetros deben ser números positivos"
        exit 1
    fi
done

# Convertir altura de cm a metros
altura_m=$(echo "scale=2; $altura_cm / 100" | bc)

# Calcular IMC: peso / (altura)^2
imc=$(echo "scale=2; $peso_kg / ($altura_m * $altura_m)" | bc)

# Mostrar resultados
echo "==================================="
echo "      CÁLCULO DE IMC"
echo "==================================="
echo "Altura: $altura_cm cm ($altura_m m)"
echo "Peso: $peso_kg kg"
echo "-----------------------------------"
echo "Tu IMC es: $imc"

# Clasificación según la OMS
echo -n "Clasificación (OMS): "

if (( $(echo "$imc < 18.5" | bc) )); then
    echo "Bajo peso"
    echo "➜ Recomendación: Deberías aumentar de peso"
elif (( $(echo "$imc >= 18.5 && $imc < 25" | bc) )); then
    echo "Normal (saludable)"
    echo "➜ Recomendación: Mantén tu peso actual"
elif (( $(echo "$imc >= 25 && $imc < 30" | bc) )); then
    echo "Sobrepeso"
    echo "➜ Recomendación: Considera perder peso"
else
    echo "Obesidad"
    echo "➜ Recomendación: Consulta a un médico para un plan de pérdida de peso"
fi

echo "==================================="

#Tabla de referencia para saber si estas en tu peso correcto
echo
echo "Tabla de referencia (OMS):"
echo "  Bajo peso:    < 18.5"
echo "  Normal:       18.5 - 24.9"
echo "  Sobrepeso:    25.0 - 29.9"
echo "  Obesidad:     ≥ 30.0"
