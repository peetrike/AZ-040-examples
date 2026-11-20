<#
    .SYNOPSIS
        Learning Path 10 samples
    .DESCRIPTION
        This file contains sample commands from course AZ-040 for
        Learning Path 10 - Managing Microsoft 365 services with PowerShell
    .LINK
        https://learn.microsoft.com/training/paths/manage-microsoft-365-services-use-windows-powershell/
    .LINK
        https://github.com/peetrike/AZ-040-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23AZ-040+%23M10
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Module 1: Manage Microsoft 365 user accounts, licenses, and groups with PowerShell

#region Benefits of using PowerShell for Microsoft 365

# https://learn.microsoft.com/powershell/microsoftgraph/overview
# https://learn.microsoft.com/powershell/entra-powershell/overview

#endregion

#region Connecting to the Microsoft 365 tenant with PowerShell

# https://learn.microsoft.com/graph/migrate-azure-ad-graph-overview
# https://learn.microsoft.com/powershell/microsoftgraph/migration-steps
# https://graphpowershell.merill.net/

Find-PSResource Microsoft.Graph -Repository PSGallery -IncludeDependencies | Measure-Object
Find-PSResource Microsoft.Entra -Repository PSGallery -IncludeDependencies | Measure-Object

Get-Help Connect-Entra
Get-Help Get-EntraContext

#endregion

#region Managing users in Microsoft 365 with PowerShell

# https://learn.microsoft.com/powershell/module/microsoft.entra.users
Find-PSResource Microsoft.Entra.Users -Repository PSGallery

Get-Command -Noun EntraUser
Get-Help Get-EntraUser -Online
# https://learn.microsoft.com/graph/api/user-list?tabs=powershell

$userId = 'mina@kuskil.ee'
Get-EntraUser -UserId $userId

Get-Help New-EntraUser
# https://learn.microsoft.com/graph/api/user-post-users?tabs=powershell

Get-Help Set-EntraUser
# https://learn.microsoft.com/graph/api/user-update?tabs=powershell

# https://learn.microsoft.com/graph/api/user-changepassword?tabs=powershell
Get-Help Set-EntraUserPassword

#endregion

#region Managing groups in Microsoft 365 with PowerShell

Get-Command -Noun EntraGroup, EntraGroupMember, EntraGroupOwner
Get-Help Get-EntraGroup
# https://learn.microsoft.com/graph/api/group-list?tabs=powershell

Get-Help Get-EntraGroupMember
# https://learn.microsoft.com/graph/api/group-list-members?tabs=powershell

Get-Help Get-EntraGroupOwner
# https://learn.microsoft.com/graph/api/group-list-owners?tabs=powershell

Find-PSResource ExchangeOnlineManagement -Repository PSGallery

Connect-ExchangeOnline
Get-Command -Noun UnifiedGroup*
Get-Help Get-UnifiedGroup
# https://learn.microsoft.com/powershell/module/exchange/get-unifiedgroup

#endregion

#region Managing roles in Microsoft 365 with PowerShell

# https://learn.microsoft.com/powershell/module/microsoft.entra.directorymanagement
Find-PSResource Microsoft.Entra.DirectoryManagement -Repository PSGallery

Get-Command -Noun EntraDirectoryRole*

Get-Help Get-EntraDirectoryRole
# https://learn.microsoft.com/powershell/module/microsoft.entra.directorymanagement/get-entradirectoryrole
Get-Help Get-EntraDirectoryRoleTemplate
# https://learn.microsoft.com/powershell/module/microsoft.entra.directorymanagement/get-entradirectoryroletemplate

Get-Help Add-EntraDirectoryRoleMember
# https://learn.microsoft.com/powershell/module/microsoft.entra.directorymanagement/add-entradirectoryrolemember

Get-Help Get-EntraDirectoryRoleMember

#endregion

#region Managing licenses in Microsoft 365 with PowerShell

Get-Command Get-EntraSubscribedSku
Get-Command -Noun EntraUserLicense*

