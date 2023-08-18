# Quick and dirty script to grab the latest Microsoft block rules
# Until https://github.com/MicrosoftDocs/windows-itpro-docs/issues/11535 is resolved
# iainfm Aug 2023

<#

    .SYNOPSIS
    Download the latest Microsoft recommended block rules and convert to multi-policy format.

    .DESCRIPTION
    Useful until https://github.com/MicrosoftDocs/windows-itpro-docs/issues/11535 is closed.

    .EXAMPLE
    Get-MSBlockList.ps1

    .EXAMPLE

    Get-MSBlockList.ps1 -FilePath WDAC\Policies\NewMSBlockList.xml    

    .LINK
    https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/design/applications-that-can-bypass-wdac

    .NOTES
    All parameters are optional and defaults will be applied if not specified. The URL of the MarkDown page may change from time to time.

#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $False)]
    [string]$Url = 'https://raw.githubusercontent.com/MicrosoftDocs/windows-itpro-docs/7a639741a199115563a05f3f458ad500a80f4100/windows/security/application-security/application-control/windows-defender-application-control/design/applications-that-can-bypass-wdac.md',
	[Parameter(Mandatory = $False)]
    [string]$FilePath = '.\MicrosoftWindowsRecommendedUserModeBlockList_' + $(Get-Date -Format yyyyMMdd) + '.xml',
    [Parameter(Mandatory = $False)]
    [string]$StartString = "<?xml version=`"1.0`" encoding=`"utf-8`"?>",
    [Parameter(Mandatory = $False)]
    [string]$EndString = "</SiPolicy>"
)

$StartString

# Grab the content
$raw = curl $url

# Find the XML within the content
$EndString_index = 0
$StartString_index = 0
$index = 0

foreach ($line in $raw) {
    if ($line -eq $StartString) {
        $StartString_index = $index
    }
    elseif ($line -eq $EndString) {
        $EndString_index = $index
    }
    #of
    $index++
}

if (($StartString_index -eq 0) -or ($EndString_index -eq 0)) {
    Write-Warning 'Could not identify the xml start/end. Please check and try again.'
    Exit
}

# Write the URL to a file
$raw[$StartString_index..$EndString_index] | Out-File $FilePath -Encoding ascii

# Convert the policy to multi format as per https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/design/applications-that-can-bypass-wdac
Set-CIPolicyIdInfo -FilePath $FilePath -ResetPolicyID
