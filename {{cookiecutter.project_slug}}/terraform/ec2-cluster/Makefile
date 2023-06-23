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
	sed -i 's/127.0.0.1/$(INSTANCE_IP)/' ~/.kube/{{cookiecutter.project_slug}}.ec2.config
	sed -i 's/default/{{cookiecutter.project_slug}}-ec2-cluster/' ~/.kube/{{cookiecutter.project_slug}}.ec2.config
	export KUBECONFIG=~/.kube/{{cookiecutter.project_slug}}.ec2.config
	kubectl config use-context {{cookiecutter.project_slug}}-ec2-cluster
	# do not apply cloudconfig in sandbox
	# kubectl apply -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.20/releases/cnpg-1.20.0.yaml
	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml
	kubectl apply -f config.yml

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
	kubectl delete secret regcred -n {{cookiecutter.project_slug}} --ignore-not-found
	kubectl delete secret regcred -n {{cookiecutter.project_slug}}-sandbox --ignore-not-found
	kubectl create secret docker-registry regcred -n {{cookiecutter.project_slug}} \
		--docker-server={{cookiecutter.aws_account_id}}.dkr.ecr.{{cookiecutter.aws_region}}.amazonaws.com \
		--docker-username=AWS \
		--docker-password=$(shell aws ecr get-login-password)
	kubectl create secret docker-registry regcred -n {{cookiecutter.project_slug}}-sandbox \
		--docker-server={{cookiecutter.aws_account_id}}.dkr.ecr.{{cookiecutter.aws_region}}.amazonaws.com \
		--docker-username=AWS \
		--docker-password=$(shell aws ecr get-login-password)