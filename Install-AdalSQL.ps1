
param (
    [Parameter(
        ParameterSetName='LocalFile'
    )]
    [string] $MSIPath,
    [Parameter(
        ParameterSetName='URL'
    )]
    [string] $MSIUrl
)

Push-Location $PSScriptRoot

if ($PSBoundParameters.ContainsKey('MSIPath')) {
    Write-Output "Attempting to install from $MSIPath .."

    $MSIPath = Resolve-Path $MSIPath

    If (-not (Test-Path $MSIPath)) {
        Throw "File not found: $MSIPath"
    }
}

if ($PSBoundParameters.ContainsKey('MSIUrl')) {
    Write-Output "Attempting to install from $MSIUrl .."

    $MSIFolder =  Join-Path $env:TEMP $(New-Guid)
    New-Item -Path $MSIFolder -ItemType Directory -Force | out-null

    $MSIPath = Join-Path $MSIFolder "adalsql.msi"

    Write-Output "Downloading file to $MSIPath .."

    try {
        (New-Object System.Net.WebClient).DownloadFile($MSIUrl,$MSIPath)
    }
    catch {
        Throw "Error downloading file: $($_.Exception)"
    }
}



try {
    $VersionsToUninstall = @{CLSID='0127E4A9-98FF-430B-A1B3-08763F9C5F92'; Version="15 x64"},
                        @{CLSID='4EE99065-01C6-49DD-9EC6-E08AA5B13491'; Version="14 x64"},
                        @{CLSID='EDE51ADE-159F-4EA5-80ED-6C00E9ED4AE7'; Version="13 x64"},
                        @{CLSID='11FA7A0D-8C0B-42A1-94AE-851F1F190A25'; Version="13 x86"}

    foreach ($VersionToUninstall in $VersionsToUninstall) {
        Write-Output "Attempting to uninstall version $($VersionToUninstall.Version)..."

        Write-Output "Running MsiExec.exe /uninstall {$($VersionToUninstall.CLSID)} /quiet"
        Start-Process -FilePath "MsiExec.exe" -ArgumentList  "/uninstall {$($VersionToUninstall.CLSID)} /quiet" -Wait -NoNewWindow
    }
}
catch {
    Write-Error "Uninstall failed: $($_.Exception)"
    Throw
}

try { 

    $LogFilePath = Join-Path (Split-Path $MSIPath) "InstallLog_$(get-date -Format yyyyMMddTHHmmss).log"

    Write-Output "Installation log file will be written to $LogFilePath"

    $MSIArguments = @(
        "/i"
        ('"{0}"' -f $MSIPath)
        "/qn"
        "/norestart"
        "/L*v"
        ('"{0}"' -f $LogFilePath)
    )
    Write-Output "Running msiexec.exe $($MSIArguments)"
    Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow
}
catch {
    Write-Error "Installation failed: $($_.Exception)"
    Throw
}

Pop-Location
