# Endjin.RecommendedPractices.Bicep

This repository hosts our library of re-useable Bicep modules.


## Design Practices

1. 'UseExisting' pattern
1. Include resource in outputs (workaround until this feature is released: [https://github.com/Azure/bicep/issues/2245]())

## Coding Standards

* The [`bicepconfig.json`](bicepconfig.json) files configures the linting rules for all templates in this repository
* Use the `#disable-next-line` directive to ignore any invalid linter errors (e.g. errors with the built-in type validation)
* Use camelCase for variable, parameter and output names
* Use snake_case for resource references
* Avoid returning secrets as output parameters
    * Use built-in ARM functions if available (e.g. getSecrets)
    * Store the required secret in Key Vault and return its `secretUriWithVersion`

Additional advice can be found here: [https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/best-practices]()

## Build Process
This repository includes an automated build process that performs the following tasks:

* Ensures all Bicep files pass the configured linting rules
* Runs the Pester-based integration tests used to validate the templates
* Optionally publishes the Bicep templates to a private Bicep registry (i.e. an Azure Container Registry)

The build can be run locally by executing the `build.ps1` script.
