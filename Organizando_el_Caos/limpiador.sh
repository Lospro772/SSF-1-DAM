#!/usr/bin/env bash

# Colores para mejor visualización
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

clear
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║           ORGANIZADOR DE ARCHIVOS                    ║"
echo "║       (Para archivos generados por random_files)     ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Crear carpetas si no existen
mkdir -p imgs docs txts pdfs vacios 2>/dev/null

# Contadores
cont_imagenes=0
cont_documentos=0
cont_vacios=0
cont_pdfs=0
cont txts=0

echo -e "${YELLOW}Organizando archivos...${NC}"
echo

# Un solo for para procesar todos los archivos
for archivo in *; do
    # Saltar si es un directorio
    if [[ -d "$archivo" ]]; then
        continue
    fi

    # Saltar los scripts propios
    if [[ "$archivo" == "limpiador.sh" ]] || [[ "$archivo" == "random_files.sh" ]]; then
        continue
    fi

    # Obtener extensión
    extension="${archivo##*.}"

    # Verificar si es un archivo vacío (0 bytes) o si es una imagen o si es un documento o si es un txt o si es un pdf
    if [[ ! -s "$archivo" ]]; then
        echo -e "${MAGENTA}📁 Moviendo archivo VACÍO: $archivo → /vacios/${NC}"
        mv "$archivo" "vacios/" 2>/dev/null && ((cont_vacios++))


    elif [[ "$extension" == "jpg" ]] || [[ "$extension" == "png" ]] || [[ "$extension" == "gif" ]]; then
        echo -e "${BLUE}📷 Imagen: $archivo → /imgs/${NC}"
        mv "$archivo" "imagenes/" 2>/dev/null && ((cont_imagenes++))

    elif [[ "$extension" == "docx" ]] || [[ "$extension" == "odt" ]]; then
        echo -e "${GREEN}📄 Documento: $archivo → /docs/${NC}"
        mv "$archivo" "documentos/" 2>/dev/null && ((cont_documentos++))

    elif [[ "$extension" == "pdf" ]]; then
        echo -e "${GREEN}📄 Documento: $archivo → /pdfs/${NC}"
        mv "$archivo" "documentos/" 2>/dev/null && ((cont_pdfs++))

    elif [[ "$extension" == "txt" ]]; then
        echo -e "${GREEN}📄 Documento: $archivo → /txts/${NC}"
        mv "$archivo" "documentos/" 2>/dev/null && ((cont_txts++))

    else
        echo -e "${RED}❌ No se movió: $archivo (extensión: .$extension)${NC}"
    fi
done

# Mostrar resumen
echo
echo -e "${CYAN}══════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}📊 RESUMEN DE ORGANIZACIÓN:${NC}"
echo -e "${BLUE}📷 Imágenes movidas: $cont_imagenes${NC}"
echo -e "${GREEN}📄 Documentos movidos: $cont_documentos${NC}"
echo -e "${MAGENTA}📁 Archivos vacíos movidos: $cont_vacios${NC}"
echo -e "${CYAN}══════════════════════════════════════════════════════${NC}"

# Mostrar ubicaciones
echo
echo -e "${GREEN}✅ Archivos organizados exitosamente:${NC}"
echo -e "  ${BLUE}📷 imagenes/   → .jpg .bmp .gif .png${NC}"
echo -e "  ${GREEN}📄 documentos/ → .txt .doc .pdf .java .odt${NC}"
echo -e "  ${MAGENTA}📁 vacios/     → Archivos de 0 bytes${NC}"
echo
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ORGANIZACIÓN COMPLETADA CON ÉXITO   ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
