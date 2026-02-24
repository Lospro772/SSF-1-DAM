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
cont_txts=0  # CORREGIDO: quitado el espacio

echo -e "${YELLOW}Organizando archivos...${NC}"
echo

# Un solo for para procesar todos los archivos
for archivo in *; do
    # Saltar si es un directorio
    if [[ -d "$archivo" ]]; then
        continue
    fi

    # Saltar los scripts propios
    if [[ "$extension" == "sh" ]]; then
        continue
    fi

    # Obtener extensión
    extension="${archivo##*.}"

    # Verificar si es un archivo vacío (0 bytes)
    if [[ ! -s "$archivo" ]]; then
        echo -e "${MAGENTA}📁 Moviendo archivo VACÍO: $archivo → /vacios/${NC}"
        mv "$archivo" "vacios/" 2>/dev/null && ((cont_vacios++))

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
    fi
done

# Mostrar resumen
echo
echo -e "${CYAN}══════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}📊 RESUMEN DE ORGANIZACIÓN:${NC}"
echo -e "${BLUE}📷 Imágenes movidas (imgs/): $cont_imagenes${NC}"
echo -e "${GREEN}📄 Documentos movidos (docs/): $cont_documentos${NC}"
echo -e "${GREEN}📑 PDFs movidos (pdfs/): $cont_pdfs${NC}"
echo -e "${GREEN}📝 TXTs movidos (txts/): $cont_txts${NC}"
echo -e "${MAGENTA}📁 Archivos vacíos movidos (vacios/): $cont_vacios${NC}"
echo -e "${CYAN}══════════════════════════════════════════════════════${NC}"

# Mostrar ubicaciones
echo
echo -e "${GREEN}✅ Archivos organizados exitosamente:${NC}"
echo -e "  ${BLUE}📷 imgs/    → .jpg .png .gif .bmp${NC}"
echo -e "  ${GREEN}📄 docs/    → .doc .odt .java${NC}"
echo -e "  ${GREEN}📑 pdfs/    → .pdf${NC}"
echo -e "  ${GREEN}📝 txts/    → .txt${NC}"
echo -e "  ${MAGENTA}📁 vacios/  → Archivos de 0 bytes${NC}"
echo
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ORGANIZACIÓN COMPLETADA CON ÉXITO   ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
