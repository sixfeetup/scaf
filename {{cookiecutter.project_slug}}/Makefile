TAG?=dev
PGPORT?=5432
DUMPFILE?=sandbox.dump
RELEASE_TAG?=unspecified

sandbox-release: RELEASE_DATE :=  $(shell date +"%Y-%m-%d")
sandbox-release: RELEASE_LETTER := $(strip $(shell git tag -l | grep $(RELEASE_DATE) | wc -l | tr 0123456789 abcdefghij ))
sandbox-release: RELEASE_TAG := $(RELEASE_DATE)$(RELEASE_LETTER)

build: export DOCKER_BUILDKIT = 1
build: ./backend/Dockerfile ## Create the build and runtime images
	@docker build -t {{ cookiecutter.project_slug }}_local_django:$(TAG) ./backend

#build-front-end:  ## Build the front-end React app
#	@docker-compose exec front-end npm run build

destroy-data: ## Remove the database volumes to start fresh
	@docker-compose stop db
	@docker-compose rm -f db
	@docker volume rm {{ cookiecutter.project_slug }}_local_postgres_data
	@docker volume rm {{ cookiecutter.project_slug }}_local_postgres_data_backups
	@docker-compose up -d db


clean: ## Remove the latest build
	@docker rmi -f {{ cookiecutter.project_slug }}_local_django:$(TAG)


squeaky-clean:  clean  ## Aggressively remove unused images
	@docker rmi python:3.10-slim-bullseye
	@docker rmi postgres:14
	@docker rmi mailhog/mailhog:v1.0.0
	@docker rmi node:16-bullseye-slim
	@docker rmi redis:6.2
	@docker system prune -a
	@for image in `docker images -f "dangling=true" -q`; do \
		echo removing $$image && docker rmi $$image ; done

update: ## Grab latest images for project
	@docker pull python:3.10-slim-bullseye
	@docker pull postgres:14
	@docker pull mailhog/mailhog:v1.0.0
	@docker pull node:16-bullseye-slim
	@docker pull redis:6.2



## Release/Deployment Targets

.PHONY: ci
ci: test secure build  ## Execute the same checks used in CI/CD.

sandbox-release: ## create release tag and push to master
	@echo "release tag: $(RELEASE_TAG)"
	@git tag $(RELEASE_TAG)
	@git push --tags

staging-release: ## update pipeline tag and execute
ifeq ($(RELEASE_TAG), unspecified)
	@echo "provide a valid RELEASE_TAG argument"
	git tag -l
endif
	@echo "release tag: $(RELEASE_TAG)"
	@git tag -l | grep $(RELEASE_TAG) | wc -l | awk '$$1 != 1 {print "RELEASE_TAG does not match any git tag"; exit 1 }'
	@aws --profile={{ cookiecutter.project_slug }}-deploy ecr batch-get-image --repository-name {{ cookiecutter.project_slug }} --image-ids imageTag=$(RELEASE_TAG) \
		| jq '.images | length'| awk '$$1 != 1 {print "RELEASE_TAG does not match any ECR images"; exit 1 }'
	@aws --profile={{ cookiecutter.project_slug }}-deploy codepipeline get-pipeline --name {{ cookiecutter.project_slug }}-staging \
		| jq 'del(.metadata) | .pipeline.stages[0].actions[0].configuration.ImageTag = "$(RELEASE_TAG)"' \
		| xargs -0 aws --profile={{ cookiecutter.project_slug }}-deploy codepipeline update-pipeline --cli-input-json 1>/dev/null
	@aws --profile={{ cookiecutter.project_slug }}-deploy codepipeline start-pipeline-execution --name {{ cookiecutter.project_slug }}-staging

prod-release: ## update pipeline tag and execute
ifeq ($(RELEASE_TAG), unspecified)
	@echo "provide a valid RELEASE_TAG argument"
	git tag -l
endif
	@echo "release tag: $(RELEASE_TAG)"
	@git tag -l | grep $(RELEASE_TAG) | wc -l | awk '$$1 != 1 {print "RELEASE_TAG does not match any git tag"; exit 1 }'
	@aws --profile={{ cookiecutter.project_slug }}-deploy ecr batch-get-image --repository-name {{ cookiecutter.project_slug }} --image-ids imageTag=$(RELEASE_TAG) \
		| jq '.images | length'| awk '$$1 != 1 {print "RELEASE_TAG does not match any ECR images"; exit 1 }'
	@aws --profile={{ cookiecutter.project_slug }}-deploy codepipeline get-pipeline --name {{ cookiecutter.project_slug }}-prod \
		| jq 'del(.metadata) | .pipeline.stages[0].actions[0].configuration.ImageTag = "$(RELEASE_TAG)"' \
		| xargs -0 aws --profile={{ cookiecutter.project_slug }}-deploy codepipeline update-pipeline --cli-input-json 1>/dev/null
	@aws --profile={{ cookiecutter.project_slug }}-deploy codepipeline start-pipeline-execution --name {{ cookiecutter.project_slug }}-prod

