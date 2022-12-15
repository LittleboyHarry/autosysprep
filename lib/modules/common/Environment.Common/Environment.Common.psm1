$isAdmin = (
    [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
function Test-RunAsAdmin { $isAdmin }

$isArm64 = $env:PROCESSOR_ARCHITECTURE -eq 'ARM64'
function Test-CpuArchIsArm64 { $isArm64 }

$isAuditMode = (
    Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State' -ErrorAction Ignore
).ImageState -eq 'IMAGE_STATE_SPECIALIZE_RESEAL_TO_AUDIT'
function Test-AuditMode { $isAuditMode }
