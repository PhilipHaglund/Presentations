break

#region parameters

#region bad
function Get-Something {
    $UserName = Read-Host -Prompt 'Enter a username'
}
#endregion

#region good

function Get-Something {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$UserName
    )
}
#endregion

#region bad

ipmo MicrosoftTeams -RequiredVersion 0.9.0
Get-Command -Name Get-Team -Syntax
Get-Command -Name Set-Team -Syntax
#endregion

#region good

Get-Command -Name Get-Item -Syntax
Get-Command -Name Set-Item -Syntax
#endregion

#endregion

#region parameter sets

#region bad

function Get-Something {
    param (
        [string]$UserName,

        [Parameter(ParameterSetName = 'Set1')]
        [string]$Set1,

        [Parameter(ParameterSetName = 'Set2')]
        [string]$Set2
    )

    if ($PSCmdlet.ParameterSetName -eq 'Set1') {
        "$UserName : $Set1"
    }
    else {
        "$UserName : $Set2"
    }
}
#endregion

#region good

function Get-Something {
    [Cmdletbinding(DefaultParameterSetName = 'Set1')]
    param (
        [string]$UserName,

        [Parameter(ParameterSetName = 'Set1')]
        [string]$Set1,

        [Parameter(ParameterSetName = 'Set2')]
        [string]$Set2
    )

    if ($PSCmdlet.ParameterSetName -eq 'Set1') {
        "$UserName : $Set1"
    }
    else {
        "$UserName : $Set2"
    }
}
#endregion

#endregion

#region whatif/confirm

#region bad
function Set-Something {
    param (
        [string]$Name,

        [string]$NewName,

        [switch]$WhatIf,
        [switch]$Confirm
    )

    if ($WhatIf) {
        Write-Host "$Name will become $NewName"
        return
    }
    elseif ($Confirm) {
        $UserInput = Read-Host "Are you sure you want to rename $Name to $NewName?"

        if ($UserInput -eq 'N') {
            return
        }
    }

    $Name = $NewName
    Write-Verbose -Message "Changed to $Name"
}
#endregion

#region good

function Set-Something {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High')]
    param (
        [string]$Name,

        [string]$NewName
    )

    if ($PSCmdlet.ShouldProcess("Changing $Name to $NewName")) {
        $Name = $NewName
        Write-Verbose -Message "Changed to $Name"
    }
}
#endregion

#endregion

#region switch

#region bad

function New-User {
    param (
        [string]$Name,

        [ValidateSet($True, $False)]
        [bool]$ChangePassword
    )

    $ChangePassword
}
#endregion

#region good

function New-User {
    param (
        [string]$Name,

        [switch]$ChangePassword
    )

    $ChangePassword
}
#endregion

#endregion

#region output types

#region bad

function Get-Something {
    param (
        $ComputerName
    )

    $User = Get-ADUser -Filter { $_.CustomAttributeXYZ -in $ComputerName }

    Invoke-Command -ComputerName $ComputerName -Scriptblock {
        Get-CimInstance -ClassName Win32_OperatingSystem
    }

    return $Users
}

#endregion

#region good
function Get-Something {
    [OutputType([PSCustomObject])]
    param (
        $ComputerName
    )

    [PSCustomObject]@{
        User         = Get-ADUser -Filter { $_.CustomAttributeXYZ -in $ComputerName }
        ComputerData = Invoke-Command -ComputerName $ComputerName -Scriptblock {
            Get-CimInstance -ClassName Win32_OperatingSystem
        }
    }
}
#endregion

#endregion

#region parameter types

#region less good
param (
    [string]$Path
)
#endregion

#region good
param (
    [System.IO.FileInfo]$Path
)
#endregion

#endregion

#region credentials

#region bad
param (
    $Username,

    $Password
)
#endregion

#region good
param (
    [PSCredential]$Credential
)

# PSv4- [System.Management.Automation.Credential()]
#endregion

#endregion