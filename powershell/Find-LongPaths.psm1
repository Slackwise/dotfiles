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
function Find-LongPaths
{
    param
    (
        [int]$Length = 256,
        [parameter(Position=0,ValueFromPipeline=$True)][String]$Path = $pwd
    ) 
    process
    {
        Get-ChildItem -Recurse $Path | ?{$_.FullName.Length -ge $Length} | Select -ExpandProperty FullName
    }
}


Export-ModuleMember -Function Find-LongPaths
