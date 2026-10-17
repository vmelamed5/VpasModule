<p align="center">
  <a href="https://vpasmodule.com/index.html" target="_blank" rel="noopener noreferrer"><img src="https://github.com/vmelamed5/vmelamed5/blob/main/images/VpasModuleLOGO.png?raw=true" /></a>
</p>

<p align="center">
<b>VpasModule</b> is a simplified PowerShell module to interact with CyberArk Web Services for Self Hosted, PrivilegeCloud Standard, and SharedServices (ISPSS) solutions as well as Identity/DPA/ConnectorManagement API suite
</p>

<p align="center">
  Creator: <b>Vadim Melamed</b>
  <br>
  Email: <b>vpasmodule@gmail.com</b>
  <br>
</p>

<div align="center">
<br>
  
![PSGallery Version](https://img.shields.io/powershellgallery/v/VpasModule)
![Downloads](https://img.shields.io/powershellgallery/dt/VpasModule)
![License](https://img.shields.io/github/license/vmelamed5/vpasmodule)
![Code Quality](https://img.shields.io/codefactor/grade/github/vmelamed5/VpasModule)
![GitHub Last Commit](https://img.shields.io/github/last-commit/vmelamed5/vpasmodule?style=flat-square)
![GitHub issues by-label](https://img.shields.io/github/issues/vmelamed5/vpasmodule/bugs?style=flat-square)

</div>


## Installation
 
Install the module via [PowershellGallery](https://www.powershellgallery.com/packages/VpasModule/)
 
```powershell
Install-Module VpasModule -scope CurrentUser
```
 
## Usage
 
```powershell
# Step1: import vpasmodule
Import-Module vpasmodule
 
# Step2: Retrieve cyberark login token via New-VPASToken
New-VPASToken -PVWA "MyPVWAServer.com" -AuthType cyberark
 
# Step3: Run desired API calls
$SafeDetails = Get-VPASSafes -searchQuery "TestSafe"
$AllAccounts = Get-VPASAllAccounts
 
# Step4: Invalidate cyberark login token via Remove-VPASToken
Remove-VPASToken
```
 
## Supported Versions
```
> v10.10 - SelfHosted
> v11.X - SelfHosted
> v12.X - SelfHosted
> v13.X - SelfHosted + PrivilegeCloud
> v14.X - SelfHosted + PrivilegeCloud + Identity
> v15.X - SelfHosted + PrivilegeCloud + Identity + SIA + ConnectorManagement + SRS
```
```
> v15.2.0 (Current):
     - SelfHosted
     - PrivilegeCloudStandard
     - SharedServices (ISPSS)
     - SRS (WORK IN PROGRESS)
     - Identity (WORK IN PROGRESS)
     - ConnectorManagement (WORK IN PROGRESS)
     - SecureInfrastructureAccess (WORK IN PROGRESS)
```
 
## Documentation
Find version specific README.md inside specific vpasmodule versions for more documentation on function syntax, examples, usages, etc.\
\
Please visit [VpasModule Website](https://vpasmodule.com/index.html) to stay up to date with any updates, changes, and various other features  

