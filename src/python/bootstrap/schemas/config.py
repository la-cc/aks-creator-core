from schema import Schema, Optional

config_schema = Schema({

    Optional("azure_backend"): {
        Optional("enable"): bool,
        Optional("resource_group_name_backend"): str,
        Optional("storage_account_name"): str,

    },

    "clusters": [
        {
            "name": str,
            "stage": str,
            Optional("azure_public_dns"): {
                Optional("enable", default=False): bool,
                Optional("azure_cloud_zone"): str,
            },
            # default node-pool
            Optional("node_pool_count", default=3): int,
            Optional("vm_size", default="Standard_B4ms"): str,
            Optional("kubernetes_version", default="1.24.9"): str,
            Optional("orchestrator_version", default="1.24.9"): str,
            # additional node-pools
            Optional("node_pools"): {
                Optional("enable_node_pools"): bool,
                Optional("pool"): [
                    {
                        Optional("name"): str,
                        Optional("min_count"): int,
                        Optional("max_count"): int,
                        Optional("node_count"): int,
                    }
                ]
            }
        }
    ],

    Optional("azure_devops_pipeline"): {
        Optional("enable"): bool,
        Optional("library_group"): str,

    }
})
