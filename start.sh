#!/bin/ash

set -e

BIN="/usr/bin/snell-server"
CONF="/etc/snell-server.conf"

# reuse existing config when the container restarts

run_bin() {
    echo "Running snell-server with config:"
    echo ""
    cat ${CONF}

    ${BIN} --version
    ${BIN} -c ${CONF}
}

if [ -f ${CONF} ]; then
    echo "Found existing config, rm it."
    rm ${CONF}
fi

if [ -z ${PSK} ]; then
    PSK=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
    echo "Using generated PSK: ${PSK}"
else
    echo "Using predefined PSK: ${PSK}"
fi

if [ -z ${PORT} ]; then
    PORT=8443
    echo "Using default PORT: ${PORT}"
else
    echo "Using predefined PORT: ${PORT}"
fi

if [ -z ${OBFS} ]; then
    OBFS=off
    echo "Using default OBFS: ${OBFS}"
else
    echo "Using predefined OBFS: ${OBFS}"
fi

if [ -z ${OTF} ]; then
    OTF=false
    echo "Using default OTF: ${OTF}"
else
    echo "Using predefined OTF: ${OTF}"
fi

if [ -z ${DNS} ]; then
    DNS=9.9.9.9,1.1.1.1
    echo "Using default DNS: ${DNS}"
else
    echo "Using predefined DNS: ${DNS}"
fi

if [ -z ${IPV6} ]; then
    IPV6=false
else
    echo "Using predefined IPV6: ${IPV6}"
fi

echo "Generating new config..."
echo "[snell-server]" >>${CONF}
echo "listen = :::${PORT}" >>${CONF}
echo "psk = ${PSK}" >>${CONF}
echo "obfs = ${OBFS}" >>${CONF}
echo "tfo = ${TFO}" >>${CONF}
echo "ipv6 = ${IPV6}" >>${CONF}
echo "dns = ${DNS}" >>${CONF}

run_bin
