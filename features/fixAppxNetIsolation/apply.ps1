#Requires -RunAsAdministrator

if (!(Get-Command -ea 0 'CheckNetIsolation.exe')) { exit }

& {
    CheckNetIsolation.exe loopbackexempt -a -p=S-1-15-2-1609473798-1231923017-684268153-4268514328-882773646-2760585773-1760938157
} | Out-Null
