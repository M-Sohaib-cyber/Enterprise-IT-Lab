param (
    [Parameter(Mandatory = $true)]
    [string]$FirstName,

    [Parameter(Mandatory = $true)]
    [string]$LastName,

    [Parameter(Mandatory = $true)]
    [string]$Username,

    [Parameter(Mandatory = $false)]
    [string]$Group
)

$Domain = "corp.internal"
$OU = "OU=Company Users,DC=corp,DC=internal"
$FullName = "$FirstName $LastName"
$UPN = "$Username@$Domain"

$ExistingUser = Get-ADUser -Filter "SamAccountName -eq '$Username'" -ErrorAction SilentlyContinue

if ($ExistingUser) {
    Write-Host "User '$Username' already exists. No account was created."
    exit
}

$Password = Read-Host "Enter password for $Username" -AsSecureString

try {
    New-ADUser `
        -Name $FullName `
        -GivenName $FirstName `
        -Surname $LastName `
        -SamAccountName $Username `
        -UserPrincipalName $UPN `
        -Path $OU `
        -AccountPassword $Password `
        -Enabled $true `
        -ErrorAction Stop

    Write-Host "User '$FullName' ($Username) created successfully."
}
catch {
    Write-Host "Failed to create user '$Username'."
    Write-Host $_.Exception.Message
    exit
}

$CreatedUser = Get-ADUser -Identity $Username -ErrorAction SilentlyContinue

if ($CreatedUser) {
    Write-Host "Verification successful: '$Username' exists in Active Directory."
}
else {
    Write-Host "Verification failed: '$Username' was not found."
}

if ($Group) {
    try {
        Add-ADGroupMember -Identity $Group -Members $Username -ErrorAction Stop
        Write-Host "User '$Username' added to group '$Group' successfully."
    }
    catch {
        Write-Host "Failed to add '$Username' to group '$Group'."
        Write-Host $_.Exception.Message
    }
}