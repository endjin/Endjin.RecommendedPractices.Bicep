[CmdletBinding()]
param (
    # The Resource Group for the ACR resource
    [Parameter()]
    [string] $ResourceGroupName,

    # location of the Azure Resource Group
    [Parameter()]
    [string] $Location,

    # Parameter help description
    [Parameter()]
    [string] $AcrName
)

New-AzResourceGroup -Name $ResourceGroupName -Location $Location

New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile ./acr.bicep -acrName $AcrName