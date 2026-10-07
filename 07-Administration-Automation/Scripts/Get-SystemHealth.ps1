$ComputerName = $env:COMPUTERNAME
$OS = Get-CimInstance Win32_OperatingSystem

Write-Host "===== SYSTEM HEALTH REPORT ====="
Write-Host "Computer: $ComputerName"
Write-Host "OS: $($OS.Caption)"
Write-Host "Build: $($OS.BuildNumber)"
Write-Host "Uptime: $((Get-Date) - $OS.LastBootUpTime)"

$TotalRAM = [math]::Round($OS.TotalVisibleMemorySize / 1MB, 2)
$FreeRAM = [math]::Round($OS.FreePhysicalMemory / 1MB, 2)
$UsedRAM = [math]::Round($TotalRAM - $FreeRAM, 2)

Write-Host ""
Write-Host "===== MEMORY ====="
Write-Host "Total RAM: $TotalRAM GB"
Write-Host "Used RAM:  $UsedRAM GB"
Write-Host "Free RAM:  $FreeRAM GB"

Write-Host ""
Write-Host "===== DISK SPACE ====="

$Volumes = Get-Volume |
    Where-Object { $_.DriveLetter -and $_.DriveType -eq "Fixed" }

foreach ($Volume in $Volumes) {
    $SizeGB = [math]::Round($Volume.Size / 1GB, 2)
    $FreeGB = [math]::Round($Volume.SizeRemaining / 1GB, 2)
    $FreePercent = [math]::Round(($Volume.SizeRemaining / $Volume.Size) * 100, 1)

    if ($FreePercent -lt 15) {
        Write-Host "WARNING: Drive $($Volume.DriveLetter): only $FreePercent% free ($FreeGB GB)"
    }
    else {
        Write-Host "Drive $($Volume.DriveLetter): Total $SizeGB GB | Free $FreeGB GB ($FreePercent%)"
    }
}

Write-Host ""
Write-Host "===== NETWORK ====="

$Network = Get-NetIPConfiguration |
    Where-Object { $_.IPv4Address } |
    Select-Object -First 1

Write-Host "Interface: $($Network.InterfaceAlias)"
Write-Host "IPv4:      $($Network.IPv4Address.IPAddress)"
Write-Host "Gateway:   $($Network.IPv4DefaultGateway.NextHop)"
Write-Host "DNS:       $($Network.DNSServer.ServerAddresses -join ', ')"

Write-Host ""
Write-Host "===== SERVICE HEALTH ====="

switch ($ComputerName) {
    "CORP-DC01" {
        $ServicesToCheck = @("DNS", "NTDS", "Netlogon")
    }

    "CORP-FS01" {
        $ServicesToCheck = @("LanmanServer")
    }

    default {
        $ServicesToCheck = @("Dnscache")
    }
}

foreach ($ServiceName in $ServicesToCheck) {
    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    if ($Service) {
        Write-Host "$($Service.DisplayName): $($Service.Status)"
    }
    else {
        Write-Host "$ServiceName`: Not Found"
    }
}