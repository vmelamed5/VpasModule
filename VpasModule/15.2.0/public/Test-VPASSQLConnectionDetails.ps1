<#
.Synopsis
   Check SQL connection details
   CREATED BY: Vadim Melamed, EMAIL: vpasmodule@gmail.com
.DESCRIPTION
   Use this function to check the VpasModule database connection details configured prior via Set-VPASSQLConnectionDetails
.LINK
   https://vpasmodule.com/commands.html#Test-VPASSQLConnectionDetails
.NOTES
   Category: PAM
   Tag: SQL Exports
   Since: v12.2.2
   Version: 7
   SelfHosted: TRUE
   PrivCloudStandard: TRUE
   SharedServices: TRUE
   SRS: TRUE
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
.EXAMPLE
   $CheckSQLConnectionDetails = Test-VPASSQLConnectionDetails -SQLServer {SQLSERVER VALUE} -SQLDatabase {SQLDATABASE VALUE} -SQLUsername {SQLUSERNAME VALUE} -AAM {AAM VALUE} -AppID {APPID VALUE} -Folder {FOLDER VALUE} -SafeID {SAFEID VALUE} -ObjectName {OBJECTNAME VALUE} -AIMServer {AIMSERVER VALUE}
.OUTPUTS
   $true if successful
   ---
   $false if failed
