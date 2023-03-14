{% if azure_devops_pipeline.enable %}
trigger:
  batch: true
  branches:
    include:
      - main
  tags:
    include:
      - "*"
{% raw %}
variables:
  - ${{ if eq(variables['Build.SourceBranch'], 'refs/heads/main') }}:
      - name: environment
        value: development
  - ${{ if startsWith(variables['Build.SourceBranch'], 'refs/tags/') }}:
      - name: environment
        value: production
{% endraw %}
pool:
  vmImage: ubuntu-latest

stages:
  - stage: validate
    displayName: validate
    jobs:
      - job: validate
        displayName: validate
        variables: # vars from azure devOps in library
          - group: {{ azure_devops_pipeline.library_group }}
{% raw %}
        steps:
          - checkout: self
          - script: |
              terraform -chdir=platform init
              terraform -chdir=platform workspace select ${{ variables.environment }}
              terraform -chdir=platform validate
            name: "ValidateTerraform"
            displayName: "Validate Terraform"
            env:
              ARM_CLIENT_ID: $(ARM_CLIENT_ID)
              ARM_CLIENT_SECRET: $(ARM_CLIENT_SECRET)
              ARM_TENANT_ID: $(ARM_TENANT_ID)
              ARM_SUBSCRIPTION_ID: $(ARM_SUBSCRIPTION_ID)
{% endraw %}
  - stage: plan
    displayName: plan
    jobs:
      - job: plan
        displayName: plan
        variables: # vars from azure devOps in library
          - group: {{ azure_devops_pipeline.library_group }}
{% raw %}
        steps:
          - checkout: self
          - script: |
              mkdir -p platform/build
              terraform -chdir=platform init
              terraform -chdir=platform workspace select ${{ variables.environment }}
              terraform -chdir=platform plan -var-file=${{ variables.environment }}/terraform.tfvars -out=$(Build.SourceVersion).plan
              cp platform/$(Build.SourceVersion).plan platform/build/
            name: "PlanTerraform"
            displayName: "Terraform Plan"
            env:
              ARM_CLIENT_ID: $(ARM_CLIENT_ID)
              ARM_CLIENT_SECRET: $(ARM_CLIENT_SECRET)
              ARM_TENANT_ID: $(ARM_TENANT_ID)
              ARM_SUBSCRIPTION_ID: $(ARM_SUBSCRIPTION_ID)
          - publish: $(Build.SourcesDirectory)/platform/build
            artifact: $(Build.SourceVersion).plan
{% endraw %}
  - stage: apply
    jobs:
      - deployment: ApplyTerraform
        displayName: "Terraform Apply"
        variables: # vars from azure devOps in library
          - group: {{ azure_devops_pipeline.library_group }}
        # creates an environment if it doesn't exist
{% raw %}
        environment: ${{ variables.environment }}
        strategy:
          runOnce:
            deploy:
              steps:
                - checkout: self
                - download: current
                  artifact: $(Build.SourceVersion).plan
                - script: |
                    cp $(Pipeline.Workspace)/$(Build.SourceVersion).plan/$(Build.SourceVersion).plan platform/
                    terraform -chdir=platform init
                    terraform -chdir=platform workspace select ${{ variables.environment }}
                    terraform -chdir=platform apply $(Build.SourceVersion).plan
                  name: "ApplyTerraform"
                  displayName: "Terraform Apply"
                  env:
                    ARM_CLIENT_ID: $(ARM_CLIENT_ID)
                    ARM_CLIENT_SECRET: $(ARM_CLIENT_SECRET)
                    ARM_TENANT_ID: $(ARM_TENANT_ID)
                    ARM_SUBSCRIPTION_ID: $(ARM_SUBSCRIPTION_ID)
{% endraw %}
{% endif %}
