# Imagen base: Ubuntu estable y ligera
FROM ubuntu:22.04

# Evitar preguntas interactivas durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualiza el sistema e instala dependencias básicas
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    git curl wget unzip nano sudo tmate openssh-client \
    build-essential software-properties-common && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Crea un usuario no root (mejor práctica para Railway)
RUN useradd -m -s /bin/bash ubuntu && \
    echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Directorio de trabajo
WORKDIR /home/ubuntu

# Clona automáticamente tu repo de GitHub (opcional, reemplaza el enlace)
# RUN git clone https://github.com/tu-usuario/tu-repo.git

# Puerto expuesto (Railway asigna automáticamente uno en PORT)
EXPOSE 8080

# Comando por defecto: abre sesión tmate para acceso remoto
CMD tmate -F
