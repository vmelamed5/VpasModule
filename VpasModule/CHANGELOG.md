<p align="center">
  <a href="https://vpasmodule.com/updates.html" target="_blank" rel="noopener noreferrer"><img src="https://github.com/vmelamed5/vmelamed5/blob/main/images/VpasModuleLOGO.png?raw=true" /></a>
</p>

<p align="center">
A simplified PowerShell module to interact with CyberArk Web Services for Self Hosted, PrivilegeCloud Standard, and SharedServices (ISPSS) solutions as well as Identity/DPA/ConnectorManagement API suite
</p>

<p align="center">
  Creator: <b>Vadim Melamed</b>
  <br>
  Email: <b>vpasmodule@gmail.com</b>
</p>

## ChangeLog
<!-- v15.0.0 -->
<details>
<summary>VpasModule v15.2.0</summary>
  
  ### Published Date
  ```
    October 17th 2026
  ```
  
  ### New Commands
  ```
	- PAM:
		- Get-VPASTargetPlatformDetails: retrieve details for target platforms including master policy settings
		- Update-VPASTargetPlatformSettings: update target platform parameters
		- Get-VPASDuplicateAccounts: return accounts that have been onboarded multiple times based on matching username and address
		- Get-VPASFailedAccounts: return accounts that have failed a password action (verify, change, reconcile)
		- Get-VPASDisabledAccounts: returns accounts that have been disabled by either User or CPM
  ```
  
  ### Important Notes
  ```
	- API Reauth: all commands can now handle an API reauth when approaching the default threshold of 1,000 API calls
		- Reauth will prompt for MFA or manual entry if authentication policies are configured to do so
	- Get-VPASAllAccounts: bug that only returned the last iteration of accounts found, big thanks to anishkam98 (https://github.com/anishkam98) for finding the issue and reporting it
	- Modified all files to reflect the new name change: Idira (formerly CyberArk)
	- Get-VPASSQLSafes: updated table to reflect new parameters "Quota" and "UsedQuota"
	- Get-VPASSafeDetails: updated return values to reflect new parameters "Quota" and "UsedQuota"
	- New-VPASToken: fixed saml login for selfhosted environments by introducing WebView2 workflows. By doing so the flag -IDPLogin is no longer needed and has been removed
  ```

</details>

<!-- v15.0.0 -->
<details>
<summary>VpasModule v15.0.0</summary>
  
  ### Published Date
  ```
    February 4th 2026
  ```
  
  ### New Commands
  ```
	- PAM:
		- Test-VPASAPIEndpoints: make an API call to an endpoint that VpasModule does NOT currently support. This call will auto adjust to VpasModule format and return data if the endpoint is valid
		- Set-VPASDependentLinkedAccount: set an extra account (Logon Account, Jump Account, Reconcile Account) to a dependent (usage) account (SelfHosted and ISPSS/SRS)
		- Remove-VPASDependentLinkedAccount: remove an extra account (Logon Account, Jump Account, Reconcile Account) from a dependent (usage) account (SelfHosted and ISPSS/SRS)
		- Get-VPASReports: retrieve details and download a report based on a search query (SelfHosted)
		- Update-VPASPlatform: update the name of an existing platform (SelfHosted)
		- Get-VPASClientIDs: retrieve a list of CyberArk client IDs (SelfHosted)
		- Get-VPASAllRemediationRules: retrieve all remediation/onboarding rules currently configured (ISPSS/SRS)
		- Get-VPASRemediationRules: retrieve remediation/onboarding rule details via search query (ISPSS/SRS)
		- Remove-VPASRemediationRule: delete a remediation/onboarding rule via search query (ISPSS/SRS)
		- Get-VPASDiscoveredAccountDetails: retrieve details for a discovered account based on a search query or via ID (ISPSS/SRS)
		- Remove-VPASDiscoveredAccount: delete a discovered account from the pending account list (ISPSS/SRS)
		- Import-VPASDiscoveredAccount: onboard an account from the pending account list in accounts discovery (ISPSS/SRS)
		- Get-VPASDiscoveredAccountActivities: retrieve the activities of a discovered account in the pending account list (ISPSS/SRS)
		- Get-VPASAllDiscoveryScanDefinitions: retrieve all the discovery scan definitions and properties, along with last run information (ISPSS/SRS)
		- Get-VPASPlatformRotationPolicy: retrieve the rotation policy configurations for a platform (SRS)
		- Update-VPASPlatformRotationPolicy: update the rotation policy configuration for a platform (SRS)
		- Get-VPASPlatformSecretPolicy: retrieve the secret policy configurations for a platform (SRS)
		- Update-VPASPlatformSecretPolicy: update the secret policy configuration for a platform (SRS)
		- Get-VPASAllPlatformPlugins: retrieve all plugin details for all platforms (SRS)
		- Get-VPASPlatformPluginSettings: retrieve the plugin settings for a platform (SRS)
		- Update-VPASPlatformPluginSettings: update the plugin settings for a platform (SRS)
		- Get-VPASPlatformWorkflowPolicy: retrieve the workflow policy configurations for a platform (SRS)
		- Update-VPASPlatformWorkflowPolicy: update the workflow policy configurations for a platform (SRS)
		- Get-VPASAccountNetwork: retrieve the network details that an account is set to (SRS)
		- Remove-VPASAccountNetwork: remove the account network that is currently assigned to an account (SRS)
		- Update-VPASAccountNetwork: assign a different account network for a sepcific account (SRS)
  ```
  
  ### Important Notes
  ```
	- API Reauth: all commands can now handle an API reauth when approaching the default threshold of 1,000 API calls
		- Reauth will prompt for MFA or manual entry if authentication policies are configured to do so
	- Get-VPASAllAccounts: bug that only returned the last iteration of accounts found, big thanks to anishkam98 (https://github.com/anishkam98) for finding the issue and reporting it
	- Get-VPASDependentAccounts: reworked to now be supported in PrivilegeCloud environments
	- Get-VPASDependentAccountDetails: reworked to now be supported in PrivilegeCloud environments
	- Get-VPASAllDependentAccounts: reworked to now be supported in PrivilegeCloud environments
	- Add-VPASDependentAccount: reworked to now be supported in PrivilegeCloud environments
	- Remove-VPASDependentAccount: reworked to now be supported in PrivilegeCloud environment
	- Update-VPASDependentAccount: reworked to now be supported in PrivilegeCloud environment
	- Get-VPASVaultDetails: only returned true when exporting to CSV file, now returns JSON data
	- Invoke-VPASHealthCheck: "InactiveUserCheck" was incorrectly sorted under "InactivePlatformCheck", this has been fixed
	- Get-VPASAllDiscoveredAccounts: added -ExportToCSV and -CSVDirectory flags to output data to a CSV file
	- Remove-VPASDependentLinkedAccount: added -WhatIf and -HideWhatIfOutput flags to run a simulated version of the command
	- Get-VPASOnboardingRules: example fixed to show correct syntax. Functionality remains the same. NO changes to output
	- Get-VPASAllDiscoveredAccounts: reworked to now be supported in PrivilegeCloud environments
	- Get-VPASDiscoveredAccounts: reworked to now be supported in PrivilegeCloud environments and added -ExportToCSV and -CSVDirectory flags to output data to a CSV file
	- Remove-VPASAllDiscoveredAccounts: reworked to now be supported in PrivilegeCloud environments
	- Get-VPASSystemHealth: added "SessionManagement" as a possible component to monitor to support SRS environments
	- Get-VPASBulkTemplateFiles: Updated safe csv to remove CPM from SRS enabled tenants, and removed OLAC parameter from PrivilegeCloud environments
	- Add-VPASBulkSafes: Updated to support no CPM in SRS enabled tenants, and the removal of OLAC in PrivilegeCloud environments
	- New-VPASToken: included more authentication types to support SRS tenants
	- Invoke-VPASAccountPasswordAction: added support for SRS tenants (verify, reconcile, change, changeSetNew, changeOnlyInVault)
  ```

