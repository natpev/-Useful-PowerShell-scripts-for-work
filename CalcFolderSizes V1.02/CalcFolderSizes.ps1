##################################
###  Author: Nathan Pevlor     ###
###  Name: CalcFolderSizes     ###
###  Version: 1.02             ###
###  Date Created 6/25/2024    ###
###  Date Revised 6/25/2024    ###
##################################

#######################################################
##  If you run into trouble running this script
##
##
##  to allow scripts
##  set-ExecutionPolicy RemoteSigned -Scope CurrentUser
##
##  to return to state Restricted
##  set-ExecutionPolicy Restricted -Scope CurrentUser
##
##  to view status
##  Get-ExecutionPolicy
########################################################


# get directory
$rundir = (Get-Item .).FullName
$CurrentDate = get-date -format MM-dd-yy--HH-mm-ss
$filename = "DIR Sizes -- $CurrentDate.csv"
$pathisbad = 0

[string[]]$Paths = Get-Content -Path "$rundir\directories.txt"



#Validate paths
foreach ($Path in $Paths){
    start-sleep -Milliseconds 100
    if (Test-Path -Path $Path){
        echo "__OK__         $Path"
    } else {
        echo "__BAD PATH__   $Path"
        $pathisbad += 1
    }
}

if ($pathisbad -ne 0){
    echo "___ERROR___    (Unable to complete due to bad paths in directories.txt)"
    Return
}


Write-Host  "`nAll Directories check good. Press any key to continue (or press Escape to exit)..."
$key = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

if ($key.VirtualKeyCode -eq 27) {
    Write-Host "`nExiting script..."
    exit
}



foreach ($Path in $Paths){
    $dir = dir $Path | ?{$_.PSISContainer}
    echo $dir
    write-host "`n`n"
    start-sleep -Seconds 2

    ## Create a nice header in the CVS
    $customObject = New-Object PSObject -Property @{
    Size = ""
    Directory = ""
    PathToFolder = ""
    }
    $customObject | Export-Csv -Path "$rundir\$filename" -Append -NoTypeInformation
    
    $customObject = New-Object PSObject -Property @{
    Size = "SIZE (MB)"
    Directory = "DIRECTORY"
    PathToFolder = "$Path"
    }
    $customObject | Export-Csv -Path "$rundir\$filename" -Append -NoTypeInformation

    ## check each folder
    foreach ($d in $dir){
        # echo $d
        $Data = ("{0:N4}" -f ((Get-ChildItem -path "$Path\$d" -recurse -ErrorAction SilentlyContinue | Measure-Object -property length -sum -ErrorAction SilentlyContinue ).sum /1MB))
        echo "$Data --- $Path\$d"
        ## Format custom Object
        $customObject = New-Object PSObject -Property @{
        Size = $Data
        Directory = $d
        PathToFolder = $Path
        }
        ##Output to CSV

        $customObject | Export-Csv -Path "$rundir\$filename" -Append -NoTypeInformation
    }  

    $customObject = New-Object PSObject -Property @{
    Size = ""
    Directory = ""
    PathToFolder = ""
    }

    $customObject | Export-Csv -Path "$rundir\$filename" -Append -NoTypeInformation

}