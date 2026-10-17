<#
.Synopsis
   Output to CSV files
   CREATED BY: Vadim Melamed, EMAIL: vpasmodule@gmail.com
.DESCRIPTION
   Helper function to output data to CSV files
#>
function Write-VPASExportCSV{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [Object]$Data,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$CommandName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$CSVDirectory
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion,$HideWarnings,$AuthenticatedAs,$SubDomain,$EnableTroubleshooting,$APICounter,$Creds,$AuthType,$IDPLogin,$SRS = Get-VPASSession -token $token
    }
    Process{
        try{
            if([String]::IsNullOrEmpty($CSVDirectory)){
                $curUser = $env:UserName
                $OutputDirectory = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\ExportedCSVs\$CommandName"
            }
            else{
                if($CSVDirectory[-1] -ne "\"){
                    $CSVDirectory += "\"
                }
                $OutputDirectory = $CSVDirectory + "$CommandName"
            }

            Write-Verbose "INITIALIZING OUTPUT DIRECTORY LOCATION: $OutputDirectory"
            if(Test-Path -Path $OutputDirectory){
                #DO NOTHING
            }
            else{
                write-verbose "$OutputDirectory DOES NOT EXIST, CREATING DIRECTORY"
                $MakeDirectory = New-Item -Path $OutputDirectory -Type Directory
            }

            $curTime = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
            $targetCSV = $OutputDirectory + "\" + "Output_$curTime.csv"

            $outputmatrix = @()
            #region AccountCommands
            if($CommandName -eq "Get-VPASAccountDetails"){
                foreach($rec in $Data){
                    $platformpropertiesstr = ""
                    $AllPlatformProperties = $rec.platformAccountProperties
                    $AllPlatformKeys = $AllPlatformProperties.psobject.Properties.name
                    foreach($prop in $AllPlatformKeys){
                        $propval = $AllPlatformProperties."$prop"
                        $platformpropertiesstr += "$prop=$propval;"
                    }

                    $minihash = [ordered]@{
                        id = $rec.id
                        address = $rec.address
                        userName = $rec.userName
                        platformId = $rec.platformId
                        safeName = $rec.safeName
                        name = $rec.name
                        secretType = $rec.secretType
                        platformAccountProperties = $platformpropertiesstr
                        createdTime = $rec.createdTime
                        secretManagement_automaticManagementEnabled = $rec.secretManagement.automaticManagementEnabled
                        secretManagement_manualManagementReason = $rec.secretManagement.manualManagementReason
                        secretManagement_status = $rec.secretManagement.status
                        secretManagement_lastModifiedTime = $rec.secretManagement.lastModifiedTime
                        secretManagement_lastReconciledTime = $rec.secretManagement.lastReconciledTime
                        secretManagement_lastVerifiedTime = $rec.secretManagement.lastVerifiedTime
                        remoteMachinesAccess_remoteMachines = $rec.remoteMachinesAccess.remoteMachines
                        remoteMachinesAccess_accessRestrictedToRemoteMachines = $rec.remoteMachinesAccess.accessRestrictedToRemoteMachines
                        categoryModificationTime = $rec.categoryModificationTime
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllAccounts"){
                foreach($rec in $Data){
                    $platformpropertiesstr = ""
                    $AllPlatformProperties = $rec.platformAccountProperties
                    $AllPlatformKeys = $AllPlatformProperties.psobject.Properties.name
                    foreach($prop in $AllPlatformKeys){
                        $propval = $AllPlatformProperties."$prop"
                        $platformpropertiesstr += "$prop=$propval;"
                    }

                    $minihash = [ordered]@{
                        id = $rec.id
                        address = $rec.address
                        userName = $rec.userName
                        platformId = $rec.platformId
                        safeName = $rec.safeName
                        name = $rec.name
                        secretType = $rec.secretType
                        platformAccountProperties = $platformpropertiesstr
                        createdTime = $rec.createdTime
                        secretManagement_automaticManagementEnabled = $rec.secretManagement.automaticManagementEnabled
                        secretManagement_manualManagementReason = $rec.secretManagement.manualManagementReason
                        secretManagement_status = $rec.secretManagement.status
                        secretManagement_lastModifiedTime = $rec.secretManagement.lastModifiedTime
                        secretManagement_lastReconciledTime = $rec.secretManagement.lastReconciledTime
                        secretManagement_lastVerifiedTime = $rec.secretManagement.lastVerifiedTime
                        remoteMachinesAccess_remoteMachines = $rec.remoteMachinesAccess.remoteMachines
                        remoteMachinesAccess_accessRestrictedToRemoteMachines = $rec.remoteMachinesAccess.accessRestrictedToRemoteMachines
                        categoryModificationTime = $rec.categoryModificationTime
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAccountActivity"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Alert = $rec.Alert
                        Date = $rec.Date
                        User = $rec.User
                        Action = $rec.Action
                        ActionID = $rec.ActionID
                        ClientID = $rec.ClientID
                        MoreInfo = $rec.MoreInfo
                        Reason = $rec.Reason
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAccountGroupMembers"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        AccountID = $rec.AccountID
                        SafeName = $rec.SafeName
                        PlatformID = $rec.PlatformID
                        Address = $rec.Address
                        UserName = $rec.UserName
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAccountGroups"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        GroupID = $rec.GroupID
                        GroupName = $rec.GroupName
                        GroupPlatformID = $rec.GroupPlatformID
                        Safe = $rec.Safe
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIncomingRequestDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        RequestorFullName = $rec.RequestorFullName
                        RequestID = $rec.RequestID
                        SafeName = $rec.SafeName
                        RequestorUserName = $rec.RequestorUserName
                        RequestorReason = $rec.RequestorReason
                        UserReason = $rec.UserReason
                        CreationDate = $rec.CreationDate
                        Operation = $rec.Operation
                        ExpirationDate = $rec.ExpirationDate
                        OperationType = $rec.OperationType
                        AccessType = $rec.AccessType
                        ConfirmationsLeft = $rec.ConfirmationsLeft
                        AccessFrom = $rec.AccessFrom
                        AccessTo = $rec.AccessTo
                        Status = $rec.Status
                        StatusTitle = $rec.StatusTitle
                        InvalidRequestReason = $rec.InvalidRequestReason
                        CurrentConfirmationLevel = $rec.CurrentConfirmationLevel
                        RequiredConfirmersCountLevel2 = $rec.RequiredConfirmersCountLevel2
                        TicketingName = $rec.TicketingSystemProperties.Name
                        TicketingNumber = $rec.TicketingSystemProperties.Number
                        TicketingStatus = $rec.TicketingSystemProperties.Status
                        AdditionalInfo = $rec.AdditionalInfo
                        AccountID = $rec.AccountDetails.AccountID
                        AccountAddress = $rec.AccountDetails.Properties.Address
                        AccountSafe = $rec.AccountDetails.Properties.Safe
                        AccountFolder = $rec.AccountDetails.Properties.Folder
                        AccountName = $rec.AccountDetails.Properties.Name
                        AccountPolicyID = $rec.AccountDetails.Properties.PolicyID
                        AccountPlatformName = $rec.AccountDetails.Properties.PlatformName
                        AccountDeviceType = $rec.AccountDetails.Properties.DeviceType
                        AccountLastModifiedDate = $rec.AccountDetails.Properties.LastModifiedDate
                        AccountLastModifiedBy = $rec.AccountDetails.Properties.LastModifiedBy
                        AccountLastUsedDate = $rec.AccountDetails.Properties.LastUsedDate
                        AccountLastUsedBy = $rec.AccountDetails.Properties.LastUsedBy
                        AccountUserName = $rec.AccountDetails.Properties.UserName
                        AccountLockedBy = $rec.AccountDetails.Properties.LockedBy
                        AccountCPMDisabled = $rec.AccountDetails.Properties.CPMDisabled
                        AccountCPMStatus = $rec.AccountDetails.Properties.CPMStatus
                        AccountManagedByCPM = $rec.AccountDetails.Properties.ManagedByCPM
                        AccountDeletedBy = $rec.AccountDetails.Properties.DeletedBy
                        AccountDeletionDate = $rec.AccountDetails.Properties.DeletionDate
                        AccountImmediateCPMTask = $rec.AccountDetails.Properties.ImmediateCPMTask
                        AccountLastCPMTask = $rec.AccountDetails.Properties.LastCPMTask
                        AccountCreationDate = $rec.AccountDetails.Properties.CreationDate
                        AccountIsSSHKey = $rec.AccountDetails.Properties.IsSSHKey
                        AccountIsIrregularPlatform = $rec.AccountDetails.Properties.IsIrregularPlatform
                        AccountCreationMethod = $rec.AccountDetails.Properties.CreationMethod

                    }
                    $grouplen = $rec.Confirmers.count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            ConfirmerType = ""
                            ConfirmerID = ""
                            ConfirmerName = ""
                            ConfirmerAction = ""
                            ConfirmerNameReason = ""
                            ConfirmerActionDate = ""
                            ConfirmerMembers = ""
                            ConfirmerFullName = ""
                            ConfirmerEmail = ""
                            ConfirmerPhone = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.Confirmers){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                ConfirmerType = $group.Type
                                ConfirmerID = $group.ID
                                ConfirmerName = $group.Name
                                ConfirmerAction = $group.Action
                                ConfirmerReason = $group.Reason
                                ConfirmerActionDate = $group.ActionDate
                                ConfirmerMembers = $group.Members
                                ConfirmerFullName = $group.AdditionalDetails.fullname
                                ConfirmerEmail = $group.AdditionalDetails.email
                                ConfirmerPhone = $group.AdditionalDetails.phone
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAccountRequestDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        RequestID = $rec.RequestID
                        SafeName = $rec.SafeName
                        RequestorUserName = $rec.RequestorUserName
                        RequestorReason = $rec.RequestorReason
                        UserReason = $rec.UserReason
                        CreationDate = $rec.CreationDate
                        Operation = $rec.Operation
                        ExpirationDate = $rec.ExpirationDate
                        OperationType = $rec.OperationType
                        AccessType = $rec.AccessType
                        ConfirmationsLeft = $rec.ConfirmationsLeft
                        AccessFrom = $rec.AccessFrom
                        AccessTo = $rec.AccessTo
                        Status = $rec.Status
                        StatusTitle = $rec.StatusTitle
                        InvalidRequestReason = $rec.InvalidRequestReason
                        CurrentConfirmationLevel = $rec.CurrentConfirmationLevel
                        RequiredConfirmersCountLevel2 = $rec.RequiredConfirmersCountLevel2
                        TicketingName = $rec.TicketingSystemProperties.Name
                        TicketingNumber = $rec.TicketingSystemProperties.Number
                        TicketingStatus = $rec.TicketingSystemProperties.Status
                        AdditionalInfo = $rec.AdditionalInfo
                        AccountID = $rec.AccountDetails.AccountID
                        AccountAddress = $rec.AccountDetails.Properties.Address
                        AccountSafe = $rec.AccountDetails.Properties.Safe
                        AccountFolder = $rec.AccountDetails.Properties.Folder
                        AccountName = $rec.AccountDetails.Properties.Name
                        AccountPolicyID = $rec.AccountDetails.Properties.PolicyID
                        AccountPlatformName = $rec.AccountDetails.Properties.PlatformName
                        AccountDeviceType = $rec.AccountDetails.Properties.DeviceType
                        AccountLastModifiedDate = $rec.AccountDetails.Properties.LastModifiedDate
                        AccountLastModifiedBy = $rec.AccountDetails.Properties.LastModifiedBy
                        AccountLastUsedDate = $rec.AccountDetails.Properties.LastUsedDate
                        AccountLastUsedBy = $rec.AccountDetails.Properties.LastUsedBy
                        AccountUserName = $rec.AccountDetails.Properties.UserName
                        AccountLockedBy = $rec.AccountDetails.Properties.LockedBy
                        AccountCPMDisabled = $rec.AccountDetails.Properties.CPMDisabled
                        AccountCPMStatus = $rec.AccountDetails.Properties.CPMStatus
                        AccountManagedByCPM = $rec.AccountDetails.Properties.ManagedByCPM
                        AccountDeletedBy = $rec.AccountDetails.Properties.DeletedBy
                        AccountDeletionDate = $rec.AccountDetails.Properties.DeletionDate
                        AccountImmediateCPMTask = $rec.AccountDetails.Properties.ImmediateCPMTask
                        AccountLastCPMTask = $rec.AccountDetails.Properties.LastCPMTask
                        AccountCreationDate = $rec.AccountDetails.Properties.CreationDate
                        AccountIsSSHKey = $rec.AccountDetails.Properties.IsSSHKey
                        AccountIsIrregularPlatform = $rec.AccountDetails.Properties.IsIrregularPlatform
                        AccountCreationMethod = $rec.AccountDetails.Properties.CreationMethod

                    }
                    $grouplen = $rec.Confirmers.count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            ConfirmerType = ""
                            ConfirmerID = ""
                            ConfirmerName = ""
                            ConfirmerAction = ""
                            ConfirmerNameReason = ""
                            ConfirmerActionDate = ""
                            ConfirmerMembers = ""
                            ConfirmerFullName = ""
                            ConfirmerEmail = ""
                            ConfirmerPhone = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.Confirmers){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                ConfirmerType = $group.Type
                                ConfirmerID = $group.ID
                                ConfirmerName = $group.Name
                                ConfirmerAction = $group.Action
                                ConfirmerReason = $group.Reason
                                ConfirmerActionDate = $group.ActionDate
                                ConfirmerMembers = $group.Members
                                ConfirmerFullName = $group.AdditionalDetails.fullname
                                ConfirmerEmail = $group.AdditionalDetails.email
                                ConfirmerPhone = $group.AdditionalDetails.phone
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllAccountRequests"){
                foreach($rec in $Data.MyRequests){
                    $minihash = [ordered]@{
                        RequestID = $rec.RequestID
                        SafeName = $rec.SafeName
                        RequestorUserName = $rec.RequestorUserName
                        RequestorReason = $rec.RequestorReason
                        UserReason = $rec.UserReason
                        CreationDate = $rec.CreationDate
                        Operation = $rec.Operation
                        ExpirationDate = $rec.ExpirationDate
                        OperationType = $rec.OperationType
                        AccessType = $rec.AccessType
                        ConfirmationsLeft = $rec.ConfirmationsLeft
                        AccessFrom = $rec.AccessFrom
                        AccessTo = $rec.AccessTo
                        Status = $rec.Status
                        StatusTitle = $rec.StatusTitle
                        InvalidRequestReason = $rec.InvalidRequestReason
                        CurrentConfirmationLevel = $rec.CurrentConfirmationLevel
                        RequiredConfirmersCountLevel2 = $rec.RequiredConfirmersCountLevel2
                        TicketingName = $rec.TicketingSystemProperties.Name
                        TicketingNumber = $rec.TicketingSystemProperties.Number
                        TicketingStatus = $rec.TicketingSystemProperties.Status
                        AdditionalInfo = $rec.AdditionalInfo
                        AccountID = $rec.AccountDetails.AccountID
                        AccountAddress = $rec.AccountDetails.Properties.Address
                        AccountSafe = $rec.AccountDetails.Properties.Safe
                        AccountFolder = $rec.AccountDetails.Properties.Folder
                        AccountName = $rec.AccountDetails.Properties.Name
                        AccountPolicyID = $rec.AccountDetails.Properties.PolicyID
                        AccountPlatformName = $rec.AccountDetails.Properties.PlatformName
                        AccountDeviceType = $rec.AccountDetails.Properties.DeviceType
                        AccountLastModifiedDate = $rec.AccountDetails.Properties.LastModifiedDate
                        AccountLastModifiedBy = $rec.AccountDetails.Properties.LastModifiedBy
                        AccountLastUsedDate = $rec.AccountDetails.Properties.LastUsedDate
                        AccountLastUsedBy = $rec.AccountDetails.Properties.LastUsedBy
                        AccountUserName = $rec.AccountDetails.Properties.UserName
                        AccountLockedBy = $rec.AccountDetails.Properties.LockedBy
                        AccountCPMDisabled = $rec.AccountDetails.Properties.CPMDisabled
                        AccountCPMStatus = $rec.AccountDetails.Properties.CPMStatus
                        AccountManagedByCPM = $rec.AccountDetails.Properties.ManagedByCPM
                        AccountDeletedBy = $rec.AccountDetails.Properties.DeletedBy
                        AccountDeletionDate = $rec.AccountDetails.Properties.DeletionDate
                        AccountImmediateCPMTask = $rec.AccountDetails.Properties.ImmediateCPMTask
                        AccountLastCPMTask = $rec.AccountDetails.Properties.LastCPMTask
                        AccountCreationDate = $rec.AccountDetails.Properties.CreationDate
                        AccountIsSSHKey = $rec.AccountDetails.Properties.IsSSHKey
                        AccountIsIrregularPlatform = $rec.AccountDetails.Properties.IsIrregularPlatform
                        AccountCreationMethod = $rec.AccountDetails.Properties.CreationMethod

                    }
                    $grouplen = $rec.Confirmers.count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            ConfirmerType = ""
                            ConfirmerID = ""
                            ConfirmerName = ""
                            ConfirmerAction = ""
                            ConfirmerNameReason = ""
                            ConfirmerActionDate = ""
                            ConfirmerMembers = ""
                            ConfirmerFullName = ""
                            ConfirmerEmail = ""
                            ConfirmerPhone = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.Confirmers){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                ConfirmerType = $group.Type
                                ConfirmerID = $group.ID
                                ConfirmerName = $group.Name
                                ConfirmerAction = $group.Action
                                ConfirmerReason = $group.Reason
                                ConfirmerActionDate = $group.ActionDate
                                ConfirmerMembers = $group.Members
                                ConfirmerFullName = $group.AdditionalDetails.fullname
                                ConfirmerEmail = $group.AdditionalDetails.email
                                ConfirmerPhone = $group.AdditionalDetails.phone
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllIncomingRequests"){
                foreach($rec in $Data.IncomingRequests){
                    $minihash = [ordered]@{
                        RequestorFullName = $rec.RequestorFullName
                        RequestID = $rec.RequestID
                        SafeName = $rec.SafeName
                        RequestorUserName = $rec.RequestorUserName
                        RequestorReason = $rec.RequestorReason
                        UserReason = $rec.UserReason
                        CreationDate = $rec.CreationDate
                        Operation = $rec.Operation
                        ExpirationDate = $rec.ExpirationDate
                        OperationType = $rec.OperationType
                        AccessType = $rec.AccessType
                        ConfirmationsLeft = $rec.ConfirmationsLeft
                        AccessFrom = $rec.AccessFrom
                        AccessTo = $rec.AccessTo
                        Status = $rec.Status
                        StatusTitle = $rec.StatusTitle
                        InvalidRequestReason = $rec.InvalidRequestReason
                        CurrentConfirmationLevel = $rec.CurrentConfirmationLevel
                        RequiredConfirmersCountLevel2 = $rec.RequiredConfirmersCountLevel2
                        TicketingName = $rec.TicketingSystemProperties.Name
                        TicketingNumber = $rec.TicketingSystemProperties.Number
                        TicketingStatus = $rec.TicketingSystemProperties.Status
                        AdditionalInfo = $rec.AdditionalInfo
                        AccountID = $rec.AccountDetails.AccountID
                        AccountAddress = $rec.AccountDetails.Properties.Address
                        AccountSafe = $rec.AccountDetails.Properties.Safe
                        AccountFolder = $rec.AccountDetails.Properties.Folder
                        AccountName = $rec.AccountDetails.Properties.Name
                        AccountPolicyID = $rec.AccountDetails.Properties.PolicyID
                        AccountPlatformName = $rec.AccountDetails.Properties.PlatformName
                        AccountDeviceType = $rec.AccountDetails.Properties.DeviceType
                        AccountLastModifiedDate = $rec.AccountDetails.Properties.LastModifiedDate
                        AccountLastModifiedBy = $rec.AccountDetails.Properties.LastModifiedBy
                        AccountLastUsedDate = $rec.AccountDetails.Properties.LastUsedDate
                        AccountLastUsedBy = $rec.AccountDetails.Properties.LastUsedBy
                        AccountUserName = $rec.AccountDetails.Properties.UserName
                        AccountLockedBy = $rec.AccountDetails.Properties.LockedBy
                        AccountCPMDisabled = $rec.AccountDetails.Properties.CPMDisabled
                        AccountCPMStatus = $rec.AccountDetails.Properties.CPMStatus
                        AccountManagedByCPM = $rec.AccountDetails.Properties.ManagedByCPM
                        AccountDeletedBy = $rec.AccountDetails.Properties.DeletedBy
                        AccountDeletionDate = $rec.AccountDetails.Properties.DeletionDate
                        AccountImmediateCPMTask = $rec.AccountDetails.Properties.ImmediateCPMTask
                        AccountLastCPMTask = $rec.AccountDetails.Properties.LastCPMTask
                        AccountCreationDate = $rec.AccountDetails.Properties.CreationDate
                        AccountIsSSHKey = $rec.AccountDetails.Properties.IsSSHKey
                        AccountIsIrregularPlatform = $rec.AccountDetails.Properties.IsIrregularPlatform
                        AccountCreationMethod = $rec.AccountDetails.Properties.CreationMethod

                    }
                    $grouplen = $rec.Confirmers.count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            ConfirmerType = ""
                            ConfirmerID = ""
                            ConfirmerName = ""
                            ConfirmerAction = ""
                            ConfirmerNameReason = ""
                            ConfirmerActionDate = ""
                            ConfirmerMembers = ""
                            ConfirmerFullName = ""
                            ConfirmerEmail = ""
                            ConfirmerPhone = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.Confirmers){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                ConfirmerType = $group.Type
                                ConfirmerID = $group.ID
                                ConfirmerName = $group.Name
                                ConfirmerAction = $group.Action
                                ConfirmerReason = $group.Reason
                                ConfirmerActionDate = $group.ActionDate
                                ConfirmerMembers = $group.Members
                                ConfirmerFullName = $group.AdditionalDetails.fullname
                                ConfirmerEmail = $group.AdditionalDetails.email
                                ConfirmerPhone = $group.AdditionalDetails.phone
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPasswordHistory"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        versionID = $rec.versionID
                        modifiedBy = $rec.modifiedBy
                        modificationDate = $rec.modificationDate
                        isTemporary = $rec.isTemporary
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAccountDetailsExtended"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        AccountID = $rec.AccountID
                        IsCompliant = $rec.Compliance.IsCompliant
                        LastModifiedDate = $rec.Compliance.LastModifiedDate
                        LastModifiedBy = $rec.Compliance.LastModifiedBy
                        ModificationType = $rec.Compliance.ModificationType
                        TotalDependencies = $rec.TotalDependencies
                        FailedDependencies = $rec.FailedDependencies
                        LastVerifiedDate = $rec.Details.LastVerifiedDate
                        LastVerifiedBy = $rec.Details.LastVerifiedBy
                        LastUsedBy = $rec.Details.LastUsedBy
                        LastUsedDate = $rec.Details.LastUsedDate
                        CreationDate = $rec.Details.CreationDate
                        Name = $rec.Details.Name
                        CreatedTime = $rec.Details.CreatedTime
                        AccountURL = $rec.Details.AccountURL
                        ManagedByCPM = $rec.Details.ManagedByCPM
                        CPMDisabled = $rec.Details.CPMDisabled
                        CPMStatus = $rec.Details.CPMStatus
                        CPMErrorDetails = $rec.Details.CPMErrorDetails
                        ImmediateCPMTask = $rec.Details.ImmediateCPMTask
                        DeletedBy = $rec.Details.DeletedBy
                        DeletionDate = $rec.Details.DeletionDate
                        LockedBy = $rec.Details.LockedBy
                        IsFavorite = $rec.Details.IsFavorite
                        IsNew = $rec.Details.IsNew
                        SafeName = $rec.Details.SafeName
                        IsGroupMember = $rec.Details.IsGroupMember
                        DualControlStatus = $rec.Details.DualControlStatus
                        LimitDomainAccess = $rec.Details.LimitDomainAccess
                        AccessDomainList = $rec.Details.AccessDomainList
                        RequestId = $rec.Details.RequestId
                        FutureTimeFrame = $rec.Details.FutureTimeFrame
                        VerificationPeriod = $rec.Platform.VerificationPeriod
                        ExpirationPeriod = $rec.Platform.ExpirationPeriod
                        HeadStartInterval = $rec.Platform.HeadStartInterval
                        PlatformID = $rec.Platform.PlatformID
                        PlatformName = $rec.Platform.PlatformName
                        IsActive = $rec.Platform.IsActive
                    }
                    $str = ""
                    foreach($client in $rec.Details.RequiredProperties.psobject.properties.name){
                        if(![String]::IsNullOrEmpty($client) -and $client -ne "Length"){
                            $clientval = $rec.Details.RequiredProperties.$client
                            $str += "$client=$clientval;"
                        }
                    }
                    $minihash += @{ RequiredProperties = $str }
                    $str = ""
                    foreach($client in $rec.Details.OptionalProperties.psobject.properties.name){
                        if(![String]::IsNullOrEmpty($client) -and $client -ne "Length"){
                            $clientval = $rec.Details.OptionalProperties.$client
                            $str += "$client=$clientval;"
                        }
                    }
                    $minihash += @{ OptionalProperties = $str }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }
                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAccountCompliance"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        IsCompliant = $rec.IsCompliant
                        AccountID = $rec.AccountID
                        Safe = $rec.Safe
                        Address = $rec.Address
                        Username = $rec.Username
                        PlatformID = $rec.PlatformID
                        Name = $rec.Name
                        LastUsedBy = $rec.LastUsedBy
                        LastUsedDate = $rec.LastUsedDate
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }
                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllDependentAccounts"){
                if($ISPSS){
                    $PlatformAccountProperties = @()
                    foreach($rec in $Data.DependentAccount.platformAccountProperties){
                        $AllProps = $rec.psobject.Properties.name
                        foreach($prop in $AllProps){
                            if(!$PlatformAccountProperties.Contains($prop)){
                                $PlatformAccountProperties += $prop
                            }
                        }
                    }

                    $SecretManagementProperties = @()
                    foreach($rec in $Data.DependentAccount.secretManagement){
                        $AllProps = $rec.psobject.Properties.name
                        foreach($prop in $AllProps){
                            if(!$SecretManagementProperties.Contains($prop)){
                                $SecretManagementProperties += $prop
                            }
                        }
                    }

                    foreach($rec in $Data.DependentAccount){
                        $minihash = [ordered]@{
                            safeName = $rec.safeName
                            createdTime = $rec.createdTime
                            categoryModificationTime = $rec.categoryModificationTime
                            id = $rec.id
                            parentAccountId = $rec.parentAccountId
                            name = $rec.name
                            platformId = $rec.platformId
                            disableParentAutomaticManagement = $rec.disableParentAutomaticManagement
                            safeId = $rec.safeId
                            isDeleted = $rec.isDeleted

                        }

                        foreach($prop in $PlatformAccountProperties){
                            $propval = $rec.platformAccountProperties.$prop
                            $minihash += @{
                                "platformAccountProperties_$prop" = $propval
                            }
                        }

                        foreach($prop in $SecretManagementProperties){
                            $propval = $rec.secretManagement.$prop
                            $minihash += @{
                                "secretManagement_$prop" = $propval
                            }
                        }

                        $convertobj = [PSCustomObject]$minihash
                        $outputmatrix += $convertobj
                    }
                }
                else{
                    $PlatformAccountProperties = @()
                    foreach($rec in $Data.DependentAccounts.platformAccountProperties){
                        $AllProps = $rec.psobject.Properties.name
                        foreach($prop in $AllProps){
                            if(!$PlatformAccountProperties.Contains($prop)){
                                $PlatformAccountProperties += $prop
                            }
                        }
                    }

                    $SecretManagementProperties = @()
                    foreach($rec in $Data.DependentAccounts.secretManagement){
                        $AllProps = $rec.psobject.Properties.name
                        foreach($prop in $AllProps){
                            if(!$SecretManagementProperties.Contains($prop)){
                                $SecretManagementProperties += $prop
                            }
                        }
                    }

                    foreach($rec in $Data.DependentAccounts){
                        $minihash = [ordered]@{
                            safeName = $rec.safeName
                            folderName = $rec.folderName
                            createdTime = $rec.createdTime
                            categoryModificationTime = $rec.categoryModificationTime
                            dependentAccountId = $rec.dependentAccountId
                            accountId = $rec.accountId
                            name = $rec.name
                            platformId = $rec.platformId

                        }

                        foreach($prop in $PlatformAccountProperties){
                            $propval = $rec.platformAccountProperties.$prop
                            $minihash += @{
                                "platformAccountProperties_$prop" = $propval
                            }
                        }

                        foreach($prop in $SecretManagementProperties){
                            $propval = $rec.secretManagement.$prop
                            $minihash += @{
                                "secretManagement_$prop" = $propval
                            }
                        }

                        $convertobj = [PSCustomObject]$minihash
                        $outputmatrix += $convertobj
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDependentAccounts"){

                if($ISPSS){
                    $PlatformAccountProperties = @()
                    foreach($rec in $Data.accountDependents.platformDependentProperties){
                        $AllProps = $rec.psobject.Properties.name
                        foreach($prop in $AllProps){
                            if(!$PlatformAccountProperties.Contains($prop)){
                                $PlatformAccountProperties += $prop
                            }
                        }
                    }

                    $SecretManagementProperties = @()
                    foreach($rec in $Data.secretManagement){
                        $AllProps = $rec.psobject.Properties.name
                        foreach($prop in $AllProps){
                            if(!$SecretManagementProperties.Contains($prop)){
                                $SecretManagementProperties += $prop
                            }
                        }
                    }

                    foreach($rec in $Data.accountDependents){
                        $minihash = [ordered]@{
                            safeName = $rec.safeName
                            createdAt = $rec.createdAt
                            modifiedAt = $rec.modifiedAt
                            id = $rec.id
                            mainAccountId = $rec.mainAccountId
                            name = $rec.name
                            platformId = $rec.platformId

                        }

                        foreach($prop in $PlatformAccountProperties){
                            $propval = $rec.platformDependentProperties.$prop
                            $minihash += @{
                                "platformDependentProperties_$prop" = $propval
                            }
                        }

                        foreach($prop in $SecretManagementProperties){
                            $propval = $rec.secretManagement.$prop
                            $minihash += @{
                                "secretManagement_$prop" = $propval
                            }
                        }

                        $convertobj = [PSCustomObject]$minihash
                        $outputmatrix += $convertobj
                    }
                }
                else{
                    $PlatformAccountProperties = @()
                    foreach($rec in $Data.platformAccountProperties){
                        $AllProps = $rec.psobject.Properties.name
                        foreach($prop in $AllProps){
                            if(!$PlatformAccountProperties.Contains($prop)){
                                $PlatformAccountProperties += $prop
                            }
                        }
                    }

                    $SecretManagementProperties = @()
                    foreach($rec in $Data.secretManagement){
                        $AllProps = $rec.psobject.Properties.name
                        foreach($prop in $AllProps){
                            if(!$SecretManagementProperties.Contains($prop)){
                                $SecretManagementProperties += $prop
                            }
                        }
                    }

                    foreach($rec in $Data){
                        $minihash = [ordered]@{
                            safeName = $rec.safeName
                            folderName = $rec.folderName
                            createdTime = $rec.createdTime
                            categoryModificationTime = $rec.categoryModificationTime
                            dependentAccountId = $rec.dependentAccountId
                            accountId = $rec.accountId
                            name = $rec.name
                            platformId = $rec.platformId

                        }

                        foreach($prop in $PlatformAccountProperties){
                            $propval = $rec.platformAccountProperties.$prop
                            $minihash += @{
                                "platformAccountProperties_$prop" = $propval
                            }
                        }

                        foreach($prop in $SecretManagementProperties){
                            $propval = $rec.secretManagement.$prop
                            $minihash += @{
                                "secretManagement_$prop" = $propval
                            }
                        }

                        $convertobj = [PSCustomObject]$minihash
                        $outputmatrix += $convertobj
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDependentAccountDetails"){

                if($ISPSS){
                    $PlatformAccountProperties = @()
                    foreach($rec in $Data.platformDependentProperties){
                        $AllProps = $rec.psobject.Properties.name
                        foreach($prop in $AllProps){
                            if(!$PlatformAccountProperties.Contains($prop)){
                                $PlatformAccountProperties += $prop
                            }
                        }
                    }

                    $SecretManagementProperties = @()
                    foreach($rec in $Data.secretManagement){
                        $AllProps = $rec.psobject.Properties.name
                        foreach($prop in $AllProps){
                            if(!$SecretManagementProperties.Contains($prop)){
                                $SecretManagementProperties += $prop
                            }
                        }
                    }

                    foreach($rec in $Data){
                        $minihash = [ordered]@{
                            safeName = $rec.safeName
                            createdAt = $rec.createdAt
                            modifiedAt = $rec.modifiedAt
                            id = $rec.id
                            mainAccountId = $rec.mainAccountId
                            name = $rec.name
                            platformId = $rec.platformId

                        }

                        foreach($prop in $PlatformAccountProperties){
                            $propval = $rec.platformDependentProperties.$prop
                            $minihash += @{
                                "platformDependentProperties_$prop" = $propval
                            }
                        }

                        foreach($prop in $SecretManagementProperties){
                            $propval = $rec.secretManagement.$prop
                            $minihash += @{
                                "secretManagement_$prop" = $propval
                            }
                        }

                        $convertobj = [PSCustomObject]$minihash
                        $outputmatrix += $convertobj
                    }
                }
                else{
                    $PlatformAccountProperties = @()
                    foreach($rec in $Data.platformAccountProperties){
                        $AllProps = $rec.psobject.Properties.name
                        foreach($prop in $AllProps){
                            if(!$PlatformAccountProperties.Contains($prop)){
                                $PlatformAccountProperties += $prop
                            }
                        }
                    }

                    $SecretManagementProperties = @()
                    foreach($rec in $Data.secretManagement){
                        $AllProps = $rec.psobject.Properties.name
                        foreach($prop in $AllProps){
                            if(!$SecretManagementProperties.Contains($prop)){
                                $SecretManagementProperties += $prop
                            }
                        }
                    }

                    foreach($rec in $Data){
                        $minihash = [ordered]@{
                            safeName = $rec.safeName
                            folderName = $rec.folderName
                            createdTime = $rec.createdTime
                            categoryModificationTime = $rec.categoryModificationTime
                            dependentAccountId = $rec.dependentAccountId
                            accountId = $rec.accountId
                            name = $rec.name
                            platformId = $rec.platformId

                        }

                        foreach($prop in $PlatformAccountProperties){
                            $propval = $rec.platformAccountProperties.$prop
                            $minihash += @{
                                "platformAccountProperties_$prop" = $propval
                            }
                        }

                        foreach($prop in $SecretManagementProperties){
                            $propval = $rec.secretManagement.$prop
                            $minihash += @{
                                "secretManagement_$prop" = $propval
                            }
                        }

                        $convertobj = [PSCustomObject]$minihash
                        $outputmatrix += $convertobj
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllOnboardingRules"){
                foreach($rec in $Data.AutomaticOnboardingRules){
                    $minihash = [ordered]@{
                        RuleId = $rec.RuleId
                        RuleName = $rec.RuleName
                        RuleDescription = $rec.RuleDescription
                        RulePrecedence = $rec.RulePrecedence
                        TargetPlatformId = $rec.TargetPlatformId
                        TargetDeviceType = $rec.TargetDeviceType
                        TargetSafeName = $rec.TargetSafeName
                        IsAdminIDFilter = $rec.IsAdminIDFilter
                        MachineTypeFilter = $rec.MachineTypeFilter
                        SystemTypeFilter = $rec.SystemTypeFilter
                        CreationTime = $rec.CreationTime
                        UserNameFilter = $rec.UserNameFilter
                        UserNameMethod = $rec.UserNameMethod
                        AddressFilter = $rec.AddressFilter
                        AddressMethod = $rec.AddressMethod
                        AccountTypeFilter = $rec.AccountTypeFilter
                        AccountCategoryFilter = $rec.AccountCategoryFilter
                        ReconcileAccountId = $rec.ReconcileAccountId
                        LastOnboardedTime = $rec.LastOnboardedTime
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASOnboardingRules"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        RuleId = $rec.RuleId
                        RuleName = $rec.RuleName
                        RuleDescription = $rec.RuleDescription
                        RulePrecedence = $rec.RulePrecedence
                        TargetPlatformId = $rec.TargetPlatformId
                        TargetDeviceType = $rec.TargetDeviceType
                        TargetSafeName = $rec.TargetSafeName
                        IsAdminIDFilter = $rec.IsAdminIDFilter
                        MachineTypeFilter = $rec.MachineTypeFilter
                        SystemTypeFilter = $rec.SystemTypeFilter
                        CreationTime = $rec.CreationTime
                        UserNameFilter = $rec.UserNameFilter
                        UserNameMethod = $rec.UserNameMethod
                        AddressFilter = $rec.AddressFilter
                        AddressMethod = $rec.AddressMethod
                        AccountTypeFilter = $rec.AccountTypeFilter
                        AccountCategoryFilter = $rec.AccountCategoryFilter
                        ReconcileAccountId = $rec.ReconcileAccountId
                        LastOnboardedTime = $rec.LastOnboardedTime
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllRemediationRules"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        id = $rec.id
                        name = $rec.name
                        status = $rec.status
                        rulesCount = $rec.rulesCount
                        OnboardedActions = $rec.actionsPerformed.ONBOARD
                        MarkForDeletionActions = $rec.actionsPerformed.MARK_FOR_DELETION
                        DeleteActions = $rec.actionsPerformed.DELETE
                        MarkThenDeleteActions = $rec.actionsPerformed.MARK_THEN_DELETE
                        lastModificationTime = $rec.lastModificationTime
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASRemediationRules"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        id = $rec.id
                        name = $rec.name
                        status = $rec.status
                        rulesCount = $rec.rulesCount
                        OnboardedActions = $rec.actionsPerformed.ONBOARD
                        MarkForDeletionActions = $rec.actionsPerformed.MARK_FOR_DELETION
                        DeleteActions = $rec.actionsPerformed.DELETE
                        MarkThenDeleteActions = $rec.actionsPerformed.MARK_THEN_DELETE
                        lastModificationTime = $rec.lastModificationTime
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllDiscoveredAccounts"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        id = $rec.id
                        name = $rec.name
                        userName = $rec.userName
                        address = $rec.address
                        discoveryDateTime = $rec.discoveryDateTime
                        accountEnabled = $rec.accountEnabled
                        osGroups = $rec.osGroups
                        platformType = $rec.platformType
                        domain = $rec.domain
                        lastLogonDateTime = $rec.lastLogonDateTime
                        lastPasswordSetDateTime = $rec.lastPasswordSetDateTime
                        passwordNeverExpires = $rec.passwordNeverExpires
                        osVersion = $rec.osVersion
                        privileged = $rec.privileged
                        userDisplayName = $rec.userDisplayName
                        passwordExpirationDateTime = $rec.passwordExpirationDateTime
                        osFamily = $rec.osFamily
                        organizationalUnit = $rec.organizationalUnit
                        numberOfDependencies = $rec.numberOfDependencies
                        additionalProperties = $rec.additionalProperties
                        platformTypeAccountProperties = $rec.platformTypeAccountProperties
                    }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllDiscoveredAccounts_NEW"){
                foreach($rec in $Data.value){
                    $tagstr = ""
                    foreach($tag in $rec.tags){
                        $tagstr += "$tag;"
                    }

                    $groupstr = ""
                    foreach($group in $rec.customProperties.groups){
                        $groupstr += "$group;"
                    }

                    $minihash = [ordered]@{
                        id = $rec.id
                        type = $rec.type
                        subType = $rec.subtype
                        source = $rec.source
                        isPrivileged = $rec.isPrivileged
                        creationTime = $rec.creationTime
                        updateTime = $rec.updateTime
                        numberOfDependencies = $rec.numberOfDependencies
                        lastActivityStatus = $rec.lastActivityStatus
                        networkId = $rec.networkId
                        scanDefinitionId = $rec.scanDefinitionId
                        scanProperties = $rec.scanProperties
                        isEdited = $rec.isEdited
                        status = $rec.status
                        statusReason = $rec.statusReason
                        tags = $tagstr
                    }

                    $AllProps = $rec.identifiers.psobject.Properties.name
                    foreach($prop in $AllProps){
                        $minihash += @{
                            $prop = $rec.identifiers.$prop
                        }
                    }

                    $AllProps = $rec.customProperties.psobject.Properties.name
                    foreach($prop in $AllProps){
                        if($prop -eq "groups"){
                            $minihash += @{
                                $prop = $groupstr
                            }
                        }
                        else{
                            $minihash += @{
                                $prop = $rec.customProperties.$prop
                            }
                        }
                    }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDiscoveredAccounts"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        id = $rec.id
                        name = $rec.name
                        userName = $rec.userName
                        address = $rec.address
                        discoveryDateTime = $rec.discoveryDateTime
                        accountEnabled = $rec.accountEnabled
                        osGroups = $rec.osGroups
                        platformType = $rec.platformType
                        domain = $rec.domain
                        lastLogonDateTime = $rec.lastLogonDateTime
                        lastPasswordSetDateTime = $rec.lastPasswordSetDateTime
                        passwordNeverExpires = $rec.passwordNeverExpires
                        osVersion = $rec.osVersion
                        privileged = $rec.privileged
                        userDisplayName = $rec.userDisplayName
                        passwordExpirationDateTime = $rec.passwordExpirationDateTime
                        osFamily = $rec.osFamily
                        organizationalUnit = $rec.organizationalUnit
                        numberOfDependencies = $rec.numberOfDependencies
                        additionalProperties = $rec.additionalProperties
                        platformTypeAccountProperties = $rec.platformTypeAccountProperties
                    }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDiscoveredAccountActivities"){
                foreach($rec in $Data.items){
                    $minihash = [ordered]@{
                        id = $rec.id
                        creationTime = $rec.creationTime
                        activity = $rec.activity
                        action = $rec.action
                        status = $rec.status
                        message = $rec.message
                        source = $rec.source
                        additionalErrorInfo = $rec.additionalErrorInfo
                        info = $rec.info
                    }

                    if($rec.ruleSets.Count -eq 0){
                        $rec.ruleSets = @{
                            id = "N/A"
                            name = "N/A"
                        }
                    }

                    foreach($rule in $rec.ruleSets){
                        $ruleID = $rule.id
                        $ruleName = $rule.name
                        $minihash += @{
                            RuleID = $ruleID
                            RuleName = $ruleName
                        }

                        $convertobj = [PSCustomObject]$minihash
                        $outputmatrix += $convertobj
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDiscoveredAccounts_NEW"){
                foreach($rec in $Data.value){
                    $tagstr = ""
                    foreach($tag in $rec.tags){
                        $tagstr += "$tag;"
                    }

                    $groupstr = ""
                    foreach($group in $rec.customProperties.groups){
                        $groupstr += "$group;"
                    }

                    $minihash = [ordered]@{
                        id = $rec.id
                        type = $rec.type
                        subType = $rec.subtype
                        source = $rec.source
                        isPrivileged = $rec.isPrivileged
                        creationTime = $rec.creationTime
                        updateTime = $rec.updateTime
                        numberOfDependencies = $rec.numberOfDependencies
                        lastActivityStatus = $rec.lastActivityStatus
                        networkId = $rec.networkId
                        scanDefinitionId = $rec.scanDefinitionId
                        scanProperties = $rec.scanProperties
                        isEdited = $rec.isEdited
                        status = $rec.status
                        statusReason = $rec.statusReason
                        tags = $tagstr
                    }

                    $AllProps = $rec.identifiers.psobject.Properties.name
                    foreach($prop in $AllProps){
                        $minihash += @{
                            $prop = $rec.identifiers.$prop
                        }
                    }

                    $AllProps = $rec.customProperties.psobject.Properties.name
                    foreach($prop in $AllProps){
                        if($prop -eq "groups"){
                            $minihash += @{
                                $prop = $groupstr
                            }
                        }
                        else{
                            $minihash += @{
                                $prop = $rec.customProperties.$prop
                            }
                        }
                    }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDiscoveredAccountDetails_NEW"){
                foreach($rec in $Data.value){
                    $tagstr = ""
                    foreach($tag in $rec.tags){
                        $tagstr += "$tag;"
                    }

                    $groupstr = ""
                    foreach($group in $rec.customProperties.groups){
                        $groupstr += "$group;"
                    }

                    $minihash = [ordered]@{
                        id = $rec.id
                        type = $rec.type
                        subType = $rec.subtype
                        source = $rec.source
                        isPrivileged = $rec.isPrivileged
                        creationTime = $rec.creationTime
                        updateTime = $rec.updateTime
                        numberOfDependencies = $rec.numberOfDependencies
                        lastActivityStatus = $rec.lastActivityStatus
                        networkId = $rec.networkId
                        scanDefinitionId = $rec.scanDefinitionId
                        scanProperties = $rec.scanProperties
                        isEdited = $rec.isEdited
                        status = $rec.status
                        statusReason = $rec.statusReason
                        tags = $tagstr
                    }

                    $AllProps = $rec.identifiers.psobject.Properties.name
                    foreach($prop in $AllProps){
                        $minihash += @{
                            $prop = $rec.identifiers.$prop
                        }
                    }

                    $AllProps = $rec.customProperties.psobject.Properties.name
                    foreach($prop in $AllProps){
                        if($prop -eq "groups"){
                            $minihash += @{
                                $prop = $groupstr
                            }
                        }
                        else{
                            $minihash += @{
                                $prop = $rec.customProperties.$prop
                            }
                        }
                    }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllDiscoveryScanDefinitions"){
                foreach($rec in $Data.items){
                    $tagstr = ""
                    foreach($tag in $rec.tags){
                        $tagstr += "$tag;"
                    }

                    $minihash = [ordered]@{
                        id = $rec.id
                        name = $rec.name
                        type = $rec.type
                        propertiesDomain = $rec.properties.domain
                        propertiesOU = $rec.properties.ou
                        propertiesDomainController = $rec.properties.targets.domainController
                        propertiesNonPrivileged = $rec.properties.targets.nonPrivileged
                        propertiesGroups = $rec.properties.adGroups.groups
                        recurrenceType = $rec.recurrenceType
                        recurrenceData = $rec.recurrenceData
                        credentialsName = $rec.credentials.name
                        credentialsType = $rec.credentials.type
                        credentialsID = $rec.credentials.properties.account_id
                        creationTime = $rec.creationTime
                        updateTime = $rec.updateTime
                        tags = $tagstr
                        state = $rec.state
                        isMigrated = $rec.isMigrated
                    }

                    foreach($prop in $rec.lastScanInstance.psobject.Properties.name){
                        $minihash += @{
                            "lastScan_$prop" = $rec.lastScanInstance.$prop
                        }
                    }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAccountNetwork"){
                foreach($rec in $Data){
                    $minihash += @{
                        accountId = $rec.accountId
                        networkId = $rec.networkId
                        networkName = $rec.networkName
                    }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDuplicateAccounts"){
                foreach($rec in $Data){
                    $platformpropertiesstr = ""
                    $AllPlatformProperties = $rec.platformAccountProperties
                    $AllPlatformKeys = $AllPlatformProperties.psobject.Properties.name
                    foreach($prop in $AllPlatformKeys){
                        $propval = $AllPlatformProperties."$prop"
                        $platformpropertiesstr += "$prop=$propval;"
                    }

                    $minihash = [ordered]@{
                        id = $rec.id
                        address = $rec.address
                        userName = $rec.userName
                        platformId = $rec.platformId
                        safeName = $rec.safeName
                        name = $rec.name
                        secretType = $rec.secretType
                        platformAccountProperties = $platformpropertiesstr
                        createdTime = $rec.createdTime
                        secretManagement_automaticManagementEnabled = $rec.secretManagement.automaticManagementEnabled
                        secretManagement_manualManagementReason = $rec.secretManagement.manualManagementReason
                        secretManagement_status = $rec.secretManagement.status
                        secretManagement_lastModifiedTime = $rec.secretManagement.lastModifiedTime
                        secretManagement_lastReconciledTime = $rec.secretManagement.lastReconciledTime
                        secretManagement_lastVerifiedTime = $rec.secretManagement.lastVerifiedTime
                        remoteMachinesAccess_remoteMachines = $rec.remoteMachinesAccess.remoteMachines
                        remoteMachinesAccess_accessRestrictedToRemoteMachines = $rec.remoteMachinesAccess.accessRestrictedToRemoteMachines
                        categoryModificationTime = $rec.categoryModificationTime
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASFailedAccounts"){
                foreach($rec in $Data){
                    $platformpropertiesstr = ""
                    $AllPlatformProperties = $rec.platformAccountProperties
                    $AllPlatformKeys = $AllPlatformProperties.psobject.Properties.name
                    foreach($prop in $AllPlatformKeys){
                        $propval = $AllPlatformProperties."$prop"
                        $platformpropertiesstr += "$prop=$propval;"
                    }

                    $minihash = [ordered]@{
                        id = $rec.id
                        address = $rec.address
                        userName = $rec.userName
                        platformId = $rec.platformId
                        safeName = $rec.safeName
                        name = $rec.name
                        secretType = $rec.secretType
                        platformAccountProperties = $platformpropertiesstr
                        createdTime = $rec.createdTime
                        secretManagement_automaticManagementEnabled = $rec.secretManagement.automaticManagementEnabled
                        secretManagement_manualManagementReason = $rec.secretManagement.manualManagementReason
                        secretManagement_status = $rec.secretManagement.status
                        secretManagement_lastModifiedTime = $rec.secretManagement.lastModifiedTime
                        secretManagement_lastReconciledTime = $rec.secretManagement.lastReconciledTime
                        secretManagement_lastVerifiedTime = $rec.secretManagement.lastVerifiedTime
                        remoteMachinesAccess_remoteMachines = $rec.remoteMachinesAccess.remoteMachines
                        remoteMachinesAccess_accessRestrictedToRemoteMachines = $rec.remoteMachinesAccess.accessRestrictedToRemoteMachines
                        categoryModificationTime = $rec.categoryModificationTime
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDisabledAccounts"){
                foreach($rec in $Data){
                    $platformpropertiesstr = ""
                    $AllPlatformProperties = $rec.platformAccountProperties
                    $AllPlatformKeys = $AllPlatformProperties.psobject.Properties.name
                    foreach($prop in $AllPlatformKeys){
                        $propval = $AllPlatformProperties."$prop"
                        $platformpropertiesstr += "$prop=$propval;"
                    }

                    $minihash = [ordered]@{
                        disabledBy = $rec.DisabledBy
                        id = $rec.id
                        address = $rec.address
                        userName = $rec.userName
                        platformId = $rec.platformId
                        safeName = $rec.safeName
                        name = $rec.name
                        secretType = $rec.secretType
                        platformAccountProperties = $platformpropertiesstr
                        createdTime = $rec.createdTime
                        secretManagement_automaticManagementEnabled = $rec.secretManagement.automaticManagementEnabled
                        secretManagement_manualManagementReason = $rec.secretManagement.manualManagementReason
                        secretManagement_status = $rec.secretManagement.status
                        secretManagement_lastModifiedTime = $rec.secretManagement.lastModifiedTime
                        secretManagement_lastReconciledTime = $rec.secretManagement.lastReconciledTime
                        secretManagement_lastVerifiedTime = $rec.secretManagement.lastVerifiedTime
                        remoteMachinesAccess_remoteMachines = $rec.remoteMachinesAccess.remoteMachines
                        remoteMachinesAccess_accessRestrictedToRemoteMachines = $rec.remoteMachinesAccess.accessRestrictedToRemoteMachines
                        categoryModificationTime = $rec.categoryModificationTime
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion AccountCommands
            #region VaultCommands
            if($CommandName -eq "Get-VPASAllowedIPs"){
                foreach($rec in $Data){
                    foreach($ip in $rec.customerPublicIPs){
                        $minihash = [ordered]@{
                            lastTaskId = $rec.lastTaskId
                            dateUpdated = $rec.dateUpdated
                            updateInProgress = $rec.updateInProgress
                            customerPublicIPs = $ip
                        }
                        $convertobj = [PSCustomObject]$minihash
                        $outputmatrix += $convertobj
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllowedReferrer"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        referrerURL = $rec.referrerURL
                        regularExpression = $rec.regularExpression
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASClientIDs"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        ClientID = $rec
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASVaultDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        ServerName = $rec.ServerName
                        ServerId = $rec.ServerId
                        ApplicationName = $rec.ApplicationName
                    }
                    foreach($key in $rec.Features.psobject.Properties.name){
                        $val = $rec.Features."$key"
                        $minihash += @{
                            $key = $val
                        }
                    }
                    foreach($rec2 in $rec.AuthenticationMethods){
                        $minihash += @{
                            $rec2.Id = $rec2.Enabled
                        }
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSpecificAuthenticationMethod"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        id = $rec.id
                        displayName = $rec.displayName
                        enabled = $rec.enabled
                        logoffUrl = $rec.logoffUrl
                        secondFactorAuth = $rec.secondFactorAuth
                        signInLabel = $rec.signInLabel
                        usernameFieldLabel = $rec.usernameFieldLabel
                        passwordFieldLabel = $rec.passwordFieldLabel
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAuthenticationMethods"){
                foreach($rec in $Data.Methods){
                    $minihash = [ordered]@{
                        id = $rec.id
                        displayName = $rec.displayName
                        enabled = $rec.enabled
                        logoffUrl = $rec.logoffUrl
                        secondFactorAuth = $rec.secondFactorAuth
                        signInLabel = $rec.signInLabel
                        usernameFieldLabel = $rec.usernameFieldLabel
                        passwordFieldLabel = $rec.passwordFieldLabel
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSystemComponents"){
                foreach($rec in $Data.Components){
                    $minihash = [ordered]@{
                        ComponentID = $rec.ComponentID
                        ComponentName = $rec.ComponentName
                        Description = $rec.Description
                        ConnectedComponentCount = $rec.ConnectedComponentCount
                        ComponentTotalCount = $rec.ComponentTotalCount
                        ComponentSpecificStat = $rec.ComponentSpecificStat
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }


                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSystemHealth"){
                foreach($rec in $Data.ComponentsDetails){
                    $minihash = [ordered]@{
                        ComponentIP = $rec.ComponentIP
                        ComponentUserName = $rec.ComponentUserName
                        ComponentVersion = $rec.ComponentVersion
                        ComponentSpecificStat = $rec.ComponentSpecificStat
                        IsLoggedOn = $rec.IsLoggedOn
                        LastLogonDate = $rec.LastLogonDate
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASVaultVersion"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        ExternalVersion = $rec.ExternalVersion
                        InternalVersion = $rec.InternalVersion
                        ServerName = $rec.ServerName
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSearchProperties"){
                foreach($rec in $Data.advancedSearchProperties){
                    foreach($key in $rec.psobject.Properties.name){
                        $minihash = [ordered]@{
                            Property = $key
                        }
                        $str = ""
                        foreach($client in $rec.$key.validValues){
                            if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                        }
                        $minihash += @{ validValues = $str }
                        $str = ""
                        foreach($client in $rec.$key.supportedOperators){
                            if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                        }
                        $minihash += @{ supportedOperators = $str }
                        $str = ""
                        foreach($client in $rec.$key.supportedLogicalOperators){
                            if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                        }
                        $minihash += @{ supportedLogicalOperators = $str }

                        $convertobj = [PSCustomObject]$minihash
                        $outputmatrix += $convertobj
                    }
                }
                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllCustomThemes"){
                foreach($rec in $Data.CustomThemes){
                    $minihash = [ordered]@{
                        isActive = $rec.isActive
                        isSystem = $rec.isSystem
                        name = $rec.name
                        isDraft = $rec.isDraft
                        mainBackgroundImage = $rec.images.main.mainBackgroundImage
                        mainLogoDark = $rec.images.main.mainLogoDark
                        advancedSmallLogo = $rec.images.main.advancedSmallLogo
                        advancedSymbolLogo = $rec.images.main.advancedSymbolLogo
                        colorsStyle = $rec.colors.colorsStyle
                        BackgroundMain = $rec.colors.definitionByType.dark.backgroundMain
                        darkBorderMain = $rec.colors.definitionByType.dark.borderMain
                        darkTextMain = $rec.colors.definitionByType.dark.textMain
                        darkDisableMain = $rec.colors.definitionByType.dark.disableMain
                        darkDisableTextPrimary = $rec.colors.definitionByType.dark.disableTextPrimary
                        darkDisableBackgroundPrimary = $rec.colors.definitionByType.dark.disableBackgroundPrimary
                        darkSuccessPrimary = $rec.colors.definitionByType.dark.successPrimary
                        darkSuccessSecondary = $rec.colors.definitionByType.dark.successSecondary
                        darkWarningPrimary = $rec.colors.definitionByType.dark.warningPrimary
                        darkWarningSecondary = $rec.colors.definitionByType.dark.warningSecondary
                        darkInfoPrimary = $rec.colors.definitionByType.dark.infoPrimary
                        darkInfoSecondary = $rec.colors.definitionByType.dark.infoSecondary
                        darkErrorPrimary = $rec.colors.definitionByType.dark.errorPrimary
                        darkErrorSecondary = $rec.colors.definitionByType.dark.errorSecondary
                        brightBackgroundMain = $rec.colors.definitionByType.bright.backgroundMain
                        brightBorderMain = $rec.colors.definitionByType.bright.borderMain
                        brightTextMain = $rec.colors.definitionByType.bright.textMain
                        brightDisableMain = $rec.colors.definitionByType.bright.disableMain
                        brightDisableTextPrimary = $rec.colors.definitionByType.bright.disableTextPrimary
                        brightDisableBackgroundPrimary = $rec.colors.definitionByType.bright.disableBackgroundPrimary
                        brightSuccessPrimary = $rec.colors.definitionByType.bright.successPrimary
                        brightSuccessSecondary = $rec.colors.definitionByType.bright.successSecondary
                        brightWarningPrimary = $rec.colors.definitionByType.bright.warningPrimary
                        brightWarningSecondary = $rec.colors.definitionByType.bright.warningSecondary
                        brightInfoPrimary = $rec.colors.definitionByType.bright.infoPrimary
                        brightInfoSecondary = $rec.colors.definitionByType.bright.infoSecondary
                        brightErrorPrimary = $rec.colors.definitionByType.bright.errorPrimary
                        brightErrorSecondary = $rec.colors.definitionByType.bright.errorSecondary
                        menuLogoBackground = $rec.colors.menu.menuLogoBackground
                        menuBackground = $rec.colors.menu.menuBackground
                        menuHoverBackground = $rec.colors.menu.menuHoverBackground
                        menuActiveBackgroundPrimary = $rec.colors.menu.menuActiveBackgroundPrimary
                        menuActiveBackgroundSecondary = $rec.colors.menu.menuActiveBackgroundSecondary
                        menuText = $rec.colors.menu.menuText
                        menuTextActive = $rec.colors.menu.menuTextActive
                        menuIcon = $rec.colors.menu.menuIcon
                        advancedBackgroundMain = $rec.colors.advanced.backgroundMain
                        advancedBorderMain = $rec.colors.advanced.borderMain
                        advancedTextMain = $rec.colors.advanced.textMain
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCustomTheme"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        isActive = $rec.isActive
                        isSystem = $rec.isSystem
                        name = $rec.name
                        isDraft = $rec.isDraft
                        mainBackgroundImage = $rec.images.main.mainBackgroundImage
                        mainLogoDark = $rec.images.main.mainLogoDark
                        advancedSmallLogo = $rec.images.main.advancedSmallLogo
                        advancedSymbolLogo = $rec.images.main.advancedSymbolLogo
                        colorsStyle = $rec.colors.colorsStyle
                        BackgroundMain = $rec.colors.definitionByType.dark.backgroundMain
                        darkBorderMain = $rec.colors.definitionByType.dark.borderMain
                        darkTextMain = $rec.colors.definitionByType.dark.textMain
                        darkDisableMain = $rec.colors.definitionByType.dark.disableMain
                        darkDisableTextPrimary = $rec.colors.definitionByType.dark.disableTextPrimary
                        darkDisableBackgroundPrimary = $rec.colors.definitionByType.dark.disableBackgroundPrimary
                        darkSuccessPrimary = $rec.colors.definitionByType.dark.successPrimary
                        darkSuccessSecondary = $rec.colors.definitionByType.dark.successSecondary
                        darkWarningPrimary = $rec.colors.definitionByType.dark.warningPrimary
                        darkWarningSecondary = $rec.colors.definitionByType.dark.warningSecondary
                        darkInfoPrimary = $rec.colors.definitionByType.dark.infoPrimary
                        darkInfoSecondary = $rec.colors.definitionByType.dark.infoSecondary
                        darkErrorPrimary = $rec.colors.definitionByType.dark.errorPrimary
                        darkErrorSecondary = $rec.colors.definitionByType.dark.errorSecondary
                        brightBackgroundMain = $rec.colors.definitionByType.bright.backgroundMain
                        brightBorderMain = $rec.colors.definitionByType.bright.borderMain
                        brightTextMain = $rec.colors.definitionByType.bright.textMain
                        brightDisableMain = $rec.colors.definitionByType.bright.disableMain
                        brightDisableTextPrimary = $rec.colors.definitionByType.bright.disableTextPrimary
                        brightDisableBackgroundPrimary = $rec.colors.definitionByType.bright.disableBackgroundPrimary
                        brightSuccessPrimary = $rec.colors.definitionByType.bright.successPrimary
                        brightSuccessSecondary = $rec.colors.definitionByType.bright.successSecondary
                        brightWarningPrimary = $rec.colors.definitionByType.bright.warningPrimary
                        brightWarningSecondary = $rec.colors.definitionByType.bright.warningSecondary
                        brightInfoPrimary = $rec.colors.definitionByType.bright.infoPrimary
                        brightInfoSecondary = $rec.colors.definitionByType.bright.infoSecondary
                        brightErrorPrimary = $rec.colors.definitionByType.bright.errorPrimary
                        brightErrorSecondary = $rec.colors.definitionByType.bright.errorSecondary
                        menuLogoBackground = $rec.colors.menu.menuLogoBackground
                        menuBackground = $rec.colors.menu.menuBackground
                        menuHoverBackground = $rec.colors.menu.menuHoverBackground
                        menuActiveBackgroundPrimary = $rec.colors.menu.menuActiveBackgroundPrimary
                        menuActiveBackgroundSecondary = $rec.colors.menu.menuActiveBackgroundSecondary
                        menuText = $rec.colors.menu.menuText
                        menuTextActive = $rec.colors.menu.menuTextActive
                        menuIcon = $rec.colors.menu.menuIcon
                        advancedBackgroundMain = $rec.colors.advanced.backgroundMain
                        advancedBorderMain = $rec.colors.advanced.borderMain
                        advancedTextMain = $rec.colors.advanced.textMain
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCurrentCustomTheme"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        isActive = $rec.isActive
                        isSystem = $rec.isSystem
                        name = $rec.name
                        isDraft = $rec.isDraft
                        mainBackgroundImage = $rec.images.main.mainBackgroundImage
                        mainLogoDark = $rec.images.main.mainLogoDark
                        advancedSmallLogo = $rec.images.main.advancedSmallLogo
                        advancedSymbolLogo = $rec.images.main.advancedSymbolLogo
                        colorsStyle = $rec.colors.colorsStyle
                        BackgroundMain = $rec.colors.definitionByType.dark.backgroundMain
                        darkBorderMain = $rec.colors.definitionByType.dark.borderMain
                        darkTextMain = $rec.colors.definitionByType.dark.textMain
                        darkDisableMain = $rec.colors.definitionByType.dark.disableMain
                        darkDisableTextPrimary = $rec.colors.definitionByType.dark.disableTextPrimary
                        darkDisableBackgroundPrimary = $rec.colors.definitionByType.dark.disableBackgroundPrimary
                        darkSuccessPrimary = $rec.colors.definitionByType.dark.successPrimary
                        darkSuccessSecondary = $rec.colors.definitionByType.dark.successSecondary
                        darkWarningPrimary = $rec.colors.definitionByType.dark.warningPrimary
                        darkWarningSecondary = $rec.colors.definitionByType.dark.warningSecondary
                        darkInfoPrimary = $rec.colors.definitionByType.dark.infoPrimary
                        darkInfoSecondary = $rec.colors.definitionByType.dark.infoSecondary
                        darkErrorPrimary = $rec.colors.definitionByType.dark.errorPrimary
                        darkErrorSecondary = $rec.colors.definitionByType.dark.errorSecondary
                        brightBackgroundMain = $rec.colors.definitionByType.bright.backgroundMain
                        brightBorderMain = $rec.colors.definitionByType.bright.borderMain
                        brightTextMain = $rec.colors.definitionByType.bright.textMain
                        brightDisableMain = $rec.colors.definitionByType.bright.disableMain
                        brightDisableTextPrimary = $rec.colors.definitionByType.bright.disableTextPrimary
                        brightDisableBackgroundPrimary = $rec.colors.definitionByType.bright.disableBackgroundPrimary
                        brightSuccessPrimary = $rec.colors.definitionByType.bright.successPrimary
                        brightSuccessSecondary = $rec.colors.definitionByType.bright.successSecondary
                        brightWarningPrimary = $rec.colors.definitionByType.bright.warningPrimary
                        brightWarningSecondary = $rec.colors.definitionByType.bright.warningSecondary
                        brightInfoPrimary = $rec.colors.definitionByType.bright.infoPrimary
                        brightInfoSecondary = $rec.colors.definitionByType.bright.infoSecondary
                        brightErrorPrimary = $rec.colors.definitionByType.bright.errorPrimary
                        brightErrorSecondary = $rec.colors.definitionByType.bright.errorSecondary
                        menuLogoBackground = $rec.colors.menu.menuLogoBackground
                        menuBackground = $rec.colors.menu.menuBackground
                        menuHoverBackground = $rec.colors.menu.menuHoverBackground
                        menuActiveBackgroundPrimary = $rec.colors.menu.menuActiveBackgroundPrimary
                        menuActiveBackgroundSecondary = $rec.colors.menu.menuActiveBackgroundSecondary
                        menuText = $rec.colors.menu.menuText
                        menuTextActive = $rec.colors.menu.menuTextActive
                        menuIcon = $rec.colors.menu.menuIcon
                        advancedBackgroundMain = $rec.colors.advanced.backgroundMain
                        advancedBorderMain = $rec.colors.advanced.borderMain
                        advancedTextMain = $rec.colors.advanced.textMain
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDirectoryDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        DirectoryType = $rec.DirectoryType
                        BindUsername = $rec.BindUsername
                        BindPassword = $rec.BindPassword
                        SSLConnect = $rec.SSLConnect
                        LDAPDirectoryName = $rec.LDAPDirectoryName
                        LDAPDirectoryQueryOrder = $rec.LDAPDirectoryQueryOrder
                        LDAPDirectoryDescription = $rec.LDAPDirectoryDescription
                        VaultObjectNamesPrefix = $rec.VaultObjectNamesPrefix
                        PasswordObjectPath = $rec.PasswordObjectPath
                        LDAPDirectoryGroupBaseContext = $rec.LDAPDirectoryGroupBaseContext
                        ReferralsChasingHopLimit = $rec.ReferralsChasingHopLimit
                        AppendFriendlyDomainNameToGroup = $rec.AppendFriendlyDomainNameToGroup
                        RequireReferredDirectoryDefinition = $rec.RequireReferredDirectoryDefinition
                        ReferralsDNSLookup = $rec.ReferralsDNSLookup
                        DisableUserEnumeration = $rec.DisableUserEnumeration
                        AdditionalQueryFilterOptimize = $rec.AdditionalQueryFilterOptimize
                        ClientBrowsing = $rec.ClientBrowsing
                        ExternalObjectCreation = $rec.ExternalObjectCreation
                        Authentication = $rec.Authentication
                        UseLDAPCertificatesOnly = $rec.UseLDAPCertificatesOnly
                        DisablePaging = $rec.DisablePaging
                        ProvisionDisabledUsers = $rec.ProvisionDisabledUsers
                        DomainName = $rec.DomainName
                        DomainBaseContext = $rec.DomainBaseContext
                    }
                    $str = ""
                    foreach($client in $rec.LDAPDirectoryUsage){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        LDAPDirectoryUsage = $str
                    }

                    $grouplen = $rec.DCList.count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            Name = ""
                            Port = ""
                            DcSSLConnect = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.DCList){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                Name = $group.Name
                                Port = $group.Port
                                DcSSLConnect = $group.SSLConnect
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDirectoryMappingDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        LDAPBranch = $rec.LDAPBranch
                        Location = $rec.Location
                        UserType = $rec.UserType
                        DisableUser = $rec.DisableUser
                        UserActivityLogPeriod = $rec.UserActivityLogPeriod
                        UserExpiration = $rec.UserExpiration
                        LogonFromHour = $rec.LogonFromHour
                        LogonToHour = $rec.LogonToHour
                        UsedQuota = $rec.UsedQuota
                        EnableENEWhenDisconnected = $rec.EnableENEWhenDisconnected
                        MappingID = $rec.MappingID
                        DirectoryMappingOrder = $rec.DirectoryMappingOrder
                        MappingName = $rec.MappingName
                        LDAPQuery = $rec.LDAPQuery
                        DomainGroupsSearchType = $rec.DomainGroupsSearchType
                    }
                    $str = ""
                    foreach($client in $rec.AuthenticationMethod){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ AuthenticationMethod = $str }

                    $str = ""
                    foreach($client in $rec.MappingAuthorizations){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ MappingAuthorizations = $str }

                    $str = ""
                    foreach($client in $rec.AuthorizedInterfaces){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ AuthorizedInterfaces = $str }

                    $str = ""
                    foreach($client in $rec.DomainGroups){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ DomainGroups = $str }

                    $str = ""
                    foreach($client in $rec.AllowedAuthenticationMethods){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ AllowedAuthenticationMethods = $str }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDirectoryMappings"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        LDAPBranch = $rec.LDAPBranch
                        Location = $rec.Location
                        UserType = $rec.UserType
                        DisableUser = $rec.DisableUser
                        UserActivityLogPeriod = $rec.UserActivityLogPeriod
                        UserExpiration = $rec.UserExpiration
                        LogonFromHour = $rec.LogonFromHour
                        LogonToHour = $rec.LogonToHour
                        UsedQuota = $rec.UsedQuota
                        EnableENEWhenDisconnected = $rec.EnableENEWhenDisconnected
                        MappingID = $rec.MappingID
                        DirectoryMappingOrder = $rec.DirectoryMappingOrder
                        MappingName = $rec.MappingName
                        LDAPQuery = $rec.LDAPQuery
                        DomainGroupsSearchType = $rec.DomainGroupsSearchType
                    }
                    $str = ""
                    foreach($client in $rec.AuthenticationMethod){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ AuthenticationMethod = $str }

                    $str = ""
                    foreach($client in $rec.MappingAuthorizations){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ MappingAuthorizations = $str }

                    $str = ""
                    foreach($client in $rec.AuthorizedInterfaces){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ AuthorizedInterfaces = $str }

                    $str = ""
                    foreach($client in $rec.DomainGroups){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ DomainGroups = $str }

                    $str = ""
                    foreach($client in $rec.AllowedAuthenticationMethods){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ AllowedAuthenticationMethods = $str }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllDirectories"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        DomainName = $rec.DomainName
                        DomainBaseContext = $rec.DomainBaseContext
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllReports"){
                foreach($rec in $Data.reports){
                    $minihash = [ordered]@{
                        name = $rec.name
                        type = $rec.type
                        filename = $rec.filename
                        isScheduled = $rec.isScheduled
                        createdAt = $rec.createdAt
                        createdBy = $rec.createdBy
                        status = $rec.status
                        statusAdditionalInfo = $rec.statusAdditionalInfo
                        records = $rec.records
                        size = $rec.size
                        duration = $rec.duration
                        safe = $rec.safe
                        location = $rec.location
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllTasks"){
                foreach($rec in $Data.tasks){
                    $minihash = [ordered]@{
                        id = $rec.id
                        folder = $rec.folder
                        type = $rec.type
                        subType = $rec.subType
                        name = $rec.name
                        keepTaskDefinition = $rec.keepTaskDefinition
                        startTime = $rec.schedule.startTime
                        recurrenceType = $rec.schedule.recurrence.type
                        recurrenceValue = $rec.schedule.recurrence.recurrenceValue
                        weekNumber = $rec.schedule.recurrence.weekNumber

                    }
                    $daysstr = ""
                    foreach($day in $rec.schedule.recurrence.daysOfWeek){
                        $daysstr += $day + ";"
                    }
                    $minihash += @{
                        daysOfWeek = $daysstr
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion VaultCommands
            #region SafeCommands
            if($CommandName -eq "Get-VPASAllSafes"){
                foreach($rec in $Data){
                    $accountstr = ""
                    $AllAccounts = $rec.accounts
                    foreach($acct in $AllAccounts){
                        $acctID = $acct.id
                        $acctName = $acct.name
                        $accountstr += "$acctID=$acctName;"
                    }

                    $minihash = [ordered]@{
                        safeUrlId = $rec.safeUrlId
                        safeName = $rec.safeName
                        safeNumber = $rec.safeNumber
                        description = $rec.description
                        location = $rec.location
                        creatorID = $rec.creator.id
                        creatorName = $rec.creator.name
                        olacEnabled = $rec.olacEnabled
                        managingCPM = $rec.managingCPM
                        numberOfVersionsRetention = $rec.numberOfVersionsRetention
                        numberOfDaysRetention = $rec.numberOfDaysRetention
                        autoPurgeEnabled = $rec.autoPurgeEnabled
                        creationTime = $rec.creationTime
                        lastModificationTime = $rec.lastModificationTime
                        isExpiredMember = $rec.isExpiredMember
                        accounts = $accountstr
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSafesByPlatformID"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        Safe = $rec
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSafeMemberSearch"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        safeUrlId = $rec.safeUrlId
                        safeName = $rec.safeName
                        safeNumber = $rec.safeNumber
                        memberId = $rec.memberId
                        memberName = $rec.memberName
                        memberType = $rec.memberType
                        membershipExpirationDate = $rec.membershipExpirationDate
                        isExpiredMembershipEnable = $rec.isExpiredMembershipEnable
                        isPredefinedUser = $rec.isPredefinedUser
                        isReadOnly = $rec.isReadOnly
                        useAccounts = $rec.permissions.useAccounts
                        retrieveAccounts = $rec.permissions.retrieveAccounts
                        listAccounts = $rec.permissions.listAccounts
                        addAccounts = $rec.permissions.addAccounts
                        updateAccountContent = $rec.permissions.updateAccountContent
                        updateAccountProperties = $rec.permissions.updateAccountProperties
                        initiateCPMAccountManagementOperations = $rec.permissions.initiateCPMAccountManagementOperations
                        specifyNextAccountContent = $rec.permissions.specifyNextAccountContent
                        renameAccounts = $rec.permissions.renameAccounts
                        deleteAccounts = $rec.permissions.deleteAccounts
                        unlockAccounts = $rec.permissions.unlockAccounts
                        manageSafe = $rec.permissions.manageSafe
                        manageSafeMembers = $rec.permissions.manageSafeMembers
                        backupSafe = $rec.permissions.backupSafe
                        viewAuditLog = $rec.permissions.viewAuditLog
                        viewSafeMembers = $rec.permissions.viewSafeMembers
                        accessWithoutConfirmation = $rec.permissions.accessWithoutConfirmation
                        createFolders = $rec.permissions.createFolders
                        deleteFolders = $rec.permissions.deleteFolders
                        moveAccountsAndFolders = $rec.permissions.moveAccountsAndFolders
                        requestsAuthorizationLevel1 = $rec.permissions.requestsAuthorizationLevel1
                        requestsAuthorizationLevel2 = $rec.permissions.requestsAuthorizationLevel2
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSafeMembers"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        safeUrlId = $rec.safeUrlId
                        safeName = $rec.safeName
                        safeNumber = $rec.safeNumber
                        memberId = $rec.memberId
                        memberName = $rec.memberName
                        memberType = $rec.memberType
                        membershipExpirationDate = $rec.membershipExpirationDate
                        isExpiredMembershipEnable = $rec.isExpiredMembershipEnable
                        isPredefinedUser = $rec.isPredefinedUser
                        isReadOnly = $rec.isReadOnly
                        useAccounts = $rec.permissions.useAccounts
                        retrieveAccounts = $rec.permissions.retrieveAccounts
                        listAccounts = $rec.permissions.listAccounts
                        addAccounts = $rec.permissions.addAccounts
                        updateAccountContent = $rec.permissions.updateAccountContent
                        updateAccountProperties = $rec.permissions.updateAccountProperties
                        initiateCPMAccountManagementOperations = $rec.permissions.initiateCPMAccountManagementOperations
                        specifyNextAccountContent = $rec.permissions.specifyNextAccountContent
                        renameAccounts = $rec.permissions.renameAccounts
                        deleteAccounts = $rec.permissions.deleteAccounts
                        unlockAccounts = $rec.permissions.unlockAccounts
                        manageSafe = $rec.permissions.manageSafe
                        manageSafeMembers = $rec.permissions.manageSafeMembers
                        backupSafe = $rec.permissions.backupSafe
                        viewAuditLog = $rec.permissions.viewAuditLog
                        viewSafeMembers = $rec.permissions.viewSafeMembers
                        accessWithoutConfirmation = $rec.permissions.accessWithoutConfirmation
                        createFolders = $rec.permissions.createFolders
                        deleteFolders = $rec.permissions.deleteFolders
                        moveAccountsAndFolders = $rec.permissions.moveAccountsAndFolders
                        requestsAuthorizationLevel1 = $rec.permissions.requestsAuthorizationLevel1
                        requestsAuthorizationLevel2 = $rec.permissions.requestsAuthorizationLevel2
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSafes"){
                foreach($rec in $Data){
                    $accountstr = ""
                    $AllAccounts = $rec.accounts
                    foreach($acct in $AllAccounts){
                        $acctID = $acct.id
                        $acctName = $acct.name
                        $accountstr += "$acctID=$acctName;"
                    }

                    $minihash = [ordered]@{
                        safeUrlId = $rec.safeUrlId
                        safeName = $rec.safeName
                        safeNumber = $rec.safeNumber
                        description = $rec.description
                        location = $rec.location
                        creatorID = $rec.creator.id
                        creatorName = $rec.creator.name
                        olacEnabled = $rec.olacEnabled
                        managingCPM = $rec.managingCPM
                        numberOfVersionsRetention = $rec.numberOfVersionsRetention
                        numberOfDaysRetention = $rec.numberOfDaysRetention
                        autoPurgeEnabled = $rec.autoPurgeEnabled
                        creationTime = $rec.creationTime
                        lastModificationTime = $rec.lastModificationTime
                        isExpiredMember = $rec.isExpiredMember
                        accounts = $accountstr
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSafeDetails"){
                foreach($rec in $Data){
                    $accountstr = ""
                    $AllAccounts = $rec.accounts
                    foreach($acct in $AllAccounts){
                        $acctID = $acct.id
                        $acctName = $acct.name
                        $accountstr += "$acctID=$acctName;"
                    }

                    $minihash = [ordered]@{
                        safeUrlId = $rec.safeUrlId
                        safeName = $rec.safeName
                        safeNumber = $rec.safeNumber
                        description = $rec.description
                        location = $rec.location
                        creatorID = $rec.creator.id
                        creatorName = $rec.creator.name
                        olacEnabled = $rec.olacEnabled
                        managingCPM = $rec.managingCPM
                        numberOfVersionsRetention = $rec.numberOfVersionsRetention
                        numberOfDaysRetention = $rec.numberOfDaysRetention
                        quota = $rec.quota
                        usedquota = $rec.usedquota
                        autoPurgeEnabled = $rec.autoPurgeEnabled
                        creationTime = $rec.creationTime
                        lastModificationTime = $rec.lastModificationTime
                        isExpiredMember = $rec.isExpiredMember
                        accounts = $accountstr
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASEmptySafes"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        safeUrlId = $rec.safeUrlId
                        safeName = $rec.safeName
                        safeNumber = $rec.safeNumber
                        description = $rec.description
                        location = $rec.location
                        creatorID = $rec.creator.id
                        creatorName = $rec.creator.name
                        olacEnabled = $rec.olacEnabled
                        managingCPM = $rec.managingCPM
                        numberOfVersionsRetention = $rec.numberOfVersionsRetention
                        numberOfDaysRetention = $rec.numberOfDaysRetention
                        autoPurgeEnabled = $rec.autoPurgeEnabled
                        creationTime = $rec.creationTime
                        lastModificationTime = $rec.lastModificationTime
                        isExpiredMember = $rec.isExpiredMember
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }
                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion SafeCommands
            #region PSMCommands
            if($CommandName -eq "Get-VPASAllPSMServers"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        ID = $rec.ID
                        Name = $rec.Name
                        Address = $rec.Address
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPSMSessionDetails"){
                foreach($rec in $Data.Recordings){
                    $minihash = [ordered]@{
                        SessionID = $rec.SessionID
                        SessionGuid = $rec.SessionGuid
                        SafeName = $rec.SafeName
                        FolderName = $rec.FolderName
                        IsLive = $rec.IsLive
                        FileName = $rec.FileName
                        Start = $rec.Start
                        End = $rec.End
                        Duration = $rec.Duration
                        User = $rec.User
                        RemoteMachine = $rec.RemoteMachine
                        ProtectionDate = $rec.ProtectionDate
                        ProtectedBy = $rec.ProtectedBy
                        ProtectionEnabled = $rec.ProtectionEnabled
                        AccountUsername = $rec.AccountUsername
                        AccountPlatformID = $rec.AccountPlatformID
                        AccountAddress = $rec.AccountAddress
                        PIMSuCommand = $rec.PIMSuCommand
                        PIMSuCWD = $rec.PIMSuCWD
                        ConnectionComponentID = $rec.ConnectionComponentID
                        PSMRecordingEntity = $rec.PSMRecordingEntity
                        TicketID = $rec.TicketID
                        FromIP = $rec.FromIP
                        Protocol = $rec.Protocol
                        Client = $rec.Client
                        RiskScore = $rec.RiskScore
                        Severity = $rec.Severity
                        VideoSize = $rec.VideoSize
                        TextSize = $rec.TextSize
                        DetailsUrl = $rec.DetailsUrl
                        Address = $rec.RawProperties.Address
                        DeviceType = $rec.RawProperties.DeviceType
                        EntityVersion = $rec.RawProperties.EntityVersion
                        ExpectedRecordingsList = $rec.RawProperties.ExpectedRecordingsList
                        PSMClientApp = $rec.RawProperties.PSMClientApp
                        PSMPasswordID = $rec.RawProperties.PSMPasswordID
                        PSMProtocol = $rec.RawProperties.PSMProtocol
                        PSMRemoteMachine = $rec.RawProperties.PSMRemoteMachine
                        PSMSafeID = $rec.RawProperties.PSMSafeID
                        PSMSourceAddress = $rec.RawProperties.PSMSourceAddress
                        PSMStartTime = $rec.RawProperties.PSMStartTime
                        PSMStatus = $rec.RawProperties.PSMStatus
                        PSMVaultUserName = $rec.RawProperties.PSMVaultUserName
                        PolicyID = $rec.RawProperties.PolicyID
                        ProviderID = $rec.RawProperties.ProviderID
                        ActualRecordings = $rec.RawProperties.ActualRecordings
                        PSMEndTime = $rec.RawProperties.PSMEndTime
                        UserName = $rec.RawProperties.UserName
                        Safe = $rec.RawProperties.Safe
                        Folder = $rec.RawProperties.Folder
                        Name = $rec.RawProperties.Name
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPSMSessionProperties"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        SessionID = $rec.SessionID
                        SessionGuid = $rec.SessionGuid
                        SafeName = $rec.SafeName
                        FolderName = $rec.FolderName
                        IsLive = $rec.IsLive
                        FileName = $rec.FileName
                        Start = $rec.Start
                        End = $rec.End
                        Duration = $rec.Duration
                        User = $rec.User
                        RemoteMachine = $rec.RemoteMachine
                        ProtectionDate = $rec.ProtectionDate
                        ProtectedBy = $rec.ProtectedBy
                        ProtectionEnabled = $rec.ProtectionEnabled
                        AccountUsername = $rec.AccountUsername
                        AccountPlatformID = $rec.AccountPlatformID
                        AccountAddress = $rec.AccountAddress
                        PIMSuCommand = $rec.PIMSuCommand
                        PIMSuCWD = $rec.PIMSuCWD
                        ConnectionComponentID = $rec.ConnectionComponentID
                        PSMRecordingEntity = $rec.PSMRecordingEntity
                        TicketID = $rec.TicketID
                        FromIP = $rec.FromIP
                        Protocol = $rec.Protocol
                        Client = $rec.Client
                        RiskScore = $rec.RiskScore
                        Severity = $rec.Severity
                        VideoSize = $rec.VideoSize
                        TextSize = $rec.TextSize
                        DetailsUrl = $rec.DetailsUrl
                        Address = $rec.RawProperties.Address
                        DeviceType = $rec.RawProperties.DeviceType
                        EntityVersion = $rec.RawProperties.EntityVersion
                        ExpectedRecordingsList = $rec.RawProperties.ExpectedRecordingsList
                        PSMClientApp = $rec.RawProperties.PSMClientApp
                        PSMPasswordID = $rec.RawProperties.PSMPasswordID
                        PSMProtocol = $rec.RawProperties.PSMProtocol
                        PSMRemoteMachine = $rec.RawProperties.PSMRemoteMachine
                        PSMSafeID = $rec.RawProperties.PSMSafeID
                        PSMSourceAddress = $rec.RawProperties.PSMSourceAddress
                        PSMStartTime = $rec.RawProperties.PSMStartTime
                        PSMStatus = $rec.RawProperties.PSMStatus
                        PSMVaultUserName = $rec.RawProperties.PSMVaultUserName
                        PolicyID = $rec.RawProperties.PolicyID
                        ProviderID = $rec.RawProperties.ProviderID
                        ActualRecordings = $rec.RawProperties.ActualRecordings
                        PSMEndTime = $rec.RawProperties.PSMEndTime
                        UserName = $rec.RawProperties.UserName
                        Safe = $rec.RawProperties.Safe
                        Folder = $rec.RawProperties.Folder
                        Name = $rec.RawProperties.Name
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPSMSessions"){
                foreach($rec in $Data.Recordings){
                    $minihash = [ordered]@{
                        SessionID = $rec.SessionID
                        SessionGuid = $rec.SessionGuid
                        SafeName = $rec.SafeName
                        FolderName = $rec.FolderName
                        IsLive = $rec.IsLive
                        FileName = $rec.FileName
                        Start = $rec.Start
                        End = $rec.End
                        Duration = $rec.Duration
                        User = $rec.User
                        RemoteMachine = $rec.RemoteMachine
                        ProtectionDate = $rec.ProtectionDate
                        ProtectedBy = $rec.ProtectedBy
                        ProtectionEnabled = $rec.ProtectionEnabled
                        AccountUsername = $rec.AccountUsername
                        AccountPlatformID = $rec.AccountPlatformID
                        AccountAddress = $rec.AccountAddress
                        PIMSuCommand = $rec.PIMSuCommand
                        PIMSuCWD = $rec.PIMSuCWD
                        ConnectionComponentID = $rec.ConnectionComponentID
                        PSMRecordingEntity = $rec.PSMRecordingEntity
                        TicketID = $rec.TicketID
                        FromIP = $rec.FromIP
                        Protocol = $rec.Protocol
                        Client = $rec.Client
                        RiskScore = $rec.RiskScore
                        Severity = $rec.Severity
                        VideoSize = $rec.VideoSize
                        TextSize = $rec.TextSize
                        DetailsUrl = $rec.DetailsUrl
                        Address = $rec.RawProperties.Address
                        DeviceType = $rec.RawProperties.DeviceType
                        EntityVersion = $rec.RawProperties.EntityVersion
                        ExpectedRecordingsList = $rec.RawProperties.ExpectedRecordingsList
                        PSMClientApp = $rec.RawProperties.PSMClientApp
                        PSMPasswordID = $rec.RawProperties.PSMPasswordID
                        PSMProtocol = $rec.RawProperties.PSMProtocol
                        PSMRemoteMachine = $rec.RawProperties.PSMRemoteMachine
                        PSMSafeID = $rec.RawProperties.PSMSafeID
                        PSMSourceAddress = $rec.RawProperties.PSMSourceAddress
                        PSMStartTime = $rec.RawProperties.PSMStartTime
                        PSMStatus = $rec.RawProperties.PSMStatus
                        PSMVaultUserName = $rec.RawProperties.PSMVaultUserName
                        PolicyID = $rec.RawProperties.PolicyID
                        ProviderID = $rec.RawProperties.ProviderID
                        ActualRecordings = $rec.RawProperties.ActualRecordings
                        PSMEndTime = $rec.RawProperties.PSMEndTime
                        UserName = $rec.RawProperties.UserName
                        Safe = $rec.RawProperties.Safe
                        Folder = $rec.RawProperties.Folder
                        Name = $rec.RawProperties.Name
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllPSMSessions"){
                foreach($rec in $Data.Recordings){
                    $minihash = [ordered]@{
                        SessionID = $rec.SessionID
                        SessionGuid = $rec.SessionGuid
                        SafeName = $rec.SafeName
                        FolderName = $rec.FolderName
                        IsLive = $rec.IsLive
                        FileName = $rec.FileName
                        Start = $rec.Start
                        End = $rec.End
                        Duration = $rec.Duration
                        User = $rec.User
                        RemoteMachine = $rec.RemoteMachine
                        ProtectionDate = $rec.ProtectionDate
                        ProtectedBy = $rec.ProtectedBy
                        ProtectionEnabled = $rec.ProtectionEnabled
                        AccountUsername = $rec.AccountUsername
                        AccountPlatformID = $rec.AccountPlatformID
                        AccountAddress = $rec.AccountAddress
                        PIMSuCommand = $rec.PIMSuCommand
                        PIMSuCWD = $rec.PIMSuCWD
                        ConnectionComponentID = $rec.ConnectionComponentID
                        PSMRecordingEntity = $rec.PSMRecordingEntity
                        TicketID = $rec.TicketID
                        FromIP = $rec.FromIP
                        Protocol = $rec.Protocol
                        Client = $rec.Client
                        RiskScore = $rec.RiskScore
                        Severity = $rec.Severity
                        VideoSize = $rec.VideoSize
                        TextSize = $rec.TextSize
                        DetailsUrl = $rec.DetailsUrl
                        Address = $rec.RawProperties.Address
                        DeviceType = $rec.RawProperties.DeviceType
                        EntityVersion = $rec.RawProperties.EntityVersion
                        ExpectedRecordingsList = $rec.RawProperties.ExpectedRecordingsList
                        PSMClientApp = $rec.RawProperties.PSMClientApp
                        PSMPasswordID = $rec.RawProperties.PSMPasswordID
                        PSMProtocol = $rec.RawProperties.PSMProtocol
                        PSMRemoteMachine = $rec.RawProperties.PSMRemoteMachine
                        PSMSafeID = $rec.RawProperties.PSMSafeID
                        PSMSourceAddress = $rec.RawProperties.PSMSourceAddress
                        PSMStartTime = $rec.RawProperties.PSMStartTime
                        PSMStatus = $rec.RawProperties.PSMStatus
                        PSMVaultUserName = $rec.RawProperties.PSMVaultUserName
                        PolicyID = $rec.RawProperties.PolicyID
                        ProviderID = $rec.RawProperties.ProviderID
                        ActualRecordings = $rec.RawProperties.ActualRecordings
                        PSMEndTime = $rec.RawProperties.PSMEndTime
                        UserName = $rec.RawProperties.UserName
                        Safe = $rec.RawProperties.Safe
                        Folder = $rec.RawProperties.Folder
                        Name = $rec.RawProperties.Name
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPSMSessionActivities"){
                foreach($rec in $Data.Activities){
                    $minihash = [ordered]@{
                        ActivityText = $rec.ActivityText
                        ActivityType = $rec.ActivityType
                        ActivityId = $rec.ActivityId
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPSMSettingsByPlatformID"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        PSMServerId = $rec.PSMServerId
                        PSMSessionRecorderSafe = $rec.PSMSessionRecorderSafe
                    }

                    $grouplen = $rec.PSMConnectors.Count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            PSMConnectorID = ""
                            Enabled = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.PSMConnectors){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                PSMConnectorID = $group.PSMConnectorID
                                Enabled = $group.Enabled
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASActiveSessionActivities"){
                foreach($rec in $Data.Activities){
                    $minihash = [ordered]@{
                        ActivityText = $rec.ActivityText
                        ActivityType = $rec.ActivityType
                        ActivityId = $rec.ActivityId
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASActiveSessionProperties"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        CanTerminate = $rec.CanTerminate
                        CanMonitor = $rec.CanMonitor
                        CanSuspend = $rec.CanSuspend
                        SessionID = $rec.SessionID
                        SessionGuid = $rec.SessionGuid
                        SafeName = $rec.SafeName
                        FolderName = $rec.FolderName
                        IsLive = $rec.IsLive
                        FileName = $rec.FileName
                        Start = $rec.Start
                        End = $rec.End
                        Duration = $rec.Duration
                        User = $rec.User
                        RemoteMachine = $rec.RemoteMachine
                        ProtectionDate = $rec.ProtectionDate
                        ProtectedBy = $rec.ProtectedBy
                        ProtectionEnabled = $rec.ProtectionEnabled
                        AccountUsername = $rec.AccountUsername
                        AccountPlatformID = $rec.AccountPlatformID
                        AccountAddress = $rec.AccountAddress
                        PIMSuCommand = $rec.PIMSuCommand
                        PIMSuCWD = $rec.PIMSuCWD
                        ConnectionComponentID = $rec.ConnectionComponentID
                        PSMRecordingEntity = $rec.PSMRecordingEntity
                        TicketID = $rec.TicketID
                        FromIP = $rec.FromIP
                        Protocol = $rec.Protocol
                        Client = $rec.Client
                        RiskScore = $rec.RiskScore
                        Severity = $rec.Severity
                        RecordedActivities = $rec.RecordedActivities
                        VideoSize = $rec.VideoSize
                        TextSize = $rec.TextSize
                        DetailsUrl = $rec.DetailsUrl
                        Address = $rec.RawProperties.Address
                        DeviceType = $rec.RawProperties.DeviceType
                        EntityVersion = $rec.RawProperties.EntityVersion
                        ExpectedRecordingsList = $rec.RawProperties.ExpectedRecordingsList
                        PSMClientApp = $rec.RawProperties.PSMClientApp
                        PSMPasswordID = $rec.RawProperties.PSMPasswordID
                        PSMProtocol = $rec.RawProperties.PSMProtocol
                        PSMRemoteMachine = $rec.RawProperties.PSMRemoteMachine
                        PSMSafeID = $rec.RawProperties.PSMSafeID
                        PSMSourceAddress = $rec.RawProperties.PSMSourceAddress
                        PSMStartTime = $rec.RawProperties.PSMStartTime
                        PSMStatus = $rec.RawProperties.PSMStatus
                        PSMVaultUserName = $rec.RawProperties.PSMVaultUserName
                        PolicyID = $rec.RawProperties.PolicyID
                        ProviderID = $rec.RawProperties.ProviderID
                        UserName = $rec.RawProperties.UserName
                        Safe = $rec.RawProperties.Safe
                        Folder = $rec.RawProperties.Folder
                        Name = $rec.RawProperties.Name
                    }
                    $str = ""
                    foreach($client in $rec.RecordingFiles){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        RecordingFiles = $str
                    }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASActiveSessions"){
                foreach($rec in $Data.LiveSessions){
                    $minihash = [ordered]@{
                        CanTerminate = $rec.CanTerminate
                        CanMonitor = $rec.CanMonitor
                        CanSuspend = $rec.CanSuspend
                        SessionID = $rec.SessionID
                        SessionGuid = $rec.SessionGuid
                        SafeName = $rec.SafeName
                        FolderName = $rec.FolderName
                        IsLive = $rec.IsLive
                        FileName = $rec.FileName
                        Start = $rec.Start
                        End = $rec.End
                        Duration = $rec.Duration
                        User = $rec.User
                        RemoteMachine = $rec.RemoteMachine
                        ProtectionDate = $rec.ProtectionDate
                        ProtectedBy = $rec.ProtectedBy
                        ProtectionEnabled = $rec.ProtectionEnabled
                        AccountUsername = $rec.AccountUsername
                        AccountPlatformID = $rec.AccountPlatformID
                        AccountAddress = $rec.AccountAddress
                        PIMSuCommand = $rec.PIMSuCommand
                        PIMSuCWD = $rec.PIMSuCWD
                        ConnectionComponentID = $rec.ConnectionComponentID
                        PSMRecordingEntity = $rec.PSMRecordingEntity
                        TicketID = $rec.TicketID
                        FromIP = $rec.FromIP
                        Protocol = $rec.Protocol
                        Client = $rec.Client
                        RiskScore = $rec.RiskScore
                        Severity = $rec.Severity
                        RecordedActivities = $rec.RecordedActivities
                        VideoSize = $rec.VideoSize
                        TextSize = $rec.TextSize
                        DetailsUrl = $rec.DetailsUrl
                        Address = $rec.RawProperties.Address
                        DeviceType = $rec.RawProperties.DeviceType
                        EntityVersion = $rec.RawProperties.EntityVersion
                        ExpectedRecordingsList = $rec.RawProperties.ExpectedRecordingsList
                        PSMClientApp = $rec.RawProperties.PSMClientApp
                        PSMPasswordID = $rec.RawProperties.PSMPasswordID
                        PSMProtocol = $rec.RawProperties.PSMProtocol
                        PSMRemoteMachine = $rec.RawProperties.PSMRemoteMachine
                        PSMSafeID = $rec.RawProperties.PSMSafeID
                        PSMSourceAddress = $rec.RawProperties.PSMSourceAddress
                        PSMStartTime = $rec.RawProperties.PSMStartTime
                        PSMStatus = $rec.RawProperties.PSMStatus
                        PSMVaultUserName = $rec.RawProperties.PSMVaultUserName
                        PolicyID = $rec.RawProperties.PolicyID
                        ProviderID = $rec.RawProperties.ProviderID
                        UserName = $rec.RawProperties.UserName
                        Safe = $rec.RawProperties.Safe
                        Folder = $rec.RawProperties.Folder
                        Name = $rec.RawProperties.Name
                    }
                    $str = ""
                    foreach($client in $rec.RecordingFiles){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        RecordingFiles = $str
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllActiveSessions"){
                foreach($rec in $Data.LiveSessions){
                    $minihash = [ordered]@{
                        CanTerminate = $rec.CanTerminate
                        CanMonitor = $rec.CanMonitor
                        CanSuspend = $rec.CanSuspend
                        SessionID = $rec.SessionID
                        SessionGuid = $rec.SessionGuid
                        SafeName = $rec.SafeName
                        FolderName = $rec.FolderName
                        IsLive = $rec.IsLive
                        FileName = $rec.FileName
                        Start = $rec.Start
                        End = $rec.End
                        Duration = $rec.Duration
                        User = $rec.User
                        RemoteMachine = $rec.RemoteMachine
                        ProtectionDate = $rec.ProtectionDate
                        ProtectedBy = $rec.ProtectedBy
                        ProtectionEnabled = $rec.ProtectionEnabled
                        AccountUsername = $rec.AccountUsername
                        AccountPlatformID = $rec.AccountPlatformID
                        AccountAddress = $rec.AccountAddress
                        PIMSuCommand = $rec.PIMSuCommand
                        PIMSuCWD = $rec.PIMSuCWD
                        ConnectionComponentID = $rec.ConnectionComponentID
                        PSMRecordingEntity = $rec.PSMRecordingEntity
                        TicketID = $rec.TicketID
                        FromIP = $rec.FromIP
                        Protocol = $rec.Protocol
                        Client = $rec.Client
                        RiskScore = $rec.RiskScore
                        Severity = $rec.Severity
                        RecordedActivities = $rec.RecordedActivities
                        VideoSize = $rec.VideoSize
                        TextSize = $rec.TextSize
                        DetailsUrl = $rec.DetailsUrl
                        Address = $rec.RawProperties.Address
                        DeviceType = $rec.RawProperties.DeviceType
                        EntityVersion = $rec.RawProperties.EntityVersion
                        ExpectedRecordingsList = $rec.RawProperties.ExpectedRecordingsList
                        PSMClientApp = $rec.RawProperties.PSMClientApp
                        PSMPasswordID = $rec.RawProperties.PSMPasswordID
                        PSMProtocol = $rec.RawProperties.PSMProtocol
                        PSMRemoteMachine = $rec.RawProperties.PSMRemoteMachine
                        PSMSafeID = $rec.RawProperties.PSMSafeID
                        PSMSourceAddress = $rec.RawProperties.PSMSourceAddress
                        PSMStartTime = $rec.RawProperties.PSMStartTime
                        PSMStatus = $rec.RawProperties.PSMStatus
                        PSMVaultUserName = $rec.RawProperties.PSMVaultUserName
                        PolicyID = $rec.RawProperties.PolicyID
                        ProviderID = $rec.RawProperties.ProviderID
                        UserName = $rec.RawProperties.UserName
                        Safe = $rec.RawProperties.Safe
                        Folder = $rec.RawProperties.Folder
                        Name = $rec.RawProperties.Name
                    }
                    $str = ""
                    foreach($client in $rec.RecordingFiles){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        RecordingFiles = $str
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllConnectionComponents"){
                foreach($rec in $Data.PSMConnectors){
                    $minihash = [ordered]@{
                        ID = $rec.ID
                        DisplayName = $rec.DisplayName
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion PSMCommands
            #region EPVCommands
            if($CommandName -eq "Get-VPASEPVUserTypes"){
                foreach($rec in $Data.UserTypes){
                    $minihash = [ordered]@{
                        UserTypeId = $rec.UserTypeId
                        UserTypeName = $rec.UserTypeName
                        IsComponentUser = $rec.IsComponentUser
                    }
                    $clientstr = ""
                    foreach($client in $rec.AllowedClientInterfaces){
                        if(![String]::IsNullOrEmpty($client)){
                            $clientstr += "$client;"
                        }
                    }
                    $minihash += @{
                        AllowedClientInterfaces = $clientstr
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASEPVUserDetailsSearch"){
                foreach($rec in $Data.Users){
                    $minihash = [ordered]@{
                        id = $rec.id
                        username = $rec.username
                        source = $rec.source
                        userType = $rec.userType
                        componentUser = $rec.componentUser
                        location = $rec.location
                        enableUser = $rec.enableUser
                        suspended = $rec.suspended
                        firstName = $rec.personalDetails.firstName
                        middleName = $rec.personalDetails.middleName
                        lastName = $rec.personalDetails.lastName
                        organization = $rec.personalDetails.organization
                        department = $rec.personalDetails.department
                    }
                    $str = ""
                    foreach($client in $rec.vaultAuthorization){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        vaultAuthorization = $str
                    }

                    $grouplen = $rec.groupsMembership.count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            groupID = ""
                            groupName = ""
                            groupType = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.groupsMembership){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                groupID = $group.groupID
                                groupName = $group.groupName
                                groupType = $group.groupType
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASEPVUserDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        enableUser = $rec.enableUser
                        changePassOnNextLogon = $rec.changePassOnNextLogon
                        expiryDate = $rec.expiryDate
                        suspended = $rec.suspended
                        lastSuccessfulLoginDate = $rec.lastSuccessfulLoginDate
                        passwordNeverExpires = $rec.passwordNeverExpires
                        distinguishedName = $rec.distinguishedName
                        description = $rec.description
                        id = $rec.id
                        username = $rec.username
                        source = $rec.source
                        userType = $rec.userType
                        componentUser = $rec.componentUser
                        location = $rec.location
                        workStreet = $rec.businessAddress.workStreet
                        workCity = $rec.businessAddress.workCity
                        workState = $rec.businessAddress.workState
                        workZip = $rec.businessAddress.workZip
                        workCountry = $rec.businessAddress.workCountry
                        homePage = $rec.internet.homePage
                        homeEmail = $rec.internet.homeEmail
                        businessEmail = $rec.internet.businessEmail
                        otherEmail = $rec.internet.otherEmail
                        homeNumber = $rec.phones.homeNumber
                        businessNumber = $rec.phones.businessNumber
                        cellularNumber = $rec.phones.cellularNumber
                        faxNumber = $rec.phones.faxNumber
                        pagerNumber = $rec.phones.pagerNumber
                        street = $rec.personalDetails.street
                        city = $rec.personalDetails.city
                        state = $rec.personalDetails.state
                        zip = $rec.personalDetails.zip
                        country = $rec.personalDetails.country
                        title = $rec.personalDetails.title
                        organization = $rec.personalDetails.organization
                        department = $rec.personalDetails.department
                        profession = $rec.personalDetails.profession
                        firstName = $rec.personalDetails.firstName
                        middleName = $rec.personalDetails.middleName
                        lastName = $rec.personalDetails.lastName
                    }
                    $str = ""
                    foreach($client in $rec.vaultAuthorization){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        vaultAuthorization = $str
                    }
                    $str = ""
                    foreach($client in $rec.authenticationMethod){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        authenticationMethod = $str
                    }
                    $str = ""
                    foreach($client in $rec.unAuthorizedInterfaces){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        unAuthorizedInterfaces = $str
                    }

                    $grouplen = $rec.groupsMembership.count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            groupID = ""
                            groupName = ""
                            groupType = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.groupsMembership){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                groupID = $group.groupID
                                groupName = $group.groupName
                                groupType = $group.groupType
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASEPVGroupDetails"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        id = $rec.id
                        groupType = $rec.groupType
                        groupName = $rec.groupName
                        description = $rec.description
                        location = $rec.location
                    }
                    $grouplen = $rec.members.count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            username = ""
                            userID = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.members){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                username = $group.username
                                userID = $group.id
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCurrentEPVUserDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        AgentUser = $rec.AgentUser
                        Disabled = $rec.Disabled
                        Email = $rec.Email
                        Expired = $rec.Expired
                        ExpiryDate = $rec.ExpiryDate
                        FirstName = $rec.FirstName
                        LastName = $rec.LastName
                        Location = $rec.Location
                        Source = $rec.Source
                        Suspended = $rec.Suspended
                        UserName = $rec.UserName
                        UserTypeName = $rec.UserTypeName
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllEPVGroups"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        id = $rec.id
                        groupType = $rec.groupType
                        groupName = $rec.groupName
                        description = $rec.description
                        location = $rec.location
                    }
                    $grouplen = $rec.members.Count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            username = ""
                            userID = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.members){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                username = $group.username
                                userID = $group.id
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllEPVUsers"){
                foreach($rec in $Data.Users){
                    $minihash = [ordered]@{
                        id = $rec.id
                        username = $rec.username
                        source = $rec.source
                        userType = $rec.userType
                        componentUser = $rec.componentUser
                        enableUser = $rec.enableUser
                        suspended = $rec.suspended
                        location = $rec.location
                        firstName = $rec.personalDetails.firstName
                        middleName = $rec.personalDetails.middleName
                        lastName = $rec.personalDetails.lastName
                        organization = $rec.personalDetails.organization
                        department = $rec.personalDetails.department
                    }
                    $str = ""
                    foreach($client in $rec.vaultAuthorization){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ vaultAuthorization = $str }

                    $grouplen = $rec.groupsMembership.Count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            groupID = ""
                            groupName = ""
                            groupType = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.groupsMembership){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                groupID = $group.groupID
                                groupName = $group.groupName
                                groupType = $group.groupType
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion EPVCommands
            #region PlatformCommands
            if($CommandName -eq "Get-VPASAllUsagePlatforms"){
                foreach($rec in $Data.Platforms){
                    $minihash = [ordered]@{
                        NumberOfLinkedTargetPlatforms = $rec.NumberOfLinkedTargetPlatforms
                        ID = $rec.ID
                        PlatformID = $rec.PlatformID
                        Name = $rec.Name
                        PlatformBaseType = $rec.PlatformBaseType
                        PlatformBaseID = $rec.PlatformBaseID
                        AllowManualChange = $rec.CredentialsManagementPolicy.Change.AllowManual
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPlatformDetails"){
                $AllProps = @()
                foreach($rec in $Data.Details){
                    $props = $rec.psobject.Properties.name
                    foreach($prop in $props){
                        if($AllProps -notcontains $prop){
                            $AllProps += $prop
                        }
                    }
                }
                foreach($rec in $Data.Details){
                    $minihash = @{}
                    foreach($prop in $AllProps){
                        $minihash += @{
                            $prop = $rec.$prop
                        }
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPlatformDetailsSearch"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        id = $rec.general.id
                        name = $rec.general.name
                        systemType = $rec.general.systemType
                        active = $rec.general.active
                        description = $rec.general.description
                        platformBaseID = $rec.general.platformBaseID
                        platformType = $rec.general.platformType
                        allowedSafes = $rec.credentialsManagement.allowedSafes
                        allowManualChange = $rec.credentialsManagement.allowManualChange
                        performPeriodicChange = $rec.credentialsManagement.performPeriodicChange
                        requirePasswordChangeEveryXDays = $rec.credentialsManagement.requirePasswordChangeEveryXDays
                        allowManualVerification = $rec.credentialsManagement.allowManualVerification
                        performPeriodicVerification = $rec.credentialsManagement.performPeriodicVerification
                        requirePasswordVerificationEveryXDays = $rec.credentialsManagement.requirePasswordVerificationEveryXDays
                        allowManualReconciliation = $rec.credentialsManagement.allowManualReconciliation
                        automaticReconcileWhenUnsynched = $rec.credentialsManagement.automaticReconcileWhenUnsynched
                        requirePrivilegedSessionMonitoringAndIsolation = $rec.sessionManagement.requirePrivilegedSessionMonitoringAndIsolation
                        recordAndSaveSessionActivity = $rec.sessionManagement.recordAndSaveSessionActivity
                        PSMServerID = $rec.sessionManagement.PSMServerID
                        requireDualControlPasswordAccessApproval = $rec.privilegedAccessWorkflows.requireDualControlPasswordAccessApproval
                        enforceCheckinCheckoutExclusiveAccess = $rec.privilegedAccessWorkflows.enforceCheckinCheckoutExclusiveAccess
                        enforceOnetimePasswordAccess = $rec.privilegedAccessWorkflows.enforceOnetimePasswordAccess
                    }
                    $str = ""
                    foreach($client in $rec.properties.required.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ RequiredProperties = $str }
                    $str = ""
                    foreach($client in $rec.properties.optional.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ OptionalProperties = $str }
                    $str = ""
                    foreach($client in $rec.linkedAccounts.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ linkedAccounts = $str }


                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASUsagePlatformDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        NumberOfLinkedTargetPlatforms = $rec.NumberOfLinkedTargetPlatforms
                        ID = $rec.ID
                        PlatformID = $rec.PlatformID
                        Name = $rec.Name
                        PlatformBaseType = $rec.PlatformBaseType
                        PlatformBaseID = $rec.PlatformBaseID
                        AllowManualChange = $rec.CredentialsManagementPolicy.Change.AllowManual
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASRotationalPlatformDetails"){
                foreach($rec in $Data.Details){
                    $minihash = [ordered]@{
                        PolicyID = $rec.PolicyID
                        PolicyName = $rec.PolicyName
                        SearchForUsages = $rec.SearchForUsages
                        PolicyType = $rec.PolicyType
                        ImmediateInterval = $rec.ImmediateInterval
                        Interval = $rec.Interval
                        MaxConcurrentConnections = $rec.MaxConcurrentConnections
                        AllowedSafes = $rec.AllowedSafes
                        MinValidityPeriod = $rec.MinValidityPeriod
                        ResetOveridesMinValidity = $rec.ResetOveridesMinValidity
                        ResetOveridesTimeFrame = $rec.ResetOveridesTimeFrame
                        Timeout = $rec.Timeout
                        UnlockIfFail = $rec.UnlockIfFail
                        UnrecoverableErrors = $rec.UnrecoverableErrors
                        MaximumRetries = $rec.MaximumRetries
                        MinDelayBetweenRetries = $rec.MinDelayBetweenRetries
                        DllName = $rec.DllName
                        XMLFile = $rec.XMLFile
                        AllowManualChange = $rec.AllowManualChange
                        PerformPeriodicChange = $rec.PerformPeriodicChange
                        HeadStartInterval = $rec.HeadStartInterval
                        FromHour = $rec.FromHour
                        ToHour = $rec.ToHour
                        ChangeNotificationPeriod = $rec.ChangeNotificationPeriod
                        DaysNotifyPriorExpiration = $rec.DaysNotifyPriorExpiration
                        VFAllowManualVerification = $rec.VFAllowManualVerification
                        VFPerformPeriodicVerification = $rec.VFPerformPeriodicVerification
                        VFFromHour = $rec.VFFromHour
                        VFToHour = $rec.VFToHour
                        RCAllowManualReconciliation = $rec.RCAllowManualReconciliation
                        RCAutomaticReconcileWhenUnsynched = $rec.RCAutomaticReconcileWhenUnsynched
                        RCReconcileReasons = $rec.RCReconcileReasons
                        RCFromHour = $rec.RCFromHour
                        RCToHour = $rec.RCToHour
                        NFNotifyPriorExpiration = $rec.NFNotifyPriorExpiration
                        NFPriorExpirationRecipients = $rec.NFPriorExpirationRecipients
                        NFNotifyOnPasswordDisable = $rec.NFNotifyOnPasswordDisable
                        NFOnPasswordDisableRecipients = $rec.NFOnPasswordDisableRecipients
                        NFNotifyOnVerificationErrors = $rec.NFNotifyOnVerificationErrors
                        NFOnVerificationErrorsRecipients = $rec.NFOnVerificationErrorsRecipients
                        NFNotifyOnPasswordUsed = $rec.NFNotifyOnPasswordUsed
                        NFOnPasswordUsedRecipients = $rec.NFOnPasswordUsedRecipients
                        PasswordLength = $rec.PasswordLength
                        MinUpperCase = $rec.MinUpperCase
                        MinLowerCase = $rec.MinLowerCase
                        MinDigit = $rec.MinDigit
                        MinSpecial = $rec.MinSpecial
                        OneTimePassword = $rec.OneTimePassword
                        ExpirationPeriod = $rec.ExpirationPeriod
                        VFVerificationPeriod = $rec.VFVerificationPeriod
                        PasswordLevelRequestTimeframe = $rec.PasswordLevelRequestTimeframe
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllRotationalPlatforms"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        id = $rec.general.id
                        name = $rec.general.name
                        systemType = $rec.general.systemType
                        active = $rec.general.active
                        description = $rec.general.description
                        platformBaseID = $rec.general.platformBaseID
                        platformType = $rec.general.platformType
                        allowedSafes = $rec.credentialsManagement.allowedSafes
                        allowManualChange = $rec.credentialsManagement.allowManualChange
                        performPeriodicChange = $rec.credentialsManagement.performPeriodicChange
                        requirePasswordChangeEveryXDays = $rec.credentialsManagement.requirePasswordChangeEveryXDays
                        allowManualVerification = $rec.credentialsManagement.allowManualVerification
                        performPeriodicVerification = $rec.credentialsManagement.performPeriodicVerification
                        requirePasswordVerificationEveryXDays = $rec.credentialsManagement.requirePasswordVerificationEveryXDays
                        allowManualReconciliation = $rec.credentialsManagement.allowManualReconciliation
                        automaticReconcileWhenUnsynched = $rec.credentialsManagement.automaticReconcileWhenUnsynched
                        requirePrivilegedSessionMonitoringAndIsolation = $rec.sessionManagement.requirePrivilegedSessionMonitoringAndIsolation
                        recordAndSaveSessionActivity = $rec.sessionManagement.recordAndSaveSessionActivity
                        PSMServerID = $rec.sessionManagement.PSMServerID
                        requireDualControlPasswordAccessApproval = $rec.privilegedAccessWorkflows.requireDualControlPasswordAccessApproval
                        enforceCheckinCheckoutExclusiveAccess = $rec.privilegedAccessWorkflows.enforceCheckinCheckoutExclusiveAccess
                        enforceOnetimePasswordAccess = $rec.privilegedAccessWorkflows.enforceOnetimePasswordAccess
                    }
                    $str = ""
                    foreach($client in $rec.properties.required.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ RequiredProperties = $str }
                    $str = ""
                    foreach($client in $rec.properties.optional.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ OptionalProperties = $str }
                    $str = ""
                    foreach($client in $rec.linkedAccounts.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ linkedAccounts = $str }


                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllPlatforms"){
                foreach($rec in $Data.Platforms){
                    $minihash = [ordered]@{
                        id = $rec.general.id
                        name = $rec.general.name
                        systemType = $rec.general.systemType
                        active = $rec.general.active
                        description = $rec.general.description
                        platformBaseID = $rec.general.platformBaseID
                        platformType = $rec.general.platformType
                        allowedSafes = $rec.credentialsManagement.allowedSafes
                        allowManualChange = $rec.credentialsManagement.allowManualChange
                        performPeriodicChange = $rec.credentialsManagement.performPeriodicChange
                        requirePasswordChangeEveryXDays = $rec.credentialsManagement.requirePasswordChangeEveryXDays
                        allowManualVerification = $rec.credentialsManagement.allowManualVerification
                        performPeriodicVerification = $rec.credentialsManagement.performPeriodicVerification
                        requirePasswordVerificationEveryXDays = $rec.credentialsManagement.requirePasswordVerificationEveryXDays
                        allowManualReconciliation = $rec.credentialsManagement.allowManualReconciliation
                        automaticReconcileWhenUnsynched = $rec.credentialsManagement.automaticReconcileWhenUnsynched
                        requirePrivilegedSessionMonitoringAndIsolation = $rec.sessionManagement.requirePrivilegedSessionMonitoringAndIsolation
                        recordAndSaveSessionActivity = $rec.sessionManagement.recordAndSaveSessionActivity
                        PSMServerID = $rec.sessionManagement.PSMServerID
                        requireDualControlPasswordAccessApproval = $rec.privilegedAccessWorkflows.requireDualControlPasswordAccessApproval
                        enforceCheckinCheckoutExclusiveAccess = $rec.privilegedAccessWorkflows.enforceCheckinCheckoutExclusiveAccess
                        enforceOnetimePasswordAccess = $rec.privilegedAccessWorkflows.enforceOnetimePasswordAccess
                    }
                    $str = ""
                    foreach($client in $rec.properties.required.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ RequiredProperties = $str }
                    $str = ""
                    foreach($client in $rec.properties.optional.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ OptionalProperties = $str }
                    $str = ""
                    foreach($client in $rec.linkedAccounts.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ linkedAccounts = $str }


                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllTargetPlatforms"){
                foreach($rec in $Data.Platforms){
                    $minihash = [ordered]@{
                        Active = $rec.Active
                        SystemType = $rec.SystemType
                        AllowedSafes = $rec.AllowedSafes
                        ID = $rec.ID
                        PlatformID = $rec.PlatformID
                        Name = $rec.Name
                        PlatformBaseType = $rec.PlatformBaseType
                        PlatformBaseID = $rec.PlatformBaseID
                        RequireDualControlPasswordAccessApprovalActive = $rec.PrivilegedAccessWorkflows.RequireDualControlPasswordAccessApproval.IsActive
                        RequireDualControlPasswordAccessApprovalException = $rec.PrivilegedAccessWorkflows.RequireDualControlPasswordAccessApproval.IsAnException
                        EnforceCheckinCheckoutExclusiveAccessActive = $rec.PrivilegedAccessWorkflows.EnforceCheckinCheckoutExclusiveAccess.IsActive
                        EnforceCheckinCheckoutExclusiveAccessException = $rec.PrivilegedAccessWorkflows.EnforceCheckinCheckoutExclusiveAccess.IsAnException
                        EnforceOnetimePasswordAccessActive = $rec.PrivilegedAccessWorkflows.EnforceOnetimePasswordAccess.IsActive
                        EnforceOnetimePasswordAccessException = $rec.PrivilegedAccessWorkflows.EnforceOnetimePasswordAccess.IsAnException
                        RequireUsersToSpecifyReasonForAccessActive = $rec.PrivilegedAccessWorkflows.RequireUsersToSpecifyReasonForAccess.IsActive
                        RequireUsersToSpecifyReasonForAccessException = $rec.PrivilegedAccessWorkflows.RequireUsersToSpecifyReasonForAccess.IsAnException
                        VFPerformAutomatic = $rec.CredentialsManagementPolicy.Verification.PerformAutomatic
                        VFRequirePasswordEveryXDays = $rec.CredentialsManagementPolicy.Verification.RequirePasswordEveryXDays
                        VFAutoOnAdd = $rec.CredentialsManagementPolicy.Verification.AutoOnAdd
                        VFAllowManual = $rec.CredentialsManagementPolicy.Verification.AllowManual
                        ChangePerformAutomatic = $rec.CredentialsManagementPolicy.Change.PerformAutomatic
                        ChangeRequirePasswordEveryXDays = $rec.CredentialsManagementPolicy.Change.RequirePasswordEveryXDays
                        ChangeAutoOnAdd = $rec.CredentialsManagementPolicy.Change.AutoOnAdd
                        ChangeAllowManual = $rec.CredentialsManagementPolicy.Change.AllowManual
                        ReconcileAutomaticReconcileWhenUnsynced = $rec.CredentialsManagementPolicy.Reconcile.AutomaticReconcileWhenUnsynced
                        ReconcileAllowManual = $rec.CredentialsManagementPolicy.Reconcile.AllowManual
                        ChangePasswordInResetMode = $rec.CredentialsManagementPolicy.SecretUpdateConfiguration.ChangePasswordInResetMode
                        PSMServerId = $rec.PrivilegedSessionManagement.PSMServerId
                        PSMServerName = $rec.PrivilegedSessionManagement.PSMServerName
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASTargetPlatformDetails"){
                foreach($rec in $Data.Platforms){
                    $exceptions = ""
                    foreach($ex in $rec.ExceptionRules){
                        $exceptions += "$ex;"
                    }

                    $minihash = [ordered]@{
                        Active = $rec.Active
                        SystemType = $rec.SystemType
                        AllowedSafes = $rec.AllowedSafes
                        Version = $rec.Version
                        ID = $rec.ID
                        PlatformID = $rec.PlatformID
                        Name = $rec.Name
                        ExceptionCount = $rec.ExceptionCount
                        ExceptionRules = $exceptions
                        RetentionPeriod = $rec.AuditPolicy.RetentionPeriod
                        RetentionPeriod_IsAnException = $rec.AuditPolicy.IsAnException
                        RequireDualControlPasswordAccessApproval_IsActive = $rec.PrivilegedAccessWorkflows.RequireDualControlPasswordAccessApproval.IsActive
                        RequireDualControlPasswordAccessApproval_IsAnException = $rec.PrivilegedAccessWorkflows.RequireDualControlPasswordAccessApproval.IsAnException
                        EnforceCheckinCheckoutExclusiveAccess_IsActive = $rec.PrivilegedAccessWorkflows.EnforceCheckinCheckoutExclusiveAccess.IsActive
                        EnforceCheckinCheckoutExclusiveAccess_IsAnException = $rec.PrivilegedAccessWorkflows.EnforceCheckinCheckoutExclusiveAccess.IsAnException
                        EnforceOnetimePasswordAccess_IsActive = $rec.PrivilegedAccessWorkflows.EnforceOnetimePasswordAccess.IsActive
                        EnforceOnetimePasswordAccess_IsAnException = $rec.PrivilegedAccessWorkflows.EnforceOnetimePasswordAccess.IsAnException
                        RequireUsersToSpecifyReasonForAccess_IsActive = $rec.PrivilegedAccessWorkflows.RequireUsersToSpecifyReasonForAccess.IsActive
                        RequireUsersToSpecifyReasonForAccess_IsAnException = $rec.PrivilegedAccessWorkflows.RequireUsersToSpecifyReasonForAccess.IsAnException
                        PSMServerId = $rec.PrivilegedSessionManagement.PSMServerId
                        PSMServerName = $rec.PrivilegedSessionManagement.PSMServerName
                        Monitoring = $rec.SessionManagementPolicy.Monitoring
                        RecordAndSave = $rec.SessionManagementPolicy.RecordAndSave
                        MonitoringDetails_IsAnException = $rec.SessionManagementPolicy.MonitoringDetails.IsAnException
                        RecordAndSaveDetails_IsAnException = $rec.SessionManagementPolicy.RecordAndSaveDetails.IsAnException
                        Verification_PerformAutomatic = $rec.CredentialsManagementPolicy.Verification.PerformAutomatic
                        Verification_RequirePasswordEveryXDays = $rec.CredentialsManagementPolicy.Verification.RequirePasswordEveryXDays
                        Verification_AutoOnAdd = $rec.CredentialsManagementPolicy.Verification.AutoOnAdd
                        Verification_IsAnException = $rec.CredentialsManagementPolicy.Verification.IsAnException
                        Verification_AllowManual = $rec.CredentialsManagementPolicy.Verification.AllowManual
                        Change_PerformAutomatic = $rec.CredentialsManagementPolicy.Change.PerformAutomatic
                        Change_RequirePasswordEveryXDays = $rec.CredentialsManagementPolicy.Change.RequirePasswordEveryXDays
                        Change_AutoOnAdd = $rec.CredentialsManagementPolicy.Change.AutoOnAdd
                        Change_IsAnException = $rec.CredentialsManagementPolicy.Change.IsAnException
                        Change_AllowManual = $rec.CredentialsManagementPolicy.Change.AllowManual
                        Reconcile_AutomaticReconcileWhenUnsynced = $rec.CredentialsManagementPolicy.Reconcile.AutomaticReconcileWhenUnsynced
                        Reconcile_AllowManual = $rec.CredentialsManagementPolicy.Reconcile.AllowManual
                        ChangePasswordInResetMode = $rec.CredentialsManagementPolicy.SecretUpdateConfiguration.ChangePasswordInResetMode

                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASEmptyPlatforms"){
                $AllProps = @()
                foreach($rec in $Data.value){
                    $props = $rec.psobject.Properties.name
                    foreach($prop in $props){
                        if($AllProps -notcontains $prop){
                            $AllProps += $prop
                        }
                    }
                }
                foreach($rec in $Data.value){
                    $minihash = @{}
                    foreach($prop in $AllProps){
                        $minihash += @{
                            $prop = $rec.$prop
                        }
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASGroupPlatformDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Active = $rec.Active
                        ID = $rec.ID
                        PlatformID = $rec.PlatformID
                        Name = $rec.Name
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllGroupPlatforms"){
                foreach($rec in $Data.Platforms){
                    $minihash = [ordered]@{
                        Active = $rec.Active
                        ID = $rec.ID
                        PlatformID = $rec.PlatformID
                        Name = $rec.Name
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASStoredPlatformDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        StoredID = $rec.StoredPlatformDetails.Id
                        StoredBaseID = $rec.StoredPlatformDetails.BaseId
                        StoredName = $rec.StoredPlatformDetails.Name
                        StoredVersion = $rec.StoredPlatformDetails.Version
                        ConflictedID = $rec.ConflictedPlatformsDetails.Id
                        ConflictedBaseID = $rec.ConflictedPlatformsDetails.BaseId
                        ConflictedName = $rec.ConflictedPlatformsDetails.Name
                        ConflictedVersion = $rec.ConflictedPlatformsDetails.Version
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASMasterPolicySettings"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        DualControl = $rec.DualControl.Value
                        MultiLevelApproval = $rec.MultiLevelApproval.Value
                        OnlyManagersApproval = $rec.OnlyManagersApproval.Value
                        ConfirmersNumber = $rec.ConfirmersNumber.Value
                        EnforceExclusiveAccess = $rec.EnforceExclusiveAccess.Value
                        EnforceOneTimePassword = $rec.EnforceOneTimePassword.Value
                        TransparentConnection = $rec.TransparentConnection.Value
                        AllowViewPassword = $rec.AllowViewPassword.Value
                        RequireReason = $rec.RequireReason.Value
                        AllowFreeText = $rec.AllowFreeText.Value
                        PasswordChangeDays = $rec.PasswordChangeDays.Value
                        PasswordVerificationDays = $rec.PasswordVerificationDays.Value
                        RequireMonitoringAndIsolation = $rec.RequireMonitoringAndIsolation.Value
                        RecordActivity = $rec.RecordActivity.Value
                        RetentionPeriod = $rec.RetentionPeriod.Value
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllMasterPolicySettings"){
                foreach($rec in $Data.value.Keys){
                    $minihash = [ordered]@{
                        PlatformID = $rec
                        DualControl = $Data.value.$rec.DualControl.Value
                        MultiLevelApproval = $Data.value.$rec.MultiLevelApproval.Value
                        OnlyManagersApproval = $Data.value.$rec.OnlyManagersApproval.Value
                        ConfirmersNumber = $Data.value.$rec.ConfirmersNumber.Value
                        EnforceExclusiveAccess = $Data.value.$rec.EnforceExclusiveAccess.Value
                        EnforceOneTimePassword = $Data.value.$rec.EnforceOneTimePassword.Value
                        TransparentConnection = $Data.value.$rec.TransparentConnection.Value
                        AllowViewPassword = $Data.value.$rec.AllowViewPassword.Value
                        RequireReason = $Data.value.$rec.RequireReason.Value
                        AllowFreeText = $Data.value.$rec.AllowFreeText.Value
                        PasswordChangeDays = $Data.value.$rec.PasswordChangeDays.Value
                        PasswordVerificationDays = $Data.value.$rec.PasswordVerificationDays.Value
                        RequireMonitoringAndIsolation = $Data.value.$rec.RequireMonitoringAndIsolation.Value
                        RecordActivity = $Data.value.$rec.RecordActivity.Value
                        RetentionPeriod = $Data.value.$rec.RetentionPeriod.Value
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPlatformRotationPolicy"){
                foreach($rec in $Data){
                    $changeDays = ""
                    $verifyDays = ""
                    $reconDays = ""
                    foreach($day in $rec.change.timeframe.days){
                        $changeDays += "$day;"
                    }
                    foreach($day in $rec.verify.timeframe.days){
                        $verifyDays += "$day;"
                    }
                    foreach($day in $rec.reconcile.timeframe.days){
                        $reconDays += "$day;"
                    }

                    $minihash = [ordered]@{
                        createdAt = $rec.createdAt
                        updatedAt = $rec.updatedAt
                        createdBy = $rec.createdBy
                        updatedBy = $rec.updatedBy
                        platformId = $rec.platformId
                        platformBaseId = $rec.platformBaseId
                        timezone = $rec.timezone
                        maxRetries = $rec.maxRetries
                        minDelayBetweenRetries = $rec.minDelayBetweenRetries
                        resetOveridesTimeframe = $rec.resetOveridesTimeframe
                        platformState = $rec.platformState
                        platformType = $rec.platformType
                        allowedManualChange = $rec.change.allowedManual
                        specificTimeframeChange = $rec.change.timeframe.specificTimeframe
                        daysChange = $changeDays
                        fromTimeChange = $rec.change.timeframe.fromTime
                        toTimeChange = $rec.change.timeframe.toTime
                        allowedPeriodicChange = $rec.change.allowedPeriodic
                        intervalChange = $rec.change.interval
                        headstartIntervalChange = $rec.change.headstartInterval
                        autoOnAddChange = $rec.change.autoOnAdd
                        overridesMasterPolicyChange = $rec.change.overridesMasterPolicy
                        enforcePasswordPolicyOnManualChange = $rec.change.enforcePasswordPolicyOnManualChange
                        allowedManualVerify = $rec.verify.allowedManual
                        specificTimeframeVerify = $rec.verify.timeframe.specificTimeframe
                        daysVerify = $verifyDays
                        fromTimeVerify = $rec.verify.timeframe.fromTime
                        toTimeVerify = $rec.verify.timeframe.toTime
                        allowedPeriodicVerify = $rec.verify.allowedPeriodic
                        intervalVerify = $rec.verify.interval
                        autoOnAddVerify = $rec.verify.autoOnAdd
                        overridesMasterPolicyVerify = $rec.verify.overridesMasterPolicy
                        allowedManualReconcile = $rec.reconcile.allowedManual
                        specificTimeframeReconcile = $rec.reconcile.timeframe.specificTimeframe
                        daysReconcile = $reconDays
                        fromTimeReconcile = $rec.reconcile.timeframe.fromTime
                        toTimeReconcile = $rec.reconcile.timeframe.toTime
                        autoReconcileWhenUnsynched = $rec.reconcile.autoReconcileWhenUnsynched
                    }

                    foreach($acct in $rec.linkedAccounts.psobject.Properties.name){
                        if($acct -ne "custom"){
                            $key1 = "$acct" + "Safe"
                            $val1 = $rec.linkedAccounts.$acct.safe
                            $minihash += @{ $key1 = $val1 }

                            $key2 = "$acct" + "Name"
                            $val2 = $rec.linkedAccounts.$acct.name
                            $minihash += @{ $key2 = $val2 }

                            $key3 = "$acct" + "Index"
                            $val3 = $rec.linkedAccounts.$acct.index
                            $minihash += @{ $key3 = $val3 }

                            $key4 = "$acct" + "Label"
                            $val4 = $rec.linkedAccounts.$acct.label
                            $minihash += @{ $key4 = $val4 }
                        }
                        else{
                            $customAccts = ""
                            foreach($customacct in $rec.linkedAccounts.custom){
                                $customAccts += "("
                                $key1 = "$acct" + "Safe"
                                $val1 = $rec.linkedAccounts.$acct.safe
                                $customAccts += "$key1=$val1|"

                                $key2 = "$acct" + "Name"
                                $val2 = $rec.linkedAccounts.$acct.name
                                $customAccts += "$key2=$val2|"

                                $key3 = "$acct" + "Index"
                                $val3 = $rec.linkedAccounts.$acct.index
                                $customAccts += "$key3=$val3|"

                                $key4 = "$acct" + "Label"
                                $val4 = $rec.linkedAccounts.$acct.label
                                $customAccts += "$key4=$val4"

                                $customAccts += ");"
                            }
                            $minihash += @{ CustomLinkedAccounts = $customAccts }
                        }
                    }

                    $minihash += @{
                        origin = $rec.origin
                        allowedSafes = $rec.allowedSafes
                        enableDownloadRotationLogs = $rec.enableDownloadRotationLogs
                        enableRotationNoticePeriod = $rec.enableRotationNoticePeriod
                        rotationNoticePeriod = $rec.rotationNoticePeriod
                    }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPlatformSecretPolicy"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        managementType = $rec.managementType
                        passwordLen = $rec.passwordGenRules.passwordLen
                        minUppercase = $rec.passwordGenRules.minUppercase
                        minLowercase = $rec.passwordGenRules.minLowercase
                        minDigit = $rec.passwordGenRules.minDigit
                        minSpecial = $rec.passwordGenRules.minSpecial
                        preventRepeatingChars = $rec.passwordGenRules.preventRepeatingChars
                        blockReusePassword = $rec.passwordGenRules.blockReusePassword
                        forbiddenChars = $rec.passwordGenRules.forbiddenChars
                        privateKeyFormat = $rec.sshKeysRules.privateKeyFormat
                        encryptionType = $rec.sshKeysRules.encryptionType
                        keyGenerationTimeout = $rec.sshKeysRules.keyGenerationTimeout
                        publicSshKeyPath = $rec.sshKeysRules.publicSshKeyPath
                        accessKeysRules = $rec.accessKeysRules
                        passwordReusedLimit = $rec.passwordReusedLimit
                        createdAt = $rec.createdAt
                        updatedAt = $rec.updatedAt
                        createdBy = $rec.createdBy
                        updatedBy = $rec.updatedBy
                        platformId = $rec.platformId
                        platformBaseId = $rec.platformBaseId
                        platformType = $rec.platformType
                        origin = $rec.origin
                    }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllPlatformPlugins"){
                foreach($rec in $Data.results){
                    $minihash = [ordered]@{
                        dateAdded = $rec.dateAdded
                        connectorManagementFolder = $rec.connectorManagementFolder
                        name = $rec.name
                        version = $rec.version
                        isOutOfTheBox = $rec.isOutOfTheBox
                        id = $rec.id
                    }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPlatformPluginSettings"){
                foreach($rec in $Data){
                    $UnrecoverableErrors = ""
                    foreach($err in $rec.params.general.UnrecoverableErrors){
                        $UnrecoverableErrors += "$err;"
                    }

                    $RCReconcileReasons = ""
                    foreach($err in $rec.params.general.RCReconcileReasons){
                        $RCReconcileReasons += "$err;"
                    }

                    $minihash = [ordered]@{}
                    foreach($prop in $rec.params.general.psobject.Properties.name){
                        if($prop -eq "UnrecoverableErrors"){
                            $minihash += @{ UnrecoverableErrors = $UnrecoverableErrors }
                        }
                        elseif($prop -eq "RCReconcileReasons"){
                            $minihash += @{ RCReconcileReasons = $RCReconcileReasons }
                        }
                        else{
                            $minihash += @{
                                $prop = $rec.params.general.$prop
                            }
                        }
                    }
                    foreach($prop in $rec.params.pluginSpecificList){
                        $propkey = $prop.name
                        $propval = $prop.value
                        $minihash += @{ "PluginSpecificProperty_$propkey" = $propval }
                    }
                    foreach($prop in $rec.params.custom){
                        $propkey = $prop.name
                        $propval = $prop.value
                        $minihash += @{ "CustomProperty_$propkey" = $propval }
                    }

                    $minihash += @{
                        name = $rec.params.name
                        version = $rec.params.version
                        isMigratedUnmappedPlugin = $rec.params.isMigratedUnmappedPlugin
                        migratedUnmappedPluginsComponentName = $rec.params.migratedUnmappedPluginsComponentName
                        migratedUnmappedPluginsComponentVersion = $rec.params.migratedUnmappedPluginsComponentVersion
                        isMigratedOriginalBin = $rec.params.isMigratedOriginalBin
                        migratedOriginalBinComponentName = $rec.params.migratedOriginalBinComponentName
                        migratedOriginalBinComponentVersion = $rec.params.migratedOriginalBinComponentVersion
                        tempPackage = $rec.params.tempPackage
                        frameworkName = $rec.params.frameworkName
                        frameworkVersion = $rec.params.frameworkVersion
                        autoInstallMsAddons = $rec.params.autoInstallMsAddons
                        dateAdded = $rec.pluginInfo.dateAdded
                        connectorManagementFolder = $rec.pluginInfo.connectorManagementFolder
                        isOutOfTheBox = $rec.pluginInfo.isOutOfTheBox
                        id = $rec.pluginInfo.id
                        platformBaseType = $rec.platformBaseType
                        createdAt = $rec.createdAt
                        updatedAt = $rec.updatedAt
                        createdBy = $rec.createdBy
                        updatedBy = $rec.updatedBy
                        platformId = $rec.platformId
                        platformBaseId = $rec.platformBaseId
                        platformType = $rec.platformType
                        origin = $rec.origin
                    }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPlatformWorkflowPolicy"){
                foreach($rec in $Data){
                    $minihash += @{
                        minValidityPeriod = $rec.minValidityPeriod
                        doNotExtendMinValidityPeriod = $rec.doNotExtendMinValidityPeriod
                        unlockIfFail = $rec.unlockIfFail
                    }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion PlatformCommands
            #region ApplicationCommands
            if($CommandName -eq "Get-VPASApplicationAuthentications"){
                foreach($rec in $Data.authentication){
                    $minihash = [ordered]@{
                        AllowInternalScripts = $rec.AllowInternalScripts
                        AppID = $rec.AppID
                        AuthType = $rec.AuthType
                        AuthValue = $rec.AuthValue
                        Comment = $rec.Comment
                        IsFolder = $rec.IsFolder
                        authID = $rec.authID
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASApplicationDetails"){
                foreach($rec in $Data.application){
                    $minihash = [ordered]@{
                        AccessPermittedFrom = $rec.AccessPermittedFrom
                        AccessPermittedTo = $rec.AccessPermittedTo
                        AllowExtendedAuthenticationRestrictions = $rec.AllowExtendedAuthenticationRestrictions
                        AppID = $rec.AppID
                        BusinessOwnerEmail = $rec.BusinessOwnerEmail
                        BusinessOwnerFName = $rec.BusinessOwnerFName
                        BusinessOwnerLName = $rec.BusinessOwnerLName
                        BusinessOwnerPhone = $rec.BusinessOwnerPhone
                        Description = $rec.Description
                        Disabled = $rec.Disabled
                        ExpirationDate = $rec.ExpirationDate
                        Location = $rec.Location
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllApplications"){
                foreach($rec in $Data.application){
                    $minihash = [ordered]@{
                        AccessPermittedFrom = $rec.AccessPermittedFrom
                        AccessPermittedTo = $rec.AccessPermittedTo
                        AllowExtendedAuthenticationRestrictions = $rec.AllowExtendedAuthenticationRestrictions
                        AppID = $rec.AppID
                        BusinessOwnerEmail = $rec.BusinessOwnerEmail
                        BusinessOwnerFName = $rec.BusinessOwnerFName
                        BusinessOwnerLName = $rec.BusinessOwnerLName
                        BusinessOwnerPhone = $rec.BusinessOwnerPhone
                        Description = $rec.Description
                        Disabled = $rec.Disabled
                        ExpirationDate = $rec.ExpirationDate
                        Location = $rec.Location
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion ApplicationCommands
            #region IdentityCommands
            if($CommandName -eq "Get-VPASIdentityAdminSecurityQuestion"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Uuid = $rec.Uuid
                        Culture = $rec.Culture
                        Question = $rec.Question
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityAllAdminSecurityQuestions"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Uuid = $rec.Uuid
                        Culture = $rec.Culture
                        Question = $rec.Question
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityAllRoles"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        _TableName = $rec._TableName
                        Name = $rec.Name
                        ID = $rec.ID
                        OrgPath = $rec.OrgPath
                        Description = $rec.Description
                        IsHidden = $rec.IsHidden
                        RoleType = $rec.RoleType
                        OrgId = $rec.OrgId
                        ReadOnly = $rec.ReadOnly
                        DirectoryServiceUuid = $rec.DirectoryServiceUuid
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityAllUsers"){
                foreach($rec in $Data.Row){
                    $minihash = [ordered]@{
                        Uuid = $rec.Uuid
                        DisplayName = $rec.DisplayName
                        Name = $rec.Name
                        Mail = $rec.Mail
                        ReportsTo = $rec.ReportsTo
                        PreferredCulture = $rec.PreferredCulture
                        HomeNumber = $rec.HomeNumber
                        StartDate = $rec.StartDate
                        MobileNumber = $rec.MobileNumber
                        EndDate = $rec.EndDate
                        PictureUri = $rec.PictureUri
                        Description = $rec.Description
                        OfficeNumber = $rec.OfficeNumber
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityCurrentUserDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        User = $rec.User
                        UserUuid = $rec.UserUuid
                        TenantId = $rec.TenantId
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityCurrentUserSecurityQuestions"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        AnswerMinLength = $rec.AnswerMinLength
                        MaxQuestions = $rec.MaxQuestions
                        MinAdminQuestions = $rec.MinAdminQuestions
                        MinUserQuestions = $rec.MinUserQuestions
                    }

                    foreach($question in $rec.AdminQuestions){
                        $minihash2 = @{
                            QuestionType = "AdminQuestion"
                            Uuid = $question.Uuid
                            Culture = $question.Culture
                            Question = $question.Question
                        }
                        $minihash2 += $minihash
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }

                    foreach($question in $rec.Questions){
                        $minihash2 = @{
                            QuestionType = "UserQuestion"
                            Uuid = $question.Uuid
                            Question = $question.QuestionText
                            Culture = ""
                        }
                        $minihash2 += $minihash
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                }
                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityRoleDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        _TableName = $rec._TableName
                        Name = $rec.Name
                        ID = $rec.ID
                        OrgPath = $rec.OrgPath
                        Description = $rec.Description
                        IsHidden = $rec.IsHidden
                        RoleType = $rec.RoleType
                        OrgId = $rec.OrgId
                        ReadOnly = $rec.ReadOnly
                        DirectoryServiceUuid = $rec.DirectoryServiceUuid
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityRoles"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        _TableName = $rec._TableName
                        Name = $rec.Name
                        ID = $rec.ID
                        OrgPath = $rec.OrgPath
                        Description = $rec.Description
                        IsHidden = $rec.IsHidden
                        RoleType = $rec.RoleType
                        OrgId = $rec.OrgId
                        ReadOnly = $rec.ReadOnly
                        DirectoryServiceUuid = $rec.DirectoryServiceUuid
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityTenantDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Version = $rec.Version
                        PodRegion = $rec.PodRegion
                        PodFqdn = $rec.PodFqdn
                        PodName = $rec.PodName
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityUserDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Uuid = $rec.Uuid
                        State = $rec.State
                        LastModifiedDate = $rec.LastModifiedDate
                        DisplayName = $rec.DisplayName
                        Version = $rec.Version
                        Mail = $rec.Mail
                        Name = $rec.Name
                        ReportsTo = $rec.ReportsTo
                        CreateDate = $rec.CreateDate
                        HomeNumber = $rec.HomeNumber
                        LockedByAdmin = $rec.LockedByAdmin
                        MobileNumber = $rec.MobileNumber
                        Alias = $rec.Alias
                        OfficeNumber = $rec.OfficeNumber
                        InEverybodyRole = $rec.InEverybodyRole
                        LastPasswordChangeDate = $rec.LastPasswordChangeDate
                        OauthClient = $rec.OauthClient
                        PasswordNeverExpire = $rec.PasswordNeverExpire
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityUserSecurityQuestions"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        AnswerMinLength = $rec.AnswerMinLength
                        MaxQuestions = $rec.MaxQuestions
                        MinAdminQuestions = $rec.MinAdminQuestions
                        MinUserQuestions = $rec.MinUserQuestions
                    }

                    foreach($question in $rec.AdminQuestions){
                        $minihash2 = @{
                            QuestionType = "AdminQuestion"
                            Uuid = $question.Uuid
                            Culture = $question.Culture
                            Question = $question.Question
                        }
                        $minihash2 += $minihash
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }

                    foreach($question in $rec.Questions){
                        $minihash2 = @{
                            QuestionType = "UserQuestion"
                            Uuid = $question.Uuid
                            Question = $question.QuestionText
                            Culture = ""
                        }
                        $minihash2 += $minihash
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                }
                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityAllApplicationTemplates"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Type = $rec.Entities.Type
                        Key = $rec.Entities.Key
                        IsForeignKey = $rec.Entities.IsForeignKey
                        ProvSettingsIsEnterpriseScimUser = $rec.Row.ProvSettingsIsEnterpriseScimUser
                        Featured = $rec.Row.Featured
                        ProvSettingPreview = $rec.Row.ProvSettingPreview
                        Name = $rec.Row.Name
                        Category = $rec.Row.Category
                        OrgId = $rec.Row.OrgId
                        MobileAppType = $rec.Row.MobileAppType
                        DirectoryId = $rec.Row.DirectoryId
                        ProvSettingsValidateEmailAttribute = $rec.Row.ProvSettingsValidateEmailAttribute
                        DisplayName = $rec.Row.DisplayName
                        AppTypeDisplayName = $rec.Row.AppTypeDisplayName
                        OnPrem = $rec.Row.OnPrem
                        OrgPath = $rec.Row.OrgPath
                        ID = $rec.Row.ID
                        ShadowAppLink = $rec.Row.ShadowAppLink
                        IsSwsEnabled = $rec.Row.IsSwsEnabled
                        ChildLinkedApps = $rec.Row.ChildLinkedApps
                        MunkiMetadata = $rec.Row.MunkiMetadata
                        AdminTag = $rec.Row.AdminTag
                        UserNameStrategy = $rec.Row.UserNameStrategy
                        Description = $rec.Row.Description
                        SkipSwsForAwsCli = $rec.Row.SkipSwsForAwsCli
                        ParentAppTemplateName = $rec.Row.ParentAppTemplateName
                        ProvConfigured = $rec.Row.ProvConfigured
                        Version = $rec.Row.Version
                        IsGatewayed = $rec.Row.IsGatewayed
                        Generic = $rec.Row.Generic
                        CatalogVisibility = $rec.Row.CatalogVisibility
                        CorpIdentifier = $rec.Row.CorpIdentifier
                        MobileAppSource = $rec.Row.MobileAppSource
                        Brand = $rec.Row.Brand
                        LastUsedPodUrl = $rec.Row.LastUsedPodUrl
                        IsBuiltInApp = $rec.Row.IsBuiltInApp
                        WebAppLoginType = $rec.Row.WebAppLoginType
                        AppType = $rec.Row.AppType
                        AuthChallengeDefinitionFlowId = $rec.Row.AuthChallengeDefinitionFlowId
                        ServiceName = $rec.Row.ServiceName
                        LastUsedCentrifyUrl = $rec.Row.LastUsedCentrifyUrl
                        PortalApp = $rec.Row.PortalApp
                        ParentApp = $rec.Row.ParentApp
                        DeepLinkUrl = $rec.Row.DeepLinkUrl
                        Icon = $rec.Row.Icon
                        WebAppTypeDisplayName = $rec.Row.WebAppTypeDisplayName
                        PolicyScript = $rec.Row.PolicyScript
                        WorkflowEnabled = $rec.Row.WorkflowEnabled
                        BypassLoginMFA = $rec.Row.BypassLoginMFA
                        CertBasedAuthEnabled = $rec.Row.CertBasedAuthEnabled
                        IsTestApp = $rec.Row.IsTestApp
                        WebAppType = $rec.Row.WebAppType
                        ProvSettingEnabled = $rec.Row.ProvSettingEnabled
                        TableName = $rec.Row._TableName
                        TemplateName = $rec.Row.TemplateName
                        Notes = $rec.Row.Notes
                        IsIdentityAsIdpEnabled = $rec.Row.IsIdentityAsIdpEnabled
                        AuthChallengeDefinitionId = $rec.Row.AuthChallengeDefinitionId
                        IsMarketplaceApp = $rec.Row.IsMarketplaceApp
                        WebUPAppType = $rec.Row.WebUPAppType
                        Handler = $rec.Row.Handler
                        State = $rec.Row.State
                        NotSelfService = $rec.Row.NotSelfService
                        IsScaEnabled = $rec.Row.IsScaEnabled
                        DerivedCredsSupported = $rec.Row.DerivedCredsSupported
                        VersionName = $rec.Row.VersionName
                        Popular = $rec.Row.Popular
                        ProvCapable = $rec.Row.ProvCapable
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityApplicationTemplates"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Type = $rec.Entities.Type
                        Key = $rec.Entities.Key
                        IsForeignKey = $rec.Entities.IsForeignKey
                        ProvSettingsIsEnterpriseScimUser = $rec.Row.ProvSettingsIsEnterpriseScimUser
                        Featured = $rec.Row.Featured
                        ProvSettingPreview = $rec.Row.ProvSettingPreview
                        Name = $rec.Row.Name
                        Category = $rec.Row.Category
                        OrgId = $rec.Row.OrgId
                        MobileAppType = $rec.Row.MobileAppType
                        DirectoryId = $rec.Row.DirectoryId
                        ProvSettingsValidateEmailAttribute = $rec.Row.ProvSettingsValidateEmailAttribute
                        DisplayName = $rec.Row.DisplayName
                        AppTypeDisplayName = $rec.Row.AppTypeDisplayName
                        OnPrem = $rec.Row.OnPrem
                        OrgPath = $rec.Row.OrgPath
                        ID = $rec.Row.ID
                        ShadowAppLink = $rec.Row.ShadowAppLink
                        IsSwsEnabled = $rec.Row.IsSwsEnabled
                        ChildLinkedApps = $rec.Row.ChildLinkedApps
                        MunkiMetadata = $rec.Row.MunkiMetadata
                        AdminTag = $rec.Row.AdminTag
                        UserNameStrategy = $rec.Row.UserNameStrategy
                        Description = $rec.Row.Description
                        SkipSwsForAwsCli = $rec.Row.SkipSwsForAwsCli
                        ParentAppTemplateName = $rec.Row.ParentAppTemplateName
                        ProvConfigured = $rec.Row.ProvConfigured
                        Version = $rec.Row.Version
                        IsGatewayed = $rec.Row.IsGatewayed
                        Generic = $rec.Row.Generic
                        CatalogVisibility = $rec.Row.CatalogVisibility
                        CorpIdentifier = $rec.Row.CorpIdentifier
                        MobileAppSource = $rec.Row.MobileAppSource
                        Brand = $rec.Row.Brand
                        LastUsedPodUrl = $rec.Row.LastUsedPodUrl
                        IsBuiltInApp = $rec.Row.IsBuiltInApp
                        WebAppLoginType = $rec.Row.WebAppLoginType
                        AppType = $rec.Row.AppType
                        AuthChallengeDefinitionFlowId = $rec.Row.AuthChallengeDefinitionFlowId
                        ServiceName = $rec.Row.ServiceName
                        LastUsedCentrifyUrl = $rec.Row.LastUsedCentrifyUrl
                        PortalApp = $rec.Row.PortalApp
                        ParentApp = $rec.Row.ParentApp
                        DeepLinkUrl = $rec.Row.DeepLinkUrl
                        Icon = $rec.Row.Icon
                        WebAppTypeDisplayName = $rec.Row.WebAppTypeDisplayName
                        PolicyScript = $rec.Row.PolicyScript
                        WorkflowEnabled = $rec.Row.WorkflowEnabled
                        BypassLoginMFA = $rec.Row.BypassLoginMFA
                        CertBasedAuthEnabled = $rec.Row.CertBasedAuthEnabled
                        IsTestApp = $rec.Row.IsTestApp
                        WebAppType = $rec.Row.WebAppType
                        ProvSettingEnabled = $rec.Row.ProvSettingEnabled
                        TableName = $rec.Row._TableName
                        TemplateName = $rec.Row.TemplateName
                        Notes = $rec.Row.Notes
                        IsIdentityAsIdpEnabled = $rec.Row.IsIdentityAsIdpEnabled
                        AuthChallengeDefinitionId = $rec.Row.AuthChallengeDefinitionId
                        IsMarketplaceApp = $rec.Row.IsMarketplaceApp
                        WebUPAppType = $rec.Row.WebUPAppType
                        Handler = $rec.Row.Handler
                        State = $rec.Row.State
                        NotSelfService = $rec.Row.NotSelfService
                        IsScaEnabled = $rec.Row.IsScaEnabled
                        DerivedCredsSupported = $rec.Row.DerivedCredsSupported
                        VersionName = $rec.Row.VersionName
                        Popular = $rec.Row.Popular
                        ProvCapable = $rec.Row.ProvCapable
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityApplicationDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        ProvSettingsIsEnterpriseScimUser = $rec.ProvSettingsIsEnterpriseScimUser
                        Featured = $rec.Featured
                        ProvSettingPreview = $rec.ProvSettingPreview
                        Name = $rec.Name
                        Category = $rec.Category
                        OrgId = $rec.OrgId
                        MobileAppType = $rec.MobileAppType
                        DirectoryId = $rec.DirectoryId
                        ProvSettingsValidateEmailAttribute = $rec.ProvSettingsValidateEmailAttribute
                        DisplayName = $rec.DisplayName
                        AppTypeDisplayName = $rec.AppTypeDisplayName
                        OnPrem = $rec.OnPrem
                        OrgPath = $rec.OrgPath
                        ID = $rec.ID
                        ShadowAppLink = $rec.ShadowAppLink
                        IsSwsEnabled = $rec.IsSwsEnabled
                        ChildLinkedApps = $rec.ChildLinkedApps
                        MunkiMetadata = $rec.MunkiMetadata
                        AdminTag = $rec.AdminTag
                        UserNameStrategy = $rec.UserNameStrategy
                        Description = $rec.Description
                        SkipSwsForAwsCli = $rec.SkipSwsForAwsCli
                        ParentAppTemplateName = $rec.ParentAppTemplateName
                        ProvConfigured = $rec.ProvConfigured
                        Version = $rec.Version
                        IsGatewayed = $rec.IsGatewayed
                        CatalogVisibility = $rec.CatalogVisibility
                        Generic = $rec.Generic
                        CorpIdentifier = $rec.CorpIdentifier
                        MobileAppSource = $rec.MobileAppSource
                        Brand = $rec.Brand
                        LastUsedPodUrl = $rec.LastUsedPodUrl
                        IsBuiltInApp = $rec.IsBuiltInApp
                        WebAppLoginType = $rec.WebAppLoginType
                        AppType = $rec.AppType
                        AuthChallengeDefinitionFlowId = $rec.AuthChallengeDefinitionFlowId
                        ServiceName = $rec.ServiceName
                        LastUsedCentrifyUrl = $rec.LastUsedCentrifyUrl
                        PortalApp = $rec.PortalApp
                        ParentApp = $rec.ParentApp
                        DeepLinkUrl = $rec.DeepLinkUrl
                        Icon = $rec.icon
                        WebAppTypeDisplayName = $rec.WebAppTypeDisplayName
                        PolicyScript = $rec.PolicyScript
                        WorkflowEnabled = $rec.WorkflowEnabled
                        BypassLoginMFA = $rec.BypassLoginMFA
                        CertBasedAuthEnabled = $rec.CertBasedAuthEnabled
                        IsTestApp = $rec.IsTestApp
                        WebAppType = $rec.WebAppType
                        ProvSettingEnabled = $rec.ProvSettingEnabled
                        _TableName = $rec._TableName
                        TemplateName = $rec.TemplateName
                        Notes = $rec.Notes
                        IsIdentityAsIdpEnabled = $rec.IsIdentityAsIdpEnabled
                        AuthChallengeDefinitionId = $rec.AuthChallengeDefinitionId
                        IsMarketplaceApp = $rec.IsMarketplaceApp
                        WebUPAppType = $rec.WebUPAppType
                        Handler = $rec.Handler
                        State = $rec.State
                        NotSelfService = $rec.NotSelfService
                        IsScaEnabled = $rec.IsScaEnabled
                        DerivedCredsSupported = $rec.DerivedCredsSupported
                        VersionName = $rec.VersionName
                        Popular = $rec.Popular
                        ProvCapable = $rec.ProvCapable

                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityAllApplications"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        ProvSettingsIsEnterpriseScimUser = $rec.ProvSettingsIsEnterpriseScimUser
                        Featured = $rec.Featured
                        ProvSettingPreview = $rec.ProvSettingPreview
                        Name = $rec.Name
                        Category = $rec.Category
                        OrgId = $rec.OrgId
                        MobileAppType = $rec.MobileAppType
                        DirectoryId = $rec.DirectoryId
                        ProvSettingsValidateEmailAttribute = $rec.ProvSettingsValidateEmailAttribute
                        DisplayName = $rec.DisplayName
                        AppTypeDisplayName = $rec.AppTypeDisplayName
                        OnPrem = $rec.OnPrem
                        OrgPath = $rec.OrgPath
                        ID = $rec.ID
                        ShadowAppLink = $rec.ShadowAppLink
                        IsSwsEnabled = $rec.IsSwsEnabled
                        ChildLinkedApps = $rec.ChildLinkedApps
                        MunkiMetadata = $rec.MunkiMetadata
                        AdminTag = $rec.AdminTag
                        UserNameStrategy = $rec.UserNameStrategy
                        Description = $rec.Description
                        SkipSwsForAwsCli = $rec.SkipSwsForAwsCli
                        ParentAppTemplateName = $rec.ParentAppTemplateName
                        ProvConfigured = $rec.ProvConfigured
                        Version = $rec.Version
                        IsGatewayed = $rec.IsGatewayed
                        CatalogVisibility = $rec.CatalogVisibility
                        Generic = $rec.Generic
                        CorpIdentifier = $rec.CorpIdentifier
                        MobileAppSource = $rec.MobileAppSource
                        Brand = $rec.Brand
                        LastUsedPodUrl = $rec.LastUsedPodUrl
                        IsBuiltInApp = $rec.IsBuiltInApp
                        WebAppLoginType = $rec.WebAppLoginType
                        AppType = $rec.AppType
                        AuthChallengeDefinitionFlowId = $rec.AuthChallengeDefinitionFlowId
                        ServiceName = $rec.ServiceName
                        LastUsedCentrifyUrl = $rec.LastUsedCentrifyUrl
                        PortalApp = $rec.PortalApp
                        ParentApp = $rec.ParentApp
                        DeepLinkUrl = $rec.DeepLinkUrl
                        Icon = $rec.icon
                        WebAppTypeDisplayName = $rec.WebAppTypeDisplayName
                        PolicyScript = $rec.PolicyScript
                        WorkflowEnabled = $rec.WorkflowEnabled
                        BypassLoginMFA = $rec.BypassLoginMFA
                        CertBasedAuthEnabled = $rec.CertBasedAuthEnabled
                        IsTestApp = $rec.IsTestApp
                        WebAppType = $rec.WebAppType
                        ProvSettingEnabled = $rec.ProvSettingEnabled
                        _TableName = $rec._TableName
                        TemplateName = $rec.TemplateName
                        Notes = $rec.Notes
                        IsIdentityAsIdpEnabled = $rec.IsIdentityAsIdpEnabled
                        AuthChallengeDefinitionId = $rec.AuthChallengeDefinitionId
                        IsMarketplaceApp = $rec.IsMarketplaceApp
                        WebUPAppType = $rec.WebUPAppType
                        Handler = $rec.Handler
                        State = $rec.State
                        NotSelfService = $rec.NotSelfService
                        IsScaEnabled = $rec.IsScaEnabled
                        DerivedCredsSupported = $rec.DerivedCredsSupported
                        VersionName = $rec.VersionName
                        Popular = $rec.Popular
                        ProvCapable = $rec.ProvCapable

                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityApplications"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        ProvSettingsIsEnterpriseScimUser = $rec.ProvSettingsIsEnterpriseScimUser
                        Featured = $rec.Featured
                        ProvSettingPreview = $rec.ProvSettingPreview
                        Name = $rec.Name
                        Category = $rec.Category
                        OrgId = $rec.OrgId
                        MobileAppType = $rec.MobileAppType
                        DirectoryId = $rec.DirectoryId
                        ProvSettingsValidateEmailAttribute = $rec.ProvSettingsValidateEmailAttribute
                        DisplayName = $rec.DisplayName
                        AppTypeDisplayName = $rec.AppTypeDisplayName
                        OnPrem = $rec.OnPrem
                        OrgPath = $rec.OrgPath
                        ID = $rec.ID
                        ShadowAppLink = $rec.ShadowAppLink
                        IsSwsEnabled = $rec.IsSwsEnabled
                        ChildLinkedApps = $rec.ChildLinkedApps
                        MunkiMetadata = $rec.MunkiMetadata
                        AdminTag = $rec.AdminTag
                        UserNameStrategy = $rec.UserNameStrategy
                        Description = $rec.Description
                        SkipSwsForAwsCli = $rec.SkipSwsForAwsCli
                        ParentAppTemplateName = $rec.ParentAppTemplateName
                        ProvConfigured = $rec.ProvConfigured
                        Version = $rec.Version
                        IsGatewayed = $rec.IsGatewayed
                        CatalogVisibility = $rec.CatalogVisibility
                        Generic = $rec.Generic
                        CorpIdentifier = $rec.CorpIdentifier
                        MobileAppSource = $rec.MobileAppSource
                        Brand = $rec.Brand
                        LastUsedPodUrl = $rec.LastUsedPodUrl
                        IsBuiltInApp = $rec.IsBuiltInApp
                        WebAppLoginType = $rec.WebAppLoginType
                        AppType = $rec.AppType
                        AuthChallengeDefinitionFlowId = $rec.AuthChallengeDefinitionFlowId
                        ServiceName = $rec.ServiceName
                        LastUsedCentrifyUrl = $rec.LastUsedCentrifyUrl
                        PortalApp = $rec.PortalApp
                        ParentApp = $rec.ParentApp
                        DeepLinkUrl = $rec.DeepLinkUrl
                        Icon = $rec.icon
                        WebAppTypeDisplayName = $rec.WebAppTypeDisplayName
                        PolicyScript = $rec.PolicyScript
                        WorkflowEnabled = $rec.WorkflowEnabled
                        BypassLoginMFA = $rec.BypassLoginMFA
                        CertBasedAuthEnabled = $rec.CertBasedAuthEnabled
                        IsTestApp = $rec.IsTestApp
                        WebAppType = $rec.WebAppType
                        ProvSettingEnabled = $rec.ProvSettingEnabled
                        _TableName = $rec._TableName
                        TemplateName = $rec.TemplateName
                        Notes = $rec.Notes
                        IsIdentityAsIdpEnabled = $rec.IsIdentityAsIdpEnabled
                        AuthChallengeDefinitionId = $rec.AuthChallengeDefinitionId
                        IsMarketplaceApp = $rec.IsMarketplaceApp
                        WebUPAppType = $rec.WebUPAppType
                        Handler = $rec.Handler
                        State = $rec.State
                        NotSelfService = $rec.NotSelfService
                        IsScaEnabled = $rec.IsScaEnabled
                        DerivedCredsSupported = $rec.DerivedCredsSupported
                        VersionName = $rec.VersionName
                        Popular = $rec.Popular
                        ProvCapable = $rec.ProvCapable

                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion IdentityCommands
            #region ConnectorManagementCommands
            if($CommandName -eq "Get-VPASCMAllConnectorPools"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        poolId = $rec.poolId
                        name = $rec.name
                        description = $rec.description
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCMAllConnectors"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        connectorId = $rec.connectorId
                        connectorStatus = $rec.connectorStatus
                        platformType = $rec.platformType
                        connectorPoolId = $rec.connectorPoolId
                        version = $rec.version
                        installedAt = $rec.installedAt
                        updatedAt = $rec.updatedAt
                        hostname = $rec.host.hostname
                        privateIp = $rec.host.privateIp
                        publicIp = $rec.host.publicIp
                        os = $rec.host.os
                        osVersion = $rec.host.osVersion
                        osName = $rec.host.osName
                        cloudRegion = $rec.host.cloudRegion
                        cloudAccount = $rec.host.cloudAccount
                        cpuType = $rec.host.cpuType
                        totalCpu = $rec.host.totalCpu
                        usedCpu = $rec.host.usedCpu
                        totalMemory = $rec.host.totalMemory
                        usedMemory = $rec.host.usedMemory
                        hostConfig = $rec.host.hostConfig
                    }
                    $str = ""
                    foreach($ver in $rec.upgradeVersions){
                        $str += "$ver;"
                    }
                    $minihash += @{ upgradeVersions = $str }

                    foreach($comp in $rec.components){
                        $minihash2 = @{
                            componentId = $comp.componentId
                            componentName = $comp.componentName
                            acronym = $comp.acronym
                            componentStatus = $comp.componentStatus
                            componentVersion = $comp.version
                            componentUsedCpu = $comp.usedCpu
                            componentUsedMemory = $comp.usedMemory
                            componentInstalledAt = $comp.installedAt
                            componentUpdatedAt = $comp.updatedAt
                            maintenanceStatus = $comp.maintenanceStatus
                        }
                        $str = ""
                        foreach($ver in $comp.upgradeVersions){
                            $str += "$ver;"
                        }
                        $minihash2 += @{ componentUpgradeVersions = $str }

                        $minihash2 += $minihash
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                }
                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCMConnectorDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        connectorId = $rec.connectorId
                        connectorStatus = $rec.connectorStatus
                        platformType = $rec.platformType
                        connectorPoolId = $rec.connectorPoolId
                        version = $rec.version
                        installedAt = $rec.installedAt
                        updatedAt = $rec.updatedAt
                        hostname = $rec.host.hostname
                        privateIp = $rec.host.privateIp
                        publicIp = $rec.host.publicIp
                        os = $rec.host.os
                        osVersion = $rec.host.osVersion
                        osName = $rec.host.osName
                        cloudRegion = $rec.host.cloudRegion
                        cloudAccount = $rec.host.cloudAccount
                        cpuType = $rec.host.cpuType
                        totalCpu = $rec.host.totalCpu
                        usedCpu = $rec.host.usedCpu
                        totalMemory = $rec.host.totalMemory
                        usedMemory = $rec.host.usedMemory
                        hostConfig = $rec.host.hostConfig
                    }
                    $str = ""
                    foreach($client in $rec.upgradeVersions){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        upgradeVersions = $str
                    }

                    $grouplen = $rec.components.Count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            componentId = ""
                            componentName = ""
                            acronym = ""
                            componentStatus = ""
                            componentConnectorId = ""
                            componentVersion = ""
                            componentUpgradeVersions = ""
                            componentUsedCpu = ""
                            componentUsedMemory = ""
                            componentInstalledAt = ""
                            componentUpdatedAt = ""
                            maintenanceStatus = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.components){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                componentId = $group.componentId
                                componentName = $group.componentName
                                acronym = $group.acronym
                                componentStatus = $group.componentStatus
                                componentConnectorId = $group.connectorId
                                componentVersion = $group.version
                                componentUsedCpu = $group.usedCpu
                                componentUsedMemory = $group.usedMemory
                                componentInstalledAt = $group.installedAt
                                componentUpdatedAt = $group.updatedAt
                                maintenanceStatus = $group.maintenanceStatus
                            }
                            $str = ""
                            foreach($client in $group.upgradeVersions){
                                if(![String]::IsNullOrEmpty($client)){
                                    $str += "$client;"
                                }
                            }
                            $minihash2 += @{
                                componentUpgradeVersions = $str
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCMConnectorPoolDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        poolId = $rec.poolId
                        name = $rec.name
                        description = $rec.description
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCMConnectors"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        connectorId = $rec.connectorId
                        connectorStatus = $rec.connectorStatus
                        platformType = $rec.platformType
                        connectorPoolId = $rec.connectorPoolId
                        version = $rec.version
                        installedAt = $rec.installedAt
                        updatedAt = $rec.updatedAt
                        hostname = $rec.host.hostname
                        privateIp = $rec.host.privateIp
                        publicIp = $rec.host.publicIp
                        os = $rec.host.os
                        osVersion = $rec.host.osVersion
                        osName = $rec.host.osName
                        cloudRegion = $rec.host.cloudRegion
                        cloudAccount = $rec.host.cloudAccount
                        cpuType = $rec.host.cpuType
                        totalCpu = $rec.host.totalCpu
                        usedCpu = $rec.host.usedCpu
                        totalMemory = $rec.host.totalMemory
                        usedMemory = $rec.host.usedMemory
                        hostConfig = $rec.host.hostConfig
                    }
                    $str = ""
                    foreach($client in $rec.upgradeVersions){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        upgradeVersions = $str
                    }

                    $grouplen = $rec.components.Count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            componentId = ""
                            componentName = ""
                            acronym = ""
                            componentStatus = ""
                            componentConnectorId = ""
                            componentVersion = ""
                            componentUpgradeVersions = ""
                            componentUsedCpu = ""
                            componentUsedMemory = ""
                            componentInstalledAt = ""
                            componentUpdatedAt = ""
                            maintenanceStatus = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.components){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                componentId = $group.componentId
                                componentName = $group.componentName
                                acronym = $group.acronym
                                componentStatus = $group.componentStatus
                                componentConnectorId = $group.connectorId
                                componentVersion = $group.version
                                componentUsedCpu = $group.usedCpu
                                componentUsedMemory = $group.usedMemory
                                componentInstalledAt = $group.installedAt
                                componentUpdatedAt = $group.updatedAt
                                maintenanceStatus = $group.maintenanceStatus
                            }
                            $str = ""
                            foreach($client in $group.upgradeVersions){
                                if(![String]::IsNullOrEmpty($client)){
                                    $str += "$client;"
                                }
                            }
                            $minihash2 += @{
                                componentUpgradeVersions = $str
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCMConnectorComponentDetails"){
                foreach($rec in $Data){
                    $minihash = @{
                        componentId = $rec.componentId
                        componentName = $rec.componentName
                        acronym = $rec.acronym
                        componentStatus = $rec.componentStatus
                        connectorId = $rec.connectorId
                        version = $rec.version
                        usedCpu = $rec.usedCpu
                        usedMemory = $rec.usedMemory
                        installedAt = $rec.installedAt
                        updatedAt = $rec.updatedAt
                        maintenanceStatus = $rec.maintenanceStatus
                    }
                    $str = ""
                    foreach($client in $rec.upgradeVersions){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        upgradeVersions = $str
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }
                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCMAllConnectorComponents"){
                foreach($rec in $Data.components){
                    $minihash = @{
                        componentId = $rec.componentId
                        componentName = $rec.componentName
                        acronym = $rec.acronym
                        componentStatus = $rec.componentStatus
                        connectorId = $rec.connectorId
                        version = $rec.version
                        usedCpu = $rec.usedCpu
                        usedMemory = $rec.usedMemory
                        installedAt = $rec.installedAt
                        updatedAt = $rec.updatedAt
                        maintenanceStatus = $rec.maintenanceStatus
                    }
                    $str = ""
                    foreach($client in $rec.upgradeVersions){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        upgradeVersions = $str
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCMComponentLogList"){
                foreach($rec in $Data.logs){
                    $minihash = [ordered]@{
                        logId = $rec.logId
                        date = $rec.date
                        displayName = $rec.displayName
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCMAllComponents"){
                foreach($rec in $Data.components){
                    $minihash = @{
                        componentId = $rec.componentId
                        componentName = $rec.componentName
                        acronym = $rec.acronym
                        componentStatus = $rec.componentStatus
                        connectorId = $rec.connectorId
                        version = $rec.version
                        usedCpu = $rec.usedCpu
                        usedMemory = $rec.usedMemory
                        installedAt = $rec.installedAt
                        updatedAt = $rec.updatedAt
                        maintenanceStatus = $rec.maintenanceStatus
                    }
                    $str = ""
                    foreach($client in $rec.upgradeVersions){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        upgradeVersions = $str
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion ConnectorManagementCommands
            #region SIACommands
            if($CommandName -eq "Get-VPASSIAAllPolicies"){
                foreach($rec in $Data.items){
                    $minihash = [ordered]@{
                        policyId = $rec.policyId
                        status = $rec.status
                        policyName = $rec.policyName
                        description = $rec.description
                        createdOn = $rec.createdOn
                        createdBy = $rec.createdBy
                        updatedOn = $rec.updatedOn
                        updatedBy = $rec.updatedBy
                    }
                    $str = ""
                    foreach($client in $rec.ruleNames){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        ruleNames = $str
                    }
                    $str = ""
                    foreach($client in $rec.platforms){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        platforms = $str
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSIAAllStrongAccounts"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        secret_id = $rec.secret_id
                        tenant_id = $rec.tenant_id
                        secret_type = $rec.secret_type
                        secret_name = $rec.secret_name
                        is_active = $rec.is_active
                        certFileName = $rec.secret_details.certFileName
                        account_domain = $rec.secret_details.account_domain
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSIAAllStrongAccountSets"){
                foreach($rec in $Data.target_sets){
                    $minihash = [ordered]@{
                        name = $rec.name
                        provision_format = $rec.provision_format
                        description = $rec.description
                        enable_certificate_validation = $rec.enable_certificate_validation
                        secret_type = $rec.secret_type
                        secret_id = $rec.secret_id
                        type = $rec.type
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSIAPolicies"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        policyId = $rec.policyId
                        status = $rec.status
                        policyName = $rec.policyName
                        description = $rec.description
                        createdOn = $rec.createdOn
                        createdBy = $rec.createdBy
                        updatedOn = $rec.updatedOn
                        updatedBy = $rec.updatedBy
                    }
                    $str = ""
                    foreach($client in $rec.ruleNames){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        ruleNames = $str
                    }
                    $str = ""
                    foreach($client in $rec.platforms){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        platforms = $str
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSIAStrongAccounts"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        secret_id = $rec.secret_id
                        tenant_id = $rec.tenant_id
                        secret_type = $rec.secret_type
                        secret_name = $rec.secret_name
                        is_active = $rec.is_active
                        certFileName = $rec.secret_details.certFileName
                        account_domain = $rec.secret_details.account_domain
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSIAStrongAccountDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        secret_id = $rec.secret_id
                        tenant_id = $rec.tenant_id
                        secret_type = $rec.secret_type
                        secret_name = $rec.secret_name
                        is_active = $rec.is_active
                        is_rotatable = $rec.is_rotatable
                        certFileName = $rec.secret_details.certFileName
                        account_domain = $rec.secret_details.account_domain
                        creation_time = $rec.creation_time
                        last_modified = $rec.last_modified
                        tenant_encrypted = $rec.secret.tenant_encrypted
                        secret_data = $rec.secret.secret_data
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSIASettings"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        mfaCaching_isMfaCachingEnabled = $rec.mfaCaching.isMfaCachingEnabled
                        mfaCaching_keyExpirationTimeSec = $rec.mfaCaching.keyExpirationTimeSec
                        mfaCaching_clientIpEnforced = $rec.mfaCaching.clientIpEnforced
                        mfaCaching_tokenUsageCount = $rec.mfaCaching.tokenUsageCount
                        sshMfaCaching_isMfaCachingEnabled = $rec.sshMfaCaching.isMfaCachingEnabled
                        sshMfaCaching_keyExpirationTimeSec = $rec.sshMfaCaching.keyExpirationTimeSec
                        sshMfaCaching_clientIpEnforced = $rec.sshMfaCaching.clientIpEnforced
                        sshMfaCaching_tokenUsageCount = $rec.sshMfaCaching.tokenUsageCount
                        rdpMfaCaching_isMfaCachingEnabled = $rec.rdpMfaCaching.isMfaCachingEnabled
                        rdpMfaCaching_keyExpirationTimeSec = $rec.rdpMfaCaching.keyExpirationTimeSec
                        rdpMfaCaching_clientIpEnforced = $rec.rdpMfaCaching.clientIpEnforced
                        rdpMfaCaching_tokenUsageCount = $rec.rdpMfaCaching.tokenUsageCount
                        rdpTokenMfaCaching_isMfaCachingEnabled = $rec.rdpTokenMfaCaching.isMfaCachingEnabled
                        rdpTokenMfaCaching_keyExpirationTimeSec = $rec.rdpTokenMfaCaching.keyExpirationTimeSec
                        rdpTokenMfaCaching_clientIpEnforced = $rec.rdpTokenMfaCaching.clientIpEnforced
                        rdpTokenMfaCaching_tokenUsageCount = $rec.rdpTokenMfaCaching.tokenUsageCount
                        adbMfaCaching_isMfaCachingEnabled = $rec.adbMfaCaching.isMfaCachingEnabled
                        adbMfaCaching_keyExpirationTimeSec = $rec.adbMfaCaching.keyExpirationTimeSec
                        adbMfaCaching_clientIpEnforced = $rec.adbMfaCaching.clientIpEnforced
                        adbMfaCaching_tokenUsageCount = $rec.adbMfaCaching.tokenUsageCount
                        k8sMfaCaching_isMfaCachingEnabled = $rec.k8sMfaCaching.isMfaCachingEnabled
                        k8sMfaCaching_keyExpirationTimeSec = $rec.k8sMfaCaching.keyExpirationTimeSec
                        k8sMfaCaching_clientIpEnforced = $rec.k8sMfaCaching.clientIpEnforced
                        k8sMfaCaching_tokenUsageCount = $rec.k8sMfaCaching.tokenUsageCount
                        sshCommandAudit_isCommandParsingForAuditEnabled = $rec.sshCommandAudit.isCommandParsingForAuditEnabled
                        sshCommandAudit_shellPromptForAudit = $rec.sshCommandAudit.shellPromptForAudit
                        standingAccessAvailable = $rec.standingAccess.standingAccessAvailable
                        sessionMaxDuration = $rec.standingAccess.sessionMaxDuration
                        sessionIdleTime = $rec.standingAccess.sessionIdleTime
                        fingerprintValidation = $rec.standingAccess.fingerprintValidation
                        sshStandingAccessAvailable = $rec.standingAccess.sshStandingAccessAvailable
                        rdpStandingAccessAvailable = $rec.standingAccess.rdpStandingAccessAvailable
                        adbStandingAccessAvailable = $rec.standingAccess.adbStandingAccessAvailable
                        rdpFileTransfer = $rec.rdpFileTransfer.enabled
                        certificateValidation = $rec.certificateValidation.enabled
                        rdpKeyboardLayout = $rec.rdpKeyboardLayout.layout
                        rdpRecording = $rec.rdpRecording.enabled
                        sshRecording = $rec.sshRecording.enabled
                        logonSequence = $rec.logonSequence.logonSequence
                        tenantType = $rec.selfHostedPam.tenantType
                        connectorPoolId = $rec.selfHostedPam.connectorPoolId
                        pvwaBaseUrl = $rec.selfHostedPam.pvwaBaseUrl
                        serviceUserSecretId = $rec.selfHostedPam.serviceUserSecretId
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion SIACommands
            #region MISCCommands
            if($CommandName -eq "Find-VPASTargetValue"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Condition = $rec.Condition
                        Asset = $rec.Asset
                        Value = $rec.Value
                        ExtraInfo = $rec.ExtraInfo
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Invoke-VPASHealthCheck"){
                foreach($rec in $Data.Keys){
                    foreach($entry in $Data.$rec){
                        $minihash = [ordered]@{
                            Check = $entry.Check
                            Category = $entry.Category
                            TargetName = $entry.TargetName
                            Recommendation = $entry.Recommendation
                        }
                        $convertobj = [PSCustomObject]$minihash
                        $outputmatrix += $convertobj
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion MISCCommands

            Write-VPASOutput -str "FAILED TO EXPORT TO CSV FILE" -type E
            return $false
        }catch{
            Write-VPASOutput -str "COULD NOT WRITE TO CSV FILES" -type E
            Write-VPASOutput -str "$_" -type E
            return $false
        }
    }
    End{

    }
}

# SIG # Begin signature block
# MIIsuQYJKoZIhvcNAQcCoIIsqjCCLKYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUCVMup6DEggK9ef0rZhgrmUyG
# TJKggiXzMIIFbzCCBFegAwIBAgIQSPyTtGBVlI02p8mKidaUFjANBgkqhkiG9w0B
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
# BgkqhkiG9w0BCQQxFgQUDNBH8sZz9d6/yiNhOcGi+LM83t8wDQYJKoZIhvcNAQEB
# BQAEggIAU/Y3nvERPGV76hRlgxoQ1BbN+UfuuPGIwIktJlDsZzzYMAJWVx21RtMJ
# hTwTgM72FwCD59X8joiZhUvtOVIpOM07Bt0F4dUGPi7fPWlXGYqyaNWmgp3gE0g+
# wCiiaB9LjI8hraTMMIcIH/Y1UrIW5r/v0j4ffuITlHs40zZBlEWIpMFmS/3VGiAd
# z8CC8WuwnEYioBj/Mebn9XyTE3u3S8ZSTdMpnmE5QWU6ctk7HIId7R6018aACOb5
# sCJWcUTK9GEEIoNWRlAmXtVTTMiB+Lj/YWftnW4xf5H62FeJqJiKuO6U5biLOaN7
# jo2+X+B3DQxvedBXhLYZefjF9nrTjXMGhAk6WsvnQJNo2b4rBRQi7/X5duMivT+q
# GjIi4UDy/qLaz8oMEVT/fh1MetmWZ/7JZM323L8Ia1B2uSMK2imZaRVTsMwwyFWe
# tOeVNQ9yVBCkpfsg02wW1iQ93f/qAKeX4lWu7VHt77ZFNnM1lxVmF4Rs+MXiU8CN
# hDjR/5ny87XRoRkVouGan6q49bR4zFytUq8tHo9V453w4fZzGEK8g5KFG5aGg6hV
# LOfFNDfjKu+VG1Rz2wJcwK2GOEKc6OzUmVeUBBXCOjvrOse/mEWmo5aAIL3QWxdt
# VRPxUyGZNb2kOuuc17p9hEnahUunTDlO9ecTciRKLEZrsbVnY0ehggMjMIIDHwYJ
# KoZIhvcNAQkGMYIDEDCCAwwCAQEwajBVMQswCQYDVQQGEwJHQjEYMBYGA1UEChMP
# U2VjdGlnbyBMaW1pdGVkMSwwKgYDVQQDEyNTZWN0aWdvIFB1YmxpYyBUaW1lIFN0
# YW1waW5nIENBIFI0MQIRAOdO8lWwUE/626bf9/yLoxUwDQYJYIZIAWUDBAICBQCg
# eTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjEw
# MTcwMjU3NDJaMD8GCSqGSIb3DQEJBDEyBDAk8nf1jPyquCv2vOMvXjNkvWFEgeFp
# 7Xp1ivspYUICuPbTxf98HOIPKfTxQJC4A6YwDQYJKoZIhvcNAQEBBQAEggIAH/72
# iYUTDOd2MhB2yjPTlISEO6JM64Eox8oxZuvRVvHM4Jav1oZLW3pudhR0V9x2YxXc
# wSccYcyZ3hWdoun6+JopfxEHh4OhvARLs0xfCt/t173YZiJnHFx7f3Or9EssjbSh
# EzcLkBB2oyU1gLJaNFll7iYCc0BujJBT022ilVwaJa5h9Pizn2F7LdP0UBcGUhLh
# FswYXfaG2284yUfJ8wUZaApjiGr3epN0KXxJkA+DVmjO1N9OaWUOz1Eiq+VUqm3x
# jusTIFUkSo7SoNSiAwR0LL9LlslXDta7A3+4xrPipycS0JNH47T87PZHur5VoIRK
# Hz0trVsVu0ANNSApT+mNG+saKs+pL1XTmMoX80FwH9HuIrrVGFNCjZUh9HR1fVAq
# 8H6DJgYOQrPcgEFh/i9X0hZR+JvX1GQnakqDqj9/KYFMOQCeQCfZfISzDVliqHao
# W8IjoBNmEXEmOZUDVyeY1R2bqpg6WKOYjt/+op3x8Pb/wRPPQmD4K1fGjloiYjs2
# Mro2tSgxECeSBJT/fgJ+HDV6m4QwIS9FdFK1f+1kuMhiOTobaqyfbwxKp8ocIPiZ
# xnS6BVxvfo/uRIs77q8n6JFPHp5AELyMYmr/BiR9FPsyYqfLcYphFNbLRh2Bpq/x
# 0PC3VZjzMG3XKkecgL3OboB108vcpwFb46zRe1U=
# SIG # End signature block
