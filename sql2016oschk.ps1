param(
[string]$sqlver
)
Write-Host $sqlver
$srvName=“Servername”
$os=get-wmiobject -class Win32_OperatingSystem
Switch -Regex ($os.version)
{
"6.3"
    {If($os.producttype -eq 1)
        #{$osv.value="Windows 8.1"
        {
        }
    else
    #{$osv.value="Windows Server 2012 R2"
    {
        $os.version 
<#
        start-process wusa "\\$srvName\deploymentshare$\Applications\SQL2016OSCHK\Windows8.1-KB2919442-x64.msu" /quiet /norestart
        start-process \\$srvName\deploymentshare$\Applications\SQL2016OSCHK\clearcompressionflag.exe
        wusa "\\$srvName\deploymentshare$\Applications\SQL2016OSCHK\Windows8.1-KB2919355-x64.msu" /quiet /norestart
    
        set $hotfix=null
        $hotfix=get-hotfix -id KB2919442 -ErrorAction SilentlyContinue
        If($hotfix)
        {
            #installed
        }
        else
        {
            $args = "\\$srvName\deploymentshare$\Applications\SQL2016OSCHK\Windows8.1-KB2919442-x64.msu"
            $args1 = " /quiet" + " /norestart"
            start-process $args $args1 -wait
            start-process "\\$srvName\deploymentshare$\Applications\SQL2016OSCHK\clearcompressionflag.exe" -wait
       
        }
#> 
        $hotfix=get-hotfix -id KB2919355 -ErrorAction SilentlyContinue
        if($hotfix)
        {
            #installed
        }
        else
        {
            $args = "\\$srvName\deploymentshare$\Applications\SQL2016OSCHK\Windows8.1-KB2919355-x64.msu" + " /quiet" + " /norestart"
            start-process wusa $args -wait
        }
    }
    }
"10.0"
{
    #10.0.10586 Windows 10
    $os.version
    $osVer="Windows10"
}
DEFAULT { "Version not listed"}
}

if($sqlver -eq "")
{
Write-Host "Installing SQL2016"
$args = " /ConfigurationFile=\\$srvName\deploymentshare$\Applications\SQL2016\Configurationfile.ini"  
start-process "\\$srvName\deploymentshare$\Applications\SQL2016\Setup.exe" $args -wait
}
else
{
Write-Host "Installing SQL2016SP1"
$args = " /ConfigurationFile=\\$srvName\deploymentshare$\Applications\SQL2016SP1\Configurationfile.ini"  
start-process "\\$srvName\deploymentshare$\Applications\SQL2016SP1\Setup.exe" $args -wait
}
if ($osVer="Windows10")
{
    $argsSMS=" /install /quiet"
    start-process "\\$srvName\deploymentshare$\Applications\SQL2016oschk\ssms-setup-enu.exe" $argsSMS -wait
}

