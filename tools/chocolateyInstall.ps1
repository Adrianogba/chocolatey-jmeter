$ErrorActionPreference = 'Stop'

$toolsPath   = Split-Path -parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
  packageName    = 'jmeter'
  url            = 'https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.5.zip'
  checksum       = 'b24cdaa57234153df34a40bdc4501aa16f3286ca3e172eb889a5daa0ded86ab51388af1ea56e756df566a6f74f39f80eceb04e5d559668aeac9ec9759d6445ac'
  checksumType   = 'sha512'
  unzipLocation  = $toolsPath
}
Install-ChocolateyZipPackage @packageArgs

# Custom batch shim
try {
  cp $toolsPath\jmeter.cmd $env:ChocolateyInstall\bin
  cp $toolsPath\jmeterw.cmd $env:ChocolateyInstall\bin
#   Install-ChocolateyShortcut `
#     -ShortcutFilePath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\JMeter.lnk" `
#     -TargetPath "C:\ProgramData\chocolatey\lib\jmeter\tools\apache-jmeter-5.4.3\bin\ApacheJMeter.jar" `
#     -IconLocation "C:\test.ico" `
} catch {
  throw $_.Exception.Message
}

# environments registration
$zipName = [System.IO.Path]::GetFileNameWithoutExtension($packageArgs.url)
$env:JMETER_HOME = Join-Path $toolsPath $zipName
try {
  [Environment]::SetEnvironmentVariable('JMETER_HOME', $env:JMETER_HOME, 'Machine')
} catch {
  throw $_.Exception.Message
}
