param (
    [Parameter(Mandatory = $true)]
    [string]$CsvPath
)

if (-not (Test-Path $CsvPath)) {
    Write-Host "CSV file not found: $CsvPath"
    exit
}

$Users = Import-Csv -Path $CsvPath

$Password = Read-Host "Enter temporary password for new users" -AsSecureString

Write-Host "CSV loaded successfully."
Write-Host "Users found: $($Users.Count)"

foreach ($User in $Users) {

    $Username = $User.Username

    $ExistingUser = Get-ADUser `
        -Filter "SamAccountName -eq '$Username'" `
        -ErrorAction SilentlyContinue

    if ($ExistingUser) {
        Write-Host "SKIPPED: '$Username' already exists."
    }
    else {
    $FirstName = $User.FirstName
    $LastName  = $User.LastName
    $FullName  = "$FirstName $LastName"
    $UPN       = "$Username@corp.internal"
    $OU        = "OU=Company Users,DC=corp,DC=internal"

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

        Write-Host "CREATED: '$Username'"

        $Group = $User.Group

        if (-not [string]::IsNullOrWhiteSpace($Group)) {
            try {
                Add-ADGroupMember `
                    -Identity $Group `
                    -Members $Username `
                    -ErrorAction Stop

                Write-Host "GROUP: '$Username' added to '$Group'."
            }
            catch {
                Write-Host "GROUP FAILED: Could not add '$Username' to '$Group'."
                Write-Host $_.Exception.Message
            }
        }
    }
    catch {
        Write-Host "FAILED: '$Username'"
        Write-Host $_.Exception.Message
    }
}
}
