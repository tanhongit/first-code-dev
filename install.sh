#!/bin/bash

install() {
  FORCE=$1

  if [ "$FORCE" == "force" ]; then
    echo "Force install"
    rm -rf dev-laravel-packages
    rm -rf telegram-git-notifier-dev
  fi

  # Install the required repo
  if [ ! -d "dev-laravel-packages" ]; then
    git clone git@github.com:tanhongit/dev-laravel-packages.git
    cd dev-laravel-packages/packages || exit

    # Clone the required repo
    cd telegram-git-notifier || exit
    git clone git@github.com:tanhongit/laravel-telegram-git-notifier.git
    git clone git@github.com:tanhongit/telegram-git-notifier.git

    cd ../
    git clone git@github.com:tanhongit/git-notifier-ui.git

    # Composer install
    cd ../
    envsubst < .env.example > .env
    composer install
    php artisan key:generate

    cd ../
  fi

  # only telegram git notifier
  if [ ! -d "telegram-git-notifier-dev" ]; then
    git clone git@github.com:tanhongit/telegram-git-notifier-dev.git
    cd telegram-git-notifier-dev || exit

    envsubst < .env.example > .env
    php artisan key:generate

    sed -i 's/cslant/tanhongit/g' .env
    sed -i 's/telegram-git-notifier/tgn/g' .env

    composer install

    cd ../
  fi
}

install "$1"