</details>

<!-- v14.6.0 -->
<details>
<summary>VpasModule v14.6.0</summary>
  
  ### Published Date
  ```
    July 20th 2025
  ```
  
  ### New Commands
  ```
	- PAM:
		- New-VPASMFACacheSSHKey: Generate a new MFA Cache SSH Key for current user or on behalf of another user
		- Remove-VPASMFACacheSSHKey: Remove an MFA cache SSH Key for current user, on behalf of a user, or for all users
		- Get-VPASStoredPlatformDetails: Retrieve details for a temporarily stored platform
		- Remove-VPASStoredPlatform: Delete a temporarily stored platform
		- Set-VPASStoredPlatform: Overwrites a platform with the temporarily stored platform
		- Import-VPASStoredPlatform: Import a stored platform with new values to clear platform conflict
		- Get-VPASMasterPolicySettings: Retrieve Master Policy settings for a target platform
		- Update-VPASMasterPolicySettings: Update Master Policy setting for a target platform
		- Get-VPASAllMasterPolicySettings: Retrieve Master Policy settings for all target platforms
		- Get-VPASAllDependentAccounts: Retrieve all dependent accounts (usages) in the environment
		- Get-VPASDependentAccounts: Retrieve dependent accounts (usages) attached to an account
		- Get-VPASDependentAccountDetails: Retrieve details for a dependent account (usages)
		- Add-VPASDependentAccount: Add a dependent account (usage)
		- Remove-VPASDependentAccount: Remove a dependent account (usage)
		- Resume-VPASDependentAccount: Resume a dependent account (usage) that has been disabled by either CPM or user
		- Push-VPASDependentAccountSecret: Push or Sync a secret to a dependent account (usage)
		- Update-VPASDependentAccount: update a property for a dependent account (usage)
		- Add-VPASOnboardingRule: Add an onboarding rule for automatic onboarding
		- Get-VPASAllOnboardingRules: Retrieve all onboarding rules for automatic onboarding in the environment
		- Get-VPASOnboardingRules: Retrieve onboarding rules for automatic onboarding in the environment via search query
		- Remove-VPASOnboardingRule: delete an existing onboarding rule for automatic onboarding in the environment
		- Get-VPASAllReports: Retrieve all reports available to the current user
		- Get-VPASAllTasks: Retrieve all scheduled reports available to the current user
	- Identity:
		- Get-VPASIdentityAllApplicationTemplates: Retrieve all application templates from Identity
		- Get-VPASIdentityApplicationTemplates: Retrieve application templates from Identity based on a search query
		- Get-VPASIdentityApplicationDetails: Retrieve details for an application in Identity
		- Get-VPASIdentityAllApplications: Retrieve details for all applications in Identity
		- Get-VPASIdentityApplications: Retrieve details for an application in Identity based on a search query
		- Test-VPASIdentityApplicationCatalog: Tests to see if the application is still available in the application catalog

  ```
  
  ### Important Notes
  ```
	- Invoke-VPASCredentialProvider: fixed bug if password being pulled contained a comma would return incorrect values
	- Update-VPASAccountFields: fixed case sensitivity issue that prevented updating "RemoteMachinesAccess" parameter for an account
	- Updated the metrics output and graphs for the following commands:
		- Invoke-VPASMetricsAccounts
		- Invoke-VPASMetricsCPM
		- Invoke-VPASMetricsPlatforms
		- Invoke-VPASMetricsProviders
		- Invoke-VPASMetricsPSM
	- Get-VPASAllPlatforms: fixed bug where -ExportToCSV would display incorrect information if Get-VPASAllTargetPlatforms was run instead
	- Remove-VPASAuthenticationMethod: fixed bug where -WhatIf did not function correctly if the target authentication method does not exist
  ```

</details>

