function Get-RegItemOrNew([string]$path) {
    if (Test-Path $path) {
        return (Get-Item $path).PSPath
    }
    else {
        return (mkdir -f $path).PSPath
    }
}

function Import-RegFile([string[]]$paths) {
    foreach ($path in $paths) {
        try { reg.exe import $path 2>&1 | Out-Null }
        catch {}
    }
}

$newUserItemPath = 'HKLM:\NewUser'

function Import-DefaultUserRegistry {
    if (Test-Path $newUserItemPath) { return }
    reg.exe load ($newUserItemPath -replace ':\\', '\') 'C:\Users\Default\NTUSER.DAT' 2>&1 >$null
}

function Set-ItemPropertyWithDefaultUser([string]$path, [string]$key, $value) {
    Import-DefaultUserRegistry

    $defaultUserPath = $path -replace '^HKCU:', $newUserItemPath
    if (!(Test-Path $path)) {
        mkdir -f $path >$null
    }
    if (!(Test-Path $defaultUserPath)) {
        mkdir -f $defaultUserPath >$null
    }
    Set-ItemProperty $path $key $value
    Set-ItemProperty $defaultUserPath $key $value
}

function Import-RegFileForMeAndDefault([string]$path) {
    Import-DefaultUserRegistry

    $newRegpath = "$env:TEMP\$((Get-ChildItem $path).BaseName)-fornewuser.reg"
    (Get-Content $path) -replace `
        '^\[HKEY_CURRENT_USER', '[HKEY_LOCAL_MACHINE\NewUser' |`
        Out-File -Force $newRegpath

    Import-RegFile $path, $newRegpath
}
