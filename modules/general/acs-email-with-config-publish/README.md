# acs-email-managed-domain-with-published-config

Azure Communication Email Service with managed Azure domain, with published configuration

## Details

This module provisions a top-level Azure Communication Service (ACS) resource and an Email Communication resource with a managed Azure domain, linking the domain to the ACS resource. A send-from email address is also configured for the domain, which defaults to `DoNotReply@<domain>`.

The ACS key, ACS connection string, the email domain, and the send-from email address are published into the specified Key Vault.

## Parameters

| Name                        | Type     | Required | Description                                                                                                                                                                  |
| :-------------------------- | :------: | :------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `communicationServiceName`  | `string` | Yes      | The name of the Azure Communication Service resource.                                                                                                                        |
| `emailServiceName`          | `string` | Yes      | The name of the Email Communication Service resource.                                                                                                                        |
| `dataLocation`              | `string` | Yes      | The location where the communication and email service stores its data at rest.                                                                                              |
| `senderUsername`            | `string` | No       | The username for the sender email address. Defaults to "DoNotReply".                                                                                                         |
| `keyVaultName`              | `string` | Yes      | The name of the key vault where the configuration will be published                                                                                                          |
| `keyVaultResourceGroupName` | `string` | No       | The resource group of the key vault where the configuration will be published                                                                                                |
| `keyVaultSubscriptionId`    | `string` | No       | The subscription of the key vault where the configuration will be published                                                                                                  |
| `enableDiagnostics`         | `bool`   | No       | If true, enable diagnostics on the workspace (`logAnalyticsWorkspaceId` must also be set).                                                                                   |
| `logAnalyticsWorkspaceId`   | `string` | No       | When `enableDiagnostics` is true, the workspace ID (resource ID of a Log Analytics workspace) for a Log Analytics workspace to which you would like to send Diagnostic Logs. |

## Outputs

| Name                   | Type     | Description                                               |
| :--------------------- | :------: | :-------------------------------------------------------- |
| `domain`               | `string` | The Azure managed domain.                                 |
| `sendFromEmailAddress` | `string` | The send-from email address for the Azure managed domain. |

## Examples

### Deploy ACS email service with data storage in the UK and publish config to Key Vault

```bicep
module acs_email_with_config_publish 'br:<registry-fqdn>/bicep/general/acs-email-with-config-publish:<version>' = {
  name: 'acsEmailDeploy'
  params: {
    communicationServiceName: 'myacsservice'
    emailServiceName: 'myacsemailservice'
    dataLocation: 'UK'
    keyVaultName: 'mykeyvault'
  }
}
```