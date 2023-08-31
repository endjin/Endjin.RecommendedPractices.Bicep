# acs-email-managed-domain

Azure Communication Email Service with managed Azure domain

## Description

This module provisions a top-level Azure Communication Service (ACS) resource and an Email Communication resource with a managed Azure domain, linking the domain to the ACS resource. A send-from email address is also configured for the domain, which defaults to `DoNotReply@<domain>`.

## Parameters

| Name                       | Type     | Required | Description                                                                     |
| :------------------------- | :------: | :------: | :------------------------------------------------------------------------------ |
| `communicationServiceName` | `string` | Yes      | The name of the Azure Communication Service resource.                           |
| `emailServiceName`         | `string` | Yes      | The name of the Email Communication Service resource.                           |
| `dataLocation`             | `string` | Yes      | The location where the communication and email service stores its data at rest. |
| `senderUsername`           | `string` | No       | The username for the sender email address. Defaults to "DoNotReply".            |

## Outputs

| Name                 | Type   | Description                                               |
| :------------------- | :----: | :-------------------------------------------------------- |
| domain               | string | The Azure managed domain.                                 |
| sendFromEmailAddress | string | The send-from email address for the Azure managed domain. |

## Examples

### Deploy ACS email service with data storage in the UK

```bicep
module acs_email 'br:<registry-fqdn>/bicep/general/acs-email:<version>' = {
  name: 'acsEmailDeploy'
  params: {
    communicationServiceName: 'myacsservice'
    emailServiceName: 'myacsemailservice'
    dataLocation: 'UK'
  }
}
```