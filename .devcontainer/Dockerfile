FROM alpine:3.21

# Add the necessary extra packages
RUN apk add --no-cache make git gcc-avr avr-libc avrdude picocom expect build-base ruby ruby-bundler gcovr lcov gzip

# Allow us to use apk to install new packages inside container even if we are not running
# as root inside the container - handy for testing new packages for use in the devcontainer
RUN chmod 4755 /sbin/apk

# Create a user for non-root work inside the container
RUN adduser -D --uid 1000 devuser && addgroup devuser dialout
USER devuser

ENTRYPOINT [ "sh" ]
