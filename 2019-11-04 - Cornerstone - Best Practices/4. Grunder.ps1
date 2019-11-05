break

#region Alias

#region bad

ps | ? path -li '*ot*pa*' | % { spps $_ -wh }
#endregion bad

#region good

Get-Process | Where-Object -Property 'Path' -like -Value '*ot*pa*' | ForEach-Object -Process { Stop-Process -Id $_.Id -WhatIf }
Get-Process | Where-Object -FilterScript { $_.Path -like '*ot*pa*' } | ForEach-Object -Process { Stop-Process -Id $_.Id -WhatIf }
#endregion good

#endregion Alias

#region Positional

#region bad

Get-ChildItem C:\Windows *.xml | Copy-Item $env:HOME\Desktop
#endregion bad

#region good

Get-ChildItem -Path C:\Windows -Filter *.xml | Copy-Item -Destination $env:HOME\Desktop
#endregion good

#endregion Positional

#region Object

#region bad

$Var = '' | Select-Object -Property ID, UserGroup, Country, Members

$Var = @{
    ID        = ''
    UserGroup = ''
    Country   = ''
    Members   = ''
}
New-Object -Property $Var -TypeName PSObject

$Var = New-Object -TypeName PSObject -Property @{
    ID        = ''
    UserGroup = ''
    Country   = ''
    Members   = ''
}

#endregion bad

#region good

# Endast PSv3+
$Var = [PSCustomObject]@{
    ID        = ''
    UserGroup = ''
    Country   = ''
    Members   = ''
}
#endregion good

#endregion Object

#region Properties

#region bad

$SaveThis = $ObjectData | Select-Object -Property 'SingleProperty'
$SaveThis = $ObjectData | Select-Object -ExpandProperty 'SingleProperty'
#endregion bad

#region good

$ObjectData.SingleProperty
#endregion good

#endregion Properties

#region Scopes

#region bad

$Global:Variable = 'Info'
#endregion bad

#region good

$Script:Variable = 'Info'
#endregion good

#region what happens?

$Available = $true
$Inside = $false
function Get-Something {
    [PSCustomObject]@{
        Available = [bool]$Available
    }
    $Inside = $true
}
Get-Something
$Inside -eq $true #?
#endregion what happens?

#endregion Scopes

#region Layout

#region bad

function Get-Something {
    <#
.SYNOPSIS
Short description
.DESCRIPTION
Long description for Get-Something
.EXAMPLE
PS C:\> Get-Something
Returns something
#>
    [CmdletBinding()]
    param ([Parameter(ValueFromPipeline)][PSObject]$ParameterName)
    process {
    if ($ParameterName.Something -eq 'Thing') {
       'Great!'
    }
    else {
      'Bad!'
         }
    }
}
#endregion bad

#region good

function Get-Something {
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description for Get-Something
    .EXAMPLE
        PS C:\> Get-Something
        Returns something
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [PSObject]$ParameterName
    )
    process {
        if ($ParameterName.Something -eq 'Thing') {
            'Great!'
        }
        else {
            'Bad!'
        }
    }
}
#endregion good

#endregion Layout