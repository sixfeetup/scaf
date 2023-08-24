# Controlplane

ArgoCD and SealedSecrets are configured on the SFU controlplane.
If you are not using the SFU controlplane you can set up your own controlplane on the EC2 instance using the makefile command

```
make controlplane_config
```