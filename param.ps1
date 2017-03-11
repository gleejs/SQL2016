param(
[string]$sqlver
)
if($sqlver -eq ""){write-host "null"}
else
{
Write-Host $sqlver
}
Function Test
{
   Write-Host "Test Function"
}

Test
Write-Host $sqlver
