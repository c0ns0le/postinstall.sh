#######
## Post-install script for a windows desktop
########################################################################
# usage:
#     @powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://raw.github.com/tcurvelo/postinstall.sh/master/windows/desktop.ps1'))"


$downloader = new-object System.Net.WebClient


## Install chocolatey
########################################################################
iex $downloader.DownloadString("https://chocolatey.org/install.ps1")
$env:Path += ";%ALLUSERSPROFILE%\chocolatey\bin"


## Install packages from chocolatey gallery
########################################################################

iex @"
choco install -y avastfreeantivirus
choco install -y calibre
choco install -y ccleaner
choco install -y cdburnerxp
choco install -y dropbox
choco install -y evernote
choco install -y Firefox
choco install -y GoogleChrome
choco install -y handbrake
choco install -y launchy
choco install -y skype
choco install -y steam
choco install -y sumatrapdf.install
choco install -y utorrent
choco install -y virtualbox
choco install -y vlc
"@

## Install citrix receiver
########################################################################
$downloader.DownloadFile("http://downloadplugins.citrix.com.edgesuite.net/Windows/CitrixReceiverWeb.exe", "citrix.exe")
iex "./citrix.exe" 


## Windows explorer tweaks
########################################################################
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key Hidden 1
Set-ItemProperty $key HideFileExt 0
Stop-Process -processname explorer

# Disable some startup programs
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' 
Remove-ItemProperty $key Skype
Remove-ItemProperty $key uTorrent

# Disable Java Update
$key = 'HKLM:\SOFTWARE\Wow6432Node\JavaSoft\Java Update\Policy'
Set-ItemProperty $key EnableJavaUpdate 0

# Disable Aero
$key = 'HKCU:\Software\Microsoft\Windows\DWM'
Set-ItemProperty $key Composition 0
