$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.microsoft.com/download/b/d/8/bd8409df-7b80-4ef7-89c5-5a7a941a5093/Setup.Microsoft.PowerAutomate.exe'
$pp = Get-PackageParameters

$packageArgs = @{
  packageName   = 'powerautomatedesktop'
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'Power Automate for Desktop*'

  checksum      = 'C4A93D1AFE0DE3A5713275994830DF88757AB5E7C7F5F4834D49735D4FA380F9'
  checksumType  = 'sha256'

  silentArgs   = '/S -accepteula'
}
Install-ChocolateyPackage @packageArgs


if ($pp['register'])
{
  if(($pp['applicationid']) -and ($pp['tenantid'])){
    try{
      if($pp['clientsecret']){
        if($pp['environmentid']){
          Write-Output $pp['clientsecret'] | C:\'Program Files (x86)'\'Power Automate Desktop'\PAD.MachineRegistration.Silent.exe -register -clientsecret -applicationid $pp['applicationid'] -tenantid $pp['tenantid'] -environmentid $pp['environmentid']
        }
        else{
          Write-Output $pp['clientsecret'] | C:\'Program Files (x86)'\'Power Automate Desktop'\PAD.MachineRegistration.Silent.exe -register -clientsecret -applicationid $pp['applicationid'] -tenantid $pp['tenantid']
        }
      }
      elseif ($pp['certificatethumbprint']) {
        if($pp['environmentid']){
          Write-Output $pp['certificatethumbprint'] | C:\'Program Files (x86)'\'Power Automate Desktop'\PAD.MachineRegistration.Silent.exe -register -certificatethumbprint -applicationid $pp['applicationid'] -tenantid $pp['tenantid'] -environmentid $pp['environmentid']
        }
        else{
          Write-Output $pp['certificatethumbprint'] | C:\'Program Files (x86)'\'Power Automate Desktop'\PAD.MachineRegistration.Silent.exe -register -certificatethumbprint -applicationid $pp['applicationid'] -tenantid $pp['tenantid']
        }
        
      }
      else {
        Write-Warning "Please specify Certificate or Client Secret you will need to register manually or troubleshoot then run again with --force"
      }
  }
    catch
    {
      Write-Warning "Failed registering to Power Platform Error: $($Error[0])" 
      Write-Warning "Please register manually or troubleshoot then run again with --force"
    }
  }
  else {
    Write-Warning "Please specify Applicationid, tenantid, and certificatethumbprint or clientsecret you will need to register manually or troubleshoot then run again with --force"
  }
}  

