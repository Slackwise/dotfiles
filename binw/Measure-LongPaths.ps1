# vim: set ts=4 sw=4:

function Measure-LongPaths {
    param (
        [int]$Size = 256,
        [parameter(Position=0)]$Path = $pwd
    )
    begin
    {
        $longPaths = New-Object System.Collections.ArrayList
        $logPathFn = { if ($_.FullName.Length -ge $LENGTH_TO_LOG) {$longpaths.Add($_.FullName)} }
    }
    process
    {
        dir $path -Recurse | % $logPathFn
    }
    end
    {
        return $longPaths
    }
}

Measure-LongPaths
