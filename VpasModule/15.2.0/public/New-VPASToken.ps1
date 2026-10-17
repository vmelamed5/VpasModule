<#
.Synopsis
   Get Idira (formerly CyberArk) login token
   CREATED BY: Vadim Melamed, EMAIL: vpasmodule@gmail.com
.DESCRIPTION
   Use this function to authenticate into Idira (formerly CyberArk) for SelfHosted and PrivilegeCloudStandard environments (RADIUS, CYBERARK, WINDOWS, SAML, LDAP, AUTHTOKEN), SharedServices environments (CYBERARK, OAUTH, AUTHTOKEN), as well as SRS enabled environments (CYBERARK, OAUTH, AUTHTOKEN)
.LINK
   https://vpasmodule.com/commands.html#New-VPASToken
.NOTES
   Category: PAM
   Tag: Authentication
   Since: v10.10
   Version: 20
   SelfHosted: TRUE
   PrivCloudStandard: TRUE
   SharedServices: TRUE
   SRS: TRUE
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
.PARAMETER PVWA
   The fully qualified domain name of the PVWA server for SelfHosted environments: server1.vman.com
   The baseURL for saas environments: MyCompany.privilegecloud.cyberark.cloud
.PARAMETER AuthType
   What method of authentication will be used
   For saas environments, select the ispss options
   Possible values: cyberark, radius, windows, ldap, saml, authtoken, ispss_oauth, ispss_cyberark, ispss_authtoken, srs_cyberark, srs_oauth, srs_authtoken
.PARAMETER creds
   A credential object containing username and password
.PARAMETER HideAscii
   To remove the VPasModule logo from appearing in the console
.PARAMETER InitiateCookie
   Initiate a cookie variable that will be included in the header from call to call
   Very useful in situations where stickiness or persistency is not enabled on PVWA loadbalancer
.PARAMETER HideWarnings
   Hide any warning outputs from the console during the API session
.PARAMETER IdentityURL
   For saas environments, the tenant URL of Identity
.PARAMETER EnableTroubleshooting
   Enable troubleshooting code that will attempt to fix failed commands
   (COMING SOON!)
.PARAMETER IdentityOnly
   Authenticate into Identity only
   Useful when the account only has rights in Identity and NOT in PrivilegeCloud
.PARAMETER AuthToken
   Provide login token generated externally
.PARAMETER EnableTextRecorder
   Enable Text Recording feature which will log out every API command, return value, and general information that is generated during the token session
   The log file will be located in the current users AppData folder: C:\Users\{current_user}\AppData\Local\VPASModuleOutputs\APITextRecorder
.PARAMETER InputParameters
   HashTable of values containing the parameters required to make the API call
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType {AUTHTYPE VALUE}
.OUTPUTS
   If successful:
   {
        "IdentityURL":  "AA12345.id.cyberark.cloud",
        "SubDomain":  "vman",
        "AuditTimeStamp":  "08-17-2024_00-23-58",
        "VaultVersion":  "14.2.0",
        "session":  false,
        "EnableTextRecorder":  {
                                   "IsPresent":  true
                               },
        "pvwa":  "vman.privilegecloud.cyberark.cloud",
        "NoSSL":  {
                      "IsPresent":  false
                  },
        "ISPSS":  true,
        "token":  "...1rcg33vtyly...",
        "AuthenticatedAs":  "vman@cyberark.cloud.1234",
        "HeaderType":  "Bearer ...1rcg33vtyly...",
        "HideWarnings":  {
                             "IsPresent":  false
                         }
   }
   ---
   $false if failed
