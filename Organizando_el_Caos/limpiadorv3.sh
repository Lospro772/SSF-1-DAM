#!/usr/bin/env bash

# Colores para los mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # Sin colores

# Contadores
cont_imagenes=0
cont_documentos=0
cont_vacios=0
cont_pdfs=0
cont_txts=0
cont_archivos_no_clasificados=0

# Crear carpetas si no existen las que vamos a utilizar (si existen skipearemos esta función)
mkdir -p imgs docs txts pdfs vacios 2>/dev/null

#Para para almacenar todos los archivos vacios
elementos_vacios=()

echo -e "${YELLOW}Organizando archivos...${NC}"
echo

#Directorio a organizar (por defecto el actual) puedes definir una ruta con la siguiente combinación: ./limpiarv3.sh /ruta/que/nesecites/organizar
directorio="${1:-.}"

#Guardar directorio actual  para volver después a la ruta donde empezamos
directorio_original=$(pwd)

# Ir al directorio a organizar (o quedarnos en el actual)
cd "$directorio" || exit 1

clear
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║           ORGANIZADOR DE ARCHIVOS                    ║"
echo "║       (Para archivos generados por random_files)     ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo -e "${YELLOW}Directorio a organizar: ${GREEN}$(pwd)${NC}"
echo

#Detectamos todos los archivos que debemos analizar cualquier archivo fuera de esta lista no sera analizado por el limpiador 
for archivo in *; do
    # Saltar si es el directorio actual o anterior
    [[ "$archivo" == "." ]] || [[ "$archivo" == ".." ]] && continue
    
    # Saltar las carpetas que acabamos de crear
    if [[ -d "$archivo" ]] && [[ "$archivo" == "imgs" || "$archivo" == "docs" || "$archivo" == "txts" || "$archivo" == "pdfs" || "$archivo" == "vacios" ]]; then
        continue
    fi
    
    # Saltar los scripts propios
    if [[ "$archivo" == "limpiador.sh" ]] || [[ "$archivo" == "random_files.sh" ]] || [[ "$archivo" == "kaos.sh" ]]; then
        continue
    fi
    
    # Verificar si es una carpeta
    if [[ -d "$archivo" ]]; then
        # Verificar si la carpeta está vacía
        if [[ -z "$(ls -A "$archivo" 2>/dev/null)" ]]; then
            echo -e "${MAGENTA}📁 Carpeta vacía detectada: $archivo${NC}"
            elementos_vacios+=("📁 $archivo (carpeta)")
        else
            echo -e "${YELLOW}📁 Carpeta con contenido (no se procesa): $archivo${NC}"
        fi
        continue
    fi
    extension="${archivo##*.}"

    # Verificar si es un archivo vacío, sin contenido o 0 bytes
    if [[ ! -s "$archivo" ]]; then
        echo -e "${MAGENTA}📁 Moviendo archivo VACÍO: $archivo → /vacios/${NC}"
        mv "$archivo" "vacios/" 2>/dev/null && ((cont_vacios++))
        elementos_vacios+=("📄 $archivo (archivo vacío)")
    elif [[ "$extension" == "jpg" ]] || [[ "$extension" == "png" ]] || [[ "$extension" == "gif" ]] || [[ "$extension" == "bmp" ]]; then
        echo -e "${BLUE}📷 Imagen: $archivo → /imgs/${NC}"
        mv "$archivo" "imgs/" 2>/dev/null && ((cont_imagenes++))

    elif [[ "$extension" == "doc" ]] || [[ "$extension" == "odt" ]] || [[ "$extension" == "java" ]]; then
        echo -e "${GREEN}📄 Documento: $archivo → /docs/${NC}"
        mv "$archivo" "docs/" 2>/dev/null && ((cont_documentos++))

    elif [[ "$extension" == "pdf" ]]; then
        echo -e "${GREEN}📄 PDF: $archivo → /pdfs/${NC}"
        mv "$archivo" "pdfs/" 2>/dev/null && ((cont_pdfs++))

    elif [[ "$extension" == "txt" ]]; then
        echo -e "${GREEN}📄 TXT: $archivo → /txts/${NC}"
        mv "$archivo" "txts/" 2>/dev/null && ((cont_txts++))

    else
        echo -e "${RED}❌ No se movió: $archivo (extensión: .$extension)${NC}"
        ((cont_archivos_no_clasificados++))
    fi
