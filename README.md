# CItool-PSWrapper

## Introduction

Powershell wrapper for citool.exe (Microsoft Code Integrity)

This is a Powershell module that acts as a wrapper for the Microsoft Code Integrity utility [CITOOL.EXE](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/operations/citool-commands)

It 'translates' the CITOOL commands into Powershell verb-noun format, and returns the results so that they can be easily manipulated or investigated.

## Cmdlets Published

| Cmdlet | Mapped to CITOOL.EXE command | Parameters | Notes |
| ------ | ---------------------------- | ---------- |----- |
| New-CIPolicy | citool.exe -up | -FilePath <path to CIP file> | |
| Update-CIPolicy | citool.exe -up | -FilePath <path to CIP file> | Alias of New-CIPolicy |
| Remove-CIPolicy | citool.exe -rp | -PolicyGUID <guid of policy> | |
| Get-CIPolicies | citool.exe -lp | | |
| New-CIToken | citool.exe -at | -FilePath <path to token file> [ -TokenId <token ID> ] | Currently untested |
| Remove-CIToken | citool.exe -rt | -TokenId <token ID> | Currently untested |
| Get-CITokens | citool.exe -lt | | |
| Get-CIDeviceId | citool.exe -id | | |
| Update-CIPolicies | citool.exe -r | | |

## Examples

#### Get the current Code Integrity policies
`Get-CIPolicies`


#### Get the current Code Integrity policies' friendly names
`(Get-CIPolicies).FriendlyName`


#### Get the current enforced Code Integrity policies
`Get-CIPolicies | Where-Object {$_.IsEnforced -eq $True}`


#### Add a new Code Integrity policy
`New-CIPolicy -FilePath .\mynewpolicy.cip`


#### Update a Code Integrity policy
`Update-CIPolicy -FilePath .\myupdatedpolicy.cip`
(Note: `Update-CIPolicy` is an alias of `New-CIPolicy`)


#### Remove a Code Integrity policy
`Remove-CIPolicy -PolicyGUID '{1f769c63-e4d6-47fa-b3ca-a9cc5f4c3253}`
