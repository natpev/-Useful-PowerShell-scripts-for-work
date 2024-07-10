# This script will get a list of all AD Users and output to a CSV with the following feilds

# Name -- Username -- AD Location -- Enabled -- Date Created -- Last Logon

$Currentlocation = Get-Location
$CurrentDate = get-date -format yy-mm-dd--hh-mm

Get-ADUser -Filter * -properties * | select HomeDirectory,Name,SamAccountName,CanonicalName,Enabled,whenCreated,LastLogonDate | export-csv -path $Currentlocation\All-AD-Users-$CurrentDate.csv
