# Powershell wrapper for citool.exe commands
# iainfm Aug 2023

function New-CitoolPolicy {
<#

    .SYNOPSIS
    Add or update a Code Integrity policy on the current system.

    .DESCRIPTION
    Calls "CITOOL.EXE -up" to add or update a local policy.

    .PARAMETER FilePath
    Specifies the filename of the binary policy to add or update.

    .EXAMPLE
    New-CitoolPolicy -FilePath .\NewCIPolicy.cip

    .NOTES
    Update-CitoolPolicy is an alias of this command.

    .LINK
    https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/operations/citool-commands

#>

    [alias("Update-CitoolPolicy")]
    param (
    [Parameter(Mandatory = $True)]
    [string]$FilePath)

    $result = (citool.exe -up $FilePath -json)
    $json = $result | ConvertFrom-Json
    
    if ( $json.OperationResult -ne 0 ) {

        Throw "CITOOL.EXE returned error $('0x{0:x}' -f [int32]($json).OperationResult)"

    }

    else {

        return $null

    }

}

function Remove-CitoolPolicy {
<#

    .SYNOPSIS
    Remove a Code Integrity policy on the current system.

    .DESCRIPTION
    Calls "CITOOL.EXE -rp" to remove a local policy.

    .PARAMETER PolicyGUID
    Specifies the GUID of the policy to remove.

    .EXAMPLE
    Remove-CitoolPolicy -PolicyGUID '{d465418f-b1fb-4fa1-8db0-c455f4084fa7}'
    
    .EXAMPLE
    Remove-CitoolPolicy -PolicyGUID d465418f-b1fb-4fa1-8db0-c455f4084fa7

    .NOTES
    Curly braces are optional.

    .LINK
    https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/operations/citool-commands

#>
    
    param (
    [Parameter(Mandatory = $True)]
    [string]$PolicyGUID)

    $PolicyGUID = ($PolicyGUID.Replace('{','')).Replace('}','')
    $result = (citool.exe -rp "{$PolicyGUID}" -json)
    $json = $result | ConvertFrom-Json

    if ( $json.OperationResult -ne 0 ) {

        Throw "CITOOL.EXE returned error $('0x{0:x}' -f [int32]($json).OperationResult)"

    }
    
    return $null

}

function Get-CitoolPolicies {
<#

    .SYNOPSIS
    List the Code Integrity policies on the current system.

    .DESCRIPTION
    Calls "CITOOL.EXE -lp" to list the policies.

    .EXAMPLE
    Get-CitoolPolicies

    .LINK
    https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/operations/citool-commands

#>

    $result = (citool.exe -lp -json)
    $json = $result | ConvertFrom-Json # This fails if "$result = (citool.exe -lp -json) | ConvertFrom-Json" is used :/

    if ( $json.OperationResult -ne 0 ) {

        Throw "CITOOL.EXE returned error $('0x{0:x}' -f [int32]($result | ConvertFrom-Json).OperationResult)"

    }

    return $json.Policies

}

function New-CitoolToken {
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
    New-CitoolToken -FilePath token_file.txt
    
    .EXAMPLE
    New-CitoolToken -FilePath token_file.txt -TokenId d465418f-b1fb-4fa1-8db0-c455f4084fa7

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

    if ( $null -eq $TokenId ) {

        $result = (citool.exe -at $FilePath -json)

    }
    else {

        $result = (citool.exe -at $FilePath --token-id $TokenId -json)

    }

    $json = $result | ConvertFrom-Json

    if ( $json.OperationResult -ne 0 ) {

        Throw "CITOOL.EXE returned error $('0x{0:x}' -f [int32]($result | ConvertFrom-Json).OperationResult)"

    }
    else {

        return $null

    }

}

function Remove-CitoolToken {
<#

    .SYNOPSIS
    Remove a Code Integrity token from the current system.

    .DESCRIPTION
    Calls "CITOOL.EXE -rt" to remove a local policy.

    .PARAMETER TokenId
    Specifies the ID of the token to remove.

    .EXAMPLE
    Remove-CitoolToken -TokenId d465418f-b1fb-4fa1-8db0-c455f4084fa7

    .NOTES
    This function is currently untested.

    .LINK
    https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/operations/citool-commands

#>
    
    param (
    [Parameter(Mandatory = $True)]
    [string]$TokenId)


    $result = (citool.exe -rt $TokenId -json)
    $json = $result | ConvertFrom-Json
    
    if ( $json.OperationResult -ne 0 ) {

        Throw "CITOOL.EXE returned error $('0x{0:x}' -f [int32]($result | ConvertFrom-Json).OperationResult)"

    }

    else {

        return $null

    }

}

function Get-CitoolTokens {
<#

    .SYNOPSIS
    List the Code Integrity tokens on the current system.

    .DESCRIPTION
    Calls "CITOOL.EXE -lt" to list the policies.

    .EXAMPLE
    Get-CitoolTokens

    .LINK
    https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/operations/citool-commands

#>

    $result = (citool.exe -lt -json)
    $json = $result | ConvertFrom-Json

    if ( $json.OperationResult -ne 0 ) { 
        
        Throw "CITOOL.EXE returned error $('0x{0:x}' -f [int32]($result | ConvertFrom-Json).OperationResult)"

    }

    else {

        return $json.Tokens

    }

}

function Get-CitoolDeviceId {
<#

    .SYNOPSIS
    Displays the Code Integrity device ID of the current system.

    .DESCRIPTION
    Calls "CITOOL.EXE -id" to display the ID.

    .EXAMPLE
    Get-CitoolDeviceId

    .LINK
    https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/operations/citool-commands

#>

    $result = (citool.exe -id -json)
    $json =  $result | ConvertFrom-Json

    if ( $json.OperationResult -ne 0 ) {

        Throw "CITOOL.EXE returned error $('0x{0:x}' -f [int32]($result | ConvertFrom-Json).OperationResult)"

    }
    else {

        return $json.DeviceID
        
    }

}

function Update-CitoolPolicies {
<#

    .SYNOPSIS
    Updates the Code Integrity policies of the current system.

    .DESCRIPTION
    Calls "CITOOL.EXE -r" to list the policies.

    .EXAMPLE
    Update-CitoolPolicies

    .LINK
    https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/operations/citool-commands

#>

    $result = (citool.exe -r -json)
    $json = $result | ConvertFrom-Json
    
    if ( $json.OperationResult -ne 0 ) { 

        Throw "CITOOL.EXE returned error $('0x{0:x}' -f [int32]($result | ConvertFrom-Json).OperationResult)"

    }
    else {

        return $null

    }

}

Export-ModuleMember -Function * -Alias *