<!-- v14.4.1 -->
<details>
<summary>VpasModule v14.4.1</summary>
  
  ### Published Date
  ```
    February 5th 2025
  ```
  
  ### New Commands
  ```
	- Find-VPASTargetValue: queries the environment to find a target value
		- currently set up to query the following:
			- Safes: name, description, and creator
			- SafeMembers: member name
			- Accounts: name, address, username, required properties, optional properties
			- Platforms: ID, name, description, required properties, optional properties
			- EPVUsers: username, firstname, lastname
			- EPVGroups: name, description
			- ApplicationIDs: ID, owner email, owner first name, owner last name
			- ApplicationID Authentications: auth value
			- Roles: ID, name, description
			- Identities: display name, name, mail, description
	- Get-VPASSearchProperties: retrieve the search properties that can be used to search for an account (SelfHosted only at this time)
	- Get-VPASAllCustomThemes: retrieve all custom themes in the environment
	- Get-VPASCustomTheme: retrieve details for a custom theme
	- Enable-VPASCustomTheme: enable a custom theme
	- Disable-VPASCustomTheme: disable custom theme and revert back to default theme
	- Get-VPASCurrentCustomTheme: retrieve details for the currently enabled custom theme
	- Remove-VPASCustomTheme: deletes a custom theme in the environment
	- Update-VPASCustomThemeDraft: update a custom themes isDraft property
	- Get-VPASEmptySafes: returns a list of safes that do not have any accounts stored inside (based on safe permissions)
	- Get-VPASEmptyPlatforms: returns a list of platforms that do not have any accounts attached to it
	- Get-VPASAccountDetailsExtended: returns extended data for an account object such as compliance, dependencies, etc.
	- Get-VPASAccountCompliance: returns the compliance status for accounts in cyberark based on a search query
	- Invoke-VPASHealthCheck: runs several checks on an environment and prints out recommendations (READ ONLY, does not make any changes)
		- currently set up to run the following checks:
			- Account Compliance: reports on accounts that are non compliant
			- Component Status: reports on any disconnected components
			- Empty Safes: reports on any safes that do not contain accounts
			- Inactive Platforms: reports on accounts that are assigned to inactive platforms
			- Inactive User: reports on any users that have not logged into the system in the last 365 days
			- Application Authentications: reports on any appIDs that have been created with no authentication methods
			- Unused Assets:
				- reports on unused providers that have not been added to any safes
				- reports on unused appIDs that have been created but not assigned to any safes
				- reports on active platforms that have no accounts assigned to them
				- reports on active CPMs that are not assigned to any safe
				- reports on unused or unknown connection components (psm connectors)
				- reports on unused or unknown PSMServerIDs that have not been assigned to any platform
			- Version Check: reports on components that do not match the vault version
  ```
  
  ### Important Notes
  ```
	- Invoke-VPASMetricsAccounts: reworked the logic for AccountCompliance metric to utilize Get-VPASAccountCompliance
	- Get-VPASIncomingRequestDetails: changed return type from a hashtable to an array for consistency purposes
	- Get-VPASAccountRequestDetails: changed return type from a hashtable to an array for consistency purposes
	- New flags added -ExportToCSV and -CSVDirectory to export the results to a csv file:
		- Disable-VPASCustomTheme
		- Enable-VPASCustomTheme
		- Find-VPASTargetValue
		- Get-VPASAccountActivity
		- Get-VPASAccountCompliance
		- Get-VPASAccountDetails
		- Get-VPASAccountDetailsExtended
		- Get-VPASAccountGroupMembers
		- Get-VPASAccountGroups
		- Get-VPASAccountRequestDetails
		- Get-VPASActiveSessionActivities
		- Get-VPASActiveSessionProperties
		- Get-VPASActiveSessions
		- Get-VPASAllAccountRequests
		- Get-VPASAllAccounts
		- Get-VPASAllActiveSessions
		- Get-VPASAllApplications
		- Get-VPASAllConnectionComponents
		- Get-VPASAllCustomThemes
		- Get-VPASAllDirectories
		- Get-VPASAllEPVGroups
		- Get-VPASAllEPVUsers
		- Get-VPASAllGroupPlatforms
		- Get-VPASAllIncomingRequests
		- Get-VPASAllowedIPs
		- Get-VPASAllowedReferrer
		- Get-VPASAllPlatforms
		- Get-VPASAllPSMServers
		- Get-VPASAllPSMSessions
		- Get-VPASAllRotationalPlatforms
		- Get-VPASAllSafes
		- Get-VPASAllTargetPlatforms
		- Get-VPASAllUsagePlatforms
		- Get-VPASApplicationAuthentications
		- Get-VPASApplicationDetails
		- Get-VPASAuthenticationMethods
		- Get-VPASCMAllComponents
		- Get-VPASCMAllConnectorComponents
		- Get-VPASCMAllConnectorPools
		- Get-VPASCMAllConnectors
		- Get-VPASCMComponentLogList
		- Get-VPASCMConnectorComponentDetails
		- Get-VPASCMConnectorDetails
		- Get-VPASCMConnectorPoolDetails
		- Get-VPASCMConnectors
		- Get-VPASCurrentCustomTheme
		- Get-VPASCurrentEPVUserDetails
		- Get-VPASCustomTheme
		- Get-VPASDirectoryDetails
		- Get-VPASDirectoryMappingDetails
		- Get-VPASDirectoryMappings
		- Get-VPASDPAAllPolicies
		- Get-VPASDPAAllStrongAccounts
		- Get-VPASDPAAllStrongAccountSets
		- Get-VPASDPAPolicies
		- Get-VPASDPASettings
		- Get-VPASDPAStrongAccountDetails
		- Get-VPASDPAStrongAccounts
		- Get-VPASEmptyPlatforms
		- Get-VPASEmptySafes
		- Get-VPASEPVGroupDetails
		- Get-VPASEPVUserDetails
		- Get-VPASEPVUserDetailsSearch
		- Get-VPASEPVUserTypes
		- Get-VPASGroupPlatformDetails
		- Get-VPASIdentityAdminSecurityQuestion
		- Get-VPASIdentityAllAdminSecurityQuestions
		- Get-VPASIdentityAllRoles
		- Get-VPASIdentityAllUsers
		- Get-VPASIdentityCurrentUserDetails
		- Get-VPASIdentityCurrentUserSecurityQuestions
		- Get-VPASIdentityRoleDetails
		- Get-VPASIdentityRoles
		- Get-VPASIdentityTenantDetails
		- Get-VPASIdentityUserDetails
		- Get-VPASIdentityUserSecurityQuestions
		- Get-VPASIncomingRequestDetails
		- Get-VPASPasswordHistory
		- Get-VPASPlatformDetails
		- Get-VPASPlatformDetailsSearch
		- Get-VPASPSMSessionActivities
		- Get-VPASPSMSessionDetails
		- Get-VPASPSMSessionProperties
		- Get-VPASPSMSessions
		- Get-VPASPSMSettingsByPlatformID
		- Get-VPASRotationalPlatformDetails
		- Get-VPASSafeDetails
		- Get-VPASSafeMembers
		- Get-VPASSafeMemberSearch
		- Get-VPASSafes
		- Get-VPASSafesByPlatformID
		- Get-VPASSearchProperties
		- Get-VPASSpecificAuthenticationMethod
		- Get-VPASSystemComponents
		- Get-VPASSystemHealth
		- Get-VPASUsagePlatformDetails
		- Get-VPASVaultDetails
		- Get-VPASVaultVersion
		- Invoke-VPASHealthCheck
		- Remove-VPASCustomTheme
		- Update-VPASCustomThemeDraft
  ```

</details>

