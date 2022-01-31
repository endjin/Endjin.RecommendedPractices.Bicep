# Choosing an approach for sharing Bicep modules

## Status

Draft

## Context

Bicep is a domain-specific language (DSL) that simplifies the deployment and management of Azure resources. The benefits of using Bicep for managing Azure resources include:

1. Simple syntax: Bicep is more concise and easier to read than the equivalent JSON template. 
2. Dependency management: In most situations, Bicep detects dependencies between resources and orchestrates deployment of coupled resources in the correct order.
3. Azure-native tooling: Bicep tooling integrates well with the Azure ecosystem. There is also a Visual Studio Code extension to improve the developer experience, providing IntelliSense and linting.
4. Re-use: Templates can be broken down into smaller module files and referenced in a main template allowing for greater re-usability.

As we adopt Bicep to streamline resource provisioning, we want to define a way of re-using and sharing templates.

The problem is that as of January 24th 2022, there is no standardized way of sharing Bicep modules as you would with source code packaged and distributed in a registry such as [npm](https://www.npmjs.com/) or [NuGet](https://www.nuget.org/). To consume a Bicep module remotely you would have to register your templates in a private Azure Container Registry.

### Experience using Azure Container Registry (ACR)


**Discoverability (naming modules):**

With the ACR, there is no way of identifying what is inside a module. This is OK if we are the owners of the module: if we have intuitive module path names and have external documentation, but how about new users?

* How can we include information about the module in a private ACR? 
* Will we need to have documentation separate from the ACR?
* How can we couple this to the module?

In our experience registering templates to the ACR, we were unsure of the correct naming path for organizing modules. This raises a few questions:

* Should modules be grouped by resource or by project? 
* Do we use the suggestions from [Azure Cloud Adoption Framework](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
* How do we organize low level templates? 

**Consuming**

Pointing to a remote Bicep module in an ACR is almost identical to referencing a local module. Consuming a published module that references a local template has dependencies resolved in the transpiled `*.json` ARM template. The benefit of referencing a remote module is that they can be versioned with tags. A similar thing can be achieved locally with source control though less explicit.

**Modifications**

For modifying a template that is in the ACR without publishing changes can be achieved by referencing a local copy of the template. Aliases help with simplifying the path for linking to modules. Could we use aliases to distinguish between local and remote registries to improve the dev workflow?

## Decision

With the upcoming `v0.5` release of Bicep, we will be able to share modules using the native public Bicep registry. Therefore we have chosen to bootstrap off the Bicep tooling as much as possible and compliment our workflow where features have yet to be released.

We considered alternative options such as sharing Bicep templates in a public Git repository but found the problem of consuming remote artefacts; to do that we would have to store every artefact we want to refer to locally and use relative local paths to refer to them. 

Another alternative we considered was packaging Bicep modules as NuGet packages like this [NuGet example](https://www.nuget.org/packages/devdeer.Templates.Bicep/1.1.2). An advantage over the previous Git-based solution is that we could sign and verify our packages. Unfortunately the overhead of referring to local artefacts remains the same. 


## Consequences

The introduction of a public Bicep repository means that we can share Bicep modules without the overhead of requiring a local copy of the modules and referring to them with relative paths.

Sharing public artefacts and hosting private artefacts will be similar as they both use container registries. This unifies the developer experience of managing Bicep modules. The naming convention for modules registered under the public repository is also similar to a private Azure Container Registry path.

Adopting the Bicep tooling for `v0.5` may also provide automatic `README.md` generation and `diagram.svg` to visualise the Bicep module relationship graph.

As the public Bicep registry has yet to be released, we still have to find a solution for sharing public modules. Ideally it would follow the OCI standard as it would make transitioning to the Bicep registry easier (whenever that happens). A potential candidate was GitHub packages. Unfortunately, after experimenting with the GitHub container registry, we discovered that non-Azure Container registries are [not supported](https://github.com/Azure/bicep/issues/4884).

### Further investigation

A collection of ideas to follow up on:

- [ ] The local workflow for creating or updating an existing Bicep template.
- [ ] Metadata around each template file (template file preview)
- [ ] Investigate local docker images
    - [ ] Dev workflow: local registry, alias, publishing
- [ ] Investigate [OCI Image](https://github.com/opencontainers/image-tools) tooling
- [ ] Module alias for pointing to local file path
- [x] Module referencing local files and try using the published version
