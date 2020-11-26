FROM alpine:edge
LABEL "version"="1.0"
LABEL "description"="Github Action Linting Build"
LABEL "author"="Dave Johnson"
LABEL "com.github.actions.icon"="check-circle"
LABEL "com.github.actions.color"="green"
LABEL "com.github.actions.name"="PHPCS Code Review"
LABEL "com.github.actions.description"="This will run phpcs on PRs"

### Install all base dependencies
RUN apk upgrade --update && apk add --no-cache \
	bash bash-completion curl ca-certificates openssl openssh git tzdata jq php7 \
    && rm -f /var/cache/apk/*

### Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

### Install PHPCS and WPCS globally with composer
RUN composer global require squizlabs/php_codesniffer wp-coding-standards/wpcs \
	&& ~/.composer/vendor/bin/phpcs --config-set installed_paths ~/.composer/vendor/wp-coding-standards/wpcs \
	&& export PATH="$HOME/.composer/vendor/bin:$PATH"

COPY entrypoint.sh \
     problem-matcher.json \
     /action/

RUN chmod +x /action/entrypoint.sh

ENTRYPOINT ["/action/entrypoint.sh"]