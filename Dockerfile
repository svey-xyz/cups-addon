ARG BUILD_FROM
FROM $BUILD_FROM

# Add env
ENV LANG C.UTF-8

# Setup base
RUN \
    apk add --no-cache \
        cups \
        cups-pdf \
        cups-filters \
        hplip \
        ghostscript \
        py3-reportlab \
        libjpeg \
        net-snmp \
    && rc-update add cupsd boot

# Copy data
COPY rootfs /

# Expose CUPS web interface port
EXPOSE 631

HEALTHCHECK \
    CMD lpstat -r || exit 1