$ErrorActionPreference = 'Stop'

$toolsPath   = Split-Path -parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
  packageName    = 'jmeter'
  url            = 'https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.4.3.zip'
  checksum       = '1ebc2a179d724aa58ff8b8f1c2146204208aeeeb8ba2b53168d6700be2d516a204b7e65dd94a6a0e3b84906fd33a97fcf2f2e6e44fb9b8fafa017c0c1856e1d8'
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