done

# Mostrar resumen de todos los archivos que han sido modificados
echo
echo -e "${CYAN}══════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}📊 RESUMEN DE ORGANIZACIÓN:${NC}"
echo -e "${BLUE}📷 Imágenes movidas (imgs/): $cont_imagenes${NC}"
echo -e "${GREEN}📄 Documentos movidos (docs/): $cont_documentos${NC}"
echo -e "${GREEN}📑 PDFs movidos (pdfs/): $cont_pdfs${NC}"
echo -e "${GREEN}📝 TXTs movidos (txts/): $cont_txts${NC}"
echo -e "${MAGENTA}📁 Archivos vacíos movidos (vacios/): $cont_vacios${NC}"

if [[ $cont_archivos_no_clasificados -gt 0 ]]; then
    echo -e "${RED}❌ Archivos no clasificados: $cont_archivos_no_clasificados${NC}"
fi

# Mostrar carpetas vacías encontradas
if [[ ${#elementos_vacios[@]} -gt $cont_vacios ]]; then
    echo -e "${YELLOW}📁 Carpetas vacías encontradas: $((${#elementos_vacios[@]} - cont_vacios))${NC}"
fi

echo -e "${CYAN}══════════════════════════════════════════════════════${NC}"
echo
echo -e "${GREEN}✅ Archivos organizados exitosamente:${NC}"
echo -e "  ${BLUE}📷 imgs/    → .jpg .png .gif .bmp${NC}"
echo -e "  ${GREEN}📄 docs/    → .doc .odt .java${NC}"
echo -e "  ${GREEN}📑 pdfs/    → .pdf${NC}"
echo -e "  ${GREEN}📝 txts/    → .txt${NC}"
echo -e "  ${MAGENTA}📁 vacios/  → Archivos de 0 bytes${NC}"
echo

if [[ ${#elementos_vacios[@]} -gt 0 ]]; then
    echo -e "${YELLOW}══════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📊 ELEMENTOS VACÍOS ENCONTRADOS (${#elementos_vacios[@]}):${NC}"

    for item in "${elementos_vacios[@]}"; do
        echo -e "  ${MAGENTA}$item${NC}"
    done

    echo
    read -p "¿Eliminar todos estos elementos? (s/n): " respuesta

    if [[ "$respuesta" == "s" ]] || [[ "$respuesta" == "S" ]]; then
        # Eliminar archivos de la carpeta vacios/
        if [[ -d "vacios" ]] && [[ $cont_vacios -gt 0 ]]; then
            echo -e "${RED}Eliminando archivos vacíos...${NC}"
            rm -f vacios/*
            rmdir vacios 2>/dev/null
        fi
        #Eliminar las carpetas vacias que no son las previamente creadas por nosotros
        for carpeta in *; do
            if [[ -d "$carpeta" ]] && [[ "$carpeta" != "imgs" ]] && [[ "$carpeta" != "docs" ]] && [[ "$carpeta" != "txts" ]] && [[ "$carpeta" != "pdfs" ]] && [[ "$carpeta" != "vacios" ]]; then
                if [[ -z "$(ls -A "$carpeta" 2>/dev/null)" ]]; then
                    rmdir "$carpeta" 2>/dev/null
                fi
            fi
        done

        echo -e "${GREEN}✅ Elementos vacíos eliminados${NC}"
    else
        echo -e "${YELLOW}No se eliminaron${NC}"
    fi
fi

echo
echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ORGANIZACIÓN COMPLETADA CON ÉXITO                  ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"

# Volver al directorio original donde empezo todo
cd "$directorio_original" || exit
