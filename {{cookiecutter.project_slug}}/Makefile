TAG?=dev
PGPORT?=5432
DUMPFILE?=sandbox.dump
RELEASE_TAG?=unspecified

sandbox-release: RELEASE_DATE :=  $(shell date +"%Y-%m-%d")
sandbox-release: RELEASE_LETTER := $(strip $(shell git tag -l | grep $(RELEASE_DATE) | wc -l | tr 0123456789 abcdefghij ))
sandbox-release: RELEASE_TAG := $(RELEASE_DATE)$(RELEASE_LETTER)

build: export DOCKER_BUILDKIT = 1
build: ./backend/Dockerfile backend/requirements/production.txt ./frontend/Dockerfile ## Create the build and runtime images
	@docker build -t {{ cookiecutter.project_slug }}_local_django:$(TAG) ./backend
	{% if cookiecutter.create_react_frontend == 'y' %}
	@docker build -t {{ cookiecutter.project_slug }}_local_frontend:$(TAG) ./frontend
	{% endif %}

#build-front-end:  ## Build the front-end React app
#	@docker-compose exec front-end npm run build

destroy-data: ## Remove the database volumes and start with a clean database
	@docker-compose stop db
	@docker-compose rm -f db
	@docker volume rm {{ cookiecutter.project_slug }}_local_postgres_data
	@docker volume rm {{ cookiecutter.project_slug }}_local_postgres_data_backups
	@docker-compose up -d db


clean: ## Remove the latest build
	@docker rmi -f {{ cookiecutter.project_slug }}_local_django:$(TAG)


squeaky-clean:  clean  ## Removes the resources not associated with a container, this is a quick way to get rid of old images, containers, volumes, and networks
	@docker rmi python:3.10-slim-bullseye
	@docker rmi postgres:16-bullseye
	@docker rmi mailhog/mailhog:v1.0.0
	@docker rmi node:16-bullseye-slim
	@docker rmi redis:6.2
	@docker system prune -a
	@for image in `docker images -f "dangling=true" -q`; do \
		echo removing $$image && docker rmi $$image ; done

update: ## Pull the latest image from a registry
	@docker pull python:3.10-slim-bullseye
	@docker pull postgres:16-bullseye
	@docker pull mailhog/mailhog:v1.0.0
	@docker pull node:16-bullseye-slim
	@docker pull redis:6.2


## Release/Deployment Targets

.PHONY: ci
ci: test secure build  ## Execute the same checks used in CI/CD

check-lint-and-formatting:  ## Execute check of lint and formatting using existing pre-commit hooks
	pip install pre-commit; \
	cd backend/; \
	pre-commit install; \
	pre-commit run -a

{% if cookiecutter.create_react_frontend == 'y' %}
check-lint-and-test-frontend:  ## Frontend Lint & Typecheck & Test
	cd frontend/; \
	npm install --legacy-peer-deps; \
	npm run lint-src; \
	npm run typecheck; \
	npm run test
{% endif %}

backend-test:  ## Execute backend tests
	cd backend; \
	pip --disable-pip-version-check install --no-deps -r requirements/production.txt; \
	pip --disable-pip-version-check install --no-deps -r requirements/tests.txt; \
	pytest --cov=./ --cov-report html --ds=config.settings.test

{% if cookiecutter.create_react_frontend == 'y' %}
frontend-test:  ## Execute frontend tests
	cd frontend; \
	npm install --legacy-peer-deps; \
	npm run test

test: backend-test frontend-test  ## Run all tests
{% else %}
test: backend-test  ## Run all tests
{% endif %}

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

backend/requirements/local.txt: compile
backend/requirements/production.txt: compile
backend/requirements/tests.txt: compile

build-dev: export DOCKER_BUILDKIT = 1
build-dev: ./backend/Dockerfile backend/requirements/local.txt ./frontend/Dockerfile ## Create the dev build and runtime images
	@docker build --build-arg DEVEL=yes --build-arg TEST=yes -t {{ cookiecutter.project_slug }}_local_django:dev ./backend
	{% if cookiecutter.create_react_frontend == 'y' %}
	@docker build -t {{ cookiecutter.project_slug }}_local_frontend:$(TAG) ./frontend
	{% endif %}

outdated: ## Show all the outdated packages with their latest versions in the container
	@docker run --rm {{ cookiecutter.project_slug }}_local_django:$(TAG) pip list --outdated

pipdeptree: ## Show the dependencies of installed packages as a tree structure
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

clean-dev: ## Force removal of the latest image
	@docker rmi -f {{ cookiecutter.project_slug }}_local_django:dev

up: ## start up the cluster locally
	@docker-compose -f ./docker-compose.yml -f ./docker-compose.override.yml up

down: ## shut down the cluster
	@docker-compose -f ./docker-compose.yml down

