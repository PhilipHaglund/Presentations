break

#region bad
Function get-something {
    [cmdletbinding(supportsshouldProcess)]
    PARAM(
        [parameter(position = 0)]
        [STRING[]]$computerName = $env:COMPUTERNAME
    )
    Begin {
        $starttime = date -f s
        write-verbose "Starting function at $startime."
    }
    Process {
        ForEach ($comp in $computerName) {
            if ($pscmdlet.shouldprocess($comp)) {
                get-ciminstance -class wIn32_timeZone -computerName $comp -erroraction STOP
            }
        }
    }
    END {
        $endtime = date -f s
        write-verbose "Finished function at $endtime."
    }
}
#endregion bad

#region good
function Get-Something {
    [CmdletBinding(
        SupportsShouldProcess
    )]
    param (
        [Parameter(
            Position = 0
        )]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )
    begin {
        $StartTime = Get-Date -Format 's'
        Write-Verbose -Message "Starting function at $StartTime."
    }
    process {
        foreach ($Comp in $ComputerName) {
            if ($PSCmdlet.ShouldProcess($Comp)) {
                Get-CimInstance -ClassName Win32_TimeZone -ComputerName $Comp -ErrorAction Stop
            }
        }
    }
    end {
        $EndTime = Get-Date -Format 's'
        Write-Verbose "Finished function at $EndTime."
    }
}
#endregion good