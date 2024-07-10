while ($true)
{
    $computer = Read-Host -Prompt "`nEnter a Computer Name: (CTL-C to exit)`n"
    Get-ADComputer -Identity $computer -Properties CanonicalName
    write-host "`n"
    start-sleep -Seconds 2

}
