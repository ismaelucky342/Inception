#!/bin/bash
# info.sh — ejecutado dentro del contenedor Arch Linux
#!/bin/bash
BLUE='\033[0;36m' # Usamos un cian brillante que resalta más en terminales oscuras
NC='\033[0m'

echo "=============================================="
echo "    Bienvenido al contenedor Arch Linux        "
echo "=============================================="
echo -e "${BLUE}                    -@                        ${NC}"
echo -e "${BLUE}                   .##@                       ${NC}"
echo -e "${BLUE}                  .####@                      ${NC}"
echo -e "${BLUE}                  @#####@                     ${NC}"
echo -e "${BLUE}                . *######@                    ${NC}"
echo -e "${BLUE}               .##@o@#####@                   ${NC}"
echo -e "${BLUE}              /############@                  ${NC}"
echo -e "${BLUE}             /##############@                 ${NC}"
echo -e "${BLUE}            @######@**%######@                ${NC}"
echo -e "${BLUE}           @#######     ######o               ${NC}"
echo -e "${BLUE}          @######@       ######%              ${NC}"
echo -e "${BLUE}        -@#######h       ######@.\\            ${NC}"
echo -e "${BLUE}       /#####h##\`\`        **%@####@           ${NC}"
echo -e "${BLUE}      @H@*\`                    \`*%#@          ${NC}"
echo -e "${BLUE}     *\`                            \`*         ${NC}"
echo "                                              "
echo "            (I use Arch, btw)                 "   
echo "=============================================="
echo ""

echo "Sistema operativo:"
cat /etc/os-release | grep PRETTY_NAME
echo ""

echo "Versión del kernel (compartido con el host):"
uname -r
echo ""

echo "Variables de entorno del contenedor:"
echo "  MI_VARIABLE = $MI_VARIABLE"
echo "  OTRA_VAR    = $OTRA_VAR"
echo ""

echo "Paquetes instalados por pacman:"
# pacman -Q lista todos los paquetes instalados con sus versiones
pacman -Q | head -20
echo "  ... ($(pacman -Q | wc -l) paquetes en total)"
echo ""

echo "Diferencias de sistema de ficheros vs Alpine:"
echo ""
echo "  Alpine (musl libc):"
echo "    /lib/ld-musl-x86_64.so.1  ← musl, más ligero, menos compatible"
echo ""
echo "  Arch (glibc):"
ls /lib/libc.so* 2>/dev/null && \
  echo "    $(ls /lib/libc.so* 2>/dev/null | head -1)  ← glibc, estándar POSIX completo" || \
  echo "    $(ls /lib/libc-*.so 2>/dev/null | head -1)  ← glibc, estándar POSIX completo"
echo ""

echo "Gestor de paquetes disponible:"
which pacman
pacman --version | head -1
echo ""

echo "Directorio de trabajo actual (WORKDIR):"
pwd
echo "============================================"
