FROM php:8.0.22-cli-bullseye@sha256:1580bfecd350604f0a0d242945acd22e56641a21bec33e6754cebdf3338eb28c

SHELL [ "/bin/bash", "-exo", "pipefail", "-c" ]

# renovate: datasource=github-tags depName=composer/composer versioning=semver
ENV COMPOSER_VERSION 2.4.1
ENV COMPOSER_INSTALLER_COMMIT 459bcaab2cc03f1656dd7b065d500d0cf3070e3f
ENV COMPOSER_INSTALLER_HASH 756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
        git \
        unzip \
        zip \
    ; \
    curl -o /tmp/composer-installer.php \
    https://raw.githubusercontent.com/composer/getcomposer.org/${COMPOSER_INSTALLER_COMMIT}/web/installer; \
    \
    echo "${COMPOSER_INSTALLER_HASH} /tmp/composer-installer.php" | sha384sum -c -; \
    \
    php /tmp/composer-installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION}; \
    \
    composer diagnose; \
    rm -f /tmp/composer-installer.php; \
    \
    rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp

USER nobody

CMD [ "composer" ]
