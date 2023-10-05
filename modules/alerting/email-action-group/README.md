# Email Action Group

Azure Action Group for sending email notifications

## Description

Deploys an Azure Action Group that can be used to send alerts to one or more e-mail addresses.

## Parameters

| Name                   | Type     | Required | Description                                                        |
| :--------------------- | :------: | :------: | :----------------------------------------------------------------- |
| `name`                 | `string` | Yes      | The name of the action group                                       |
| `shortName`            | `string` | Yes      | The short name of the action group                                 |
| `enabled`              | `bool`   | No       | When true, the action group is enabled and will send notifications |
| `notifyEmailAddresses` | `array`  | Yes      | The email addresses to notify                                      |

## Outputs

| Name     | Type   | Description                                      |
| :------- | :----: | :----------------------------------------------- |
| id       | string | The resource ID of the action group              |
| name     | string | The name of the action group                     |
| resource | object | An object representing the action group resource |

## Examples

### Example Usage

```bicep
module action_group 'br:<registry-fqdn>/bicep/alerting/email-action-group:<version>' = {
  name: 'EmailActionGroupDeploy'
  params: {
    name: 'App Support Team'
    notifyEmailAddresses: [
      'opsteam@nowhere.org'
      'developers@nowehere.org'
      'security@nowehere.org'
    ]
    shortName: 'ops-team'
  }
}
```