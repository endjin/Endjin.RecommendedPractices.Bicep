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

## Adding a new module

1. Clone the repo.
1. Create and checkout a new feature branch.
1. Run the `build.ps1` script.
    - This will validate you have the correct versions of the Bicep CLI and Bicep Registry Module (BRM) tooling.
    - If you do not have the correct version of the Bicep CLI, you will need to manually update to the correct version.
1. Create a new folder for the module in the `modules` folder
    - If it is a general purpose module, the module should go under the `general` subfolder.
    - If it is an opinionated module, the module should go under the `opinions` subfolder.
1. In the terminal, set the working directory to the new module folder and run `brm generate`
    - This will scaffold the new files required for the module
    - The file structure will be:
        - `test`
            - `main.test.bicep`
            - `main.test.json`
        - `main.bicep`
        - `main.json`
        - `metadata.json`
        - `README.md`
        - `version.json`

1. Fill in the properties in the `metadata.json` file.
1. Add a version (in `major.minor` format) in the `version.json` file. Initial version should be `1.0` unless there a strong reason to set it otherwise.
1. Add the parameters/variables/resources/outputs to the `main.bicep` file. 
    - Note: you can reference other modules using relative paths.
    - Ensure that all parameters and outputs have description attributes.
1. Add tests to the `main.test.bicep` file
    - The resources in this file are expected to be deployed successfully as part of running the test suite.
    - Instantiate the module with as many combinations of parameters as are necessary to test the module's functionality.
1. Run the `build.ps1` script
    - This will compile the ARM templates from the Bicep files and validate the files.
    - If the build shows any errors, make any necessary changes and repeat.
1. The `README.md` will be partially auto-generated based on the `main.bicep` and `metadata.json` files.
    - Fill in the `Description` and `Examples` sections of the README manually.
1. Commit the changes and push up the branch.
1. Open a pull request with the changes.
