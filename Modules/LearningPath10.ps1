﻿<#
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

# https://learn.microsoft.com/powershell/azure/active-directory/overview
# https://learn.microsoft.com/powershell/microsoftgraph/overview


#endregion

#region Connecting to the Microsoft 365 tenant with PowerShell

# https://learn.microsoft.com/graph/migrate-azure-ad-graph-overview
# https://learn.microsoft.com/powershell/microsoftgraph/migration-steps
# https://graphpowershell.merill.net/

Find-Module AzureAD -Repository PSGallery
Find-Module AzureADPreview -Repository PSGallery
Find-Module MSOnline -Repository PSGallery
Find-Module Microsoft.Graph -Repository PSGallery -IncludeDependencies | Measure-Object

Get-Help Connect-MgGraph

#endregion

#region Managing users in Microsoft 365 with PowerShell

# https://learn.microsoft.com/powershell/module/microsoft.graph.users/
Find-PSResource Microsoft.Graph.Users -Repository PSGallery

Get-Command -Noun MgUser
Get-Help Get-MgUser -Online
# https://learn.microsoft.com/graph/api/user-list?tabs=powershell

$userId = 'mina@kuskil.ee'
Get-MgUser -UserId $userId

Get-Help New-MgUser
# https://learn.microsoft.com/graph/api/user-post-users?tabs=powershell

Get-Help Update-MgUser
# https://learn.microsoft.com/graph/api/user-update?tabs=powershell

Find-PSResource -CommandName Update-MgUserPassword -Repository PSGallery
Find-PSResource Microsoft.Graph.Users.Actions -Repository PSGallery
# https://learn.microsoft.com/graph/api/user-changepassword?tabs=powershell
Get-Help Update-MgUserPassword

#endregion

#region Managing groups in Microsoft 365 with PowerShell

Get-Command -Noun MgGroup, MgGroupMember, MgGroupOwner
Get-Help Get-MgGroup
# https://learn.microsoft.com/graph/api/group-list?tabs=powershell

Get-Help Get-MgGroupMember
# https://learn.microsoft.com/graph/api/group-list-members?tabs=powershell

Get-Help Get-MgGroupOwner
# https://learn.microsoft.com/graph/api/group-list-owners?tabs=powershell

Find-PSResource ExchangeOnlineManagement -Repository PSGallery

Connect-ExchangeOnline
Get-Command -Noun UnifiedGroup*
Get-Help Get-UnifiedGroup
# https://learn.microsoft.com/powershell/module/exchange/get-unifiedgroup

#endregion

#region Managing roles in Microsoft 365 with PowerShell

# https://learn.microsoft.com/graph/tutorial-assign-azureadroles?tabs=powershell
# https://learn.microsoft.com/powershell/module/microsoft.graph.identity.governance
Find-PSResource Microsoft.Graph.Identity.Governance -Repository PSGallery

# https://learn.microsoft.com/graph/api/resources/rolemanagement

Get-Help Get-MgRoleManagementDirectoryRoleDefinition
# https://learn.microsoft.com/powershell/module/microsoft.graph.identity.governance/get-mgrolemanagementdirectoryroledefinition
# https://learn.microsoft.com/graph/api/rbacapplication-list-roledefinitions?tabs=powershell

Get-Help Get-MgRoleManagementDirectoryRoleAssignment
# https://learn.microsoft.com/powershell/module/microsoft.graph.identity.governance/get-mgrolemanagementdirectoryroleassignment
# https://learn.microsoft.com/graph/api/rbacapplication-list-roleassignments?tabs=powershell

Get-Help New-MgRoleManagementDirectoryRoleAssignment
# https://learn.microsoft.com/powershell/module/microsoft.graph.identity.governance/new-mgrolemanagementdirectoryroleassignment
# https://learn.microsoft.com/graph/api/rbacapplication-post-roleassignments?tabs=powershell

# https://learn.microsoft.com/graph/api/resources/privilegedidentitymanagementv3-overview

Get-Help New-MgRoleManagementDirectoryRoleEligibilityScheduleRequest
# https://learn.microsoft.com/powershell/module/microsoft.graph.identity.governance/new-mgrolemanagementdirectoryroleeligibilityschedulerequest
# https://learn.microsoft.com/graph/api/rbacapplication-post-roleeligibilityschedulerequests?tabs=powershell

