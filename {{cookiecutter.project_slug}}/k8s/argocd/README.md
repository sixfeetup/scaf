# Kubernetes Control Plane

## ArgoCD

An ArgoCD application will automate your kubernetes deployments.

Install [ArgoCD CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/).

Log in to your ArgoCD dashboard, eg

    $ argocd login argocd.sixfeetup.com

Find your cluster context (set your KUBECONFIG file if neccessary)

    $ kubectl config get-contexts -o name

Add your cluster to ArgoCD. This will also output the `CLUSTER_IP` you will use in the application.

    $ argocd cluster add {{ cookiecutter.project_slug }}-ec2-cluster

### Creating the ArgoCD application manifests

Export the cluster IP from ArgoCD to your environment

    $ export CLUSTER_IP=CLUSTER_IP

Create a deploy key for your repository export it to your environment as `SSH_PRIVATE_KEY`.

    $ export SSH_PRIVATE_KEY=DEPLOY_KEY

Export your repository url to your environment

    $ export REPO_URL=PROJECT_REPOSITORY

Create the `application.yaml` manifest and `repocred.yaml` secret and seal it

    $ make argocd-app

If you are working in the SFU environment move your application and repocreds manifest to `sixfeetup/controlplane.git/argocd/applications/{{ cookiecutter.project_slug }}/`

Apply the manifests

    $ kubectl apply -f argocd/applications/{{ cookiecutter.project_slug }}

Your ArgoCD application should be visible on the ArgoCD dashboard. Check the repository and cluster connection.
