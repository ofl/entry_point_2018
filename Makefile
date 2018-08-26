# https://github.com/saboyutaka/rails-laravel-mix/blob/master/Makefile
.DEFAULT_GOAL := help

build: ## build develoment environment
	docker-compose run --rm rails bundle install
	docker-compose run --rm yarn install
	docker-compose run --rm yarn run dev

serve: up attach ## Run Serve

up: ## Run rails container
	docker-compose up -d rails

console: ## Run Rails Console
	docker-compose run --rm rails bundle exec rails c

bundle: ## Run bundle install
	docker-compose run --rm rails bundle install

attach: ## Attach running rails container for binding.pry
	docker attach `docker ps -f name=ofl/entry_point_2018_rails -f status=running --format "{{.ID}}"`

yarn_install: ## Run yarn install
	docker-compose run --rm yarn install

yarn_dev: ## Run yarn run dev
	docker-compose run --rm yarn run dev

yarn_watch: ## Run yarn watch
	docker-compose run --rm yarn run watch

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