check-x-release = @aws --profile={{ cookiecutter.project_slug }}-deploy codepipeline get-pipeline-state --name {{ cookiecutter.project_slug }}-$(subst check-,,$(subst -release,,$@))  | jq '.stageStates[0].latestExecution.pipelineExecutionId as $$execId | { Pipeline: .pipelineName, Started: .stageStates[0].actionStates[0].latestExecution.lastStatusChange, Actions: .stageStates | map( .latestExecution.pipelineExecutionId as $$stage_execId | .actionStates | map( { (.actionName): (if $$stage_execId == $$execId then .latestExecution.status else "Pending" end) } ))  | flatten | add }'

check-sandbox-release check-staging-release check-prod-release: ## check status of release pipeline
	$(check-x-release)

## Development Targets

build-dev: export DOCKER_BUILDKIT = 1
build-dev: ./backend/Dockerfile  ## Create the dev build and runtime images
	@docker build --build-arg DEVEL=yes --build-arg TEST=yes -t {{ cookiecutter.project_slug }}_local_django:dev ./backend

outdated: ## Show outdated packages in the container
	@docker run --rm {{ cookiecutter.project_slug }}_local_django:$(TAG) pip list --outdated

pipdeptree: ## Show pipdeptree output
	@docker run --rm {{ cookiecutter.project_slug }}_local_django:$(TAG) pipdeptree

compile: backend/requirements/base.in backend/requirements/tests.in ## compile latest requirements to be built into the docker image
	@docker run --rm -v $(shell pwd)/backend/requirements:/local python:3.10-slim-bullseye /bin/bash -c \
		"apt-get update; apt-get install -y libpq-dev; \
		 pip install pip-tools; \
		 touch /local/base.txt; touch /local/production.txt; touch /local/tests.txt; touch /local/local.txt; \
		 python -m piptools compile --upgrade --allow-unsafe --generate-hashes --output-file /local/base.txt /local/base.in; \
		 python -m piptools compile --upgrade --allow-unsafe --generate-hashes --output-file /local/production.txt /local/production.in; \
		 python -m piptools compile --upgrade --allow-unsafe --generate-hashes --output-file /local/tests.txt /local/tests.in; \
		 python -m piptools compile --upgrade --allow-unsafe --output-file /local/local.txt /local/local.in"

load-dump: destroy-data ## Fresh load the data file passed in
	@sleep 5
	pg_restore -h localhost -p $(PGPORT) -j 4 -n public --no-owner -U {{ cookiecutter.project_slug }} -W -d {{ cookiecutter.project_slug }} $(DUMPFILE)

clean-dev: ## Remove the latest build
	@docker rmi -f {{ cookiecutter.project_slug }}_local_django:dev

up: ## start up the cluster locally
	@docker-compose -f ./docker-compose.yml -f ./docker-compose.override.yml up

down: ## shut down the cluster
	@docker-compose -f ./docker-compose.yml down

down-clean:
	@docker-compose -f ./docker-compose.yml down --remove-orphans

test:  ## Run the PyTests for the Django Application
	@docker-compose exec django pytest

shell:  ## Shell into the running Django container
	@docker-compose exec django /bin/bash

.PHONY: secure
secure:  ## Analyze dependencies for security issues.
	@docker-compose exec django safety check
	#@docker-compose exec django pip-audit --desc

#node:  ## Shell into the running Node container
#	@docker-compose exec front-end /bin/bash

help: ## This help.
	@awk 'BEGIN 	{ FS = ":.*##"; target="";printf "\nUsage:\n  make \033[36m<target>\033[33m\n\nTargets:\033[0m\n" } \
		/^[a-zA-Z_-]+:.*?##/ { if(target=="")print ""; target=$$1; printf " \033[36m%-10s\033[0m %s\n\n", $$1, $$2 } \
		/^([a-zA-Z_-]+):/ {if(target=="")print "";match($$0, "(.*):"); target=substr($$0,RSTART,RLENGTH) } \
		/^\t## (.*)/ { match($$0, "[^\t#:\\\\]+"); txt=substr($$0,RSTART,RLENGTH);printf " \033[36m%-10s\033[0m", target; printf " %s\n", txt ; target=""} \
		/^## .*/ {match($$0, "## (.+)$$"); txt=substr($$0,4,RLENGTH);printf "\n\033[33m%s\033[0m\n", txt ; target=""} \
	' $(MAKEFILE_LIST)

.PHONY: help build build-dev outdated pipdeptree compile destroy-data load-dump clean clean-dev squeaky_clean update check-sandbox-release check-staging-release check-prod-release

.DEFAULT_GOAL := help

