<#
.Synopsis
   Get dependent account ID
   CREATED BY: Vadim Melamed, EMAIL: vpasmodule@gmail.com
.DESCRIPTION
   Helper function to retrieve dependent account IDs from Idira (formerly CyberArk)
#>
function Get-VPASDependentAccountIDHelper{
    [OutputType([String],'System.Int32')]
    [CmdletBinding()]
    Param(

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$AcctID,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$searchquery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion,$HideWarnings,$AuthenticatedAs,$SubDomain,$EnableTroubleshooting,$APICounter,$Creds,$AuthType,$IDPLogin,$SRS = Get-VPASSession -token $token
        $CommandName = $MyInvocation.MyCommand.Name
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType COMMAND -Helper
    }
    Process{
        try{
            Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY IDIRA (formerly CyberArk)"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                if($ISPSS){
                    $uri = "http://$PVWA/API/accounts/$AcctID/account-dependents"
                }
                else{
                    $uri = "http://$PVWA/PasswordVault/API/Accounts/$AcctID/dependentAccounts"
                }
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                if($ISPSS){
                    $uri = "https://$PVWA/API/accounts/$AcctID/account-dependents"
                }
                else{
                    $uri = "https://$PVWA/PasswordVault/API/Accounts/$AcctID/dependentAccounts"
                }
            }
            write-verbose "MAKING API CALL"
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI -Helper
            $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD -Helper

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
                $APICounter += 1
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
                $APICounter += 1
            }

            $counter = 0
            $potentialOutput = $false

            if($ISPSS){
                foreach($rec in $response.accountDependents){
                    $recplatformID = $rec.platformId
                    $recname = $rec.name

                    if($recname -eq $searchquery){
                        write-verbose "FOUND UNIQUE DEPENDENT ACCOUNT ID"
                        Write-Verbose "RETURNING UNIQUE DEPENDENT ACCOUNT ID"
                        $logoutput = $rec
                        $logoutput = $logoutput | ConvertTo-Json | ConvertFrom-Json
                        $log = Write-VPASTextRecorder -inputval $logoutput -token $token -LogType RETURN -Helper
                        return $rec.id
                    }

                    $AllPlatprops = $rec.platformDependentProperties.psobject.Properties.name
                    foreach($prop in $AllPlatprops){
                        $propval = $rec.platformDependentProperties.$prop

                        if($propval -eq $searchquery){
                            $counter += 1
                            $potentialOutput = $rec
                        }
                    }
                }
            }
            else{
                foreach($rec in $response){
                    $recplatformID = $rec.platformId
                    $recname = $rec.name
                    Write-Verbose "FOUND $recplatformID : $recname"

                    if($recname -eq $searchquery){
                        write-verbose "FOUND UNIQUE DEPENDENT ACCOUNT ID"
                        Write-Verbose "RETURNING UNIQUE DEPENDENT ACCOUNT ID"
                        $logoutput = $rec
                        $logoutput = $logoutput | ConvertTo-Json | ConvertFrom-Json
                        $log = Write-VPASTextRecorder -inputval $logoutput -token $token -LogType RETURN -Helper
                        return $rec.dependentAccountId
                    }

                    $AllPlatprops = $rec.platformAccountProperties.psobject.Properties.name
                    foreach($prop in $AllPlatprops){
                        $propval = $rec.platformAccountProperties.$prop

                        if($propval -eq $searchquery){
                            $counter += 1
                            $potentialOutput = $rec
                        }
                    }
                }
            }

            if($counter -gt 1){
                #Write-VPASOutput -str "MULTIPLE ENTRIES FOUND, ADD MORE SEARCH FIELDS TO NARROW DOWN RESULTS" -type E
                Write-Verbose "MULTIPLE DEPENDENT ACCOUNT ENTRIES WERE RETURNED, ADD MORE SEARCH FIELDS TO NARROW RESULTS"
                $log = Write-VPASTextRecorder -inputval "MULTIPLE DEPENDENT ACCOUNT ENTRIES WERE RETURNED, ADD MORE SEARCH FIELDS TO NARROW RESULTS" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: -1" -token $token -LogType MISC -Helper
                return -1
            }
            elseif($counter -eq 0){
                Write-Verbose "NO DEPENDENT ACCOUNTS FOUND"
                Write-VPASOutput -str "NO DEPENDENT ACCOUNTS FOUND" -type E
                $log = Write-VPASTextRecorder -inputval "NO DEPENDENT ACCOUNTS FOUND" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: -2" -token $token -LogType MISC -Helper
                return -2
            }
            else{
                write-verbose "FOUND UNIQUE DEPENDENT ACCOUNT ID"
                Write-Verbose "RETURNING UNIQUE DEPENDENT ACCOUNT ID"
                $logoutput = $potentialOutput
                $logoutput = $logoutput | ConvertTo-Json | ConvertFrom-Json
                $log = Write-VPASTextRecorder -inputval $logoutput -token $token -LogType RETURN -Helper
                if($ISPSS){
                    return $potentialOutput.id
                }
                else{
                    return $potentialOutput.dependentAccountId
                }
            }
        }catch{
            Write-Verbose "UNABLE TO QUERY IDIRA (formerly CyberArk)"
            Write-VPASOutput -str $_ -type E
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER -Helper
        $token = Update-VPASSession -AddCounter $APICounter -InputToken $token
    }
}

