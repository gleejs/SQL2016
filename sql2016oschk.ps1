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
        start-process wusa "\\servername\deploymentshare$\Applications\SQL2016OSCHK\Windows8.1-KB2919442-x64" /quiet /norestart
        start-process \\servername\deploymentshare$\Applications\SQL2016OSCHK\clearcompressionflag.exe
        wusa "\\servername\deploymentshare$\Applications\SQL2016OSCHK\Windows8.1-KB2919355-x64.msu" /quiet /norestart
#>     
        set $hotfix=null
        $hotfix=get-hotfix -id KB2919442 -ErrorAction SilentlyContinue
        If($hotfix)
        {
            #installed
        }
        else
        {
            $args = "\\servername\deploymentshare$\Applications\SQL2016OSCHK\Windows8.1-KB2919442-x64.msu"+" /quiet" + " /norestart"
            start-process wusa $args -wait
            start-process \\servername\deploymentshare$\Applications\SQL2016OSCHK\clearcompressionflag.exe -wait
       
        }

        $hotfix=get-hotfix -id KB2919355 -ErrorAction SilentlyContinue
        if($hotfix)
        {
            #installed
        }
        else
        {
            $args = "\\servername\deploymentshare$\Applications\SQL2016OSCHK\Windows8.1-KB2919355-x64.msu" + " /quiet" + " /norestart"
            start-process wusa $args -wait
        }
    }
    }
"10.0"
{
    #10.0.10586 Windows 10
    $os.version
}
DEFAULT { "Version not listed"}
}

$args = " /ConfigurationFile=\\servername\deploymentshare$\Applications\SQL2016x64\Configurationfile.ini"  
start-process \\servername\deploymentshare$\Applications\SQL2016x64\Setup.exe $args -wait