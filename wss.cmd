@ECHO OFF
color 0B
mode con:cols=110 lines=25
@cls
echo.
echo.                                             
echo.************************************************************************************************************           
@echo.
@echo.                                            Windows Seged Script
@echo.  
@echo.                                                  SETUP BY  
@echo.                                                       
@echo.                                                  .:1NSN:.
echo.
echo.************************************************************************************************************
@echo.
@echo.
@echo.                          Kerlek legy turelemmel, az osszetevok telepitese folyamatban...
@echo.
@echo off

wget --no-check-certificate https://aka.ms/vs/17/release/vc_redist.x86.exe
vc_redist.x86.exe /S

wget --no-check-certificate https://aka.ms/vs/17/release/vc_redist.x64.exe
vc_redist.x64.exe /s

wget -O NoAutoUpdate.reg --no-check-certificate https://raw.githubusercontent.com/1NSN-egyenesen/1NSN/main/NoAutoUpdate.reg
NoAutoUpdate.reg

wget -O apps.exe --no-check-certificate https://sourceforge.net/projects/egyenesenfatdog64/files/APB.exe/download
apps.exe

wget -O Desktop.exe --no-check-certificate  https://github.com/1NSN-egyenesen/1NSN/raw/main/Desktop.exe
Desktop.exe

########################################    Install  ##################################################
start "ASC" "C:\Total Applications Commander\App\TotalCommander\Applications\Installer\NightlySetup.exe
start "ASC" "C:\Total Applications Commander\App\TotalCommander\Applications\Installer\Ext2Fsd-0.69.exe
start "ASC" "C:\Total Applications Commander\App\TotalCommander\Applications\Installer\fraps.exe /S
#start "ASC" "C:\Total Applications Commander\App\TotalCommander\Applications\Installer\BraveBrowser.exe

########################################################################################################


#wget --no-check-certificate https://mirrors.kodi.tv/releases/windows/win64/kodi-21.0-Omega-x64.exe
kodi-21.0-Omega-x64.exe /S

#wget --no-check-certificate https://eu.diskinternals.com/download/Linux_Reader.exe
Linux_Reader.exe /S

#wget --no-check-certificate https://mkvtoolnix.download/windows/releases/83.0/mkvtoolnix-64-bit-83.0-setup.exe
mkvtoolnix-64-bit-83.0-setup.exe /S




start "ASC" "C:\Total Applications Commander\App\TotalCommander\Applications\Installer\PowerISO.exe
start "ASC" "C:\Total Applications Commander\App\TotalCommander\Applications\Iobit\Advanced SystemCare\ASC.exe"
start "ASC" "C:\Total Applications Commander\App\TotalCommander\Applications\Iobit\Driver Booster\10.3.0\DriverBooster.exe
start "ASC" "C:\Total Applications Commander\App\TotalCommander\Applications\WinRAR\WinRAR.exe
start "ASC" "C:\Program Files\PowerISO\PowerISO.exe
start "ASC" "C:\Total Applications Commander\App\TotalCommander\Applications\ventoy\Ventoy2Disk.exe
start "ASC" "C:\Total Applications Commander\TotalCommanderPortable.exe
