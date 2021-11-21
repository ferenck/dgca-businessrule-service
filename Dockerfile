FROM debian:11 AS builder
RUN apt-get update \
    && apt-get install --yes libtcnative-1

FROM gcr.io/distroless/java-debian11:11
WORKDIR /
COPY scripts/Dpkg.java Dpkg.java
COPY target/*.jar app.jar
COPY --from=builder /usr/lib/x86_64-linux-gnu/libtcnative-1.so /usr/lib/x86_64-linux-gnu/libapr-1.so.0 /usr/lib/x86_64-linux-gnu/
RUN ["java", "Dpkg.java"]
USER 65534:65534
CMD ["-Djava.security.egd=file:/dev/./urandom", "app.jar"]