<!-- v14.3.0 -->
<details>
<summary>VpasModule v14.3.0</summary>
  
  ### Published Date
  ```
    November 20th 2024
  ```
  
  ### Potential Script Breakers
  ```
	- REMOVED flags -LookupBy + -LookupVal and replaced with -EPVUsername + -EPVUserID
		- For any scripts using the commands below remove:
			- "-LookupBy Username -LookupVal TargetUsername" with "-EPVUsername TargetUsername"
		- For any scripts using the commands below remove:
			- "-LookupBy UserID -LookupVal 55" with "-EPVUserID 55"
		- Affected Commands:
			- Enable-VPASEPVUser
			- Disable-VPASEPVUser
			- Get-VPASEPVUserDetails
			- Reset-VPASEPVUserPassword
			- Remove-VPASEPVUser
			- Update-VPASEPVUser
	- REMOVED flags -GroupLookupBy + -GroupLookupVal and replaced with -GroupName + -GroupID
		- For any scripts using the commands below remove:
			- "-GroupLookupBy GroupName -GroupLookupVal TargetGroupName" with "-GroupName TargetGroupName"
		- For any scripts using the commands below remove:
			- "-GroupLookupBy GroupID -GroupLookupVal 22" with "-GroupID 22"
		- Affected Commands:
			- Add-VPASMemberEPVGroup
			- Remove-VPASEPVGroup
			- Update-VPASEPVGroup
			- Remove-VPASMemberEPVGroup
  ```
  
  ### Important Notes
  ```
	- ***BIG CHANGE: Added ParameterSets to every command to help avoid adding unnecessary parameters to an API call
		- *Should NOT effect any current functionality, but please test
	- ***BIG CHANGE: Added -InputParameters flag to every command to support passing an object directly to the API call containing required parameters
		- *No effect on current functionality
	- Update-VPASSafe: Removed OLACEnabled as an editable field, this field can not be updated and should not have been functioning to begin with
	- New-VPASToken: Added new AuthTypes (Added new flag -AuthToken to support two new AuthTypes):
		- ispss_AuthToken: support the ability to provide an Identity login token generated externally
		- AuthToken: support the ability to provide a token generated externally
	- Update-VPASAccountFields: Added AutomaticManagementEnabled and ManualManagementReason as editable fields (same fields as Status and StatusReason)
		- *Status and StatusReason will still work, but recommended to switch to AutomaticManagementEnabled (status) and ManualManagementReason (StatusReason) sooner rather then later
	- Add-VPASSafeMember: -MemberType parameter flipped to MANDATORY to reflect the change in the API call
		- *Add -MemberType and a value to any script using Add-VPASSafeMember
  ```

  ### New Commands
  ```
    - None
  ```
</details>

<!-- v14.2.2 -->
<details>
<summary>VpasModule v14.2.2</summary>
  
  ### Published Date
  ```
    August 22nd 2024
  ```
  
  ### Important Notes
  ```
	- Add-VPASBulkSafeMembers: Added logic to auto include "InitiateCPMAccountManagementOperations" permission if "SpecifyNextAccountContent" permission is being added
	- Update-VPASSafeMember: Added logic to auto include "InitiateCPMAccountManagementOperations" permission if "SpecifyNextAccountContent" permission is being added
	- Add-VPASSafeMember: Added logic to auto include "InitiateCPMAccountManagementOperations" permission if "SpecifyNextAccountContent" permission is being added
	- Watch-VPASActivePSMSession: Fixed file path issue preventing saving and opening generated RDPFiles
	- New-VPASPSMSession: Fixed file path issue preventing saving and opening generated RDPFiles
	- Get-VPASPSMSessions: Fixed issue where api call would only return the first 1,000 PSMSessions, command will now loop until all sessions are captured that fit the search criteria
	- Get-VPASAllPSMSessions: Fixed issue where api call would only return the first 1,000 PSMSessions, command will now loop until all sessions are captured
	- Get-VPASAllPSMSessions: -Confirm parameter added to confirm running the command as it WILL take some time to query all PSMSessions depending on retention period and size of the environment
	- Invoke-VPASReporting: REMOVED -limit parameter, command will now loop until all results are retrieved instead of guessing an upper limit of safes
	- Get-VPASSafes: REMOVED -limit and -offset parameters, command will now loop until all results are retrieved instead of guessing an upper limit of safes
	- Invoke-VPASMetricsCPM: -SafeSearchQuery parameter added to limit the metric output to a certain set of safes
	- Invoke-VPASMetricsCPM: -IgnoreSafes parameter added to ignore those values from displaying in the metric output
	- Invoke-VPASMetricsAccounts: -IgnoreSafes, -IgnorePlatforms, -IgnoreUsernames parameters added to ignore those values from displaying in the metric output
	- Invoke-VPASMetricsAccounts: -SafeSearchQuery, PlatformSearchQuery, UsernameSearchQuery parameters added to limit the metric output to a certain set of safes, platforms, or account usernames
	- Invoke-VPASMetricsPlatforms: -IgnoreSafes, -IgnorePlatforms, -IgnoreUsernames parameters added to ignore those values from displaying in the metric output
	- Invoke-VPASMetricsPlatforms: -SafeSearchQuery, PlatformSearchQuery, UsernameSearchQuery parameters added to limit the metric output to a certain set of safes, platforms, or account usernames
	- Invoke-VPASMetricsProviders: fixed bug on reporting "A null key is not allowed in a hash literal"
	- Invoke-VPASMetricsProviders: -IgnoreSafes, -IgnorePlatforms, -IgnoreUsernames parameters added to ignore those values from displaying in the metric output
	- Invoke-VPASMetricsProviders: -SafeSearchQuery, PlatformSearchQuery, UsernameSearchQuery parameters added to limit the metric output to a certain set of safes, platforms, or account usernames
	- Invoke-VPASMetricsPSM: PlatformSearchQuery, UsernameSearchQuery parameters added to limit the metric output to a certain set of platforms or account usernames
	- Invoke-VPASMetricsPSM: -IgnorePlatforms, -IgnoreUsernames parameters added to ignore those values from displaying in the metric output
  ```

  ### New Commands
  ```
    - None
  ```
</details>

<!-- v14.2.1 -->
<details>
<summary>VpasModule v14.2.1</summary>
  
  ### Published Date
  ```
    July 17th 2024
  ```
  
  ### Important Notes
  ```
	-HideRawData: Parameter added to hide raw data from the metric outputs, helpful when exporting the output as a pdf or document (Invoke-VPASMetricsAccounts; Invoke-VPASMetricsCPM; Invoke-VPASMetricsPlatforms; Invoke-VPASMetricsProviders; Invoke-VPASMetricsPSM)
  ```

  ### New Commands
  ```
    - New-VPASDPASetupScript: Generate an installation script that will deploy a DPA connector
	- Get-VPASDPAPolicies: Retrieve details for policies in DPA via search query
	- Get-VPASDPAAllPolicies: Retrieve details for all policies in DPA
	- Get-VPASDPAPolicyDetails: Retrieve details for a specific policy in DPA
	- Remove-VPASDPAPolicy: Delete a policy from DPA
	- Get-VPASDPASettings: Retrieve DPA configurations and settings
	- Get-VPASDPAAllStrongAccountSets: Retrieve all strong account sets from DPA
	- Get-VPASDPAAllStrongAccounts: Retrieve details for all strong accounts from DPA
	- Get-VPASDPAStrongAccounts: Retrieve details for strong accounts from DPA via search query
	- Get-VPASDPAStrongAccountDetails: Retrieve details for a specific strong account from DPA
	- Remove-VPASDPAStrongAccount: Delete a strong account from DPA
	- Get-VPASCMAllComponents: Retrieve details for all components from ConnectorManagement
	- Get-VPASCMAllConnectors: Retrieve details for all connectors from ConnectorManagement
	- Get-VPASCMConnectorDetails: Retrieve details for a specific ConnectorManagement connector
	- Get-VPASCMConnectors: Retrieve details for ConnectorManagement connectors via search query
	- Get-VPASCMAllConnectorComponents: Retrieve details for all components in a specific ConnectorManagement connector
	- Get-VPASCMConnectorComponentDetails: Retrieve details for a component in a specific ConnectorManagement connector via search query
	- Get-VPASCMComponentLogList: Retrieve available log list for a component in a ConnectorManagement connector
	- Get-VPASCMComponentLogs: Retrieve logs for a component in a ConnectorManagement connector
	- Get-VPASCMAllConnectorPools: Retrieve details for all available pools from ConnectorManagement
	- Get-VPASCMConnectorPoolDetails: Retrieve details of a pool assigned to a ConnectorManagement connector
	- Invoke-VPASCentralCredentialProvider: Pull password for an account object via Central Credential Provider (CCP)
	- Invoke-VPASCredentialProvider: Pull password for an account object via Credential Provider (CP)
  ```
