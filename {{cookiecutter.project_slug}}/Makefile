TAG?=latest

build: Dockerfile ## create the build and runtime images
	@docker build -t {{ cookiecutter.project_slug }}_local_django:$(TAG) .

build-front-end:  ## shell in
	@docker-compose exec front-end npm run build

build-dev: Dockerfile ## create the dev build and runtime images
	@docker build --build-arg DEVEL=yes -t {{ cookiecutter.project_slug }}_local_django:dev .

outdated: ## Show outdated packages in the container
	@docker run --rm {{ cookiecutter.project_slug }}_local_django:$(TAG) pip list --outdated

compile: requirements/base.in requirements/tests.in ## compile latest requirements to be built into the docker image
	@docker run --rm -v $(shell pwd)/requirements:/local {{ cookiecutter.project_slug }}_local_django:dev /bin/bash -c \
		"apt-get update; apt-get install -y libpq-dev; \
		 python -m piptools compile --upgrade --no-annotate --no-header --allow-unsafe --generate-hashes --output-file /local/base.txt /local/base.in; \
		 python -m piptools compile --upgrade --no-annotate --no-header --allow-unsafe --generate-hashes --output-file /local/production.txt /local/production.in; \
	     python -m piptools compile --upgrade --no-annotate --no-header --allow-unsafe --generate-hashes --output-file /local/tests.txt /local/tests.in"

destroy-data: ## Remove the database volumes to start fresh
	@docker volume rm {{ cookiecutter.project_slug }}_local_postgres_data
	@docker volume rm {{ cookiecutter.project_slug }}_local_postgres_data_backups

clean: ## remove the latest build
	@docker rmi -f {{ cookiecutter.project_slug }}_local_django:$(TAG)

clean-dev: ## remove the latest build
	@docker rmi -f {{ cookiecutter.project_slug }}_local_django:dev

squeaky-clean:  clean  ## aggressively remove unused images
	@docker rmi python:3.8-slim
	@docker system prune -a
	@for image in `docker images -f "dangling=true" -q`; do \
		echo removing $$image && docker rmi $$image ; done

update: ## Grab latest images for project
	@docker pull python:3.8-slim
	@docker pull postgres:12.2
	@docker pull mailhog/mailhog:v1.0.0

shell:  ## shell in
	@docker-compose exec django /bin/bash

help: ## This help.
	@awk 'BEGIN 	{ FS = ":.*##"; target="";printf "\nUsage:\n  make \033[36m<target>\033[33m\n\nTargets:\033[0m\n" } \
		/^[a-zA-Z_-]+:.*?##/ { if(target=="")print ""; target=$$1; printf " \033[36m%-10s\033[0m %s\n\n", $$1, $$2 } \
		/^([a-zA-Z_-]+):/ {if(target=="")print "";match($$0, "(.*):"); target=substr($$0,RSTART,RLENGTH) } \
		/^\t## (.*)/ { match($$0, "[^\t#:\\\\]+"); txt=substr($$0,RSTART,RLENGTH);printf " \033[36m%-10s\033[0m", target; printf " %s\n", txt ; target=""} \
		/^## .*/ {match($$0, "## (.+)$$"); txt=substr($$0,4,RLENGTH);printf "\n\033[33m%s\033[0m\n", txt ; target=""} \
	' $(MAKEFILE_LIST)

.PHONY: help build build-dev compile destroy-data clean squeaky_clean update