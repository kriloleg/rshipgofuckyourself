FROM fedora:35

RUN useradd -m fuckUship

RUN dnf update -y
RUN dnf install -y wget
RUN dnf install -y python3
RUN dnf install -y proxychains-ng
RUN dnf install -y tor

COPY ./proxychains.conf /etc/proxychains.conf
COPY ./ripper /opt/blockrussia/ripper
COPY /run.sh /

RUN chmod +x /run.sh
RUN chown -R fuckUship /opt/blockrussia
RUN chown fuckUship /etc/proxychains.conf
RUN chmod a+rw /etc/proxychains.conf

USER fuckUship

CMD "/run.sh"