</details>

<!-- v14.2.0 -->
<details>
<summary>VpasModule v14.2.0</summary>
  
  ### Published Date
  ```
    June 20th 2024
  ```
  
  ### Important Notes
  ```
    - Bug: -WhatIf parameter has been fixed for the following commands: Invoke-VPASReporting; Remove-VPASSafeMember; Remove-VPASPlatform; Remove-VPASMemberEPVGroup; Remove-VPASIdentityRole; Remove-VPASEPVGroup; Remove-VPASApplication; Remove-VPASAccount;
	- Invoke-VPASReporting: Added new report "ApplicationIDAuthentications", which lists out every authentication method required by each ApplicationID
	- Invoke-VPASReporting: Added new report "PlatformLinkedAccounts", which lists out every linked account found on each platform
	- Get-VPASCurrentEPVUserDetails: no longer works for privilegecloud standard environments, logic placed to handle that
	- Invoke-VPASUserLicense: does not work for SelfHosted environments, message will now display stating that instead of just failing
  ```

  ### New Commands
  ```
    - Invoke-VPASMetricsPlatforms: Generate Platform related metrics (Amount of Accounts Assigned to which Platforms, Amount of Accounts Assigned to Platforms with Automatic vs Manual Rotation Flows, Amount of Accounts Assigned to Platforms with Automatic vs Manual Verification Flows)
	- Invoke-VPASMetricsProviders: Generate Provider related metrics (Amount of safes that contain ApplicationIDs, Amount of accounts that can be pulled via the providers)
	- Get-VPASAllDiscoveredAccounts: Get all discovered accounts in the pending safe list
  ```
</details>

<!-- v14.1.0 -->
<details>
<summary>VpasModule v14.1.0</summary>
  
  ### Published Date
  ```
    May 18th 2024
  ```
  
  ### Important Notes
  ```
    - New-VPASToken: -HideWarnings parameter ADDED to supress any output to the console, for cosmetics
	- Add-VPASApplicationAuthentication: -HideWarnings parameter REMOVED, now handled as part of New-VPASToken
	- Add-VPASSafe: -HideWarnings parameter REMOVED, now handled as part of New-VPASToken
	- Get-VPASAccountDetails: -HideWarnings parameter REMOVED, now handled as part of New-VPASToken
	- Get-VPASAccountDetails: -ExactMatch parameter ADDED to return values with an exact match (not a wildcard search)
	- Get-VPASDiscoveredAccountsDependencies: -HideWarnings parameter REMOVED, now handled as part of New-VPASToken
	- Invoke-VPASAccountPasswordAction: -HideWarnings parameter REMOVED, now handled as part of New-VPASToken
	- Add-VPASApplication: -HideWarnings parameter REMOVED, now handled as part of New-VPASToken
	- Get-VPASPSMSessions: -FromTime and -ToTime parameters ADDED to filter search to a specified date range
	- Add-VPASAccount: CHANGED -extraprops from a string to hashtable like so: @{PropertyName1 = "PropertyValue1"}
	- Get-VPASAllPlatforms: If this API call fails, due to a failed platform import or a missing policy.ini file, api will run Get-VPASAllTargetPlatforms instead
	- Get-VPASPlatformDetailsSearch: If query via Get-VPASAllPlatforms fails, due to a failed platform import or a missing policy.ini file, api will query via Get-VPASAllTargetPlatforms instead
	- Get-VPASSQLPlatforms: If query via Get-VPASAllPlatforms fails, due to a failed platform import or a missing policy.ini file, api will query via Get-VPASAllTargetPlatforms instead
	- Get-VPASReporting: Platform Details Report updated if query via Get-VPASAllPlatforms fails, due to a failed platform import or a missing policy.ini file, api will query via Get-VPASAllTargetPlatforms instead
  ```

  ### New Commands
  ```
    - Invoke-VPASMetricsPSM: Generate PSM related metrics (PSM sessions in the last X days, PSM servers utilized in the last X days, PSM connection components used in the last X days, Users connecting via PSM in the last X days)
	- Invoke-VPASMetricsCPM: Generate CPM related metrics (CPMs assigned to safes, CPMs assigned to accounts, CPM management status)
	- Invoke-VPASMetricsAccounts: Generate Account related metrics (Onboarded account types, Accounts onboarded in the last X days, Account compliance status)
	- Get-VPASAllowedIPs: retrieve the allowed or whitelisted IPs that cyberark cloud communicates with
	- Add-VPASAllowedIPs: add an allowed or whitelisted IP for cyberark cloud to communicate to
	- Get-VPASAllEPVUsers: retrieve all EPVUser details
	- Import-VPASConnectionComponent: imports a zip folder holding the contents for a connection component
	- Add-VPASAccountRequest: create an account request for an account with dual control enabled
	- Get-VPASAccountRequestDetails: retrieve details for an existing account request made by user
	- Get-VPASAllAccountRequests: retrieve all account requests made by user
	- Remove-VPASAccountRequest: delete an existing account request made by user
	- Get-VPASAllIncomingRequests: retrieve all incoming requests made by users
	- Get-VPASIncomingRequestDetails: retrieve details for an incoming request made by users
	- Approve-VPASIncomingRequest: approve an incoming request for an account requiring approval
	- Deny-VPASIncomingRequest: deny an incoming request for an account requiring approval
	- Invoke-VPASUserLicenseReport: run a report to display current license usage
	- Get-VPASAllTargetPlatforms: retrieve all target platform details
  ```
</details>