Get-EntraUser -UserId $userId -Property AssignedLicenses
Get-EntraUserLicenseDetail -UserId $userId
# https://learn.microsoft.com/graph/api/user-list-licensedetails?tabs=powershell

Get-Help Set-EntraUserLicense
# https://learn.microsoft.com/powershell/module/microsoft.entra.users/set-entrauserlicense

# https://learn.microsoft.com/entra/identity/users/licensing-powershell-graph-examples
Get-MgGroup -Property AssignedLicenses
Get-Help Set-MgGroupLicense

#endregion

#endregion


#region Module 2: Manage Exchange Online with PowerShell

#region Connecting to Exchange Online PowerShell

Find-Module ExchangeOnlineManagement -Repository PSGallery

# https://aka.ms/exov3-module

Get-Help Connect-ExchangeOnline -ShowWindow
Connect-ExchangeOnline

# https://learn.microsoft.com/powershell/exchange/connect-to-exchange-online-powershell
# https://learn.microsoft.com/powershell/exchange/app-only-auth-powershell-v2

Get-Help Get-ConnectionInformation
Get-ConnectionInformation

Get-Help Connect-ExchangeOnline -Parameter SkipLoadingFormatData

# https://learn.microsoft.com/powershell/exchange/disable-access-to-exchange-online-powershell

#endregion

#region Managing mailboxes in Exchange Online

# https://learn.microsoft.com/exchange/recipients-in-exchange-online/manage-user-mailboxes/manage-user-mailboxes#use-exchange-online-powershell-to-change-user-mailbox-properties
# https://learn.microsoft.com/powershell/module/exchangepowershell/#mailboxes
Get-Command -Noun EXOMailbox*
Get-Help Get-EXOMailbox -Online

# https://learn.microsoft.com/powershell/module/exchangepowershell/get-mailbox
# https://learn.microsoft.com/powershell/module/exchangepowershell/set-mailbox
# https://learn.microsoft.com/powershell/module/exchangepowershell/new-mailbox

Get-Help Get-EXOMailboxPermission
# https://learn.microsoft.com/powershell/module/exchangepowershell/get-mailboxpermission
# https://learn.microsoft.com/powershell/module/exchangepowershell/add-mailboxpermission
# https://learn.microsoft.com/powershell/module/exchangepowershell/set-mailboxpermission
# https://learn.microsoft.com/powershell/module/exchangepowershell/remove-mailboxpermission

Get-Help Get-EXOMailboxFolderPermission
# https://learn.microsoft.com/powershell/module/exchangepowershell/add-mailboxfolderpermission
# https://learn.microsoft.com/powershell/module/exchangepowershell/get-mailboxfolderpermission
# https://learn.microsoft.com/powershell/module/exchangepowershell/set-mailboxfolderpermission
# https://learn.microsoft.com/powershell/module/exchangepowershell/remove-mailboxfolderpermission

#endregion

#region Managing resources in Exchange Online

# https://learn.microsoft.com/exchange/recipients-in-exchange-online/manage-resource-mailboxes#use-exchange-online-powershell-to-modify-resource-mailboxes

# https://learn.microsoft.com/powershell/module/exchangepowershell/set-calendarprocessing
# https://learn.microsoft.com/powershell/module/exchangepowershell/get-calendarprocessing

# https://learn.microsoft.com/exchange/recipients-in-exchange-online/manage-resource-mailboxes

#endregion

#region Managing admin roles in Exchange Online

# https://learn.microsoft.com/et-ee/exchange/permissions-exo/role-groups#use-exchange-online-powershell-to-manage-role-groups

# https://learn.microsoft.com/powershell/module/exchangepowershell/get-rolegroup
# https://learn.microsoft.com/powershell/module/exchangepowershell/add-rolegroupmember
# https://learn.microsoft.com/powershell/module/exchangepowershell/remove-rolegroupmember

#endregion

#endregion


#region Module 3: Manage SharePoint Online with PowerShell

#region SharePoint Online Management Shell overview

