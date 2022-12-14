#Requires -RunAsAdministrator

$docsFolderPath = Get-AppFolderPath -Docs

$localizedFolderPath = switch ((Get-Culture).Name) {
    zh-CN { "$docsFolderPath\zh-CN" }
    Default { "$docsFolderPath\en" }
}

$linksFolderPath = "$docsFolderPath\links"
$linksFolderName = Get-Translation 'User Guide' -cn '使用说明'

Push-Location $docsFolderPath
Remove-Item -Recurse -Force *
Copy-Item -Recurse -Force "$PSScriptRoot\docs\*" .
mkdir -f $linksFolderPath >$null
Pop-Location

$it = New-Shortcut ($path = "C:\users\Default\Desktop\$linksFolderName.lnk")
$it.TargetPath = $linksFolderPath
$it.IconLocation = switch (1) {
    { Test-Windows11 } { 'imageres.dll,107' }
    { Test-Windows10 } { 'imageres.dll,189' }
    Default { 'imageres.dll,188' }
}
$it.save()
Copy-ToCurrentDesktop $path
Copy-Item -Force $path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs'

function New-DocShortcut([string]$id, [string]$name, [string]$icon = $null) {
    $it = New-Shortcut -Lnk "$linksFolderPath\$name"
    $it.TargetPath = "$localizedFolderPath\$id.html"
    if ($icon) { $it.IconLocation = $icon }
    $it.save()
}

$readmeIcon = if (Test-Windows7) { 'imageres.dll,203' } else { 'imageres.dll,204' }
New-DocShortcut readme (
    Get-Translation 'README' -cn '自述文件'
) $readmeIcon

New-DocShortcut input (
    Get-Translation 'Keyboard & Input' -cn '键盘与输入法'
) 'imageres.dll,173'

New-DocShortcut options (
    Get-Translation 'Options' -cn '选项'
) 'control.exe'

if (Test-AppxSystemAvailable) {
    if (Get-AppxPackage Microsoft.WindowsStore) {
        New-DocShortcut store (
            Get-Translation 'Store Apps for You' -cn '应用商店推荐应用'
        ) 'explorer.exe,17'
    }
}

if ((Get-OSVersionBuild) -ge 18362) { New-DocShortcut wsl2 WSL2 'wsl.exe' }

$it = New-Shortcut -Url "$linksFolderPath\$(
    Get-Translation 'GitHub Project Homepage' -cn 'GitHub 项目主页'
)"
$it.TargetPath = "https://github.com/setupfw/win-sf"
$it.save()

if (Get-FeatureConfig addNewIsolatedUserScript) {
    New-DocShortcut multiuser (
        Get-Translation 'Isolated Multi User Proctect' -cn '多用户安全隔离'
    ) 'imageres.dll,83'
}