Get-Help New-MgRoleManagementDirectoryRoleAssignmentScheduleRequest
# https://learn.microsoft.com/powershell/module/microsoft.graph.identity.governance/new-mgrolemanagementdirectoryroleassignmentschedulerequest
# https://learn.microsoft.com/graph/api/rbacapplication-post-roleassignmentschedulerequests?tabs=powershell

#endregion

#region Managing licenses in Microsoft 365 with PowerShell

Get-Command -Noun MgUserLicenseDetail

Get-MgUser -UserId $userId -Property AssignedLicenses
Get-MgUserLicenseDetail -UserId $userId
# https://learn.microsoft.com/graph/api/user-list-licensedetails?tabs=powershell

Get-Help Set-MgUserLicense
# https://learn.microsoft.com/powershell/module/microsoft.graph.users.actions/set-mguserlicense
# https://learn.microsoft.com/graph/api/user-assignlicense?tabs=powershell

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

Get-Command -Noun Mailbox, EXOMailbox
Get-Help Get-EXOMailbox -Online
Get-Help Get-Mailbox

Get-Help Set-Mailbox
Get-Help New-Mailbox

Get-Command -Noun *MailboxPermission
Get-Command -Noun *MailboxFolderPermission

#endregion

#region Managing resources in Exchange Online

Get-Command -Noun CalendarProcessing

# https://learn.microsoft.com/exchange/recipients-in-exchange-online/manage-resource-mailboxes

#endregion

#region Managing admin roles in Exchange Online

Get-Command -Noun RoleGroup*

Get-RoleGroup | Select-Object Name

Get-RoleGroup Organization* | Get-RoleGroupMember

# https://learn.microsoft.com/exchange/permissions-exo/permissions-exo

#endregion

#endregion


#region Module 3: Manage SharePoint Online with PowerShell

#region SharePoint Online Management Shell overview

Find-PSResource Microsoft.Online.SharePoint.PowerShell -Repository PSGallery

# https://learn.microsoft.com/powershell/sharepoint/sharepoint-online/introduction-sharepoint-online-management-shell

Get-Command -Noun SPOService
Get-Help Connect-SPOService
# https://learn.microsoft.com/powershell/module/sharepoint-online/connect-sposervice

# https://learn.microsoft.com/powershell/sharepoint/sharepoint-pnp/sharepoint-pnp-cmdlets
# https://pnp.github.io/powershell/index.html

Find-PSResource PnP.PowerShell -Repository PSGallery
    #Requires -Version 7.2
Get-Command -Noun PnPOnline

#endregion

#region Managing SharePoint Online users and groups with PowerShell

Get-Command -Noun SPOSiteGroup

Get-Command -Noun SPOUser

#endregion

#region Managing SharePoint sites with PowerShell

Get-Command -Noun SPOSite
Get-Command -Noun SPOWebTemplate
Get-Command -Noun SPODeletedSite

#endregion

#region Managing external user sharing with PowerShell

# https://learn.microsoft.com/powershell/module/sharepoint-online/set-sposite#parameters
Get-Help Set-SPOSite -Parameter SharingCapability
Get-Help Set-SPOSite -Parameter SharingDomainRestrictionMode
Get-Help Set-SPOSite -Parameter DefaultLinkSharingType
Get-Help Set-SPOSite -Parameter DefaultLinkPermission

Get-Command -noun SPOTenant
Get-Help Set-SPOTenant
# https://learn.microsoft.com/powershell/module/sharepoint-online/set-spotenant

#endregion

#endregion


#region Module 4: Manage Microsoft Teams with PowerShell

#region Overview of the Microsoft Teams PowerShell module

# https://learn.microsoft.com/microsoftteams/teams-powershell-overview

#endregion

#region Installing the Microsoft Teams PowerShell module

Find-PSResource MicrosoftTeams -Repository PSGallery

# https://learn.microsoft.com/powershell/module/teams/connect-microsoftteams
Get-Help Connect-MicrosoftTeams

# https://learn.microsoft.com/microsoftteams/teams-powershell-application-authentication

#endregion

#region Managing Teams with the Microsoft Teams PowerShell module

Get-Command -Noun Team

Get-Help Get-CsTeamTemplateList

Get-Command -Noun TeamUser
Get-Command -Noun TeamChannel*

#endregion

#endregion


#region Lab

# https://microsoftlearning.github.io/AZ-040T00-Automating-Administration-with-PowerShell/Instructions/Labs/LAB_10_Managing_Microsoft_365_services_with_PowerShell.html

#endregion
