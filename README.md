# CItool-PSWrapper

## Introduction

Powershell wrapper for citool.exe (Microsoft Code Integrity)

This is a Powershell module that acts as a wrapper for the Microsoft Code Integrity utility [CITOOL.EXE](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/operations/citool-commands)

It 'translates' the CITOOL commands into Powershell verb-noun format, and returns the results so that they can be easily manipulated or investigated.

Note: The cmdlets were changed from `*-CI*` to `*-Citool*` to avoid conflict with the `New-CIPolicy` cmdlet in the ConfigCI module. 

## Cmdlets Published

| Cmdlet | Mapped to CITOOL.EXE command | Parameters | Notes |
| ------ | ---------------------------- | ---------- |----- |
| New-CitoolPolicy | citool.exe -up | -FilePath <path to CIP file> | |
| Update-CitoolPolicy | citool.exe -up | -FilePath <path to CIP file> | Alias of New-CitoolPolicy |
| Remove-CitoolPolicy | citool.exe -rp | -PolicyGUID <guid of policy> | |
| Get-CitoolPolicies | citool.exe -lp | | |
| New-CitoolToken | citool.exe -at | -FilePath <path to token file> [ -TokenId <token ID> ] | Currently untested |
| Remove-CitoolToken | citool.exe -rt | -TokenId <token ID> | Currently untested |
| Get-CitoolTokens | citool.exe -lt | | |
| Get-CitoolDeviceId | citool.exe -id | | |
| Update-CitoolPolicies | citool.exe -r | | |

## Examples

#### Get the current Code Integrity policies
`Get-CitoolPolicies`


#### Get the current Code Integrity policies' friendly names
`(Get-CitoolPolicies).FriendlyName`


#### Get the current enforced Code Integrity policies
`Get-CitoolPolicies | Where-Object {$_.IsEnforced -eq $True}`


#### Add a new Code Integrity policy
`New-CitoolPolicy -FilePath .\mynewpolicy.cip`


#### Update a Code Integrity policy
`Update-CitoolPolicy -FilePath .\myupdatedpolicy.cip`
(Note: `Update-CitoolPolicy` is an alias of `New-CitoolPolicy`)


#### Remove a Code Integrity policy
`Remove-CitoolPolicy -PolicyGUID '{1f769c63-e4d6-47fa-b3ca-a9cc5f4c3253}' `

## Bonus script - Get-MSBlockList.ps1

Download the latest Microsoft recommended block list and extract the XML from the MD file

`Get-MSBlockList.ps1 [-FilePath] [-Url] [-StartString] [-EndString]`
