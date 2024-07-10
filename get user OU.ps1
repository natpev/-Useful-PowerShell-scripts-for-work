while ($true)
{
    $user = Read-Host -Prompt "`nEnter a Username: (CTL-C to exit)`n"
    Get-ADUser -Identity $user -Properties CanonicalName
    write-host "`n"
    start-sleep -Seconds 2

}
