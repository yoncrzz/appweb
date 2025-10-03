FROM kalilinux/kali-rolling

# Evita interacción en la instalación
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && \
    apt install -y openssh-server net-tools iproute2 && \
    mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd

# Habilitar acceso SSH
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