# https://learn.microsoft.com/powershell/sharepoint/sharepoint-online/introduction-sharepoint-online-management-shell

Find-PSResource Microsoft.Online.SharePoint.PowerShell -Repository PSGallery

# https://learn.microsoft.com/powershell/sharepoint/sharepoint-online/connect-sharepoint-online

Find-PSResource -CommandName Connect-SPOService -Repository PSGallery
# https://learn.microsoft.com/powershell/module/microsoft.online.sharepoint.powershell/connect-sposervice

# https://learn.microsoft.com/powershell/sharepoint/sharepoint-pnp/sharepoint-pnp-cmdlets
# https://pnp.github.io/powershell/index.html

Find-PSResource PnP.PowerShell -Repository PSGallery

#endregion

#region Managing SharePoint Online users and groups with PowerShell

# https://learn.microsoft.com/powershell/module/microsoft.online.sharepoint.powershell/get-spositegroup
# https://learn.microsoft.com/powershell/module/microsoft.online.sharepoint.powershell/new-spositegroup
# https://learn.microsoft.com/powershell/module/microsoft.online.sharepoint.powershell/set-spositegroup

# https://learn.microsoft.com/powershell/module/microsoft.online.sharepoint.powershell/add-spouser
# https://learn.microsoft.com/powershell/module/microsoft.online.sharepoint.powershell/remove-spouser

#endregion

#region Managing SharePoint sites with PowerShell

# https://learn.microsoft.com/powershell/module/microsoft.online.sharepoint.powershell/get-sposite
# https://learn.microsoft.com/powershell/module/microsoft.online.sharepoint.powershell/new-sposite
# https://learn.microsoft.com/powershell/module/microsoft.online.sharepoint.powershell/set-sposite

# https://learn.microsoft.com/powershell/module/microsoft.online.sharepoint.powershell/get-spowebtemplate

# https://learn.microsoft.com/powershell/module/microsoft.online.sharepoint.powershell/restore-spodeletedsite

#endregion

#region Managing external user sharing with PowerShell

# https://learn.microsoft.com/powershell/module/sharepoint-online/set-sposite#parameters

# https://learn.microsoft.com/powershell/module/microsoft.online.sharepoint.powershell/set-spotenant

#endregion

#endregion


#region Module 4: Manage Microsoft Teams with PowerShell

#region Overview of the Microsoft Teams PowerShell module

# https://learn.microsoft.com/microsoftteams/teams-powershell-overview

#endregion

#region Installing the Microsoft Teams PowerShell module

Find-PSResource MicrosoftTeams -Repository PSGallery

# https://learn.microsoft.com/powershell/module/teams/connect-microsoftteams
Find-PSResource -CommandName Connect-MicrosoftTeams

# https://learn.microsoft.com/microsoftteams/teams-powershell-application-authentication

#endregion

#region Managing Teams with the Microsoft Teams PowerShell module

# https://learn.microsoft.com/powershell/module/microsoftteams/get-team
# https://learn.microsoft.com/powershell/module/microsoftteams/new-team
# https://learn.microsoft.com/powershell/module/microsoftteams/set-team

# https://learn.microsoft.com/powershell/module/microsoftteams/get-csteamtemplatelist

# https://learn.microsoft.com/powershell/module/microsoftteams/get-teamchannel
# https://learn.microsoft.com/powershell/module/microsoftteams/new-teamchannel
# https://learn.microsoft.com/powershell/module/microsoftteams/set-teamchannel

# https://learn.microsoft.com/powershell/module/microsoftteams/add-teamuser
# https://learn.microsoft.com/powershell/module/microsoftteams/remove-teamuser

# # https://learn.microsoft.com/powershell/module/microsoftteams/add-teamchanneluser
# # https://learn.microsoft.com/powershell/module/microsoftteams/remove-teamchanneluser


#endregion

#endregion


#region Lab

# https://microsoftlearning.github.io/AZ-040T00-Automating-Administration-with-PowerShell/Instructions/Labs/LAB_10_Managing_Microsoft_365_services_with_PowerShell.html

#endregion
