Import-Module ActiveDirectory

# ---------------------------------------------
# Step 1: Create the service account `sqladmin`
# ---------------------------------------------

$UserName = "sqladmin"
$User = "CORP\$UserName"
$ContainerDN = "CN=Computers,DC=corp,DC=contoso,DC=com"
$Password = ConvertTo-SecureString "Sqlaccnt@2025!" -AsPlainText -Force

Write-Host "Creating domain user: $User"

New-ADUser `
    -Name $UserName `
    -SamAccountName $UserName `
    -UserPrincipalName "$UserName@corp.contoso.com" `
    -AccountPassword $Password `
    -Enabled $true `
    -PasswordNeverExpires $true `
    -ChangePasswordAtLogon $false

Write-Host "Created domain user: $User"

# ---------------------------------------------
# Step 2: Add `sqladmin` to Domain Admins group
# ---------------------------------------------

Add-ADGroupMember -Identity "Domain Admins" -Members "sqladmin"

# ---------------------------------------------
# Step 3: Delegate AD permissions to sqladmin
# ---------------------------------------------

# Define NTAccount for the user
$identity = New-Object System.Security.Principal.NTAccount($User)

# GUID of 'computer' object class
$computerGUID = [Guid]"bf967a86-0de6-11d0-a285-00aa003049e2"

# Define rights: create/delete/read/write computer objects
$rights = [System.DirectoryServices.ActiveDirectoryRights]::CreateChild `
        -bor [System.DirectoryServices.ActiveDirectoryRights]::DeleteChild `
        -bor [System.DirectoryServices.ActiveDirectoryRights]::WriteProperty `
        -bor [System.DirectoryServices.ActiveDirectoryRights]::ReadProperty

# Define inheritance: apply to all child objects
$inheritance = [System.DirectoryServices.ActiveDirectorySecurityInheritance]::All

# Create the access rule for the user
$accessRule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule `
    ($identity, $rights, "Allow", $computerGUID, $inheritance)

# Get the current ACL of the Computers container
$acl = Get-ACL "AD:$ContainerDN"

# Add the new access rule
$acl.AddAccessRule($accessRule)

# Apply the updated ACL to the container
Set-ACL -Path "AD:$ContainerDN" -AclObject $acl

Write-Host "$User has been granted rights to create/delete/manage computer objects under $ContainerDN"

Enable-ADAccount -Identity sqladmin
