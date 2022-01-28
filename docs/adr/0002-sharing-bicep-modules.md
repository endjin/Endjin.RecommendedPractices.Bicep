# Choosing an approach for sharing Bicep modules

## Status

Draft

## Context

Bicep is a domain-specific language (DSL) that simplifies Azure resource deployment. The benefits of using Bicep to create templates for Azure resources include:

1. Simpler syntax: Bicep is more concise and easier to read than ARM templates
2. Dependency management: In most situations, Bicep detects dependencies between resources
3. Azure-native tooling: Bicep tooling integrates well with Azure ecosystem. There is also a Visual Studio Code to improve the developer experience, providing IntelliSense and linting.
4. Templates can be broken down into smaller modules files and referenced in a main template allowing greater re-usability.

As we adopt Bicep and encourage clients to also adopt Bicep to streamline resource provisioning, we want to a way of re-using and sharing templates.

The problem is that as of January 24th 2022, there is not a standardized way of sharing Bicep modules as you would with source code packaged and distributed in a registry such as [npm](https://www.npmjs.com/) and [NuGet](https://www.nuget.org/). To consume a Bicep module remotely you would have to register your templates in a private Azure Container Registry.

### Experience using Azure Container Registry (ACR)

**Publishing, Consuming, and Modifying modules**

**Discoverability (naming modules):**

Although you can see the modules in the ACR there is no immediate way of discovering what is in the module.

With the proposed Bicep registry, what will the gallery experience be like? There are plans to auto-generate a `README` file that shows the Bicep modules "schema", will this be view-able in the registry or will we have to download the module locally and inspect the `README`?

With the ACR, there is no way of identifying what is inside a module. This is _OK_ if we are the owners of the module (if we name it correctly) but how about new users. 

* How can we include information about the module in a private ACR? 
* Will we need to have documentation separate from the ACR? 
* Would we have a private Git repo that hosts a copy of the modules remotely?

In my experience registering templates to the ACR, I was unsure of the correct naming path for modules. This raises a few questions:

* Should modules be grouped by resource or by project? 
* Do we use the suggestions from [Azure Cloud Adoption Framework](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
* How do we organize low level templates? 

**Consuming**

Pointing to a remote Bicep module in an ACR is almost identical to referencing a local module.  We saw that consuming a published module that reference a local template has the dependencies resolved in the transpiled `*.json` ARM template. The benefit of referencing a remote module is that they can be versioned with tags. A similar thing can be achieved locally with source control though less explicit.


**Modifications**


To modify a template that is in the ACR, you would have to change the module path for all references to the module to a local path. Aliases help with simplifying the path for linking to modules. We also considered whether we could use aliases to refer to local and remote (either ACR or public Bicep registry) modules?


## Decision

With the upcoming `v0.5` release of Bicep, we will be able to share Bicep modules using the native public module registry. Therefore we have chosen to Bootstrap off the Bicep tooling as much as possible and compliment where

The proposed naming convention is no different to referencing private Bicep registries.

We considered alternative options such as sharing Bicep templates in a public repository but found the problem of consuming remote artefacts; to do that we would have to store every artefact we want to refer to locally and use relative paths to refer to them. Another alternative we considered was packaging Bicep modules as NuGet packages like this [NuGet example](https://www.nuget.org/packages/devdeer.Templates.Bicep/1.1.2). An advantage over the previous Git-based solution is that we could sign and verify our packages. Unfortunately the overhead of referring to local artefact remains the same. 


## Consequences

The addition of a public repository means that we can share Bicep modules without the overhead of having to have a local copy of the modules and referring to them with relative paths.

Sharing public artefacts and hosting private artefacts will be similar as they both use container registries. This unifies the developer experience of managing Bicep modules. The naming convention for modules registered under the public repository is also similar to a private Azure Container Registry path.

Adopting the Bicep tooling may also provide automatic `README.md` generation and `diagram.svg` to visualise the Bicep module relationship graph.


As the Bicep registry has yet to be released, we still have to find a solution for sharing public modules. We want it to follow the OCI standard as it should make transitioning to the Bicep registry easier (whenever that happens).

### Further investigation

A collection of ideas to follow up on:


Mono repo of all templates or package Bicep template with the respective project i.e. Marain specific packages with Marain should general purpose, low level modules should go in the recommended practices.

- [ ] The local workflow for creating or updating an existing Bicep template.
- [ ] Metadata around each template file (template file preview)
- [ ] Test if we can use GitHub package registry.
- [ ] Investigate local docker images
    - [ ] Dev workflow: local registry, alias, publishing
- [ ] Investigate [OCI Image](https://github.com/opencontainers/image-tools) tooling
- [ ] Module alias for pointing to local file path
- [x] Module referencing local files and try using the published version
