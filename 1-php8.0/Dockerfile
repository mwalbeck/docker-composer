FROM php:8.0.19-cli-bullseye@sha256:60308db8546b73c9828ea7159b26b449055d9381ffd407e9fe1980e8d16d6495

SHELL [ "/bin/bash", "-exo", "pipefail", "-c" ]

# renovate: datasource=github-tags depName=composer/composer versioning=semver
ENV COMPOSER_VERSION 1.10.26
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
