# Lates AlpineLinux with glibc 2.26-r0 and Oracle Java 8
FROM alpine:latest

MAINTAINER Igor Belikov <mail@igorbelikov.com>

# Java URL-related other variables
ENV JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=141 \
    JAVA_VERSION_BUILD=15 \
    JAVA_PACKAGE=jdk \
    JAVA_AUTH_PATH=336fa29ff2bb4ef291e347e091f7f4a7 \
    JAVA_HOME=/opt/jdk \
    PATH=${PATH}:/opt/jdk/bin \
    GLIBC_VERSION=2.26-r0 \
    LANG=C.UTF-8

# Run everythin in one step
RUN set -ex && \
    apk add --no-cache --update libstdc++ curl ca-certificates && \
    for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION}; \
      do curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; \
    done && \
    apk add --no-cache --allow-untrusted /tmp/*.apk && \
    rm /tmp/*.apk && \
    mkdir /opt && \
    curl -sSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/java.tar.gz \
      http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_AUTH_PATH}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz && \
    tar -C /opt -xzf /tmp/java.tar.gz && \
    ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/jdk && \
    apk del curl && \
    rm -rf /opt/jdk/*src.zip \
           /tmp/java.tar.gz
