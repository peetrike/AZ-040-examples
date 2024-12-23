﻿<#
    .SYNOPSIS
        Learning Path 9 samples
    .DESCRIPTION
        This file contains sample commands from course AZ-040 for
        Learning Path 9 - Managing Azure resources with PowerShell
    .LINK
        https://learn.microsoft.com/training/paths/manage-cloud-resources-use-windows-powershell/
    .LINK
        https://learn.microsoft.com/training/modules/automate-azure-tasks-with-powershell/
    .LINK
        https://github.com/peetrike/AZ-040-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23AZ-040+%23M9
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Module 1: Azure PowerShell

#region Azure PowerShell overview

# https://learn.microsoft.com/powershell/azure/what-is-azure-powershell

#endregion

#region What is the Azure Az PowerShell module?

# https://learn.microsoft.com/powershell/azure/new-azureps-module-az
# https://learn.microsoft.com/powershell/azure/release-notes-azureps

Find-PSResource az -Repository PSGallery
Find-PSResource az -Repository PSGallery -IncludeDependencies | Measure-Object

# https://learn.microsoft.com/powershell/azure/migrate-from-azurerm-to-az


#endregion

#region Installing the Azure Az PowerShell module

# https://learn.microsoft.com/powershell/azure/install-az-ps

Find-PSResource -Command Connect-AzAccount -Repository PSGallery
Find-PSResource Az.Accounts -Repository PSGallery

docker.exe search azuresdk/azure-powershell

# https://learn.microsoft.com/powershell/azure/authenticate-azureps
Get-Help Connect-AzAccount -ShowWindow

(Get-Help Connect-AzAccount).examples.example[6]

#endregion

#region Migrate Azure PowerShell from AzureRM to Az

Find-PSResource Az.Tools.Migration -Repository PSGallery

# https://learn.microsoft.com/powershell/azure/quickstart-migrate-azurerm-to-az-automatically

# https://marketplace.visualstudio.com/items?itemName=azps-tools.azps-tools

#endregion

#region What are the Azure Active Directory management modules for PowerShell?

Find-PSResource Az.Resources -Repository PSGallery
# https://learn.microsoft.com/powershell/module/az.resources#active-directory

# https://learn.microsoft.com/powershell/microsoftgraph/overview
Find-PSResource Microsoft.Graph -Repository PSGallery
Find-PSResource Microsoft.Graph -Repository PSGallery -IncludeDependencies | Measure-Object

# https://learn.microsoft.com/powershell/microsoftgraph/migration-steps

Get-Help Connect-MgGraph -ShowWindow
# https://learn.microsoft.com/powershell/microsoftgraph/app-only

#endregion

#endregion


#region Module 2: Introduce Azure Cloud Shell

#region Cloud Shell overview

# https://learn.microsoft.com/azure/cloud-shell/overview

# https://shell.azure.com/

# https://marketplace.visualstudio.com/items?itemName=ms-vscode.azure-account

# https://learn.microsoft.com/azure/cloud-shell/pricing

#endregion

#region Features and tools for Azure Cloud Shell

# https://learn.microsoft.com/azure/cloud-shell/features

# https://shell.azure.com/powershell
# https://learn.microsoft.com/learn/modules/introduction-to-powershell/3-exercise-powershell

#endregion

#endregion


#region Module 3: Manage Azure resources with PowerShell

#region Creating Azure VMs with PowerShell

# https://learn.microsoft.com/azure/virtual-machines/windows/quick-create-powershell

Find-PSResource Az.Resources -Repository PSGallery
Get-Command -Noun AzResourceGroup
Get-Help New-AzResourceGroup -ShowWindow

Find-PSResource Az.Compute -Repository PSGallery
Get-Command -Noun AzVM, AzVMConfig
Get-Help New-AzVM -ShowWindow

Get-Command -Noun AzVMOperatingSystem
Get-Help Set-AzVMOperatingSystem
Get-Command -Noun AzVMSourceImage
Get-Help Set-AzVMSourceImage
Get-Command -Noun AzVMNetworkInterface
Get-Help Set-AzVMSourceImage
Get-Command -Noun AzVMOSDisk
Get-Help Set-AzVMOSDisk

Get-Command Invoke-AzVMRunCommand
Get-Help Invoke-AzVMRunCommand

Find-PSResource Az.Network -Repository PSGallery
Get-Command -Noun AzPublicIpAddress
Get-Help Get-AzPublicIpAddress

# https://github.com/Azure/azure-docs-powershell-samples/tree/master/virtual-machine

#endregion

#region Managing Azure VMs with PowerShell

Get-Command -Noun AzVMSize
Get-Help Get-AzVMSize -ShowWindow

Get-Help Update-AzVM -ShowWindow
Get-Help Stop-AzVM -ShowWindow
Get-Help Start-AzVM -ShowWindow

Get-Command -Noun AzDisk, AzDiskConfig, AzVMDataDisk

Get-Help New-AzDiskConfig
Get-Help New-AzDisk
Get-Help Add-AzVMDataDisk

#endregion

#region Managing storage with Azure PowerShell

# https://learn.microsoft.com/powershell/module/az.storage

Find-PSResource Az.Storage -Repository PSGallery

# https://learn.microsoft.com/azure/storage/common/storage-account-create?tabs=azure-powershell
Get-Command -Noun AzStorageAccount
Get-Help New-AzStorageAccount -ShowWindow

Get-Command -Noun AzStorageContainer
Get-Help New-AzStorageContainer -ShowWindow

Get-Help Set-AzStorageAccount -ShowWindow

# https://learn.microsoft.com/azure/storage/blobs/storage-samples-blobs-powershell
# https://github.com/Azure/azure-docs-powershell-samples/tree/master/storage

#endregion

#region Managing Azure subscriptions with Azure PowerShell

# https://learn.microsoft.com/powershell/azure/manage-subscriptions-azureps

Get-Command -Noun AzSubscription
Get-Help Get-AzSubscription -ShowWindow

Get-Command -Noun AzContext
Get-Help Set-AzContext -ShowWindow

# https://learn.microsoft.com/powershell/azure/context-persistence

#endregion

#endregion


#region Lab

# https://microsoftlearning.github.io/AZ-040T00-Automating-Administration-with-PowerShell/Instructions/Labs/LAB_09_Azure_resource_management_with_PowerShell.html

#endregion
