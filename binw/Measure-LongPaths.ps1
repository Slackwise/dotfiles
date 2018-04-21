# vim: set ts=4 sw=4:


# Config Vars
$ROOT_PATH      = "/home/slackwise"
$LENGTH_TO_LOG  = 256





function Measure-LongPaths($path=$ROOT_PATH) {
    begin
    {
        $longPaths = New-Object System.Collections.Generic.List[System.Object]
        $logPathFn = { if ($_.FullName.Length -ge $LENGTH_TO_LOG) { $longpaths.Add($_.FullName) } }
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