<!-- v14.0.3 -->
<details>
<summary>VpasModule v14.0.3</summary>
  
  ### Published Date
  ```
    March 12th 2024
  ```
  
  ### Important Notes
  ```
    - Add-VPASApplication: -Disabled parameter has been changed to be a flag instead of a String
	- Get-VPASEPVCurrentEPVUserDetails: re-reroutes to Get-VPASIdentityCurrentUserDetails for ISPSS Tenants + returns false for Standard tenants
	- New-VPASToken: fixed the APITextRecording to handle the different tenants with retrieving the current logged in user
	- Add-VPASSafeMember: Added the ability to input a hashtable of safe permissions (Hashtable of permissions will take priority over the flags passed)
	- Add-VPASApplicationAuthentication: -AuthType parameter validateset updated address to machineAddress and Certificate to certificateSerialNumber
	- Get-VPASSafes: -IncludeAccounts parameter added to include accounts in the return value
	- Get-VPASSafeDetails: -IncludeAccounts parameter added to include accounts in the return value
	- Get-VPASSafeMembers: -LimitSearchTo parameter added to return either UsersOnly or GroupsOnly
	- Update-VPASSafeMember: Added the ability to input a hashtable of safe permissions (Hashtable of permissions will take priority over the flags passed)
	- Get-VPASAccountDetails: -SavedFilter parameter added to run prebuilt search queries (Regular, Recently, New, Link, Deleted, PolicyFailures, AccessedByUsers, ModifiedByUsers, ModifiedByCPM, DisabledPasswordByUser, DisabledPasswordByCPM, ScheduledForChange, ScheduledForVerify, ScheduledForReconcile, SuccessfullyReconciled, FailedChange, FailedVerify, FailedReconcile, LockedOrNew, Locked, Favorites)
	- Get-VPASSafeAccountGroups: This command is no longer needed as Get-VPASAccountGroups achieves the same functionality
	- Unlock-VPASExclusiveAccount: -AdminUnlock parameter added to unlock an exclusive account skipping the release workflow
	- Get-VPASPlatformDetailsSearch: return value now returns all platform properties
	- Get-VPASAllSafes: removed -Limit and -Offset parameters, api will loop in batches of 25 until there are no more safes
	- Add-VPASBulkAccounts: added support for additional PlatformAccountProperties
	- Invoke-VPASReporting: added more fields to the plaform export report, including required and optional properties
	- Add-VPASSafemember: -searchIn parameter changed to optional
  ```

  ### New Commands
  ```
    - Get-VPASEPVUserTypes: Retrieve the various types of EPV users (SelfHosted Only)
	- Get-VPASAllEPVGroups: Retrieve all EPVGroups
	- Get-VPASAllSafes: Retrieve all Safes
	- Get-VPASAllAccounts: Retrieve all Accounts
	- Get-VPASAccountPrivateSSHKey: Retrieve private SSH Key and save to a PEM file
	- Get-VPASAllPlatforms: Retrieve all platforms details
	- Get-VPASAllRotationalPlatforms: Retrieve all rotational group platforms details
	- Get-VPASAllGroupPlatforms: Retrieve all group platforms details
	- Get-VPASAllUsagePlatforms: Retrieve all usage platforms details
	- Get-VPASIdentityAllRoles: Retrieve all roles in Identity
	- Get-VPASAllActiveSessions: Retrieve all active sessions
	- Get-VPASAllPSMSessions: Retrieve all psm sessions
  ```
</details>

<!-- v13.2.0 -->
<details>
<summary>VpasModule v13.2.0</summary>
  
  ### Published Date
  ```
    November 12th 2023
  ```
  
  ### Important Notes
  ```
    -WhatIf/-HideWhatIfOutput parameters added to every Remove command to simulate what would happen if the target API call is invoked and what implications that call would have (*WORK IN PROGRESS - will build on this in future releases)
	-APITextRecording parameter added to New-VPASToken command to enable a text recording of every command run, return values, and outputs for the duration of the APIToken. Output is saved to a LOG file to the user's AppData directory
	-NoSSL parameter removed from every command and will only need to be initiated via New-VPASToken command and the preference will be carried over for the duration of the APIToken
	- Update-VPASAccountFields: added -LogonDomain and -CustomField parameters to better handle optional platform properties
	- Add-VPASEPVUser and Update-VPASEPVUser: added -AuthenticationMethod and -DistinguishedName parameters as more optional parameters when creating or updating an EPVUser
	- Add-VPASSafe: fixed bug where -NumberOfDaysRetention and -NumberOfVersionRetention parameters would clash and overwrite each other
	- Get-VPASAccountGroupMembers: fixed bug where -NoSSL preference would enable https instead of http
  ```

  ### New Commands
  ```
    - Add-VPASIdentityRole
	- Get-VPASIdentityTenantDetails
	- Get-VPASIdentityUserSecurityQuestions
	- Reset-VPASIdentityUserSecurityQuestions
	- Add-VPASIdentityUserSecurityQuestions
	- Get-VPASIdentityRoles
	- Get-VPASIdentityRoleDetails
  ```
</details>

<!-- v13.1.1 -->
<details>
<summary>VpasModule v13.1.1</summary>
  
  ### Published Date
  ```
    June 28th 2023
  ```
  
  ### Important Notes
  ```
    - Changed every command in VpasModule to follow powershell best practice verb-noun naming ***BIG CHANGE***
	- Reworked the way a login token is generated and stored, removing the need to pass -token to every command ***BIG CHANGE***
	- New-VPASToken: added the ability to authenticate into ISPSS via internal authentication "ispss_cyberark"
	- Added parameter descriptions to ever parameter in VpasModule to better understand information if "get-help" is run
	- Fixed several bugs discovered in commands
	- Updated verbose comments to better log what is happening if ocmmands are run with the -verbose flag
	- Many QOL updates on VpasModule itself to better conform to powershell "best practice"
  ```

  ### New Commands
  ```
    - Add-VPASIdentityRole
	- Add-VPASIdentitySecurityQuestionAdmin
	- Get-VPASIdentityAdminSecurityQuestion
	- Get-VPASIdentityAllAdminSecurityQuestions
	- Get-VPASIdentityAllUsers
	- Get-VPASIdentityCurrentUserDetails
	- Get-VPASIdentityCurrentUserSecurityQuestions
	- Get-VPASIdentityUserDetails
	- New-VPASIdentityGenerateUserPassword
	- Remove-VPASIdentityAdminSecurityQuestion
	- Remove-VPASIdentityRole
	- Set-VPASIdentityUserState
	- Set-VPASIdentityUserStatus
	- Test-VPASIdentityUserLocked
	- Update-VPASIdentityCurrentUserPassword
	- Update-VPASIdentityRole
  ```
</details>