#>
function Test-VPASSQLConnectionDetails{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [Switch]$NoSSL
    )

    Begin{

    }
    Process{

        $curUser = $env:UserName
        $ConfigFilePath = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\SQL"
        $ConfigFile = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\SQL\SQLConfigFile.txt"

        Write-Verbose "SEARCHING FILEPATHS FOR SQLConfigFile"

        #LOCATE FILE
        try{
            if(Test-Path -Path $ConfigFilePath){
                #DO NOTHING
                Write-Verbose "SQLConfigFile DIRECTORY EXISTS"
            }
            else{
                Write-Verbose "SQLConfigFile DIRECTORY DOES NOT EXIST...RERUN Set-VPASSQLConnectionDetails"
                Write-VPASOutput -str "SQLConfigFile DIRECTORY DOES NOT EXIST...RERUN Set-VPASSQLConnectionDetails" -type E
                return $false
            }

            if(Test-Path -Path $ConfigFile){
                #DO NOTHING
                Write-Verbose "SQLConfigFile FILE EXISTS"
            }
            else{
                Write-Verbose "SQLConfigFile FILE DOES NOT EXIST...RERUN Set-VPASSQLConnectionDetails"
                Write-VPASOutput -str "SQLConfigFile FILE DOES NOT EXIST...RERUN Set-VPASSQLConnectionDetails" -type E
                return $false
            }
        }catch{
            Write-VPASOutput -str "ERROR FINDING SQLConfigFile FILE OR DIRECTORY" -type E
            Write-VPASOutput -str $_ -type E
            return $false
        }

        #PARSE FILE
        try{
            Write-Verbose "READING CONTENTS OF $ConfigFile"
            $AllLines = Get-Content $ConfigFile

            write-verbose "INITIALIZING VARIABLES"
            $SQLServer = ""
            $SQLDatabase = ""
            $SQLUsername = ""
            $AAM = ""
            $AppID = ""
            $Folder = ""
            $SafeID = ""
            $ObjectName = ""
            $AIMServer = ""
            $PasswordSDKPath = ""
            $EncryptedPass = ""
            $CertificateTP = ""

            foreach($line in $AllLines){
                if($line -match "SQLServer="){
                    $SQLServer = $line -replace "SQLServer=",""
                }
                if($line -match "SQLDatabase="){
                    $SQLDatabase = $line -replace "SQLDatabase=",""
                }
                if($line -match "SQLUsername="){
                    $SQLUsername = $line -replace "SQLUsername=",""
                }
                if($line -match "AAM="){
                    $AAM = $line -replace "AAM=",""
                }
                if($line -match "AppID="){
                    $AppID = $line -replace "AppID=",""
                }
                if($line -match "Folder="){
                    $Folder = $line -replace "Folder=",""
                }
                if($line -match "SafeID="){
                    $SafeID = $line -replace "SafeID=",""
                }
                if($line -match "ObjectName="){
                    $ObjectName = $line -replace "ObjectName=",""
                }
                if($line -match "AIMServer="){
                    $AIMServer = $line -replace "AIMServer=",""
                }
                if($line -match "PasswordSDK="){
                    $PasswordSDK = $line -replace "PasswordSDK=",""
                }
                if($line -match "CERTIFICATETP="){
                    $CertificateTP = $line -replace "CERTIFICATETP=",""
                }
                if($line -match "SQLPassword="){
                    $EncryptedPass = $line -replace "SQLPassword=",""
                    $SecureString = ConvertTo-SecureString -String $EncryptedPass
                    $Pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
                    $SQLPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto($Pointer)
                }
            }
        }catch{
            Write-VPASOutput -str "ERROR PARSING SQLConfigFile...RERUN Set-VPASSQLConnectionDetails" -type E
            Write-VPASOutput -str $_ -type E
            return $false
        }

        #TESTING AAM CONNECTION
        if($AAM -eq "CCP"){
            try{
                if($NoSSL){
                    $uri = "http://$AIMServer/AIMWebService/api/accounts?AppID=$AppID&Safe=$SafeID&Folder=$Folder&Object=$ObjectName"
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                }
                else{
                    $uri = "https://$AIMServer/AIMWebService/api/accounts?AppID=$AppID&Safe=$SafeID&Folder=$Folder&Object=$ObjectName"
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                }

                if([String]::IsNullOrEmpty($CertificateTP)){
                    $CCPResult = Invoke-RestMethod -Uri $uri
                    $APICounter += 1
                }
                else{
                    $CCPResult = Invoke-RestMethod -Uri $uri -CertificateThumbprint $CertificateTP
                    $APICounter += 1
                }

                $Secret = $CCPResult.Content
                if($Secret){
                    Write-VPASOutput -str "CCP TEST SUCCESSFULL" -type C
                }
                else{
                    Write-VPASOutput -str "FAILED TO RETRIEVE SQL SECRET...PLEASE CONFIRM CCP FUNCTIONALITY AND RERUN Set-VPASSQLConnectionDetails" -type E
                    return $false
                }
            }catch{
                Write-VPASOutput -str "FAILED TO RETRIEVE SQL SECRET...PLEASE CONFIRM CCP FUNCTIONALITY AND RERUN Set-VPASSQLConnectionDetails" -type E
                Write-VPASOutput -str $_ -type E
                return $false
            }
        }
        if($AAM -eq "CP"){
            try{
                $Secret = & $PasswordSDKPath GetPassword /p AppDescs.AppID=$AppID /p Query="Safe=$SafeID;Folder=$Folder;Object=$ObjectName" /o Password
                if($Secret){
                    Write-VPASOutput -str "CP TEST SUCCESSFULL" -type C
                }
                else{
                    Write-VPASOutput -str "FAILED TO RETRIEVE SQL SECRET...PLEASE CONFIRM CP FUNCTIONALITY AND RERUN Set-VPASSQLConnectionDetails" -type E
                    return $false
                }
            }catch{
                Write-VPASOutput -str "FAILED TO RETRIEVE SQL SECRET...PLEASE CONFIRM CP FUNCTIONALITY AND RERUN Set-VPASSQLConnectionDetails" -type E
                Write-VPASOutput -str $_ -type E
                return $false
            }
        }
        if($AAM -eq "NONE"){
            $Secret = $SQLPassword
        }

        #TESTING SQL MODULE
        try{
            import-module sqlserver -ErrorAction Stop
        }catch{
            Write-VPASOutput -str "FAILED TO LOAD SQLServer MODULE..." -type E
            Write-VPASOutput -str $_ -type E
            Write-VPASOutput -str "FAILED TO FIND SQLServer MODULE IN THE FOLLOWING DIRECTORIES:" -type E

            $str = $env:PSModulePath -split ";"
            foreach($strsplit in $str){
                Write-VPASOutput -str $strsplit -type E
            }

            Write-VPASOutput -str "DOWNLOAD THE MODULE BY TYPING IN 'Install-Module -Name SqlServer' THEN RERUN Set-VPASSQLConnectionDetails" -type E
            Write-VPASOutput -str "YOU CAN ALSO VIEW THIS LINK FOR MORE INFORMATION: 'https://www.powershellgallery.com/packages/SqlServer/21.1.18256'" -type E
            Write-VPASOutput -str "PROCESS TERMINATED" -type E
            return $false
        }

        #TESTING SQL CONNECTIVITY
        try{
            $output = @()
            $result = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDatabase -Query "SELECT DB_NAME()" -Username $SQLUsername -Password $Secret

            if($result.Column1 -eq $SQLDatabase){
                Write-VPASOutput -str "SQL CONNECTIVITY TEST SUCCESSFUL" -type C
            }
            else{
                Write-VPASOutput -str "FAILED TO CONNECT TO SQL DATABASE...PLEASE RERUN Set-VPASSQLConnectionDetails" -type E
                return $false
            }
        }catch{
            Write-VPASOutput -str $_ -type E
            Write-VPASOutput -str "FAILED TO CONNECT TO SQL DATABASE...PLEASE RERUN Set-VPASSQLConnectionDetails" -type E
            return $false
        }

        return $true
    }
    End{

    }
}

