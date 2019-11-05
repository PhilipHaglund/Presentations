break

#region Arrays

#region bad

$ADUsers = Get-ADUser -Filter 'SomeProperty -like "X"' -Properties UserPrincipalName
$Array = @()
foreach ($User in $ADUsers) {
    $Array += [PSCustomObject]@{
        UserName = $User.SamaccountName
        NewUPN   = '{0}@contoso.com' -f $User.SamaccountName
        OldUPN   = $User.UserPrincipalName
    }
}
#endregion bad

#region good

Get-ADUser -Filter 'SomeProperty -like "X"' -Properties UserPrincipalName
$Array = foreach ($User in $ADUsers) {
    [PSCustomObject]@{
        UserName = $User.SamaccountName
        NewUPN   = '{0}@contoso.com' -f $User.SamaccountName
        OldUPN   = $User.UserPrincipalName
    }
}
#endregion good

#region bad

# "less good"
Get-ADUser -Filter 'SomeProperty -like "X"' -Properties UserPrincipalName
$Array = New-Object -TypeName System.Collections.ArrayList
foreach ($User in $ADUsers) {
    $null = $Array.Add([PSCustomObject]@{
            UserName = $User.SamaccountName
            NewUPN   = '{0}@contoso.com' -f $User.SamaccountName
            OldUPN   = $User.UserPrincipalName
        })
}

#endregion bad

#region good

Get-ADUser -Filter 'SomeProperty -like "X"' -Properties UserPrincipalName
$Array = [Collections.ArrayList]::new() # PSv5+
foreach ($User in $ADUsers) {
    $null = $Array.Add([PSCustomObject]@{
            UserName = $User.SamaccountName
            NewUPN   = '{0}@contoso.com' -f $User.SamaccountName
            OldUPN   = $User.UserPrincipalName
        })
}

$Array = foreach ($User in $ADUsers) {
    [PSCustomObject]@{
        UserName = $User.SamaccountName
        NewUPN   = '{0}@contoso.com' -f $User.SamaccountName
        OldUPN   = $User.UserPrincipalName
    }
}
#endregion good

#endregion Arrays