#!/bin/bash

###############################################################################
# FreeRADIUS Instalador y Configurador Simple
# - Instala FreeRADIUS
# - Configura cliente y usuario
# - Valida con radtest contra localhost
###############################################################################

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Este script debe ejecutarse con permisos de superusuario (root o sudo),tranquil@ es para ejecutar los comados de instalacion y entrar a las carpetas de configuracion"
    echo "Por favor ejecuta: sudo $0"
    exit 1
fi

function install_radius() {
    echo "Actualizando el sistema..."
    apt update && apt upgrade -y

    echo "Instalando FreeRADIUS y utilidades..."
    apt install freeradius freeradius-utils -y

    echo "Habilitando y arrancando el servicio..."
    systemctl enable freeradius
    systemctl start freeradius

    echo "FreeRADIUS instalado y funcionando."
}

function configure_radius() {
    echo ""
    echo "=== Configuración de cliente ==="
    read -p "IP del cliente autorizado (ejemplo: 192.168.1.10): " CLIENT_IP
    read -p "Secreto compartido para el cliente: " CLIENT_SECRET
    read -p "Nombre corto para el cliente (opcional): " CLIENT_SHORTNAME

    cat > /etc/freeradius/3.0/clients.conf <<EOF
client custom_client {
    ipaddr = $CLIENT_IP
    secret = $CLIENT_SECRET
    shortname = $CLIENT_SHORTNAME
}
EOF

    echo ""
    echo "=== Configuración de usuario ==="
    read -p "Nombre del usuario: " USER_NAME
    read -p "Contraseña del usuario: " USER_PASS

    # Escribir configuración de usuario
    echo "$USER_NAME Cleartext-Password := \"$USER_PASS\"" >> /etc/freeradius/3.0/mods-config/files/authorize

    echo ""
    echo "Reiniciando FreeRADIUS para aplicar cambios..."
    systemctl restart freeradius

    echo ""
    echo "Validando configuración con radtest..."
    radtest $USER_NAME $USER_PASS 127.0.0.1 0 $CLIENT_SECRET
}

# MENU PRINCIPAL
while true; do
    echo ""
    echo "==============================="
    echo "  FREE RADIUS SIMPLE SETUP"
    echo "==============================="
    echo "1) Instalar y configurar FreeRADIUS"
    echo "2) Salir"
    read -p "Selecciona una opción [1-2]: " OPTION

    case $OPTION in
        1)
            install_radius
            configure_radius
            ;;
        2)
            echo "Saliendo. Hasta luego!"
            exit 0
            ;;
        *)
            echo "Opción inválida. Por favor elige 1 o 2."
            ;;
    esac
done
