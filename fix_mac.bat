@echo off

:: Check for administrative permissions
net session >nul 2>&1
if %errorLevel% neq 0 (
    :: If not running as administrator, re-run the script with elevated permissions
    echo Requesting administrative privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)


:menu
cls
echo =====================================
echo         MacOS Fix Script
echo		Author: sanjay singh
echo 		github.com/sanjaysrocks
echo =====================================
echo 1. Disable HyperV
echo 2. Fix Virtual Box
echo 3. Fix Resolution
echo 0. Exit
echo =====================================
set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" goto disable_hyperv
if "%choice%"=="2" goto fix_virtualbox
if "%choice%"=="3" goto fix_res
if "%choice%"=="0" goto exit
goto menu



:disable_hyperv

:: Command
bcdedit /set hypervisorlaunchtype off

pause
goto menu


:fix_virtualbox

set /p macName="Enter the Virtual Machine Name: "
if "%macName%" == "" goto menu

cd "C:\Program Files\Oracle\VirtualBox\"

echo =============================================================
echo Select your processor type
echo 1. Intel Processor
echo 2. AMD Processor
echo =============================================================

set /p proc="Enter your choice (1/2): "

if "%proc%" == "1" goto :apply_intel_fix
if "%proc%" == "2" goto :apply_amd_fix
if "%proc%" == "" goto menu


pause
goto menu


:apply_intel_fix
VBoxManage.exe modifyvm "%macName%" --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff
VBoxManage setextradata "%macName%" "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "iMac19,3"
VBoxManage setextradata "%macName%" "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0"
VBoxManage setextradata "%macName%" "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Iloveapple"
VBoxManage setextradata "%macName%" "VBoxInternal/Devices/smc/0/Config/DeviceKey" "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
VBoxManage setextradata "%macName%" "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 0
VBoxManage setextradata "%macName%" "VBoxInternal/TM/TSCMode" "RealTSCOffset"
echo "Intel fix applied!!!"
pause
goto menu


:apply_amd_fix
VBoxManage.exe modifyvm "%macName%" --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff
VBoxManage setextradata "%macName%" "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "iMac19,3"
VBoxManage setextradata "%macName%" "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0"
VBoxManage setextradata "%macName%" "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Iloveapple"
VBoxManage setextradata "%macName%" "VBoxInternal/Devices/smc/0/Config/DeviceKey" "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
VBoxManage setextradata "%macName%" "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 0
VBoxManage modifyvm "%macName%" --cpu-profile "Intel Core i7-6700K"
VBoxManage setextradata "%macName%" "VBoxInternal/TM/TSCMode" "RealTSCOffset"
echo "Amd fix applied!!!"
pause
goto menu



:fix_res
:: Take User Inputs
set /p macName="Enter the Virtual Machine Name: "
if "%macName%" == "" goto menu


echo =============================================================
echo Resolution Available
echo 1280x720 | 1920x1080 | 2560x1440 | 2048x1080 | 3840x2160
echo    HD         FHD        QHD          2K          4K
echo =============================================================

set /p setRes="Enter resolution (default: 1920x1080): "

:: If the user did not enter a resolution, set it to the default
if "%setRes%"=="" set setRes=1920x1080


:: Execute Commands
cd "C:\Program Files\Oracle\VirtualBox\"
VBoxManage setextradata “%macName%” VBoxInternal2/EfiGraphicsResolution %setRes%
VBoxManage modifyvm "%macName%" --vram 256

pause
goto menu


:exit
exit