<!-- v13.0.0 -->
<details>
<summary>VpasModule v13.0.0</summary>
  
  ### Published Date
  ```
    February 19th 2023
  ```
  
  ### Important Notes
  ```
    - VLogin: added "ISPSS" as an option to authenticate into PrivilegeCloud Shared Services via Oauth. Added "IdentityURL" parameter to facilitate this. To set this authentication up, please view this article by CyberArk: https://docs.cyberark.com/Product-Doc/OnlineHelp/PrivCloud-SS/Latest/en/Content/ISPSS/ISPSS-API-Authentication.htm
	- VAddSafeMember: added [String]$MemberType parameter as optional, possible values: User, Group, Role to handle the api change in PrivilegeCloud
	- VGetDirectoryDetails + VDeleteDirectory + VGetAllDirectories + VGetDirectoryMappings + VGetDirectoryMappingDetails + VGetDirectoryMappingIDHelper: commands work properly for SelfHosted environments, but due to the lack of vault authorizations (ManageDirectoryMapping) in PrivilegeCloud, these commands will NOT work in SharedServices environments
	- VDeleteApplicationAuthentication + VGetAllApplications + VGetApplicationDetails + VGetApplicationAuthIDHelper + VGetApplicationAuthentications + VDeleteApplication + VAddApplication + AddApplicationAuthentication: commands work properly for SelfHosted environments, currently unavailable in PrivilegedCloud Shared Services
	- VGetBulkTemplateFiles: added [Switch]$ISPSS as optional to account for memberType in PrivilegeCloud Shared Services add safe member API call
	- VBulkValidateFile: added [Switch]$ISPSS as optional to account for memberType in PrivilegeCloud Shared Services add safe member api call
	- VGetPasswordValue: added [Switch]$HideOutput as optional to hide messages if needed
	- VGetPlatformDetailsSearch: fixed the blank searchQuery to find all platforms (bug fix)
	- VReporting: added [Switch]$HideOutput as optional to hide messages if needed
	- VGetDiscoveredAccounts: removed $Limit and $Offset as parameters, added [String]$PlatformType('Windows Server Local','Windows Desktop Local','Windows Domain','Unix','Unix SSH Key','AWS','AWS - Access Keys','Azure Password Management'), [String]$Privileged('true','false'), [String]$Enabled('true','false') to better query discovered accounts
  ```

  ### New Commands
  ```
    - VDisableEPVUser
	- VEnableEPVUser
	- VUpdateEPVGroup
  ```
</details>

<!-- v12.6.1 -->
<details>
<summary>VpasModule v12.6.1</summary>
  
  ### Published Date
  ```
    December 23rd 2022
  ```
  
  ### Important Notes
  ```
    - VBulkValidateFile: fixed AddUpdateSafeMembers CSV file flagging RequestsAuthorizationLevel1 + RequestsAuthorizationLevel2 incorrectly
	- VGetUsagePlatformDetails: changed platformID variable to be mandatory
	- VDeleteUsagePlatform: fixed return comment, true if successful otherwise false
	- VGetGroupPlatformDetails: changed platformID variable to be mandatory
	- VGetRotationalPlatformDetails: changed platformID variable to be mandatory
	- VReporting: added "Limit" variable to handle default safe return size of only 25
	- VGetEPVGroupDetails: added "IncludeMembers" parameter to the api call to return GroupMembers as well
	- VGetPlatformDetailsSearch: fixed description comment to be more accurate
	- VConnectWithPSM: removed unused variable "ActiveSessionID"
	- VGetPasswordValue: added "CopyToClipboard" parameter to api call to return the secret to the clipboard instead of printing it out to the console
	- VUpdatePSMSettingsByPlatformID: added "Action" parameter to api call to better distinguish adding or removing ConnectionComponents
	- VLogin: added the ability to authenticate in via saml - for more information look here: https://github.com/allynl93/PS-SAML-Interactive
  ```

  ### New Commands
  ```
    - VGetEPVUserDetailsSearch
  ```
</details>

<!-- v12.6 -->
<details>
<summary>VpasModule v12.6</summary>
  
  ### Published Date
  ```
    October 17th 2022
  ```
  
  ### Important Notes
  ```
    - VBulkValidateFile: fixed AddUpdateSafeMembers CSV file flagging RequestsAuthorizationLevel1 + RequestsAuthorizationLevel2 incorrectly
	- CyberArk v12.6 is the new long term service version
	- Cleaned up various Get-Help tags in newer commands
	- Added more functionality and new commands
	- VReporting: Added more report types and report outputs
	- SQLCommands: Updated table names and layout for each export command
  ```

  ### New Commands
  ```
    - VGetAuthenticationMethodIDHelper
	- VGetDirectoryMappingIDHelper
	- VGetRecordingIDHelper
	- VActionActiveSession
	- VAddAuthenticationMethod
	- VConnectWithPSM
	- VDeleteAuthenticationMethod
	- VDeleteDirectory
	- VGetActiveSessionActivities
	- VGetActiveSessionProperties
	- VGetAllDirectories
	- VGetAuthenticationMethods
	- VGetDirectoryDetails
	- VGetDirectoryMappingDetails
	- VGetDirectoryMappings
	- VGetPSMSessionActivities
	- VGetPSMSessionDetails
	- VGetPSMSessionProperties
	- VGetSpecificAuthenticationMethod
	- VGetVaultDetails
	- VGetVaultVersion
	- VImportPlatform
	- VMonitorActiveSession
	- VUpdateAuthenticationMethod
  ```
</details>

<!-- v12.2.3 -->
<details>
<summary>VpasModule v12.2.3</summary>
  
  ### Published Date
  ```
    July 31st 2022
  ```
  
  ### Important Notes
  ```
    - Added PVWA variable into the token variable, removing the need to pass it into any command except VLogin to initialize it
	- Last update to v12.2 as CyberArk is moving to new long term service version v12.6
  ```

  ### New Commands
  ```
    - None
  ```
</details>

<!-- v12.2.2 -->
<details>
<summary>VpasModule v12.2.2</summary>
  
  ### Published Date
  ```
    July 13th 2022
  ```
  
  ### Important Notes
  ```
    - Advanced feature request SQL support: Export vault data into an SQL database for various reporting
	- Advanced feature request Safe Audit support: Run a "check" on safes and safe members to confirm proper convention is being followed based on custom parameters
  ```

  ### New Commands
  ```
    - VCheckSQLConnectionDetails
	- VGetSQLAccounts
	- VGetSQLPlatforms
	- VGetSQLSafes
	- VQueryDB
	- VSetSQLConnectionDetails
	- VRunAuditSafeTest
	- VSetAuditSafeTest
  ```
</details>

