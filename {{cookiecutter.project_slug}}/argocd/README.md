# Kubernetes Control Plane

## ArgoCD

An ArgoCD application will automate your kubernetes deployments.

Install [ArgoCD CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/).

Log in to the sixfeetup dashboard

    $ argocd login argocd.sixfeetup.com

Find your cluster context (set your KUBECONFIG file if neccessary)

    $ kubectl config get-contexts -o name

Add your cluster to ArgoCD. This will also output the `CLUSTER_IP` you will use in the application.

    $ argocd cluster add CLUSTER_NAME


If you are working in the SFU enviornment move your application manifest to `sixfeetup/controlplane.git/argocd/applications/{{cookiecutter.project_slug}}/application.yaml`

```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: PROJECT_NAME                                        # the application name, you will need a separate application for prod and sandbox
  namespace: argocd
spec:
  project: default
  source:
    repoURL: git@bitbucket.org:sixfeetup/PROJECT_NAME.git
    targetRevision: HEAD
    path: deploy/ENVIRONMENT                                # this is the path ArgoCD will watch for changes
  destination:
    server: CLUSTER_IP:6443                                 # this is the access to your cluster
    namespace: PROJECT_NAME                                 # the namespace of your project on your cluster
  syncPolicy:
    automated:
      prune: true
    syncOptions:
    - CreateNamespace=true
```

Create a deploy key for your repository and add it to SealedSecrets.
Add your repository deploy key in `argocd/applications/PROJECT_NAME/repocreds.yaml`

```
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: deploy-key
  namespace: argocd
spec:
  encryptedData:
    sshPrivateKey: ENCRYPTED_PRIVATE_KEY                    # encrypted value from SealedSecret
  template:
    metadata:
      labels:
        argocd.argoproj.io/secret-type: repository
      name: deploy-key
      namespace: argocd
```


Apply the manifests

    $ kubectl apply -f argocd/applications/PROJECT_NAME

Your ArgoCD application should be visible on the dashboard at https://argocd.sixfeetup.com. Check the repository and cluster connection.