FROM debian:stretch

ENV RADICALE_COMMIT="c028de4fb7059d5fa5f379bcc72514ac8912f948"
ENV AUTH_LDAP_COMMIT="cc32d985f5b9f9051026d0834eab4c1508365917"

# Base packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests git ca-certificates python3 python3-setuptools python3-pip sudo && \
    python3 -m pip install --upgrade pip setuptools wheel && \
    mkdir -p /data/config && mkdir -p /data/db && \
    git clone "https://github.com/Kozea/Radicale.git" /data/radicale && \
    cd /data/radicale && \
    git checkout -b work $RADICALE_COMMIT && \
    python3 -m pip install --upgrade . && \
    git clone "https://github.com/marcoh00/radicale-auth-ldap.git" /data/radicale-auth-ldap && \
    cd /data/radicale-auth-ldap && \
    git checkout -b work $AUTH_LDAP_COMMIT && \
    python3 -m pip install --upgrade . && \
    cd /data && rm -rf radicale radicale-auth-ldap && \
    apt-get purge -y git ca-certificates && \
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

CMD ["radicale", "-C", "/data/config/config", "-H", "0.0.0.0:5232"]