down-clean: ## Remove containers for services not defined in the docker-compose.yml file
	@docker-compose -f ./docker-compose.yml down --remove-orphans

shell:  ## Shell into the running Django container
	@docker-compose exec django /bin/bash

.PHONY: secure
secure:  ## Analyze dependencies for security issues
	@docker-compose exec django safety check
	#@docker-compose exec django pip-audit --desc

node:  ## Shell into the running Node container
	@docker-compose exec frontend /bin/bash

sandbox-secrets: ## Substitute with secrets template with env variable and run kubeseal
	@echo "Sealing secrets from sandbox template to $$(kubectl config current-context)"
	NAMESPACE={{cookiecutter.project_dash}}-sandbox envsubst < k8s/templates/secrets.yaml.template | kubeseal --format yaml > k8s/sandbox/secrets.yaml

prod-secrets: ## Substitute with secrets template with env variable and run kubeseal
	@echo "Sealing secrets from prod template to $$(kubectl config current-context)"
	NAMESPACE={{cookiecutter.project_dash}} envsubst < k8s/templates/secrets.yaml.template | kubeseal --format yaml > k8s/prod/secrets.yaml

argocd-app:
	envsubst < k8s/templates/argocd.application.yaml.template | kubeseal --format yaml > k8s/argocd/application.yaml
	envsubst < k8s/templates/repocreds.yaml.template | kubeseal --format yaml > k8s/argocd/repocreds.yaml
	sed -i '/spec:/ {N; s/spec:\n/  annotations:\n    sealedsecrets.bitnami.com\/managed: "true"\nspec:\n/}' k8s/argocd/repocreds.yaml

## Monitoring
check_var = $(strip $(if $(filter undefined,$(origin $1)),$(error $1 is not set)))

kube-prometheus-up:  ## Install kube-prometheus
	@$(call check_var,GRAFANA_ADMIN_PASSWORD)
	@helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	@helm repo update
	@helm install kube-prometheus prometheus-community/kube-prometheus-stack --set grafana.sidecar.datasources.isDefaultDatasource=false,grafana.persistence.enabled=true,grafana.adminPassword=$(GRAFANA_ADMIN_PASSWORD) --namespace monitoring --create-namespace

loki-up:  ## Install loki
	@helm repo add grafana https://grafana.github.io/helm-charts
	@helm repo update
	@helm install loki grafana/loki-stack --values k8s/_monitoring/loki-stack-values.yaml --namespace monitoring --create-namespace

monitoring-up: kube-prometheus-up loki-up  ## Install the monitoring stack

loki-down:  ## Uninstall loki
	helm uninstall loki --namespace monitoring

kube-prometheus-down:  ## Uninstall kube-prometheus
	helm uninstall kube-prometheus --namespace monitoring

monitoring-down: loki-down kube-prometheus-down  ## Uninstall the monitoring stack

monitoring-login:  ## Get the login credentials for the monitoring stack
	@kubectl get secret --namespace monitoring kube-prometheus-grafana -o jsonpath='{.data.admin-user}' | base64 -d; echo
	@kubectl get secret --namespace monitoring kube-prometheus-grafana -o jsonpath='{.data.admin-password}' | base64 -d; echo

monitoring-port-forward:  ## Forward the port for the monitoring stack
	kubectl --namespace monitoring port-forward svc/kube-prometheus-grafana 8080:80

monitoring-dashboard:  ## Create the dashboard for the monitoring stack
	kubectl apply -f k8s/_monitoring/django-logs-table.yaml -n monitoring

monitoring:  ## Show the status of the monitoring stack
	kubectl get all -n monitoring

## Help

help: ## Show the list of all the commands and their help text
	@awk 'BEGIN 	{ FS = ":.*##"; target="";printf "\nUsage:\n  make \033[36m<target>\033[33m\n\nTargets:\033[0m\n" } \
		/^[a-zA-Z_-]+:.*?##/ { if(target=="")print ""; target=$$1; printf " \033[36m%-10s\033[0m %s\n\n", $$1, $$2 } \
		/^([a-zA-Z_-]+):/ {if(target=="")print "";match($$0, "(.*):"); target=substr($$0,RSTART,RLENGTH) } \
		/^\t## (.*)/ { match($$0, "[^\t#:\\\\]+"); txt=substr($$0,RSTART,RLENGTH);printf " \033[36m%-10s\033[0m", target; printf " %s\n", txt ; target=""} \
		/^## .*/ {match($$0, "## (.+)$$"); txt=substr($$0,4,RLENGTH);printf "\n\033[33m%s\033[0m\n", txt ; target=""} \
	' $(MAKEFILE_LIST)

.PHONY: help build build-dev outdated pipdeptree compile destroy-data load-dump clean clean-dev squeaky_clean update check-sandbox-release check-staging-release check-prod-release

.DEFAULT_GOAL := help
