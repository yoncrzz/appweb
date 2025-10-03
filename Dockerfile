# Dockerfile: kali-full
FROM kalilinux/kali-rolling:latest

# Opcional: elegir metapaquete (kali-linux-default | kali-linux-large | kali-linux-everything)
ARG KALI_META=kali-linux-large

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Actualiza e instala paquetes base + metapaquete Kali
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      sudo curl wget gnupg2 ca-certificates \
      locales lsb-release apt-transport-https \
      openssh-server net-tools iproute2 procps \
      && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# (Opcional) Instalar metapaquete Kali — MUY pesado
RUN apt-get update && \
    apt-get install -y --no-install-recommends ${KALI_META} || true && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Crear usuario no-root
ARG USERNAME=kali
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd -g $USER_GID $USERNAME || true && \
    useradd -m -u $USER_UID -g $USER_GID -s /bin/bash $USERNAME && \
    echo "$USERNAME:kali" | chpasswd && \
    usermod -aG sudo $USERNAME

# Si quieres SSH: prepara sshd (no recomendado en servicios públicos)
RUN mkdir /var/run/sshd

# Puerto (Render expone $PORT para web services; si quieres SSH en Render puede no funcionar)
EXPOSE 22

# Por defecto entra en shell (no se recomienda en producción)
CMD ["/bin/bash"]
