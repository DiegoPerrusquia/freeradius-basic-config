# freeradius-basic-config

Guía técnica para la instalación, configuración y prueba de un servidor FreeRADIUS en Linux. Incluye ejemplos de clientes, usuarios, pruebas de autenticación y recomendaciones de seguridad.  
Technical guide for installing, configuring, and testing a FreeRADIUS server on Linux. Includes client, user, authentication test examples, and security recommendations.

---

## Descripción

Este repositorio proporciona:
- Un tutorial paso a paso para instalar FreeRADIUS en sistemas basados en Debian.
- Archivos de configuración de ejemplo para clientes y usuarios.
- Un script básico de instalación.
- Recomendaciones para entornos de laboratorio y producción.

---

## Requisitos

- Distribución Linux 
- Privilegios de superusuario
- Acceso a la red si se desea probar con clientes remotos

---

## Instalación

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install freeradius freeradius-utils -y
sudo systemctl enable freeradius
sudo systemctl start freeradius
sudo systemctl status freeradius

