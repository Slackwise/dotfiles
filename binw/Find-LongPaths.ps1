# vim: set ts=4 sw=4:

<#
.SYNOPSIS
Returns list of full paths that exceed 256 chars or -Length

.DESCRIPTION
Recursively traverses a given -Path (default: current directory) and returns
a list of any full paths that exceed -Length (default: 256) characters.

.PARAMETER Length
Character length of full path that will be logged

.PARAMETER Path
The path to recursively traverse to find long paths

.INPUTS
Integer Length
String Path

.OUTPUTS
List<String>

.LINK
Source for the script: https://github.com/Slackwise/dotfiles/blob/master/binw/Find-LongPaths.ps1
#>
function global:Find-LongPaths {
    param (
        [int]$Length = 256,
        [parameter(Position=0,ValueFromPipeline=$True)][String]$Path = $pwd
    )
    begin
    {
        $longPaths = New-Object System.Collections.Generic.List[String]
        $logPathFn = { if ($_.FullName.Length -ge $Length) {$longPaths.Add($_.FullName)} }
    }
    process
    {
        dir $path -Recurse | % $logPathFn
    }
    end
    {
        # Normally, I'd wish to instead return some sort of object representing
        # paths, but .NET does not provide one, so an Array of Strings it is!
        return $longPaths.ToArray()
    }
}

if ($args) { Find-LongPaths $args[0] }