#>
function New-VPASToken{
    [OutputType('System.Collections.Hashtable',[bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter PVWA FQDN (for example: MyPVWAServer.vman.com)",Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter AuthenticationType (Cyberark, Radius, Windows, LDAP, Saml, AuthToken, ISPSS_OAuth, ISPSS_Cyberark, ISPSS_AuthToken, SRS_OAuth, SRS_Cyberark, SRS_AuthToken)",Position=1)]
        [ValidateSet('cyberark','radius','windows','ldap','saml','authtoken','ispss_oauth','ispss_cyberark','ispss_authtoken','srs_oauth','srs_cyberark','srs_authtoken')]
        [String]$AuthType,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [PSCredential]$creds,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$HideAscii,

	    [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$InitiateCookie,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$IdentityURL,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$AuthToken,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [Switch]$EnableTextRecorder,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [Switch]$HideWarnings,

        #[Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=10)]
        #[Switch]$EnableTroubleshooting,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=10)]
        [Switch]$IdentityOnly
    )

    Begin{

    }
    process{
        $EnableTroubleshooting = $false
        $APICounter = 0
        $output = @{}

        if($HideAscii){
    	    #DO NOTHING
        }
        else{
            Write-VPASOutput -str " __      _______          __  __           _       _       " -type G -Initialized
            Write-VPASOutput -str " \ \    / /  __ \        |  \/  |         | |     | |      " -type G -Initialized
            Write-VPASOutput -str "  \ \  / /| |__) |_ _ ___| \  / | ___   __| |_   _| | ___  " -type G -Initialized
            Write-VPASOutput -str "   \ \/ / |  ___/ _`  / __| |\/| |/ _ \ / _`  | | | | |/ _ \ " -type G -Initialized
            Write-VPASOutput -str "    \  /  | |  | (_| \__ \ |  | | (_) | (_| | |_| | |  __/ " -type G -Initialized
            Write-VPASOutput -str "     \/   |_|   \__,_|___/_|  |_|\___/ \__,_|\__,_|_|\___| " -type G -Initialized
        }

        if(([Net.SecurityProtocolType].GetEnumNames() -contains "Tls12" ) -and (-not ([System.Net.ServicePointManager]::SecurityProtocol -match "Tls12"))){
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        }

        if($AuthType -ne "saml" -and $AuthType -ne "ispss_oauth" -and $AuthType -ne "ispss_cyberark" -and $AuthType -ne "ispss_authtoken" -and $AuthType -ne "authtoken" -and $AuthType -ne "srs_oauth" -and $AuthType -ne "srs_cyberark" -and $AuthType -ne "srs_authtoken"){
            if($AuthType -eq "radius"){
                Write-Verbose "RADIUS AUTHENTICATION SELECTED"

	            if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/PasswordVault/API/auth/RADIUS/Logon"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/PasswordVault/API/auth/RADIUS/Logon"
                }

            }
            if($AuthType -eq "cyberark"){
                Write-Verbose "CYBERARK AUTHENTICATION SELECTED"

	            if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/PasswordVault/API/auth/cyberark/Logon"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/PasswordVault/API/auth/cyberark/Logon"
                }
            }
            if($AuthType -eq "windows"){
                Write-Verbose "WINDOWS AUTHENTICATION SELECTED"

	            if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/PasswordVault/API/auth/Windows/Logon"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/PasswordVault/API/auth/Windows/Logon"
                }
            }
            if($AuthType -eq "ldap"){
                Write-Verbose "LDAP AUTHENTICATION SELECTED"

	            if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/PasswordVault/API/auth/LDAP/Logon"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/PasswordVault/API/auth/LDAP/Logon"
                }
            }

            if(!$creds){
                $creds = Get-Credential -Message 'ENTER CYBERARK CREDENTIALS'
            }
            $username = $creds.GetNetworkCredential().UserName
            $password = $creds.GetNetworkCredential().Password
            Write-Verbose "IDIRA (formerly CyberArk) CREDENTIALS SET"

            #GET LOGIN TOKEN
            try{
                $params = @{
                    username = $username;
                    password = $password;
                    concurrentSession = $true;
                } | ConvertTo-Json
                Write-Verbose "API PARAMETERS SET"


                if($InitiateCookie){
                    Write-Verbose "INITIATING COOKIE"
                    $cookie = new-object system.net.cookie
                    $cookie.name = "tos_accepted"
                    $cookie.domain = "$PVWA"
                    $session = new-object microsoft.powershell.commands.webrequestsession
                    $session.cookies.add($cookie)

                    $token = Invoke-RestMethod -Uri $uri -Method Post -Body $params -ContentType 'application/json' -WebSession $session
                    $APICounter += 1
                    Write-Verbose "RETURNING LOGIN TOKEN AND COOKIE SESSION"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($NoSSL){
                        $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                        $APICounter += 1
                        $VaultVersion = $response.ExternalVersion
                    }
                    else{
                        $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                        $APICounter += 1
                        $VaultVersion = $response.ExternalVersion
                    }

                    $output = @{
                        token = $token
                        session = $session
                        pvwa = $PVWA
                        HeaderType = "$token"
                        ISPSS = $false
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = "N/A"
                        EnableTroubleshooting = $EnableTroubleshooting
                        APICounter = $APICounter
                        Creds = $creds
                        AuthType = $AuthType
                        IDPLogin = $false
                    }
                    $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -APIUsername $username
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $token" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
                else{
                    $token = Invoke-RestMethod -Uri $uri -Method Post -Body $params -ContentType 'application/json'
                    $APICounter += 1
                    Write-Verbose "RETURNING LOGIN TOKEN"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($NoSSL){
                        $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                        $APICounter += 1
                        $VaultVersion = $response.ExternalVersion
                    }
                    else{
                        $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                        $APICounter += 1
                        $VaultVersion = $response.ExternalVersion
                    }

                    $output = @{
                        token = $token
                        pvwa = $PVWA
                        HeaderType = "$token"
                        ISPSS = $false
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = "N/A"
                        EnableTroubleshooting = $EnableTroubleshooting
                        APICounter = $APICounter
                        Creds = $creds
                        AuthType = $AuthType
                        IDPLogin = $false
                    }
                    $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -APIUsername $username
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $token" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
            }catch{
                Write-VPASOutput -str $_ -type E -Initialized
                return $false
            }
        }
        elseif($AuthType -eq "saml"){
            try{
	            if($HideAscii){
                    #DO NOTHING
                }
                else{
                    Write-VPASOutput -str "NOTE - A BROWSER WINDOW WILL OPEN FOR SAML LOGIN, PLEASE COMPLETE AUTHENTICATION THERE" -type M -Initialized
                }

                Add-Type -AssemblyName System.Windows.Forms
                Add-Type -AssemblyName System.Web

                $WebView2LibDir = Join-Path $PSScriptRoot "..\lib\WebView2"
                $webview2CorePath = Join-Path $WebView2LibDir "Microsoft.Web.WebView2.Core.dll"
                $webview2WinFormsPath = Join-Path $WebView2LibDir "Microsoft.Web.WebView2.WinForms.dll"
                switch([System.Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture){
                    "X64"   { $webview2LoaderArch = "x64" }
                    "Arm64" { $webview2LoaderArch = "arm64" }
                    default { $webview2LoaderArch = "x86" }
                }
                $webview2LoaderDir = Join-Path $WebView2LibDir $webview2LoaderArch
                $webview2LoaderPath = Join-Path $webview2LoaderDir "WebView2Loader.dll"

                if(!(Test-Path $webview2CorePath) -or !(Test-Path $webview2WinFormsPath) -or !(Test-Path $webview2LoaderPath)){
                    Write-VPASOutput -str "WebView2 files not found under $WebView2LibDir (need Microsoft.Web.WebView2.Core.dll, Microsoft.Web.WebView2.WinForms.dll, and $webview2LoaderArch\WebView2Loader.dll for this process's architecture). Pull these from the Microsoft.Web.WebView2 NuGet package, or update `$WebView2LibDir in this function if you keep them elsewhere." -type E -Initialized
                    return $false
                }

                Add-Type -Path $webview2CorePath
                if(-not ("VpasModuleNative.Kernel32" -as [type])){
                    Add-Type -Namespace VpasModuleNative -Name Kernel32 -MemberDefinition @"
[System.Runtime.InteropServices.DllImport("kernel32.dll", SetLastError = true, CharSet = System.Runtime.InteropServices.CharSet.Auto)]
public static extern bool SetDllDirectory(string lpPathName);
"@
                }
                [VpasModuleNative.Kernel32]::SetDllDirectory($webview2LoaderDir) | Out-Null
                try{
                    [Microsoft.Web.WebView2.Core.CoreWebView2Environment]::GetAvailableBrowserVersionString() | Out-Null
                }
                catch{
                    Write-VPASOutput -str "WebView2 Runtime not found on this machine. Install it from https://developer.microsoft.com/microsoft-edge/webview2/ (Evergreen Bootstrapper), confirm it under Control Panel > Programs and Features, then retry." -type E -Initialized
                    return $false
                }

                if($NoSSL){
                    $samlUrl = "http://$PVWA/PasswordVault/v10/logon/saml"
                }
                else{
                    $samlUrl = "https://$PVWA/PasswordVault/v10/logon/saml"
                }

                $webView2UserDataFolder = Join-Path $env:LOCALAPPDATA "VpasModule\WebView2"
                if(!(Test-Path $webView2UserDataFolder)){
                    New-Item -ItemType Directory -Path $webView2UserDataFolder -Force | Out-Null
                }

                $wv2Script = {
                    param($SamlUrl, $WebView2CorePath, $WebView2WinFormsPath, $WebView2LoaderDir, $UserDataFolder, $TimeoutSec)

                    Add-Type -AssemblyName System.Windows.Forms
                    Add-Type -Path $WebView2CorePath
                    Add-Type -Path $WebView2WinFormsPath

                    if(-not ("VpasModuleNative.Kernel32" -as [type])){
                        Add-Type -Namespace VpasModuleNative -Name Kernel32 -MemberDefinition @"
[System.Runtime.InteropServices.DllImport("kernel32.dll", SetLastError = true, CharSet = System.Runtime.InteropServices.CharSet.Auto)]
public static extern bool SetDllDirectory(string lpPathName);
"@
                    }
                    [VpasModuleNative.Kernel32]::SetDllDirectory($WebView2LoaderDir) | Out-Null

                    $state = @{
                        SAMLResponse = $null
                        RecipientUri = $null
                        Cookies = @()
                        TimedOut = $false
                        StartTime = [DateTime]::UtcNow
                    }

                    $form = [System.Windows.Forms.Form]::new()
                    $form.Text = "CyberArk PVWA SAML Login"
                    $form.Width = 820
                    $form.Height = 680
                    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
                    $form.Topmost = $true

                    $wv = [Microsoft.Web.WebView2.WinForms.WebView2]::new()
                    $wv.Dock = [System.Windows.Forms.DockStyle]::Fill
                    $form.Controls.Add($wv)

                    $timer = [System.Windows.Forms.Timer]::new()
                    $timer.Interval = 300
                    $timer.Add_Tick({
                        if(([DateTime]::UtcNow - $state.StartTime).TotalSeconds -gt $TimeoutSec){
                            $state.TimedOut = $true
                            $timer.Stop()
                            $form.Close()
                            return
                        }
                        if($null -ne $state.SAMLResponse){
                            try{
                                $cookieTask = $wv.CoreWebView2.CookieManager.GetCookiesAsync($SamlUrl)
                                while(-not $cookieTask.IsCompleted){
                                    [System.Windows.Forms.Application]::DoEvents()
                                    Start-Sleep -Milliseconds 10
                                }
                                $cookieList = $cookieTask.GetAwaiter().GetResult()
                                $state.Cookies = @($cookieList | ForEach-Object {
                                    [PSCustomObject]@{
                                        Name = $_.Name
                                        Value = $_.Value
                                        Domain = $_.Domain
                                        Path = $_.Path
                                    }
                                })
                            }
                            catch{
                                #DO NOTHING
                            }
                            $timer.Stop()
                            $form.Close()
                        }
                    })

                    $wv.Add_CoreWebView2InitializationCompleted({
                        $wv.CoreWebView2.AddWebResourceRequestedFilter("*", [Microsoft.Web.WebView2.Core.CoreWebView2WebResourceContext]::All)
                        $wv.CoreWebView2.add_WebResourceRequested({
                            param($sender, $e)
                            if($null -ne $state.SAMLResponse){ return }

                            if($e.Request.Method -eq "GET"){
                                if($e.Request.Uri -match "SAMLResponse=([^&]+)"){
                                    $state.SAMLResponse = [System.Uri]::UnescapeDataString($Matches[1])
                                    $state.RecipientUri = $e.Request.Uri
                                    $e.Response = $sender.Environment.CreateWebResourceResponse($null, 200, "OK", "")
                                }
                                return
                            }

                            if($e.Request.Method -eq "POST"){
                                $contentStream = $e.Request.Content
                                if($null -eq $contentStream){ return }
                                try{
                                    $ms = New-Object System.IO.MemoryStream
                                    $contentStream.CopyTo($ms)
                                    $body = [System.Text.Encoding]::UTF8.GetString($ms.ToArray())
                                }
                                catch{
                                    return
                                }
                                if($body -match "SAMLResponse=([^&]+)"){
                                    $state.SAMLResponse = [System.Uri]::UnescapeDataString($Matches[1])
                                    $state.RecipientUri = $e.Request.Uri
                                    $e.Response = $sender.Environment.CreateWebResourceResponse($null, 200, "OK", "")
                                }
                                elseif($body -match '"?SAMLResponse"?\s*[:=]\s*"([^"&]+)"'){
                                    $state.SAMLResponse = [System.Uri]::UnescapeDataString($Matches[1])
                                    $state.RecipientUri = $e.Request.Uri
                                    $e.Response = $sender.Environment.CreateWebResourceResponse($null, 200, "OK", "")
                                }
                            }
                        })
                        $wv.CoreWebView2.Navigate($SamlUrl)
                    })

                    $envTask = [Microsoft.Web.WebView2.Core.CoreWebView2Environment]::CreateAsync($null, $UserDataFolder, $null)
                    while(-not $envTask.IsCompleted){
                        [System.Windows.Forms.Application]::DoEvents()
                        Start-Sleep -Milliseconds 10
                    }
                    $environment = $envTask.GetAwaiter().GetResult()

                    [void]$wv.EnsureCoreWebView2Async($environment)
                    $timer.Start()
                    [System.Windows.Forms.Application]::Run($form)

                    $timer.Dispose()
                    $wv.Dispose()
                    $form.Dispose()

                    if($state.TimedOut){ return $null }
                    return [PSCustomObject]@{
                        SAMLResponse = $state.SAMLResponse
                        RecipientUri = $state.RecipientUri
                        Cookies = $state.Cookies
                    }
                }

                $runspace = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace()
                $runspace.ApartmentState = [System.Threading.ApartmentState]::STA
                $runspace.ThreadOptions = [System.Management.Automation.Runspaces.PSThreadOptions]::ReuseThread
                $runspace.Open()

                $ps = [System.Management.Automation.PowerShell]::Create()
                $ps.Runspace = $runspace
                [void]$ps.AddScript($wv2Script).AddParameters(@{
                    SamlUrl = $samlUrl
                    WebView2CorePath = $webview2CorePath
                    WebView2WinFormsPath = $webview2WinFormsPath
                    WebView2LoaderDir = $webview2LoaderDir
                    UserDataFolder = $webView2UserDataFolder
                    TimeoutSec = 300
                })

                try{
                    $wv2Output = $ps.Invoke()
                }
                finally{
                    $runspace.Close()
                    $ps.Dispose()
                    $runspace.Dispose()
                }

                if($ps.HadErrors){
                    Write-VPASOutput -str "WebView2 window error: $($ps.Streams.Error[0].Exception.Message)" -type E -Initialized
                    return $false
                }

                $wv2Result = $wv2Output | Where-Object { $null -ne $_ } | Select-Object -First 1
                if(-not $wv2Result -or -not $wv2Result.SAMLResponse){
                    Write-VPASOutput -str "SAMLResponse not captured - login timed out or was cancelled in the browser window." -type E -Initialized
                    return $false
                }
                $SAMLToken = $wv2Result.SAMLResponse

                if($wv2Result.RecipientUri){
                    $uri = $wv2Result.RecipientUri
                }
                elseif($NoSSL){
                    $uri = "http://$PVWA/PasswordVault/API/auth/SAML/Logon"
                }
                else{
                    $uri = "https://$PVWA/PasswordVault/API/auth/SAML/Logon"
                }
                $params = @{
                    concurrentSession='true'
                    apiUse='true'
                    SAMLResponse=$SAMLToken
                }

                $samlSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                foreach($capturedCookie in $wv2Result.Cookies){
                    try{
                        $netCookie = New-Object System.Net.Cookie($capturedCookie.Name, $capturedCookie.Value, $capturedCookie.Path, $capturedCookie.Domain)
                        $samlSession.Cookies.Add($netCookie)
                    }
                    catch{
                        Write-Verbose "Could not replay cookie $($capturedCookie.Name): $_"
                    }
                }
                Write-Verbose "API PARAMETERS SET"

                $APICounter += 1
                Write-Verbose "RETURNING LOGIN TOKEN"
                $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                if($InitiateCookie){
                    Write-Verbose "INITIATING COOKIE"
                    $cookie = new-object system.net.cookie
                    $cookie.name = "tos_accepted"
                    $cookie.domain = "$PVWA"
                    $session = new-object microsoft.powershell.commands.webrequestsession
                    $session.cookies.add($cookie)
                    foreach($sc in $samlSession.Cookies.GetCookies($uri)){
                        $session.Cookies.Add($sc)
                    }

                    try{
                        $token = Invoke-RestMethod -Uri $uri -Method Post -body $params -ContentType 'application/x-www-form-urlencoded' -WebSession $session
                    }
                    catch{
                        Write-VPASOutput -str "$_" -type E -Initialized
                        return $false
                    }

                    if($NoSSL){
                        $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                        $APICounter += 1
                        $VaultVersion = $response.ExternalVersion
                    }
                    else{
                        $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                        $APICounter += 1
                        $VaultVersion = $response.ExternalVersion
                    }

                    $output = @{
                        token = $token
                        session = $session
                        pvwa = $PVWA
                        HeaderType = "$token"
                        ISPSS = $false
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = "N/A"
                        EnableTroubleshooting = $EnableTroubleshooting
                        APICounter = $APICounter
                        Creds = $creds
                        AuthType = $AuthType
                        IDPLogin = $false
                    }
                    $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -APIUsername $username
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
                else{
                    try{
                        $token = Invoke-RestMethod -Uri $uri -Method Post -body $params -ContentType 'application/x-www-form-urlencoded' -WebSession $samlSession
                    }
                    catch{
                        Write-VPASOutput -str "$_" -type E -Initialized
                        return $false
                    }

                    if($NoSSL){
                        $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                        $APICounter += 1
                        $VaultVersion = $response.ExternalVersion
                    }
                    else{
                        $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                        $APICounter += 1
                        $VaultVersion = $response.ExternalVersion
                    }

                    $output = @{
                        token = $token
                        pvwa = $PVWA
                        HeaderType = "$token"
                        ISPSS = $false
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = "N/A"
                        EnableTroubleshooting = $EnableTroubleshooting
                        APICounter = $APICounter
                        Creds = $creds
                        AuthType = $AuthType
                        IDPLogin = $false
                    }
                    $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -APIUsername $username
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
            }catch{
                Write-VPASOutput -str $_ -type E -Initialized
                return $false
            }
        }
        elseif($AuthType -eq "ispss_oauth" -or $AuthType -eq "srs_oauth"){
            if([String]::IsNullOrEmpty($IdentityURL)){
                Write-VPASOutput -str "ISPSS/SRS OUATH SELECTED BUT NO IdentityURL PROVIDED, PLEASE ENTER IdentityURL (Example: AAT1234.id.cyberark.cloud): " -type Y -Initialized
                $IdentityURL = Read-host
            }
            $IdentityURL = $IdentityURL -replace "https://",""
            $IdentityURL = $IdentityURL -replace "http://",""

            try{
                if(!$creds){
                    $creds = Get-Credential -Message 'ENTER OAUTH CREDENTIALS'
                }
                $username = $creds.GetNetworkCredential().UserName
                $password = $creds.GetNetworkCredential().Password
                Write-Verbose "OAUTH CREDENTIALS SET"

                $params = @{
                    concurrentSession='true'
                    grant_type = "client_credentials"
                    client_id = $username
                    client_secret = $password
                }
                Write-Verbose "API PARAMETERS SET"
                if($NoSSL){
                    $uri = "http://$IdentityURL/oauth2/platformtoken"
                }
                else{
                    $uri = "https://$IdentityURL/oauth2/platformtoken"
                }

                if($InitiateCookie){
                    Write-Verbose "INITIATING COOKIE"
                    $cookie = new-object system.net.cookie
                    $cookie.name = "tos_accepted"
                    $cookie.domain = "$IdentityURL"
                    $session = new-object microsoft.powershell.commands.webrequestsession
                    $session.cookies.add($cookie)

                    $response = Invoke-RestMethod -Uri $uri -Method Post -Body $params
                    $APICounter += 1
                    $tokenval = $response.access_token
                    Write-Verbose "RETURNING LOGIN TOKEN AND COOKIE SESSION"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($IdentityOnly){
                        $VaultVersion = "N/A"
                        $SubDomain = "N/A"
                        $PVWA = "Identity_Only"
                        Write-VPASOutput -str "***IdentityOnly selected, only Identity related api calls will work***" -type M -Initialized
                    }
                    else{
                        if($NoSSL){
                            $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                            $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                            $APICounter += 1
                            $VaultVersion = $response.ExternalVersion
                            if([String]::IsNullOrEmpty($VaultVersion)){
                                Write-VPASOutput -str "***Authenticated into Identity successfully, but failed to connect to $PVWA endpoint***" -type M -Initialized
                                Write-VPASOutput -str "***Token will be returned and Identity related api calls will work, but not privilegecloud related api calls***" -type M -Initialized
                            }
                        }
                        else{
                            $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                            $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                            $APICounter += 1
                            $VaultVersion = $response.ExternalVersion
                            if([String]::IsNullOrEmpty($VaultVersion)){
                                Write-VPASOutput -str "***Authenticated into Identity successfully, but failed to connect to $PVWA endpoint***" -type M -Initialized
                                Write-VPASOutput -str "***Token will be returned and Identity related api calls will work, but not privilegecloud related api calls***" -type M -Initialized
                            }
                        }
                        $SubDomain = ($PVWA.split("."))[0]
                    }
                    $output = @{
                        token = $tokenval
                        session = $session
                        pvwa = $PVWA
                        HeaderType = "Bearer $tokenval"
                        ISPSS = $true
                        IdentityURL = $IdentityURL
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = $SubDomain
                        EnableTroubleshooting = $EnableTroubleshooting
                        APICounter = $APICounter
                        Creds = $creds
                        AuthType = $AuthType
                        IDPLogin = $false
                    }
                    if($AuthType -eq "srs_oauth"){
                        $output += @{ SRS = $true }
                    }
                    else{
                        $output += @{ SRS = $false }
                    }
                    if($IdentityOnly){
                        $outputCurUser = $username
                    }
                    else{
                        $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output
                    }
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
                else{
                    $response = Invoke-RestMethod -Uri $uri -Method Post -Body $params
                    $APICounter += 1
                    $tokenval = $response.access_token
                    Write-Verbose "RETURNING LOGIN TOKEN"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($IdentityOnly){
                        $VaultVersion = "N/A"
                        $SubDomain = "N/A"
                        $PVWA = "Identity_Only"
                        Write-VPASOutput -str "***IdentityOnly selected, only Identity related api calls will work***" -type M -Initialized
                    }
                    else{
                        if($NoSSL){
                            $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                            $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                            $APICounter += 1
                            $VaultVersion = $response.ExternalVersion
                            if([String]::IsNullOrEmpty($VaultVersion)){
                                Write-VPASOutput -str "***Authenticated into Identity successfully, but failed to connect to $PVWA endpoint***" -type M -Initialized
                                Write-VPASOutput -str "***Token will be returned and Identity related api calls will work, but not privilegecloud related api calls***" -type M -Initialized
                            }
                        }
                        else{
                            $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                            $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                            $APICounter += 1
                            $VaultVersion = $response.ExternalVersion
                            if([String]::IsNullOrEmpty($VaultVersion)){
                                Write-VPASOutput -str "***Authenticated into Identity successfully, but failed to connect to $PVWA endpoint***" -type M -Initialized
                                Write-VPASOutput -str "***Token will be returned and Identity related api calls will work, but not privilegecloud related api calls***" -type M -Initialized
                            }
                        }
                        $SubDomain = ($PVWA.split("."))[0]
                    }

                    $output = @{
                        token = $tokenval
                        pvwa = $PVWA
                        HeaderType = "Bearer $tokenval"
                        ISPSS = $true
                        IdentityURL = $IdentityURL
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        session = $false
                        HideWarnings = $HideWarnings
                        SubDomain = $SubDomain
                        EnableTroubleshooting = $EnableTroubleshooting
                        APICounter = $APICounter
                        Creds = $creds
                        AuthType = $AuthType
                        IDPLogin = $false
                    }
                    if($AuthType -eq "srs_oauth"){
                        $output += @{ SRS = $true }
                    }
                    else{
                        $output += @{ SRS = $false }
                    }
                    if($IdentityOnly){
                        $outputCurUser = $username
                    }
                    else{
                        $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output
                    }
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
            }catch{
                Write-VPASOutput -str $_ -type E -Initialized
                return $false
            }
        }
        elseif($AuthType -eq "ispss_cyberark" -or $AuthType -eq "srs_cyberark"){
            $output = @{}
            if([String]::IsNullOrEmpty($IdentityURL)){
                Write-VPASOutput -str "ISPSS/SRS CYBERARK SELECTED BUT NO IdentityURL PROVIDED, PLEASE ENTER IdentityURL (Example: AAT1234.id.cyberark.cloud): " -type Y -Initialized
                $IdentityURL = Read-host
            }
            $IdentityURL = $IdentityURL -replace "https://",""
            $IdentityURL = $IdentityURL -replace "http://",""

            try{
                if(!$creds){
                    $creds = Get-Credential -Message 'ENTER CYBERARK CREDENTIALS'
                }
                $username = $creds.GetNetworkCredential().UserName
                $password = $creds.GetNetworkCredential().Password
                Write-Verbose "IDIRA (formerly CyberArk) CREDENTIALS SET"

                $params = @{
                    TenantId = $IdentityTenantID
                    User = $username
                    Version = "1.0"
                } | ConvertTo-Json
                Write-Verbose "API PARAMETERS SET"

                if($NoSSL){
                    $uri = "http://$IdentityURL/Security/StartAuthentication"
                }
                else{
                    $uri = "https://$IdentityURL/Security/StartAuthentication"
                }

                if($InitiateCookie){
                    Write-Verbose "INITIATING COOKIE"
                    $cookie = new-object system.net.cookie
                    $cookie.name = "tos_accepted"
                    $cookie.domain = "$IdentityURL"
                    $session = new-object microsoft.powershell.commands.webrequestsession
                    $session.cookies.add($cookie)
                    $output += @{ session = $session }
                }
                else{
                    $output += @{ session = $false }
                }

                $response = Invoke-RestMethod -Uri $uri -Method Post -Body $params -ContentType 'application/json'
                $APICounter += 1
                $SessionID = $response.Result.SessionId
                $AllTasks = $response.Result.Challenges

                $ChallengeMatrix = @{}
                $AmtTasks = $AllTasks.Count
                for($j = 0; $j -lt $AmtTasks; $j++){
                    $tempcount = $j + 1
                    $count = 1
                    $authMethod = @{}
                    foreach($challenge in $AllTasks[$j].Mechanisms){
                        $ChallangeParams = @{
                            AnswerType = $challenge.AnswerType
                            Name = $challenge.Name
                            PromptMechChosen = $challenge.PromptMechChosen
                            PromptSelectMech = $challenge.PromptSelectMech
                            MechanismId = $challenge.MechanismId
                            Enrolled = $challenge.Enrolled
                        }
                        $authMethod += @{
                            "Challenge$count" = $ChallangeParams
                        }
                        $count += 1
                    }
                    $ChallengeMatrix += @{
                        "Task$tempcount" = $authMethod
                    }
                }

                $AmtTasks = $ChallengeMatrix.Keys.Count
                for($i = 1; $i -lt $AmtTasks + 1; $i++){
                    $challengeCounter = 1
                    $AmtChallenges = $ChallengeMatrix."Task$i".Count

                    Write-VPASOutput -str "MUST COMPLETE ONE OF THE CHALLENGES BELOW TO PROCEED:" -type M -Initialized
                    for($j = 1; $j -lt $AmtChallenges + 1; $j++){
                        $ChallengeType = $ChallengeMatrix."Task$i"."Challenge$j".PromptSelectMech
                        Write-VPASOutput -str "Challenge$j : $ChallengeType" -type G -Initialized
                    }

                    Write-VPASOutput -str "SELECT CHALLENGE NUMBER: " -type Y -Initialized
                    $selChallenger = Read-Host
                    while(!$ChallengeMatrix."Task$i"."Challenge$selChallenger"){
                        Write-VPASOutput -str "INVALID CHOICE" -type E -Initialized
                        Write-VPASOutput -str "SELECT CHALLENGE NUMBER: " -type Y -Initialized
                        $selChallenger = Read-Host
                    }
                    Write-VPASOutput -str "Starting Challenge..." -type C -Initialized

                    $curAnswerType = $ChallengeMatrix."Task$i"."Challenge$selChallenger".AnswerType
                    $curName = $ChallengeMatrix."Task$i"."Challenge$selChallenger".Name
                    $curPromptMechChosen = $ChallengeMatrix."Task$i"."Challenge$selChallenger".PromptMechChosen
                    $curPromptSelectMech = $ChallengeMatrix."Task$i"."Challenge$selChallenger".PromptSelectMech
                    $curMechanismID = $ChallengeMatrix."Task$i"."Challenge$selChallenger".MechanismId
                    $curEnrolled = $ChallengeMatrix."Task$i"."Challenge$selChallenger".Enrolled

                    if($curAnswerType -eq "StartTextOob"){
                        $curAction = "StartOOB"
                        $params = @{
                            TenantID = $IdentityTenantID
                            SessionId = $SessionID
                            MechanismId = $curMechanismID
                            Action = $curAction
                        } | ConvertTo-Json
                    }
                    elseif($curAnswerType -eq "Text"){
                        $curAction = "Answer"
                        if($curName -eq "UP"){
                            $curAnswer = $password
                        }
                        else{
                            $tempAnswer = Read-Host "$curPromptMechChosen" -AsSecureString
                            $curBSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($tempAnswer)
                            $curAnswer = ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($curBSTR))
                        }
                        $params = @{
                            TenantID = $IdentityTenantID
                            SessionId = $SessionID
                            MechanismId = $curMechanismID
                            Action = $curAction
                            Answer = $curAnswer
                        } | ConvertTo-Json
                    }

                    $uri = "https://$IdentityURL/Security/AdvanceAuthentication"
                    $AnswerToChallenge = Invoke-RestMethod -Uri $uri -Method Post -Body $params -ContentType "application/json"
                    $APICounter += 1
                    while($AnswerToChallenge.Result.Summary -eq "OobPending") {
                        Write-VPASOutput -str "Waiting for email/push/other action to complete" -type M -Initialized
                        Start-Sleep -Seconds 4
                        $param = @{
                            TenantID = $IdentityTenantId
                            SessionId = $SessionId
                            MechanismId = $curMechanismID
                            Action = "Poll"
                        } | ConvertTo-Json
                        $AnswerToChallenge = Invoke-RestMethod -Uri $uri -Method Post -Body $param -ContentType "application/json" -TimeoutSec 5
                        $APICounter += 1
                    }
                }

                if($AnswerToChallenge.success){
                    $tokenval = $AnswerToChallenge.Result.Token
                    Write-Verbose "RETURNING LOGIN TOKEN"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($IdentityOnly){
                        $VaultVersion = "N/A"
                        $SubDomain = "N/A"
                        $PVWA = "Identity_Only"
                        Write-VPASOutput -str "***IdentityOnly selected, only Identity related api calls will work***" -type M -Initialized
                    }
                    else{
                        if($session){
                            if($NoSSL){
                                $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                                $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                                $APICounter += 1
                                $VaultVersion = $response.ExternalVersion
                                if([String]::IsNullOrEmpty($VaultVersion)){
                                    Write-VPASOutput -str "***Authenticated into Identity successfully, but failed to connect to $PVWA endpoint***" -type M -Initialized
                                    Write-VPASOutput -str "***Token will be returned and Identity related api calls will work, but not privilegecloud related api calls***" -type M -Initialized
                                }
                            }
                            else{
                                $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                                $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                                $APICounter += 1
                                $VaultVersion = $response.ExternalVersion
                                if([String]::IsNullOrEmpty($VaultVersion)){
                                    Write-VPASOutput -str "***Authenticated into Identity successfully, but failed to connect to $PVWA endpoint***" -type M -Initialized
                                    Write-VPASOutput -str "***Token will be returned and Identity related api calls will work, but not privilegecloud related api calls***" -type M -Initialized
                                }
                            }
                        }
                        else{
                            if($NoSSL){
                                $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                                $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                                $APICounter += 1
                                $VaultVersion = $response.ExternalVersion
                                if([String]::IsNullOrEmpty($VaultVersion)){
                                    Write-VPASOutput -str "***Authenticated into Identity successfully, but failed to connect to $PVWA endpoint***" -type M -Initialized
                                    Write-VPASOutput -str "***Token will be returned and Identity related api calls will work, but not privilegecloud related api calls***" -type M -Initialized
                                }
                            }
                            else{
                                $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                                $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                                $APICounter += 1
                                $VaultVersion = $response.ExternalVersion
                                if([String]::IsNullOrEmpty($VaultVersion)){
                                    Write-VPASOutput -str "***Authenticated into Identity successfully, but failed to connect to $PVWA endpoint***" -type M -Initialized
                                    Write-VPASOutput -str "***Token will be returned and Identity related api calls will work, but not privilegecloud related api calls***" -type M -Initialized
                                }
                            }
                        }
                        $SubDomain = ($PVWA.split("."))[0]
                    }

                    $output += @{
                        token = $tokenval
                        pvwa = $PVWA
                        HeaderType = "Bearer $tokenval"
                        ISPSS = $true
                        IdentityURL = $IdentityURL
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = $SubDomain
                        EnableTroubleshooting = $EnableTroubleshooting
                        APICounter = $APICounter
                        Creds = $creds
                        AuthType = $AuthType
                        IDPLogin = $false
                    }
                    if($AuthType -eq "srs_cyberark"){
                        $output += @{ SRS = $true }
                    }
                    else{
                        $output += @{ SRS = $false }
                    }
                    if($IdentityOnly){
                        $outputCurUser = $username
                    }
                    else{
                        $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output
                    }
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
                else{
                    Write-VPASOutput -str "FAILED TO PASS CHALLENGES...RETURNING FALSE" -type E -Initialized
                    return $false
                }
            }catch{
                Write-VPASOutput -str $_ -type E -Initialized
                return $false
            }
        }
        elseif($AuthType -eq "ispss_authtoken" -or $AuthType -eq "srs_authtoken"){
            if([String]::IsNullOrEmpty($IdentityURL)){
                Write-VPASOutput -str "ISPSS/SRS AUTHTOKEN SELECTED BUT NO IdentityURL PROVIDED, PLEASE ENTER IdentityURL (Example: AAT1234.id.cyberark.cloud): " -type Y -Initialized
                $IdentityURL = Read-host
            }
            $IdentityURL = $IdentityURL -replace "https://",""
            $IdentityURL = $IdentityURL -replace "http://",""

            if([String]::IsNullOrEmpty($AuthToken)){
                Write-VPASOutput -str "ISPSS/SRS AUTHTOKEN SELECTED BUT NO AuthToken PROVIDED, PLEASE ENTER AuthToken (Example: eyJhbGc....Q0IyNE): " -type Y -Initialized
                $AuthToken = Read-host
            }

            try{
                Write-Verbose "AuthToken PROVIDED...SKIPPING CREDENTIAL SECTION"
                if($InitiateCookie){
                    Write-Verbose "INITIATING COOKIE"
                    $cookie = new-object system.net.cookie
                    $cookie.name = "tos_accepted"
                    $cookie.domain = "$IdentityURL"
                    $session = new-object microsoft.powershell.commands.webrequestsession
                    $session.cookies.add($cookie)

                    $tokenval = $AuthToken
                    Write-Verbose "RETURNING LOGIN TOKEN AND COOKIE SESSION"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($IdentityOnly){
                        $VaultVersion = "N/A"
                        $SubDomain = "N/A"
                        $PVWA = "Identity_Only"
                        Write-VPASOutput -str "***IdentityOnly selected, only Identity related api calls will work***" -type M -Initialized
                    }
                    else{
                        if($NoSSL){
                            $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                            $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                            $APICounter += 1
                            $VaultVersion = $response.ExternalVersion
                        }
                        else{
                            $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                            $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                            $APICounter += 1
                            $VaultVersion = $response.ExternalVersion
                        }
                        $SubDomain = ($PVWA.split("."))[0]
                    }

                    $output = @{
                        token = $tokenval
                        session = $session
                        pvwa = $PVWA
                        HeaderType = "Bearer $tokenval"
                        ISPSS = $true
                        IdentityURL = $IdentityURL
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = $SubDomain
                        EnableTroubleshooting = $EnableTroubleshooting
                        APICounter = $APICounter
                        Creds = $creds
                        AuthType = $AuthType
                        IDPLogin = $false
                    }
                    if($AuthType -eq "srs_authtoken"){
                        $output += @{ SRS = $true }
                    }
                    else{
                        $output += @{ SRS = $false }
                    }
                    if($IdentityOnly){
                        $outputCurUser = "UNKNOWN"
                    }
                    else{
                        $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output
                    }
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
                else{
                    $tokenval = $AuthToken
                    Write-Verbose "RETURNING LOGIN TOKEN"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($IdentityOnly){
                        $VaultVersion = "N/A"
                        $SubDomain = "N/A"
                        $PVWA = "Identity_Only"
                        Write-VPASOutput -str "***IdentityOnly selected, only Identity related api calls will work***" -type M -Initialized
                    }
                    else{
                        if($NoSSL){
                            $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                            $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                            $APICounter += 1
                            $VaultVersion = $response.ExternalVersion
                        }
                        else{
                            $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                            $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                            $APICounter += 1
                            $VaultVersion = $response.ExternalVersion
                        }
                        $SubDomain = ($PVWA.split("."))[0]
                    }

                    $output = @{
                        token = $tokenval
                        pvwa = $PVWA
                        HeaderType = "Bearer $tokenval"
                        ISPSS = $true
                        IdentityURL = $IdentityURL
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        session = $false
                        HideWarnings = $HideWarnings
                        SubDomain = $SubDomain
                        EnableTroubleshooting = $EnableTroubleshooting
                        APICounter = $APICounter
                        Creds = $creds
                        AuthType = $AuthType
                        IDPLogin = $false
                    }
                    if($AuthType -eq "srs_authtoken"){
                        $output += @{ SRS = $true }
                    }
                    else{
                        $output += @{ SRS = $false }
                    }
                    if($IdentityOnly){
                        $outputCurUser = "UNKNOWN"
                    }
                    else{
                        $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output
                    }
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
            }catch{
                Write-VPASOutput -str $_ -type E -Initialized
                return $false
            }
        }
        elseif($AuthType -eq "authtoken"){
            try{
                Write-Verbose "AuthToken PROVIDED...SKIPPING CREDENTIAL SECTION"
                if($InitiateCookie){
                    Write-Verbose "INITIATING COOKIE"
                    $cookie = new-object system.net.cookie
                    $cookie.name = "tos_accepted"
                    $cookie.domain = "$PVWA"
                    $session = new-object microsoft.powershell.commands.webrequestsession
                    $session.cookies.add($cookie)

                    $token = $AuthToken
                    Write-Verbose "RETURNING LOGIN TOKEN AND COOKIE SESSION"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($NoSSL){
                        $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                        $APICounter += 1
                        $VaultVersion = $response.ExternalVersion
                    }
                    else{
                        $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                        $APICounter += 1
                        $VaultVersion = $response.ExternalVersion
                    }

                    $output = @{
                        token = $token
                        session = $session
                        pvwa = $PVWA
                        HeaderType = "$token"
                        ISPSS = $false
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = "N/A"
                        EnableTroubleshooting = $EnableTroubleshooting
                        APICounter = $APICounter
                        Creds = $creds
                        AuthType = $AuthType
                        IDPLogin = $false
                    }
                    $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -APIUsername $username
                    if([String]::IsNullOrEmpty($outputCurUser)){ $outputCurUser = "UNKNOWN" }
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $token" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
                else{
                    $token = $AuthToken
                    Write-Verbose "RETURNING LOGIN TOKEN"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($NoSSL){
                        $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                        $APICounter += 1
                        $VaultVersion = $response.ExternalVersion
                    }
                    else{
                        $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                        $APICounter += 1
                        $VaultVersion = $response.ExternalVersion
                    }

                    $output = @{
                        token = $token
                        pvwa = $PVWA
                        HeaderType = "$token"
                        ISPSS = $false
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = "N/A"
                        EnableTroubleshooting = $EnableTroubleshooting
                        APICounter = $APICounter
                        Creds = $creds
                        AuthType = $AuthType
                        IDPLogin = $false
                    }
                    $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -APIUsername $username
                    if([String]::IsNullOrEmpty($outputCurUser)){ $outputCurUser = "UNKNOWN" }
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $token" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
            }catch{
                Write-VPASOutput -str $_ -type E -Initialized
                return $false
            }
        }
    }
    End{

    }
}
# SIG # Begin signature block
# MIIsuQYJKoZIhvcNAQcCoIIsqjCCLKYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUwZs6R6oupsEZbvEZ4kayrHZW
# ZCCggiXzMIIFbzCCBFegAwIBAgIQSPyTtGBVlI02p8mKidaUFjANBgkqhkiG9w0B
# AQwFADB7MQswCQYDVQQGEwJHQjEbMBkGA1UECAwSR3JlYXRlciBNYW5jaGVzdGVy
# MRAwDgYDVQQHDAdTYWxmb3JkMRowGAYDVQQKDBFDb21vZG8gQ0EgTGltaXRlZDEh
# MB8GA1UEAwwYQUFBIENlcnRpZmljYXRlIFNlcnZpY2VzMB4XDTIxMDUyNTAwMDAw
# MFoXDTI4MTIzMTIzNTk1OVowVjELMAkGA1UEBhMCR0IxGDAWBgNVBAoTD1NlY3Rp
# Z28gTGltaXRlZDEtMCsGA1UEAxMkU2VjdGlnbyBQdWJsaWMgQ29kZSBTaWduaW5n
# IFJvb3QgUjQ2MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAjeeUEiIE
# JHQu/xYjApKKtq42haxH1CORKz7cfeIxoFFvrISR41KKteKW3tCHYySJiv/vEpM7
# fbu2ir29BX8nm2tl06UMabG8STma8W1uquSggyfamg0rUOlLW7O4ZDakfko9qXGr
# YbNzszwLDO/bM1flvjQ345cbXf0fEj2CA3bm+z9m0pQxafptszSswXp43JJQ8mTH
# qi0Eq8Nq6uAvp6fcbtfo/9ohq0C/ue4NnsbZnpnvxt4fqQx2sycgoda6/YDnAdLv
# 64IplXCN/7sVz/7RDzaiLk8ykHRGa0c1E3cFM09jLrgt4b9lpwRrGNhx+swI8m2J
# mRCxrds+LOSqGLDGBwF1Z95t6WNjHjZ/aYm+qkU+blpfj6Fby50whjDoA7NAxg0P
# OM1nqFOI+rgwZfpvx+cdsYN0aT6sxGg7seZnM5q2COCABUhA7vaCZEao9XOwBpXy
# bGWfv1VbHJxXGsd4RnxwqpQbghesh+m2yQ6BHEDWFhcp/FycGCvqRfXvvdVnTyhe
# Be6QTHrnxvTQ/PrNPjJGEyA2igTqt6oHRpwNkzoJZplYXCmjuQymMDg80EY2NXyc
# uu7D1fkKdvp+BRtAypI16dV60bV/AK6pkKrFfwGcELEW/MxuGNxvYv6mUKe4e7id
# FT/+IAx1yCJaE5UZkADpGtXChvHjjuxf9OUCAwEAAaOCARIwggEOMB8GA1UdIwQY
# MBaAFKARCiM+lvEH7OKvKe+CpX/QMKS0MB0GA1UdDgQWBBQy65Ka/zWWSC8oQEJw
# IDaRXBeF5jAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zATBgNVHSUE
# DDAKBggrBgEFBQcDAzAbBgNVHSAEFDASMAYGBFUdIAAwCAYGZ4EMAQQBMEMGA1Ud
# HwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0FBQUNlcnRpZmlj
# YXRlU2VydmljZXMuY3JsMDQGCCsGAQUFBwEBBCgwJjAkBggrBgEFBQcwAYYYaHR0
# cDovL29jc3AuY29tb2RvY2EuY29tMA0GCSqGSIb3DQEBDAUAA4IBAQASv6Hvi3Sa
# mES4aUa1qyQKDKSKZ7g6gb9Fin1SB6iNH04hhTmja14tIIa/ELiueTtTzbT72ES+
# BtlcY2fUQBaHRIZyKtYyFfUSg8L54V0RQGf2QidyxSPiAjgaTCDi2wH3zUZPJqJ8
# ZsBRNraJAlTH/Fj7bADu/pimLpWhDFMpH2/YGaZPnvesCepdgsaLr4CnvYFIUoQx
# 2jLsFeSmTD1sOXPUC4U5IOCFGmjhp0g4qdE2JXfBjRkWxYhMZn0vY86Y6GnfrDyo
# XZ3JHFuu2PMvdM+4fvbXg50RlmKarkUT2n/cR/vfw1Kf5gZV6Z2M8jpiUbzsJA8p
# 1FiAhORFe1rYMIIGGjCCBAKgAwIBAgIQYh1tDFIBnjuQeRUgiSEcCjANBgkqhkiG
# 9w0BAQwFADBWMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVk
# MS0wKwYDVQQDEyRTZWN0aWdvIFB1YmxpYyBDb2RlIFNpZ25pbmcgUm9vdCBSNDYw
# HhcNMjEwMzIyMDAwMDAwWhcNMzYwMzIxMjM1OTU5WjBUMQswCQYDVQQGEwJHQjEY
# MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSswKQYDVQQDEyJTZWN0aWdvIFB1Ymxp
# YyBDb2RlIFNpZ25pbmcgQ0EgUjM2MIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIB
# igKCAYEAmyudU/o1P45gBkNqwM/1f/bIU1MYyM7TbH78WAeVF3llMwsRHgBGRmxD
# eEDIArCS2VCoVk4Y/8j6stIkmYV5Gej4NgNjVQ4BYoDjGMwdjioXan1hlaGFt4Wk
# 9vT0k2oWJMJjL9G//N523hAm4jF4UjrW2pvv9+hdPX8tbbAfI3v0VdJiJPFy/7Xw
# iunD7mBxNtecM6ytIdUlh08T2z7mJEXZD9OWcJkZk5wDuf2q52PN43jc4T9OkoXZ
# 0arWZVeffvMr/iiIROSCzKoDmWABDRzV/UiQ5vqsaeFaqQdzFf4ed8peNWh1OaZX
# nYvZQgWx/SXiJDRSAolRzZEZquE6cbcH747FHncs/Kzcn0Ccv2jrOW+LPmnOyB+t
# AfiWu01TPhCr9VrkxsHC5qFNxaThTG5j4/Kc+ODD2dX/fmBECELcvzUHf9shoFvr
# n35XGf2RPaNTO2uSZ6n9otv7jElspkfK9qEATHZcodp+R4q2OIypxR//YEb3fkDn
# 3UayWW9bAgMBAAGjggFkMIIBYDAfBgNVHSMEGDAWgBQy65Ka/zWWSC8oQEJwIDaR
# XBeF5jAdBgNVHQ4EFgQUDyrLIIcouOxvSK4rVKYpqhekzQwwDgYDVR0PAQH/BAQD
# AgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAwEwYDVR0lBAwwCgYIKwYBBQUHAwMwGwYD
# VR0gBBQwEjAGBgRVHSAAMAgGBmeBDAEEATBLBgNVHR8ERDBCMECgPqA8hjpodHRw
# Oi8vY3JsLnNlY3RpZ28uY29tL1NlY3RpZ29QdWJsaWNDb2RlU2lnbmluZ1Jvb3RS
# NDYuY3JsMHsGCCsGAQUFBwEBBG8wbTBGBggrBgEFBQcwAoY6aHR0cDovL2NydC5z
# ZWN0aWdvLmNvbS9TZWN0aWdvUHVibGljQ29kZVNpZ25pbmdSb290UjQ2LnA3YzAj
# BggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wDQYJKoZIhvcNAQEM
# BQADggIBAAb/guF3YzZue6EVIJsT/wT+mHVEYcNWlXHRkT+FoetAQLHI1uBy/YXK
# ZDk8+Y1LoNqHrp22AKMGxQtgCivnDHFyAQ9GXTmlk7MjcgQbDCx6mn7yIawsppWk
# vfPkKaAQsiqaT9DnMWBHVNIabGqgQSGTrQWo43MOfsPynhbz2Hyxf5XWKZpRvr3d
# MapandPfYgoZ8iDL2OR3sYztgJrbG6VZ9DoTXFm1g0Rf97Aaen1l4c+w3DC+IkwF
# kvjFV3jS49ZSc4lShKK6BrPTJYs4NG1DGzmpToTnwoqZ8fAmi2XlZnuchC4NPSZa
# PATHvNIzt+z1PHo35D/f7j2pO1S8BCysQDHCbM5Mnomnq5aYcKCsdbh0czchOm8b
# kinLrYrKpii+Tk7pwL7TjRKLXkomm5D1Umds++pip8wH2cQpf93at3VDcOK4N7Ew
# oIJB0kak6pSzEu4I64U6gZs7tS/dGNSljf2OSSnRr7KWzq03zl8l75jy+hOds9TW
# SenLbjBQUGR96cFr6lEUfAIEHVC1L68Y1GGxx4/eRI82ut83axHMViw1+sVpbPxg
# 51Tbnio1lB93079WPFnYaOvfGAA0e0zcfF/M9gXr+korwQTh2Prqooq2bYNMvUoU
# KD85gnJ+t0smrWrb8dee2CvYZXD5laGtaAxOfy/VKNmwuWuAh9kcMIIGRzCCBK+g
# AwIBAgIQacs5SDkvNuif0aEmZmr03jANBgkqhkiG9w0BAQwFADBUMQswCQYDVQQG
# EwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSswKQYDVQQDEyJTZWN0aWdv
# IFB1YmxpYyBDb2RlIFNpZ25pbmcgQ0EgUjM2MB4XDTI1MDEyOTAwMDAwMFoXDTI4
# MDEyOTIzNTk1OVowXjELMAkGA1UEBhMCVVMxEzARBgNVBAgMCk5ldyBKZXJzZXkx
# HDAaBgNVBAoME0N5YmVyTWVsIENvbnN1bHRpbmcxHDAaBgNVBAMME0N5YmVyTWVs
# IENvbnN1bHRpbmcwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDBQmSv
# dfamF8o0CJr4vbHCcJ4rwx6T1HR3d32u4aIf9v9p/GV4nFdG4PP9SMjWw7Nx9CLF
# qGPpkw7aDU2IxwpfPYExDzkCj2pgiyeVKlL0itTlPocb6i1cZLe/WHV7aUkGkVlf
# vyYIqdJ9uw711dhNWmMhlqo+/qyp+gpKqaiFHm6mWNVg2KLTH5Pu38cBoGhS1tn7
# mlQbtALNjehkpFw2AAntEIBzM3ZEg9WBxQlgYY0yAPkydYbJfTEOEFJqHUPTSV46
# jx22Jb9dl0cEIPsGrCp+Jo5Ugusp9oZECZ8bGt7Vc9jYoIWGpqcRDq1JZFNCSVvN
# E4N3ECGjq6W3kYW7ot0CP1DkpJ93a5wrksQ6bvYGUy3lghkMvzjkkq/NVUDEVcdN
# R7PsUFf654vSw+iLINZ+9kYg+ZnplfndT/JSMJDAaWkM5oLu6+ao0774QWrsHOtt
# z7M8EDU+3PntYHglwWoej6qXIFRurgXdwAXXyXYcSmkOTbPqrjSwsbs8CuSwGqeb
# bRSDKfjRzDqQ9D1AZ/JHHaaUkBbAYBsVMrvypDSrP/1o37mt4Zky28BnEp5ztEGp
# 0HJ44X4rFVWWz+BfeuZWcVUcGKW2YFHobNwGmJ/OanLvlnmtpZIRLF9ZkbzCHHom
# i+RId4g3fc3FsGxKqEW9Vj8PCumwKc6LUwZU4wIDAQABo4IBiTCCAYUwHwYDVR0j
# BBgwFoAUDyrLIIcouOxvSK4rVKYpqhekzQwwHQYDVR0OBBYEFCiCHmEfvPkU1uIc
# 2sPugFDBq88SMA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQM
# MAoGCCsGAQUFBwMDMEoGA1UdIARDMEEwNQYMKwYBBAGyMQECAQMCMCUwIwYIKwYB
# BQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMAgGBmeBDAEEATBJBgNVHR8E
# QjBAMD6gPKA6hjhodHRwOi8vY3JsLnNlY3RpZ28uY29tL1NlY3RpZ29QdWJsaWND
# b2RlU2lnbmluZ0NBUjM2LmNybDB5BggrBgEFBQcBAQRtMGswRAYIKwYBBQUHMAKG
# OGh0dHA6Ly9jcnQuc2VjdGlnby5jb20vU2VjdGlnb1B1YmxpY0NvZGVTaWduaW5n
# Q0FSMzYuY3J0MCMGCCsGAQUFBzABhhdodHRwOi8vb2NzcC5zZWN0aWdvLmNvbTAN
# BgkqhkiG9w0BAQwFAAOCAYEAmLUUP/C5nHN/qX27dIrfNezHdUul/uhOA5CwNkD7
# P4pvLJButR/S1OmvozuzJJTce6824IylnXkRwUFj04XLbodkBL7+YwQ5ml7CjdDS
# Vo+sI/38jcEQ6FgosV/TTJSiFAgqMNwkx/kSzvQ1/Ufp5YVKggCXGJ4VitIzl5nM
# bzzu35G/uy4vmCQfh0KPYUTJYiRsF6Z3XJiIVtYrEwN/ikif/WFGrzsFj1OOWHNn
# 5qDOP80xExmRS09z/wdZE9RdjPv5fYLnKWy1+GQ/w1vzg/l2vUXIgBV0MxalUfTP
# 4V9Spsodrb+noPXiCy5n+6hy9yCf3EQb3G1n8rT/a454fLSijMm6bhrgBRqhPUUt
# n6ZIBdEJzJUI6ftuXrQnB/U7zf32xcTTAW7WPem7DFK/4JrSaxiXcSkxQ4kXJDVo
# DPUJdpb0c5XdWVJO0DCkB35ONEIoqT6VjEIjLPSw9UXE420r1OIpV8FRJqrW4Fr5
# RUveEUlyF+FyygVOYZECNsjRMIIGgjCCBGqgAwIBAgIQNsKwvXwbOuejs902y8l1
# aDANBgkqhkiG9w0BAQwFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCk5ldyBK
# ZXJzZXkxFDASBgNVBAcTC0plcnNleSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRS
# VVNUIE5ldHdvcmsxLjAsBgNVBAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlmaWNhdGlv
# biBBdXRob3JpdHkwHhcNMjEwMzIyMDAwMDAwWhcNMzgwMTE4MjM1OTU5WjBXMQsw
# CQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMS4wLAYDVQQDEyVT
# ZWN0aWdvIFB1YmxpYyBUaW1lIFN0YW1waW5nIFJvb3QgUjQ2MIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAiJ3YuUVnnR3d6LkmgZpUVMB8SQWbzFoVD9mU
# EES0QUCBdxSZqdTkdizICFNeINCSJS+lV1ipnW5ihkQyC0cRLWXUJzodqpnMRs46
# npiJPHrfLBOifjfhpdXJ2aHHsPHggGsCi7uE0awqKggE/LkYw3sqaBia67h/3awo
# qNvGqiFRJ+OTWYmUCO2GAXsePHi+/JUNAax3kpqstbl3vcTdOGhtKShvZIvjwulR
# H87rbukNyHGWX5tNK/WABKf+Gnoi4cmisS7oSimgHUI0Wn/4elNd40BFdSZ1Ewpu
# ddZ+Wr7+Dfo0lcHflm/FDDrOJ3rWqauUP8hsokDoI7D/yUVI9DAE/WK3Jl3C4LKw
# Ipn1mNzMyptRwsXKrop06m7NUNHdlTDEMovXAIDGAvYynPt5lutv8lZeI5w3MOlC
# ybAZDpK3Dy1MKo+6aEtE9vtiTMzz/o2dYfdP0KWZwZIXbYsTIlg1YIetCpi5s14q
# iXOpRsKqFKqav9R1R5vj3NgevsAsvxsAnI8Oa5s2oy25qhsoBIGo/zi6GpxFj+mO
# dh35Xn91y72J4RGOJEoqzEIbW3q0b2iPuWLA911cRxgY5SJYubvjay3nSMbBPPFs
# yl6mY4/WYucmyS9lo3l7jk27MAe145GWxK4O3m3gEFEIkv7kRmefDR7Oe2T1HxAn
# ICQvr9sCAwEAAaOCARYwggESMB8GA1UdIwQYMBaAFFN5v1qqK0rPVIDh2JvAnfKy
# A2bLMB0GA1UdDgQWBBT2d2rdP/0BE/8WoWyCAi/QCj0UJTAOBgNVHQ8BAf8EBAMC
# AYYwDwYDVR0TAQH/BAUwAwEB/zATBgNVHSUEDDAKBggrBgEFBQcDCDARBgNVHSAE
# CjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2VydHJ1
# c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMDUG
# CCsGAQUFBwEBBCkwJzAlBggrBgEFBQcwAYYZaHR0cDovL29jc3AudXNlcnRydXN0
# LmNvbTANBgkqhkiG9w0BAQwFAAOCAgEADr5lQe1oRLjlocXUEYfktzsljOt+2sgX
# ke3Y8UPEooU5y39rAARaAdAxUeiX1ktLJ3+lgxtoLQhn5cFb3GF2SSZRX8ptQ6Iv
# uD3wz/LNHKpQ5nX8hjsDLRhsyeIiJsms9yAWnvdYOdEMq1W61KE9JlBkB20XBee6
# JaXx4UBErc+YuoSb1SxVf7nkNtUjPfcxuFtrQdRMRi/fInV/AobE8Gw/8yBMQKKa
# Ht5eia8ybT8Y/Ffa6HAJyz9gvEOcF1VWXG8OMeM7Vy7Bs6mSIkYeYtddU1ux1dQL
# bEGur18ut97wgGwDiGinCwKPyFO7ApcmVJOtlw9FVJxw/mL1TbyBns4zOgkaXFnn
# fzg4qbSvnrwyj1NiurMp4pmAWjR+Pb/SIduPnmFzbSN/G8reZCL4fvGlvPFk4Uab
# /JVCSmj59+/mB2Gn6G/UYOy8k60mKcmaAZsEVkhOFuoj4we8CYyaR9vd9PGZKSin
# aZIkvVjbH/3nlLb0a7SBIkiRzfPfS9T+JesylbHa1LtRV9U/7m0q7Ma2CQ/t392i
# oOssXW7oKLdOmMBl14suVFBmbzrt5V5cQPnwtd3UOTpS9oCG+ZZheiIvPgkDmA8F
# zPsnfXW5qHELB43ET7HHFHeRPRYrMBKjkb8/IN7Po0d0hQoF4TeMM+zYAJzoKQnV
# KOLg8pZVPT8wgganMIIEj6ADAgECAhEAkKwIciD9xafEa1zHDfc9BjANBgkqhkiG
# 9w0BAQwFADBXMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVk
# MS4wLAYDVQQDEyVTZWN0aWdvIFB1YmxpYyBUaW1lIFN0YW1waW5nIFJvb3QgUjQ2
# MB4XDTI2MDMyNTAwMDAwMFoXDTQxMDMyNDIzNTk1OVowVTELMAkGA1UEBhMCR0Ix
# GDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEsMCoGA1UEAxMjU2VjdGlnbyBQdWJs
# aWMgVGltZSBTdGFtcGluZyBDQSBSNDEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw
# ggIKAoICAQCu5EqiAa2CHGL5Zi1bmgPM8NUXwYZJ+BtQqHps43GLTC+sjVLypsBh
# +8uv+TLkgtVGD//vSmA0qrzELf9YRCh2MTAA/aGaQZKGg0BRCmziR3pbCnvgWjtG
# XBDUyn3j3K2lZAO8KxgFtlxwOYEAkL+CCqK4v9zzTl8ZwzDpPMiDIFa5THk8an1i
# eF5I09cXNrPQw+1ER1liThaG0z6FrOpqwxZWmPRZQBw2E32878UB1bL0Zp91vuWZ
# gsMpNNiPCoBj0/1F+LE8+NRokfqacFI0F2tftrRB2W7HQClLR9zjxFbWb5be2rce
# IfNyHUUfKGIvMI2NzoxSlxXnFqUG887D8W1Cj8DFok688JKxWvHR/9aQykSbd+9V
# utj36ij2sgq/125wTpUZ/AgC0ph50bRs7gFrUyaXE9wSsOqMvCCC+sEm7vd/BemS
# G0TSHNXSmyCba+FCzekeWX03TRIcF3Laqd0Rw24OH7jpei4zaGhcI7nfdhBA4c8R
# ScxNY6jeHLHHmSMMTk9Wqn7H4dLhUBP5YEwbgbN4uv1i9ltTnHli8t1xHV0StX9B
# FgrnmunTX19kUXY1H5ORJbRZyZDdvm1oZyteDj0SnMozr+YSmdIleDUTXdfoY7b2
# taz8s2+QbOxLxcahEIYGWzqu6h955tKwcANHcZ4gTmAhT3btuOiQsQIDAQABo4IB
# bjCCAWowHwYDVR0jBBgwFoAU9ndq3T/9ARP/FqFsggIv0Ao9FCUwHQYDVR0OBBYE
# FDp0pQxnxkJQwv21/Me7KTSC9Hq5MA4GA1UdDwEB/wQEAwIBhjASBgNVHRMBAf8E
# CDAGAQH/AgEAMBMGA1UdJQQMMAoGCCsGAQUFBwMIMCMGA1UdIAQcMBowCAYGZ4EM
# AQQCMA4GDCsGAQQBsjEBAgEDCDBMBgNVHR8ERTBDMEGgP6A9hjtodHRwOi8vY3Js
# LnNlY3RpZ28uY29tL1NlY3RpZ29QdWJsaWNUaW1lU3RhbXBpbmdSb290UjQ2LmNy
# bDB8BggrBgEFBQcBAQRwMG4wRwYIKwYBBQUHMAKGO2h0dHA6Ly9jcnQuc2VjdGln
# by5jb20vU2VjdGlnb1B1YmxpY1RpbWVTdGFtcGluZ1Jvb3RSNDYucDdjMCMGCCsG
# AQUFBzABhhdodHRwOi8vb2NzcC5zZWN0aWdvLmNvbTANBgkqhkiG9w0BAQwFAAOC
# AgEAMt5SR2bxngNm+N8oc6Gq76Gx1c235fkX7jw8Ho9MAkJGADerHE7dhsBXttqm
# zgr/7ZZahZSykGRPhPY1crj028kB8KzO0dKC2qQBAwtfgqMLKkkX/6bYq2uT33eD
# 6ByAp2/XKD0LcmZh0kKecvSBr6ln9ajX6u1dnx2fA7xEKy1M3qBhfQSUWLtjs2nF
# t0ELVLptzTlX9ID0cL+iOPfdboZ3CelT+JXKVKR2Sge0d4YiFAtPZkfSo8z1Z1x7
# y/Z9mwMIlBAnyuWXs4YsNuxdrYIt/QxE31PDOJ9DesS4Bc7H9OTORlEV/AvfiF/V
# epKZpira1MzLYuCw+uoLZn/pkpvd+CvNTS+mEHjBJNa6WK1j8qXFu+jIq+sG9QIL
# HiyB6p/xpHrkJu8zkw393+VqF9eKlTY2VjRxdycZLrVemZ4Yp3wi33b+W58CllH3
# HqjmowlZ7SOrgmx8YwYOkgrHsXOQHyBp6O4FRb8In0+FzjT7ElGie9V7CfhL3IlV
# FZ4zjuKsZtH1iU3fGu4z/JnOGT6sCb0BbTqe/uhvpFCQBdH5xPGIA/LrbQUXjU2t
# WJgHhTIqnN/HvHyOHi5tM4zP3nhgh2rJ6Kqq2xsHBeNYs/R18xQ8DeIg+c90Eoae
# h0YlN1KU8AyYol3K9M+qY5ez8syd/7ZlrRnoVewgH3P1pcswggbiMIIEyqADAgEC
# AhEA507yVbBQT/rbpt/3/IujFTANBgkqhkiG9w0BAQwFADBVMQswCQYDVQQGEwJH
# QjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSwwKgYDVQQDEyNTZWN0aWdvIFB1
# YmxpYyBUaW1lIFN0YW1waW5nIENBIFI0MTAeFw0yNjAzMjUwMDAwMDBaFw0zNzA2
# MjQyMzU5NTlaMHIxCzAJBgNVBAYTAkdCMRcwFQYDVQQIEw5HcmVhdGVyIExvbmRv
# bjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMTAwLgYDVQQDEydTZWN0aWdvIFB1
# YmxpYyBUaW1lIFN0YW1waW5nIFNpZ25lciBSMzcwggIiMA0GCSqGSIb3DQEBAQUA
# A4ICDwAwggIKAoICAQCy/8NtS9xQ2UUtBRF32bj7VK3n4m50Uqjk/zTciSziYV40
# H1LKah0/oEklYG42E4VCP3DvsBUB6DmpCkDZ0jCnZBPIEevaH15ZJOQwFWP2ZXr5
# YjlJpb68Nlbs+ElNvKx32/1YHde3qqUSLybjulxPLz6T85+HOIqK7M1Bep8Lspyh
# EP/q6nw5kGxTSrGvufmeH+JF8CnVBcVMFA40FlIYh0cDJVFhhfTfdWgLy/vWuLMQ
# oKkf3s/FvByf16r0rtbyHm/iemwxSioJL9zyZDDKUNAbHXl0dhXo2VxUV2NcPXWX
# uoKsjL+6cfk6Vm2DHnxAlFdFsaBDIF1JOkSnC6PeLlBznZn2buF3vIIYJcq6N/ze
# FRCk4/HXDz7zgRsRRMdUB+rhyk5FoZaBjw0nLq3GZ3fClLUx5es5pUAxzNODMBn7
# JkFYip2BAGBPER5eV0ROhk6tGTG+fUiMiV+vgjg1YnP5FvnYWyEtWeQD/B2hp3vz
# 0RvtdkM0p3igyadzrfpOBq5ppVk/YsuhTQkP99ivneHAGfi5e7lmxJ+meoBPrRLu
# zMmb81rzzbESjJHMsn5RVtc6Ucs7rcMqQC13PUIO7BbGBETV2ufCmV6lPTp3P7XJ
# OvmnUCRTPbVvMTpxP/z+SOHg4/OCBhiqs4FA9+4oQvlkk9w32NGASli9GWrm5wID
# AQABo4IBjjCCAYowHwYDVR0jBBgwFoAUOnSlDGfGQlDC/bX8x7spNIL0erkwHQYD
# VR0OBBYEFGEQ6XoSr1HEhdTyz6R0D1DNIK/4MA4GA1UdDwEB/wQEAwIGwDAMBgNV
# HRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMEoGA1UdIARDMEEwCAYG
# Z4EMAQQCMDUGDCsGAQQBsjEBAgEDCDAlMCMGCCsGAQUFBwIBFhdodHRwczovL3Nl
# Y3RpZ28uY29tL0NQUzBKBgNVHR8EQzBBMD+gPaA7hjlodHRwOi8vY3JsLnNlY3Rp
# Z28uY29tL1NlY3RpZ29QdWJsaWNUaW1lU3RhbXBpbmdDQVI0MS5jcmwwegYIKwYB
# BQUHAQEEbjBsMEUGCCsGAQUFBzAChjlodHRwOi8vY3J0LnNlY3RpZ28uY29tL1Nl
# Y3RpZ29QdWJsaWNUaW1lU3RhbXBpbmdDQVI0MS5jcnQwIwYIKwYBBQUHMAGGF2h0
# dHA6Ly9vY3NwLnNlY3RpZ28uY29tMA0GCSqGSIb3DQEBDAUAA4ICAQAD6j2N0azN
# +hl6k6bKB5/U6VuSOs93ZBb3Pczy9VtBIKu4947Z5GwL0aFngIxl+GSuLFrJgPru
# BCRvKJEJsm7kv+LQ1COVCEG9tZ+IRtr4ocUoa53lgdFaENlS0N4wgkZkbQEPv+x+
# 1lSjYh+T4JeL9mUznT7Erc6Sp5dWLka5sMP/m3GZi6oJPdPcsCKWagH7m2H2xDGI
# yHJC5PdH9phvi/KmhkktiSVTNNqVeV5bWdX2zhRE6UTfz0IcMoCL996lFIydXxOC
# E4MNDHDM0as4lnTiT/KHMccO6l8c9TnUVgmpci9ar1IABZ2U1XUkYjGGSn9MC3EH
# DP9V39VuBVvZ33/BEV/EWSRrf07T7jFplKX+gQr/UOqPGMlE7ZJ72UaUkNJy7bVl
# 3bcLKzdpjIHzLkf/4MVa1V7w8wqCv5W4gOnRGTlud5UMARbRM8BPxR/CXYXoMmIO
# D8pmTk2axgRL4LG8XtuchISdCHRmtacAmLGq5XSYSVTHTXADlO48iDKh3HM2r98L
# SF6f0sG12d8V9Jn7C3wDUieOxuKj4MdWrW+hiJU2kF87v6eH00HgCFFc2V0+CvfO
# CMn7juzS41jLaINcBlKWQ/fKb/uDLfWOW73z1I2lFY7Xj8tQ1XYtK5eREjWItM8j
# pl1cbQOc88btR+0XS2TmboE/141+va2PWzGCBjAwggYsAgEBMGgwVDELMAkGA1UE
# BhMCR0IxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDErMCkGA1UEAxMiU2VjdGln
# byBQdWJsaWMgQ29kZSBTaWduaW5nIENBIFIzNgIQacs5SDkvNuif0aEmZmr03jAJ
# BgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0B
# CQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAj
# BgkqhkiG9w0BCQQxFgQU5cIq6CyFyAAZeov8NgqCSd5jX3IwDQYJKoZIhvcNAQEB
# BQAEggIAVIbg0iKKaWtTZ8rbSlBbc5q1xTwtv2vOfHXWYhqBlIQd3wOXLxcGyimD
# 6p0VrqKV5xZ9luNIUtmIcz/w+qM7BDg+f2XmEm/SHsR01cRtTHFwzJt3PMpHWeIX
# WbtNa7IPCkcG/T2nu+6+ii3CBjWkaVuw2T6WAhT4/jjoa8nbdNXg3Rk/wingYM6U
# gNIyMk2VxUv/F9ZQ1pA4q+5Iz5nAcWXXPqAyGaCCC9mvcIdAnpzvj9U9Vw9wDngZ
# STZy6YOW/Eq4deiAC/byxOY8XAb2WQXyFWEmsKgFojK7JzKtuMpo1a9XBZPHw3o9
# uJWtTuHqiBI1O0oqjhQ/AOzJ25ND04+nnZY2Xv9+2+95H00egjV1nvR03YNvbQ35
# NuiBqsphH0p/3+VXl/TI9e4P9Kq5SSoYYglm58fiUHdBPSwc52n+dxPTzuYT8vIl
# LlkaEwKDpgvZqXvwcMqigUEAbSyMR8UTvY+1rYrN1Qof0TftlDUIKuaa+snVj4px
# /10ZJyAeU7bwRR4IEAmMzKIRtK2OU19eauFKLsCnzCOflpt3M2nEjnaCh2kY+jFP
# lvIJU+S0qOl3cbjhSrac31JQgJdl4z/9GtnG1Jwj/2u9it20PTURm8NytnIhV2tG
# kQxt5Fp7xKNZwZ0RR0HuL3tjBiDcwgJPTnd1pZ5Yv5yakHQhA9qhggMjMIIDHwYJ
# KoZIhvcNAQkGMYIDEDCCAwwCAQEwajBVMQswCQYDVQQGEwJHQjEYMBYGA1UEChMP
# U2VjdGlnbyBMaW1pdGVkMSwwKgYDVQQDEyNTZWN0aWdvIFB1YmxpYyBUaW1lIFN0
# YW1waW5nIENBIFI0MQIRAOdO8lWwUE/626bf9/yLoxUwDQYJYIZIAWUDBAICBQCg
# eTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjEw
# MTcwMzA4MDFaMD8GCSqGSIb3DQEJBDEyBDAW9p9YHpAt8h7t7ArVdztc+PGoL0IU
# xhyLcRV54VzZPpNgbm22osf8Om482LUe8V4wDQYJKoZIhvcNAQEBBQAEggIAT162
# p6ZrM+UTkt6lhQ2pY5HPiNxgIfNNbbhkVCLxPR8vhywEIxIN9WUypa21bMqTX1WG
# XksGUQQNE2aNTQw/PyA7x349vX6tzF7FJmc9q+WjFlsZhUPqmuuwnDhO1YNtUwmy
# pIiOunlWaSFw6s92AlDnAXk4adokVr83czNvhHX7NfFlACopZxsTTW89lCXXfSIG
# n08aXj4sZ9MO86pN2Qh+Nf16AaPfgNbMMvXdS6B6NS1yyhtVbziBmuGRviru44mv
# NN3n7PDLYZTSLmjVhG0ASgMqRIziIVEkhKIdbiNJs78Ruy3ypERapilQUY4MD+/T
# trZzJ3yDZtZY7TBWOLjSv+CEz4EheLRgKbXiv7+Lwvd58n+MDAzt4jTJJB9FPMdO
# BgJlsiBYsAW9++WQC58pjr4H4PFLm18d1a7CkikL7dhBanWIuqa0Od+GsjPJbUrH
# 4Pt5cCFqcK5OjJsyFOmYbinwp1a3u38AXu8Apy2FAoZo/c8jsJhW/+jwN2oYlNrt
# YME8+xd1MeKjWyUt/gFZvnkAIiMkn8X0/HUm/NFytTHtpAuNwkCF0hH8LkGHlk27
# zKURNQ3P4egJ2UYubfyJHMRkiXmpO9UXhOamvQRez+YDenNaD2VuJfKFL+1a4rM4
# 3nl1t61CBWbNaXwM6V8Vx7FxMQ1kVyk+uCTpcOk=
# SIG # End signature block