# SIG # Begin signature block
# MIIsuQYJKoZIhvcNAQcCoIIsqjCCLKYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUzJAFKWjsz3VSVIbABHHgTfcW
# D4iggiXzMIIFbzCCBFegAwIBAgIQSPyTtGBVlI02p8mKidaUFjANBgkqhkiG9w0B
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
# BgkqhkiG9w0BCQQxFgQUtnZasAwJlb1H81aWlKvgm2oqJjcwDQYJKoZIhvcNAQEB
# BQAEggIAi9zvlPmYKCklhyQixVNx24NOanECyjEfpsW+oJUwuzPUtmb9Yu5gWDLk
# cYCsRSk2gM0tnLugbWnz0MASKkQQHESuREY/5sUJcYv5tv7i6hdv8sPFL0IERxm9
# hbAf4lNftIKHKe1UW1MDG60JQ72O8bQE29ACfeFDlWauMC0NKHxCByYNDxl9E02Q
# XOZ3DhH2bKIVMLmdKfsF40qZD9TIrsnjINnaZJ0vJ2TE0C2PvZKle4N6ejgRLguv
# gJZLtqLuT7+JnecdGb/DWmrG/vJeP/J1eyGIhw6YS0hWu0dwLRKNiEG/Tn+jz6Ya
# RCgeWJwU++JhnUGx+JA48cbXCRyQTZPh5XM7MTqhvfupfC9zcC0w60YN4HP/OAPi
# NEKzhQELgpGJHnsMF/AXIqqixA2d/nb6eOfjdZqYdW7u1KytqTi0hQbeJ0c2aIPW
# GSF1JHBnuop+a/GSCITrR0zfWglZtEZnGObNfyD3WhdEs1PmbR1BBRynsMCidxxK
# ByxfOIHygCLRwthW+JqOHDp35nv/O4do4tgOIqheMLeHWjJmjAg8512SwoQl8aWm
# jnoPKlsF3nalO21Ok7duC5/5WV1PGDGxx4U2ex0TtUmg+hj7M+o9VB6uFgAqITaP
# JVr/HNOLBHavUc+Kd1frVwc6njz9jgzJTD3suRM2lO/9pgKBOWWhggMjMIIDHwYJ
# KoZIhvcNAQkGMYIDEDCCAwwCAQEwajBVMQswCQYDVQQGEwJHQjEYMBYGA1UEChMP
# U2VjdGlnbyBMaW1pdGVkMSwwKgYDVQQDEyNTZWN0aWdvIFB1YmxpYyBUaW1lIFN0
# YW1waW5nIENBIFI0MQIRAOdO8lWwUE/626bf9/yLoxUwDQYJYIZIAWUDBAICBQCg
# eTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjEw
# MTcwMjU2MjRaMD8GCSqGSIb3DQEJBDEyBDBPyB5n2c81aFjQuFnMhGkoVfIWr/eP
# OcBM380uBJaM5LAvRNyTNvGv352LqRAf9AEwDQYJKoZIhvcNAQEBBQAEggIANmDu
# 9+D7xNiMXW3HxIH/5Mnk9FDm0ADKyac0A5+ui6yUGN4aRTM688b/sB8S8zcAht6u
# 23OL278ynQHkjfL7le6e0CAaw9C9YZSjYl01HJ11ZRr/IycWnizAG5skZup3tz04
# +QSzFr2ZdINt0IGlXbXAxY8SEQQF6EEaiiIJwQC/zYzEoyXe/78DZfg1tK7bkVlA
# IOtojEBefv6sPjnsG8T7adviDqRiB6Cu/rStFio6tW7FzSqNlK4DDa4t6I7zSB4H
# 7Ax/pbn99i1br0KyYppTimEH/PbWu9z9P9FabaOML/JJ/5exqCrhkW9SUyc3SytY
# ztnOrdJFadafifwphqlmsdWy8kHIogqP+AZ1pKyULld1dDVqO9sT9Cbz8P/821lg
# qZqpho6BR3byEBSZpVJNpePZa+CBA7kmOmKAxHpuyz6GjNYutFoIxJ3fCUWnEfAx
# 5ub1mW9JAAdONgwDeZF86P6IRpGHLKVsJkN+jhPxHFtprdHYzeikH+aA5hSU359T
# aBnOJASAVgsHAPg33fR77jMoph+f0Y+kHFmmqeTnpj6Y3dkFYG+ED9ag8iv9iaMa
# iHqN/o/ltEfo3gKNvJDWjYZm3/zyv+dTI3oLIB/vehmFZtfs6J/DHsanwBd+uD0s
# Fwp0fKEj5xE2Mz3fcJ12Pzi8ftSba4nLqHlJc70=
# SIG # End signature block
