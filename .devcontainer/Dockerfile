FROM alpine:3.23

# Add the necessary extra packages
RUN apk add --no-cache doas make git gcc-avr avr-libc avrdude picocom expect build-base ruby ruby-bundler gcovr lcov gzip

# Create a user for non-root work inside the container, and add use to the dialout group
# so it can access the serial port, and to the wheel group so it can use doas
RUN adduser -D --uid 1000 devuser && addgroup devuser dialout && addgroup devuser wheel

# Give the vscode user passwordless doas access to the necessary commands
RUN echo "permit nopass :wheel" > /etc/doas.conf && \
    chown -c root:root /etc/doas.conf && \
    chmod -c 0400 /etc/doas.conf
USER devuser

ENTRYPOINT [ "sh" ]