<!-- v12.2.1 -->
<details>
<summary>VpasModule v12.2.1</summary>
  
  ### Published Date
  ```
    June 20th 2022
  ```
  
  ### Important Notes
  ```
    - Started accepting requests for Advanced features (bulk actions + reporting)
	- VLogin: cookie (WebSession) functionality added in case PVWA LoadBalancer is not setup properly with sticky sessions
  ```

  ### New Commands
  ```
    - VLogger
	- VBulkAddUpdateSafeMembers
	- VBulkCreateAccounts
	- VBulkCreateSafes
	- VBulkValidateFile
	- VGetBulkTemplateFiles
	- VReporting
  ```
</details>

<!-- v12.2 -->
<details>
<summary>VpasModule v12.2</summary>
  
  ### Published Date
  ```
    May 3rd 2022
  ```
  
  ### Important Notes
  ```
    - No significant changes to the API from v11.6 up to v12, development started for v12.2 as the long term support version of CyberArk
  ```

  ### New Commands
  ```
    - VGetAccountGroupIDHelper
	- VGetActiveSessionIDHelper
	- VGetDiscoveredAccountIDHelper
	- VAddAllowedReferrer
	- VDeleteAllDiscoveredAccounts
	- VGetActiveSessions
	- VGetAllowedReferrer
	- VGetDiscoveredAccounts
	- VGetPasswordHistory
	- VGetPSMSessions
	- VGetSafeMemberSearch
	- VLinkAccount
	- VUnlinkAccount
  ```
</details>

<!-- v11.6 -->
<details>
<summary>VpasModule v11.6</summary>
  
  ### Published Date
  ```
    April 18th 2022
  ```
  
  ### Important Notes
  ```
    - Added functionality
  ```

  ### New Commands
  ```
    - VDeleteEPVGroup
	- VGetAllConnectionComponents
	- VGetAllPSMServers
	- VGetPSMSettingsByPlatformID
	- VUpdatePSMSettingsByPlatformID
	- VGetCurrentEPVUserDetails
  ```
</details>

<!-- v11.5 -->
<details>
<summary>VpasModule v11.5</summary>
  
  ### Published Date
  ```
    March 29th 2022
  ```
  
  ### Important Notes
  ```
    - Platforms now categorized as Rotational, Group, Usage, Target
  ```

  ### New Commands
  ```
    - VGetGroupPlatformIDHelper
	- VGetPlatformIDHelper
	- VGetRotationalPlatformIDHelper
	- VGetUsagePlatformIDHelper
	- VActivateGroupPlatform
	- VActivatePlatform
	- VActivateRotationalPlatform
	- VDeactivateGroupPlatform
	- VDeactivatePlatform
	- VDeactivateRotationalPlatform
	- VDeleteGroupPlatform
	- VDeletePlatform
	- VDeleteRotationalPlatform
	- VDeleteUsagePlatform
	- VDuplicateGroupPlatform
	- VDuplicatePlatform
	- VDuplicateRotationalPlatform
	- VDuplicateUsagePlatform
	- VGetGroupPlatformDetails
	- VGetRotationalPlatformDetails
	- VGetUsagePlatformDetails
  ```
</details>

<!-- v11.4 -->
<details>
<summary>VpasModule v11.4</summary>
  
  ### Published Date
  ```
    March 11th 2022
  ```
  
  ### Important Notes
  ```
    - VLogin: added ConcurrentSessions
	- VGetPlatformDetailsSearch: fixed an error that prevented the search query from finding target platforms
	- VGetAccountIDHelper: fixed an error that prevented the search query from finding target accountID
	- VGetApplicationAuthIDHelper: fixed an error that prevented the search query from finding target ApplicationID Auth
	- VGetEPVGroupIDHelper: fixed an error that prevented the search query from finding target EPVGroupID
	- VGetEPVUserIDHelper: fixed an error that prevented the search query from finding target EPVUserID
  ```

  ### New Commands
  ```
    - None
  ```
</details>

<!-- v11.3 -->
<details>
<summary>VpasModule v11.3</summary>
  
  ### Published Date
  ```
    March 3rd 2022
  ```
  
  ### Important Notes
  ```
    - Added Get-Help content (Descriptions, Examples, Syntax, Return Values, etc.)
  ```

  ### New Commands
  ```
    - None
  ```
</details>

<!-- v11.2 -->
<details>
<summary>VpasModule v11.2</summary>
  
  ### Published Date
  ```
    March 1st 2022
  ```
  
  ### Important Notes
  ```
    - No updates, just keeping up with CyberArk's versioning
  ```

  ### New Commands
  ```
    - None
  ```
</details>

<!-- v11.1 -->
<details>
<summary>VpasModule v11.1</summary>
  
  ### Published Date
  ```
    February 22nd 2022
  ```
  
  ### Important Notes
  ```
    - VLogin: added TLS 1.2 support + modified authentication from a WebRequest to a RestMethod
	- VAddSafeMember: added grouped safe permissions to lessen the amount of flags needed to pass to the command
	- Modified return value for various commands from 0,1 to True,False
  ```

  ### New Commands
  ```
    - VCreateEPVGroup
	- VGetPlatformDetailsSearch
	- VGetSafesByPlatformID
  ```
</details>

<!-- v10.10 -->
<details>
<summary>VpasModule v10.10</summary>
  
  ### Published Date
  ```
    February 12th 2022
  ```
  
  ### Important Notes
  ```
    - VpasModule debut!
  ```

  ### New Commands
  ```
    - VAccountPasswordAction
    - VActivateEPVUser
    - VAddAccountGroup
    - VAddAccountToAccountGroup
    - VAddApplication
    - VAddApplicationAuthentication
    - VAddEPVUser
    - VAddMemberEPVGroup
    - VAddSafeMember
    - VCheckInAccount
    - VCreateAccount
    - VCreateSafe
    - VDeleteAccount
    - VDeleteAccountFromAccountGroup
    - VDeleteApplication
    - VDeleteApplicationAuthentication
    - VDeleteEPVUser
    - VDeleteMemberEPVGroup
    - VDeleteSafe
    - VDeleteSafeMember
    - VExportPlatform
    - VGetAccountActivity
    - VGetAccountDetails
    - VGetAccountGroupMembers
    - VGetAccountGroups
    - VGetAllApplications
    - VGetApplicationAuthentications
    - VGetApplicationDetails
    - VGetEPVGroupDetails
    - VGetEPVUserDetails
    - VGetPasswordValue
    - VGetPlatformDetails
    - VGetSafeAccountGroups
    - VGetSafeDetails
    - VGetSafeMembers
    - VGetSafes
    - VLogin
    - VLogoff
    - Vout
    - VResetEPVUserPassword
    - VSystemComponents
    - VSystemHealth
    - VUpdateAccountFields
    - VUpdateEPVUser
    - VUpdateSafe
    - VUpdateSafeMember
  ```
</details>










