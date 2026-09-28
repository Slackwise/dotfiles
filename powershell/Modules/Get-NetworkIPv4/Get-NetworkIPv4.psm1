<#
.SYNOPSIS
Converts an IP/CIDR to its Network/Subnet form.

.LINK
Source: https://gist.github.com/Slackwise/943aee9c1394adf480a00705def95c15
#>
function Get-NetworkIPv4 {
    param(
        [string]$ipAddress,
        [int]$cidr
    )
    $parsedIpAddress = [System.Net.IPAddress]::Parse($ipAddress)
    $shift = 64 - $cidr

    [System.Net.IPAddress]$subnet = 0

    if ($cidr -ne 0) {
        $subnet = [System.Net.IPAddress]::HostToNetworkOrder([int64]::MaxValue -shl $shift)
    }

    [System.Net.IPAddress]$network = $parsedIpAddress.Address -band $subnet.Address

    return [PSCustomObject]@{
        Network = $network
        SubnetMask = $subnet
    }
}

Export-ModuleMember -Function Get-NetworkIPv4
