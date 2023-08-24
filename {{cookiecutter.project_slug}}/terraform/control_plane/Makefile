controlplane_config:
	export KUBECONFIG=~/.kube/{{cookiecutter.project_slug}}.ec2.config
	kubectl config use-context {{cookiecutter.project_slug}}-ec2-cluster
	kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.23.0/controller.yaml
	kubectl apply -f controlplane_config.yml
