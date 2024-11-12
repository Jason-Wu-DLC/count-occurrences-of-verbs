#Define a variable PHP_FPM_VER with a default value (8.2) 
ARG PHP_FPM_VER=8.2

#Stage1
#multi-stage build use builder
FROM ubuntu:22.04 AS builder

#Cancel user selection interaction
ARG DEBIAN_FRONTEND=noninteractive

# Run Enviroment update list and install necessary package
RUN apt-get update && apt-get install -y \
    apt-utils \
    curl \
    php \
    php-curl \
    php-zip \
    unzip \
    git

# set working directory
WORKDIR /app

#Copy to image and Install Composer in the container
COPY ./conf/composer.json . 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#Install PHP dependencies with Composer
RUN composer install --no-dev --optimize-autoloader --no-interaction

#Final stage
#Use a specific PHP-FPM version based on Alpine
FROM php:${PHP_FPM_VER}-fpm-alpine AS final

#maintainer information
LABEL version="1.0" \
      author="yulin wu" \
      email="s4565901@student.uq.edu.au"

# Install additional PHP extensions and nginx
RUN apk add --no-cache nginx php-pdo php-mysqli \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy nginx configuration file into the image
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

#Copy the web source code into the image
COPY ./src .

#Designate the root folder of the website as a volume
VOLUME /var/www/html

# Copy the PHP vendor directory from the builder stage
COPY --from=builder /app/vendor /var/www/vendor

#Set up a healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

#Expose port 80 for the nginx server
EXPOSE 80

#Set the working directory for the CMD
WORKDIR /var/www/html

## Command to start PHP-FPM and nginx
CMD ["sh", "-c", "php-fpm -D; nginx -g 'daemon off;'"]

