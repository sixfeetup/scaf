generate-tfvars:
	terraform apply -refresh-only -auto-approve
	bin/generate-tfvars

key-pair:
	ssh-keygen -t ED25519 -f ~/.ssh/{{cookiecutter.project_slug}}_default_key -N ""

plan:
	terraform plan

deploy:
	terraform apply -auto-approve

INSTANCE_IP :=  $(shell ./bin/ip | sed 's/"//g')

config:
	ssh -oStrictHostKeyChecking=no -i ~/.ssh/{{cookiecutter.project_slug}}_default_key \
		ubuntu@$(INSTANCE_IP) \
		'curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--tls-san $(INSTANCE_IP)" K3S_KUBECONFIG_MODE="644" sh -s -'
	ssh -oStrictHostKeyChecking=no -i ~/.ssh/{{cookiecutter.project_slug}}_default_key \
		ubuntu@$(INSTANCE_IP) cat /etc/rancher/k3s/k3s.yaml \
		> ~/.kube/{{cookiecutter.project_slug}}.ec2.config
	sed -ie 's/127.0.0.1/$(INSTANCE_IP)/' ~/.kube/{{cookiecutter.project_slug}}.ec2.config
	sed -ie 's/default/{{cookiecutter.project_slug}}-ec2-cluster/' ~/.kube/{{cookiecutter.project_slug}}.ec2.config
	export KUBECONFIG=~/.kube/{{cookiecutter.project_slug}}.ec2.config
	kubectl config get-contexts
	kubectl config use-context {{cookiecutter.project_slug}}-ec2-cluster
	# do not apply cloudconfig in sandbox
	# kubectl apply -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.20/releases/cnpg-1.20.0.yaml
	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.yaml
	kubectl apply -f config.yml

controlplane_config:
	export KUBECONFIG=~/.kube/{{cookiecutter.project_slug}}.ec2.config
	kubectl config use-context {{cookiecutter.project_slug}}-ec2-cluster
	kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.23.0/controller.yaml
	kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl apply -f controlplane_config.yml
	kubectl -n argocd rollout restart deployment argocd-server

ssh:
	./bin/ssh

show-ip:
	@./bin/ip

destroy:
	terraform destroy

kubecreds:
	aws sso login --profile={{cookiecutter.project_slug}}
	aws ecr get-login-password --region {{cookiecutter.aws_region}} | docker login --username AWS \
		--password-stdin {{cookiecutter.aws_account_id}}.dkr.ecr.{{cookiecutter.aws_region}}.amazonaws.com
	kubectl delete secret regcred -n {{cookiecutter.project_dash}} --ignore-not-found
	kubectl delete secret regcred -n {{cookiecutter.project_dash}}-sandbox --ignore-not-found
	kubectl create secret docker-registry regcred -n {{cookiecutter.project_dash}} \
		--docker-server={{cookiecutter.aws_account_id}}.dkr.ecr.{{cookiecutter.aws_region}}.amazonaws.com \
		--docker-username=AWS \
		--docker-password=$(shell aws ecr get-login-password)
	kubectl create secret docker-registry regcred -n {{cookiecutter.project_dash}}-sandbox \
		--docker-server={{cookiecutter.aws_account_id}}.dkr.ecr.{{cookiecutter.aws_region}}.amazonaws.com \
		--docker-username=AWS \
		--docker-password=$(shell aws ecr get-login-password)
