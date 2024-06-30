.terraform.lock.hcl: 
	terraform init

init: .terraform.lock.hcl

plan:
	@echo "======================================================================="
	@echo "IMPORTANT: Please make sure that you are on the VPN before you continue"
	@echo "======================================================================="
	terraform plan -out="tfplan.out"
	@terraform show -no-color tfplan.out >> .terraform/tfplan-$$(date +%Y%m%d-%H%M%S).log

tfplan.out: plan

apply: tfplan.out
	# TODO: Add check to see if you are on the VPN 
	tofu apply "tfplan.out"

kubeconfig:
	tofu output -raw kubeconfig > ./kubeconfig

remove-kube-state:
	rm -f kubeconfig
	tofu state rm helm_release.argocd \
		kubernetes_namespace.monitoring || true

# TODO: add cookiecutter.use_talos check for talos targets
talosconfig:
	tofu output -raw talosconfig > ./talosconfig

remove-talos-state:
	rm -f talosconfig
	tofu state rm data.talos_client_configuration.this \
		data.talos_cluster_kubeconfig.this || true

talos-health:
	@echo "Fetching Talos node public IPs..."
	@ips=$$(tofu output talos_node_public_ips | tr -d '"') ; \
	first_ip=$$(echo $$ips | cut -d',' -f1) ; \
	echo "Running health check on Talos node at IP: $$first_ip" ; \
	talosctl health --nodes $$first_ip

talos-version:
	@echo "Fetching Talos node public IPs..."
	@ips=$$(tofu output talos_node_public_ips | tr -d '"') ; \
	IFS=',' read -r -a ip_array <<< "$$ips" ; \
	for ip in $${ip_array[@]} ; do \
		talosctl --nodes $$ip version --short ; \
	done

upgrade-talos:
	@echo "Fetching Talos node public IPs..."
	@ips=$$(tofu output talos_node_public_ips | tr -d '"') ; \
	IFS=',' read -r -a ip_array <<< "$$ips" ; \
	for ip in $${ip_array[@]} ; do \
		echo "Upgrading Talos node at IP: $$ip" ; \
		talosctl upgrade --nodes $$ip \
		--image factory.talos.dev/installer/10e276a06c1f86b182757a962258ac00655d3425e5957f617bdc82f06894e39b:v1.7.4 ; \
	done

destroy: remove-kube-state remove-talos-state
	tofu destroy

