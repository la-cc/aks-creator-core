# Configuration Options

The following examples show the possible configuration of the templating. The used module itself can be further adjusted or overwritten.

## Minimum necessary configuration

```
---
# Azure Backend for Terraform related data
azure_backend: {}

# Azure Kubernetes Cluster related data
clusters:
  - name: <valiant>
    stage: <development>
    node_pools: {}
```

## Maximum possible configuration:

```
---
# Azure Backend for Terraform related data
azure_backend:
  enable: true
  resource_group_name_backend: <"rg-tfstate-backend-example">
  storage_account_name: <"satfstatebackendexample">

# Azure Kubernetes Cluster related data
clusters:
  - name: <valiant>
    stage: <development>
    azure_public_dns:
      enable: true
      azure_cloud_zone: <"your-domain.de">
    node_pool_count: <3>
    vm_size: <"Standard_B4ms">
    kubernetes_version: <"1.24.9">
    orchestrator_version: <"1.24.9">
    node_pools:
      enable_node_pools: true
      pool:
        - name: <"internal">
          min_count: <1>
          max_count: <3>
          node_count: <2>

```
