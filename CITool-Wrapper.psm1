# Powershell wrapper for citool.exe commands
# iainfm Aug 2023

function New-CIPolicy {

<#

    .SYNOPSIS
    Add or update a Code Integrity policy on the current system.

    .DESCRIPTION
    Calls "CITOOL.EXE -up" to add or update a local policy.

    .PARAMETER FilePath
    Specifies the filename of the binary policy to add or update.

    .EXAMPLE
    New-CIPolicy -FilePath .\NewCIPolicy.cip

    .NOTES
    Update-CIPolicy is an alias of this command.

    .LINK
    https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/operations/citool-commands

#>

    [alias("Update-CIPolicy")]
    param (
    [Parameter(Mandatory = $True)]
    [string]$FilePath)

    $result = ((citool.exe -up $FilePath -json) | ConvertFrom-Json).OperationResult
    
    if ($result -eq 0) { 
        return $null
    }
    else {
        return $result
    }

}

function Remove-CIPolicy {

<#

    .SYNOPSIS
    Remove a Code Integrity policy on the current system.

    .DESCRIPTION
    Calls "CITOOL.EXE -rp" to remove a local policy.

    .PARAMETER PolicyGUID
    Specifies the GUID of the policy to remove.

    .EXAMPLE
    Remove-CIPolicy -PolicyGUID '{d465418f-b1fb-4fa1-8db0-c455f4084fa7}'
    
    .EXAMPLE
    Remove-CIPolicy -PolicyGUID d465418f-b1fb-4fa1-8db0-c455f4084fa7

    .NOTES
    Curly braces are optional.

    .LINK
    https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/operations/citool-commands

#>
    
    param (
    [Parameter(Mandatory = $True)]
    [string]$PolicyGUID)

    $PolicyGUID = ($PolicyGUID.Replace('{','')).Replace('}','')
    $result = ((citool.exe -rp "{$PolicyGUID}" -json) | ConvertFrom-Json).OperationResult

    if ($result -eq 0) { 
        return $null
    }
    else {
        return $result
    }

}

function Get-CIPolicies {

<#

    .SYNOPSIS
    List the Code Integrity policies on the current system.

    .DESCRIPTION
    Calls "CITOOL.EXE -lp" to list the policies.

    .EXAMPLE
    Get-CIPolicies

    .LINK
    https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/operations/citool-commands

#>

    $result = ((citool.exe -lp -json) | ConvertFrom-Json).Policies
    
    if ($result -eq 0) { 
        return $null
    }
    else {
        return $result
    }

}

function New-CIToken {

    <#

    .SYNOPSIS
    Adds a Code Integrity token on the current system, with optional Token ID.

    .DESCRIPTION
    Calls "CITOOL.EXE -at" to add the token.

    .PARAMETER FilePath
    Specifies the filepath of the token to add.

    .PARAMETER TokenId
    (Optional) Specifies the ID of the token to add.

    .EXAMPLE
    New-CIToken -FilePath token_file.txt
    
    .EXAMPLE
    New-CIToken -FilePath token_file.txt -TokenId d465418f-b1fb-4fa1-8db0-c455f4084fa7

    .NOTES
    This command is currently untested.

    .LINK
    https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/operations/citool-commands

#>

    param (
    [Parameter(Mandatory = $True)]
    [string]$FilePath,
    [Parameter(Mandatory = $False)]
    [string]$TokenId)

    if ($null -eq $TokenId) {
        $result = ((citool.exe -at $FilePath -json) | ConvertFrom-Json).OperationResult
    }
    else {
        $result = ((citool.exe -at $FilePath --token-id $TokenId -json) | ConvertFrom-Json).OperationResult
    }

    if ($result -eq 0) { 
        return $null
    }
    else {
        return $result
    }

}

function Remove-CIToken {

<#

    .SYNOPSIS
    Remove a Code Integrity token from the current system.

    .DESCRIPTION
    Calls "CITOOL.EXE -rt" to remove a local policy.

    .PARAMETER TokenId
    Specifies the ID of the token to remove.

    .EXAMPLE
    Remove-CIToken -TokenId d465418f-b1fb-4fa1-8db0-c455f4084fa7

    .NOTES
    This function is currently untested.

    .LINK
    https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/operations/citool-commands

#>
    
    param (
    [Parameter(Mandatory = $True)]
    [string]$TokenId)


    $result = ((citool.exe -rt $TokenId -json) | ConvertFrom-Json).OperationResult
    
    if ($result -eq 0) { 
        return $null
    }
    else {
        return $result
    }

}

function Get-CITokens {

<#

    .SYNOPSIS
    List the Code Integrity tokens on the current system.

    .DESCRIPTION
    Calls "CITOOL.EXE -lt" to list the policies.

    .EXAMPLE
    Get-CITokens

    .LINK
    https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/operations/citool-commands

#>

    $result = ((citool.exe -lt -json) | ConvertFrom-Json).Tokens

    if ($result -eq 0) { 
        return $null
    }
    else {
        return $result
    }

}

function Get-CIDeviceId {

<#

    .SYNOPSIS
    Displays the Code Integrity device ID of the current system.

    .DESCRIPTION
    Calls "CITOOL.EXE -id" to display the ID.

    .EXAMPLE
    Get-CIDeviceId

    .LINK
    https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/operations/citool-commands

#>

    $result = ((citool.exe -id -json) | ConvertFrom-Json).DeviceID

    if ($result -eq 0) { 
        return $null
    }
    else {
        return $result
    }

}

function Update-CIPolicies {

<#

    .SYNOPSIS
    Updates the Code Integrity policies of the current system.

    .DESCRIPTION
    Calls "CITOOL.EXE -r" to list the policies.

    .EXAMPLE
    Update-CIPolicies

    .LINK
    https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/operations/citool-commands

#>

    $result = ((citool.exe -r -json) | ConvertFrom-Json).OperationResult
    
    if ($result -eq 0) { 
        return $null
    }
    else {
        return $result
    }

}

Export-ModuleMember -Function * -Alias *
