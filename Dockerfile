FROM debian:stretch

ENV RADICALE_COMMIT="0122d3ebd5d97852ce30855a96c8ee910e6bc2e3"

# Base packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests git wget ca-certificates build-essential python3-dev libffi-dev python3 python3-setuptools python3-pip libffi6 sudo && \
    pip3 install pip setuptools wheel --upgrade && \
    pip3 install passlib bcrypt ldap3 && \
    mkdir -p /data/config && mkdir -p /data/db && \
    git clone "https://github.com/Kozea/Radicale.git" /data/radicale && \
    cd /data/radicale && \
    git checkout -b work $RADICALE_COMMIT && \
    wget -O /data/radicale/radicale/auth/LDAP3.py "https://raw.githubusercontent.com/rthill/Radicale/7950fb5c57237b22ab401be52e073859ecc0fa0b/radicale/auth/LDAP3.py" && \
    python3 setup.py install && \
    cd /data && rm -rf radicale && \
    apt-get purge -y git wget ca-certificates build-essential python3-dev libffi-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/*

# Radicale configuration
RUN groupadd -g 10720 radicale && \
    useradd -u 10720 -g radicale -d /home/radicale -m radicale && \
	mkdir -p /home/radicale/.config && \
 	ln -s /data/config /home/radicale/.config/radicale && \
 	chown -R radicale:radicale /data/config /data/db && \
	chown -R radicale:radicale /home/radicale

ADD entrypoint.sh /

WORKDIR	/home/radicale
EXPOSE 5232
VOLUME ["/data/db", "/data/config"]
ENTRYPOINT ["/entrypoint.sh"]

CMD ["radicale", "-C", "/data/config/config"]