# SIG # Begin signature block
# MIIsuQYJKoZIhvcNAQcCoIIsqjCCLKYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUnEi+Gqtm7k50RNFz0seCKhKB
# V9yggiXzMIIFbzCCBFegAwIBAgIQSPyTtGBVlI02p8mKidaUFjANBgkqhkiG9w0B
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
# BgkqhkiG9w0BCQQxFgQUrmFw5zm3t/MC1VZ+Q9dPFqLZ+jQwDQYJKoZIhvcNAQEB
# BQAEggIAIQkmMFOvHOKPdg4kBu9dhitLYn8Nygz1SMZvAeC1pynhoGjb7DR/WYsk
# qaokalchMZH6PvhGDUZ/PMaGcpIHF5Lrl/l3lI6AL9C7HTgOLp5eKoY2SudEI8SR
# ddkwA6+xUzkjvbzU8a6tgiQx9pqg8DEeNHtmHnsRJwvz2VeTg7NcwAcUZTeWEdqf
# 6wAW2NhQMjgE+1v7kpodR/NmlTn5uywMUZvfW+eSkFHFL+sWSeVk8ej1JfRUukPs
# jEuhaITpzl/aOe7X09BKs9ftPxUzxrzJAj6aOlcU6B//XleZCPDcEQzjmG0/aO9Y
# EKRnEf4BwpImS+SGTZG36FJTSpvILqCDWEAVI5abS789bJKdztlTOYNXE9IMIFRl
# nLdCFQuBT5L7JygqPbIoMlLtNA8+aJE7+dwr8fCYBIv6n/v3QKZs4u4TA8v5Iwny
# LQsQni8PLJEYOcvvLbB3botYbrO+SBx32hvZbjlslq1ieIm7mj1NjCpRdTbBO3w/
# xw1jtJeK252RS8/bN0povH3qPnqMCSYSBX4ygh795ErQnQBvChymfgct2lWU4XEp
# x9E9EI2O47XKV3iysNwZpeUJ2rUFsqzVvjn8OFbwwggMD2nc4t2ZnuLjjhLgG6pn
# TVGTBpQgUCpyemE07FXcBO/kNDu0QZWmqFeiTPuClnW0spnHsFqhggMjMIIDHwYJ
# KoZIhvcNAQkGMYIDEDCCAwwCAQEwajBVMQswCQYDVQQGEwJHQjEYMBYGA1UEChMP
# U2VjdGlnbyBMaW1pdGVkMSwwKgYDVQQDEyNTZWN0aWdvIFB1YmxpYyBUaW1lIFN0
# YW1waW5nIENBIFI0MQIRAOdO8lWwUE/626bf9/yLoxUwDQYJYIZIAWUDBAICBQCg
# eTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjEw
# MTcwMzEwMjNaMD8GCSqGSIb3DQEJBDEyBDAoseCq54tpE12O0TOPMjHvbgUIo3LP
# x0Yb2GTzyXKudzWyJ++VAXHnKZRTxGB9orYwDQYJKoZIhvcNAQEBBQAEggIAMk1T
# HWamn0oWs3XALrrZSpvbXuxs1A68KiIlIqIJmJdQN0qibJsB6lr+kCsEyOoD2F77
# tbatULXYZzx5+3mFdvbjPFp7kmvVG+1JWIOnM6PTyhp8XcGXAzEpLTDTT1CI4Gmn
# CaWntEkjoXnEGQSLWjOt+AUZoFaL8aW1VvmKFx4DdQYUOp5SleLB3oDkCoMBTAyJ
# mpCYr1+fGNrd0125mcVgR7GPBxZnvBkgpf5eKS3qiL3h2V1zR2y5bDBN3S3t247G
# MDhCSfQryX7NyhlzEgCInAJ2M3IACsOTlqdfZCuMKvHLvN6Si7HW56/VHsf8SZ6a
# BR7OclycQ0fWMpn+cykfUpCxJvNJwA+tjHzSQqCxLKNGaWJsAb14X8CzCa6MGbnK
# GWY1vEqe/VwsNfpUf3JXnunJSjGMuJq752WbK2JOM6uGF8oqCzFfbLYpmtB31sq7
# 4qmAuDcNABJggi7VOuEtk49ko0m9VEAtzxL7wt1TTNaxaRLzZ0XE8ZAEzPsFrh04
# il7YzO/GyFBoHqy1VShSHDobDePenhOucy/2eqlqVUc6XPQ29Y2o09AF50qvyS92
# 58fiwa+OCXkc92JCjJ/Cu7ncdC7LndFK71uxC/Lg14i6DAmsEiE4WiHAgXPr2us5
# VO0JizfdOECvkk7rd6YQeb8EiTz/Pg1fYV24ido=
# SIG # End signature block
