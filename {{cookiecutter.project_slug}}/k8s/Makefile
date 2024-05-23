envrc:
	AWS_PROFILE=docker-desktop envsubst < templates/envrc.template > overlays/local/.envrc
	AWS_PROFILE={{ cookiecutter.project_slug }} envsubst < templates/envrc.template > overlays/prod/.envrc
	AWS_PROFILE={{ cookiecutter.project_slug }} envsubst < templates/envrc.template > overlays/sandbox/.envrc

local/secrets.yaml:
	@echo "Check the README.md file to create the secrets for local setup in the Application Secrets section."

prod/secrets.yaml:
	source overlays/prod/.envrc && envsubst < templates/secrets.yaml.template | kubeseal --format=yaml > overlays/prod/secrets.yaml

sandbox/secrets.yaml:
	source overlays/sandbox/.envrc && envsubst < templates/secrets.yaml.template | kubeseal --format=yaml > overlays/sandbox/secrets.yaml

kubecreds:
	aws sso login --profile={{ cookiecutter.project_slug }}
	aws ecr get-login-password --region {{ cookiecutter.aws_region }} | docker login --username AWS \
		--password-stdin {{ cookiecutter.aws_account_id }}.dkr.ecr.{{ cookiecutter.aws_region }}.amazonaws.com
	kubectl delete secret regcred -n {{ cookiecutter.project_dash }}-prod --ignore-not-found
	kubectl delete secret regcred -n {{ cookiecutter.project_dash }}-sandbox --ignore-not-found
	kubectl create secret docker-registry regcred -n {{ cookiecutter.project_dash }}-prod \
		--docker-server={{ cookiecutter.aws_account_id }}.dkr.ecr.{{ cookiecutter.aws_region }}.amazonaws.com \
		--docker-username=AWS \
		--docker-password=$(shell aws ecr get-login-password)
	kubectl create secret docker-registry regcred -n {{ cookiecutter.project_dash }}-sandbox \
		--docker-server={{ cookiecutter.aws_account_id }}.dkr.ecr.{{ cookiecutter.aws_region }}.amazonaws.com \
		--docker-username=AWS \
		--docker-password=$(shell aws ecr get-login-password)
