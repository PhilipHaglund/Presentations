break

#region Output

#region bad

function Get-MyUser {
    Get-ADUser -Filter "Attribute -eq 'Something'" -Properties DisplayName, Description | Format-Table *
}
Get-MyUser

function Get-MyUser {
    $Object = Get-ADUser -Filter "Attribute -eq 'Something'" -Properties DisplayName, Description
    $Object | Select-Object -Property DisplayName, Description
}
Get-MyUser
#endregion bad

#region good

function Get-MyUser {
    Get-ADUser -Filter { Attribute -eq 'Something' } -Properties DisplayName, Description
}
Get-MyUser

function Get-MyUser {
    Get-ADUser -Filter { Attribute -eq 'Something' } -Properties DisplayName, Description
}
Get-MyUser | Select-Object -Property DisplayName, Description
#endregion good

#endregion Output

#region Backtick and line breaks

#region bad

Get-ADUser -Filter "Attribute -eq 'Something'" -Properties DisplayName, `
    Description, `
    Lastlogon, `
    WhenChanged, `
    Proxyaddresses
#endregion bad

#region good

Get-ADUser -Filter "Attribute -eq 'Something'" -Properties DisplayName,
Description,
Lastlogon,
WhenChanged,
Proxyaddresses


$Properties = 'DisplayName', 'Description', 'Lastlogon', 'WhenChanged', 'Proxyaddresses'
Get-ADUser -Filter "Attribute -eq 'Something'" -Properties $Properties
#endregion good

#region bad

Get-ADUser -Filter "Attribute -eq 'Something'" -Properties DisplayName, Description `
| Where-Object { ProptertyX -like 'this' } `
| ForEach-Object -Process {
    Set-Something
}
#endregion bad

#region good

Get-ADUser -Filter { Attribute -eq 'Something' } -Properties DisplayName, Description |
    Where-Object { ProptertyX -like 'this' } |
    ForEach-Object -Process {
        Set-Something
    }
#endregion good

#region bad

Get-ADUser -Identity 'CN=Some User,OU=Contoso Users,DC=contoso,DC=com' `
    -Properties 'Decription', 'DisplayName', 'LastLogon', 'WhenCreated' `
    -Server 'DC.contoso.com' `
    -Verbose `
    -ErrorAction 'Stop'
#endregion bad

#region good

$ADUser = @{
    Identity    = 'CN=Some User,OU=Contoso Users,DC=contoso,DC=com'
    Properties  = 'Decription', 'DisplayName', 'LastLogon', 'WhenCreated'
    Server      = 'DC.contoso.com'
    Verbose     = $true
    ErrorAction = 'Stop'
}
Get-ADUser @ADUser
#endregion good

#region bad

if ($LongVariableNameButWhy -match 'SomeRegex' -and $PSScriptRoot -eq 'C:\MyPath' -or ($env:PSExecutionPolicyPreference -eq 'RemoteSigned' -and $MyVar -eq 1234 -and 'asdf' -is [string])) {
    Get-Magic
}
#endregion bad

#region good

if ($LongVariableNameButWhy -match 'SomeRegex' -and
    $PSScriptRoot -eq 'C:\MyPath' -or
    ($env:PSExecutionPolicyPreference -eq 'RemoteSigned' -and
        $MyVar -eq 1234 -and
        'asdf' -is [string]
    )
) {
    Get-Magic
}
#endregion good

#endregion Backtick and line breaks