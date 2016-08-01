#NoTrayIcon
#RequireAdmin
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resource\Icon.ico
#AutoIt3Wrapper_Res_Description=Smart GApps Insta11er
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2013 Kyaw Swar Thwin
#AutoIt3Wrapper_Res_Language=1033
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <Constants.au3>
#include <Crypt.au3>
#include "Busy.au3"

OnAutoItExitRegister("_Exit")

Global Const $sAppName = "Smart GApps Installer"
Global Const $sAppVersion = "1.0"
Global Const $sAppPublisher = "Kyaw Swar Thwin"
Global Const $sAppPath = _TempFile("", "", "", 8)

Global Const $sTitle = $sAppName

Global Const $sBinaryPath = @ScriptDir & "\bin"

Global Const $AC_POWERED = "AC powered"
Global Const $USB_POWERED = "USB powered"
Global Const $EXTRA_STATUS = "status"
Global Const $EXTRA_HEALTH = "health"
Global Const $EXTRA_LEVEL = "level"
Global Const $EXTRA_SCALE = "scale"
Global Const $EXTRA_VOLTAGE = "voltage"
Global Const $EXTRA_TEMPERATURE = "temperature"
Global Const $EXTRA_TECHNOLOGY = "technology"

Global Const $BATTERY_STATUS_UNKNOWN = 1
Global Const $BATTERY_STATUS_CHARGING = 2
Global Const $BATTERY_STATUS_DISCHARGING = 3
Global Const $BATTERY_STATUS_NOT_CHARGING = 4
Global Const $BATTERY_STATUS_FULL = 5

Global Const $BATTERY_HEALTH_UNKNOWN = 1
Global Const $BATTERY_HEALTH_GOOD = 2
Global Const $BATTERY_HEALTH_OVERHEAT = 3
Global Const $BATTERY_HEALTH_DEAD = 4
Global Const $BATTERY_HEALTH_OVER_VOLTAGE = 5
Global Const $BATTERY_HEALTH_UNSPECIFIED_FAILURE = 6
Global Const $BATTERY_HEALTH_COLD = 7

Global Const $PROPERTY_BASEBAND_VERSION = "gsm.version.baseband"
Global Const $CURRENT_ACTIVE_PHONE = "gsm.current.phone-type"
Global Const $PROPERTY_OPERATOR_ALPHA = "gsm.operator.alpha"
Global Const $PROPERTY_OPERATOR_NUMERIC = "gsm.operator.numeric"
Global Const $PROPERTY_OPERATOR_ISO_COUNTRY = "gsm.operator.iso-country"
Global Const $PROPERTY_OPERATOR_ISROAMING = "gsm.operator.isroaming"
Global Const $PROPERTY_DATA_NETWORK_TYPE = "gsm.network.type"
Global Const $PROPERTY_SIM_STATE = "gsm.sim.state"
Global Const $PROPERTY_ICC_OPERATOR_ALPHA = "gsm.sim.operator.alpha"
Global Const $PROPERTY_ICC_OPERATOR_NUMERIC = "gsm.sim.operator.numeric"
Global Const $PROPERTY_ICC_OPERATOR_ISO_COUNTRY = "gsm.sim.operator.iso-country"

Global Const $PHONE_TYPE_NONE = 0
Global Const $PHONE_TYPE_GSM = 1
Global Const $PHONE_TYPE_CDMA = 2
Global Const $PHONE_TYPE_SIP = 3

Global $sDeviceModel = _Android_GetDeviceModel()
Global $sAndroidVersion = _Android_GetAndroidVersion()
Global $iAPILevel = _Android_GetAPILevel()
Global $bRootAccess = _Android_IsDeviceRooted()

DirCreate($sAppPath)
FileInstall("Resource\Banner.bmp", $sAppPath & "\Banner.bmp", 1)

$frmMain = GUICreate($sTitle, 400, 320, -1, -1)
$imgBanner = GUICtrlCreatePic($sAppPath & "\Banner.bmp", 0, 0, 400, 160)
$lblVersion = GUICtrlCreateLabel("Version: " & $sAppVersion, 195, 90, 72, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$lblDeveloper = GUICtrlCreateLabel("Developed By: " & $sAppPublisher, 195, 110, 191, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$lblDesigner = GUICtrlCreateLabel("Design By: Green Like Orange", 195, 130, 176, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$lblDeviceModel = GUICtrlCreateLabel("Model Number:", 15, 173, 76, 17)
$txtDeviceModel = GUICtrlCreateInput($sDeviceModel, 100, 170, 290, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$lblAndroidVersion = GUICtrlCreateLabel("Android Version:", 10, 203, 81, 17)
$txtAndroidVersion = GUICtrlCreateInput($sAndroidVersion, 100, 200, 290, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$lblRootAccess = GUICtrlCreateLabel("Root Access:", 23, 233, 68, 17)
$txtRootAccess = GUICtrlCreateInput($bRootAccess, 100, 230, 290, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$btnInstall = GUICtrlCreateButton("&Install", 148, 270, 105, 35)
If (Not $bRootAccess) Or (Not FileExists(@ScriptDir & "\install\gapps\" & $iAPILevel)) Then GUICtrlSetState($btnInstall, $GUI_DISABLE)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnInstall
			_Busy_UseTheme("Green")
			_Busy_Create("Installing GApps...", -1, -1, $frmMain)
			_Android_ShellAsRoot("rm -R /data/local/tmp/*")
			_Android_Push("..\dependencies\busybox", "/data/local/tmp")
			_Android_Shell("chmod 755 /data/local/tmp/busybox")
			_Android_Push("..\install\gapps\" & $iAPILevel, "/data/local/tmp")
			_Android_Push("..\shells\install-gapps.sh", "/data/local/tmp")
			_Android_Shell("chmod 755 /data/local/tmp/install-gapps.sh")
			_Android_ShellAsRoot("sh /data/local/tmp/install-gapps.sh")
			_Android_ShellAsRoot("rm -R /data/local/tmp/*")
			_Android_Reboot()
			_Busy_Close()
			MsgBox(0, $sTitle, "Success!")
	EndSwitch
WEnd

Func _Exit()
	DirRemove($sAppPath, 1)
EndFunc   ;==>_Exit

Func _Android_Connect()
	__RunWait("adb kill-server")
	__RunWait("adb start-server")
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Error: Device Not Found!")
EndFunc   ;==>_Android_Connect

Func _Android_Reboot($iMode = 1)
	If _Android_IsDeviceOffline() Then Return SetError(1, 0, "Error: Device Not Found!")
	Switch $iMode
		Case 2; Bootloader Mode
			If _Android_IsDeviceOnline() Then
				__Run("adb reboot bootloader")
			Else
				__Run("fastboot reboot-bootloader")
			EndIf
		Case 3; Download Mode
			If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Error: Device Not Found!")
			__Run("adb reboot download")
		Case 4; Recovery Mode
			If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Error: Device Not Found!")
			__Run("adb reboot recovery")
		Case Else; Normal Mode
			If _Android_IsDeviceOnline() Then
				__Run("adb reboot")
			Else
				__Run("fastboot reboot")
			EndIf
	EndSwitch
EndFunc   ;==>_Android_Reboot

Func _Android_WaitForDevice($iMode = 1)
	_Android_Connect()
	If $iMode = 2 Then; Bootloader Mode
		Do
			Sleep(500)
		Until _Android_IsDeviceBootloader()
	Else; Normal Mode
		Do
			Sleep(500)
		Until _Android_IsDeviceOnline()
	EndIf
EndFunc   ;==>_Android_WaitForDevice

Func _Android_Remount()
	Local $sOutput
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Error: Device Not Found!")
	If Not _Android_IsDeviceRooted() Then
		$sOutput = StringStripWS(_Android_Shell("mount -o remount,rw /system"), 3)
	Else
		$sOutput = StringStripWS(_Android_ShellAsRoot("mount -o remount,rw /system"), 3)
	EndIf
	If $sOutput <> "" Then Return SetError(2, 0, "Error: Failure!")
EndFunc   ;==>_Android_Remount

Func _Android_Push($sLocal, $sRemote)
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Error: Device Not Found!")
	Return __Run("adb push " & $sLocal & " " & $sRemote)
EndFunc   ;==>_Android_Push

Func _Android_Pull($sRemote, $sLocal)
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Error: Device Not Found!")
	Return __Run("adb pull " & $sRemote & " " & $sLocal)
EndFunc   ;==>_Android_Pull

Func _Android_Install($sFilePath, $iMode = 1)
	Local $sOutput
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Error: Device Not Found!")
	If $iMode = 2 Then; Install on SD Card
		$sOutput = StringStripWS(__Run("@echo off && for /f ""skip=1 tokens=* delims="" %i in ('adb install -s " & $sFilePath & "') do echo.%i"), 3)
	Else; Install on Internal Storage
		$sOutput = StringStripWS(__Run("@echo off && for /f ""skip=1 tokens=* delims="" %i in ('adb install " & $sFilePath & "') do echo.%i"), 3)
	EndIf
	If $sOutput <> "Success" Then Return SetError(2, 0, "Error: Failure!")
EndFunc   ;==>_Android_Install

Func _Android_Uninstall($sPackage)
	Local $sOutput
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Error: Device Not Found!")
	$sOutput = StringStripWS(__Run("adb uninstall " & $sPackage), 3)
	If $sOutput <> "Success" Then Return SetError(2, 0, "Error: Failure!")
EndFunc   ;==>_Android_Uninstall

Func _Android_Shell($sCommand)
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Error: Device Not Found!")
	Return __Run("adb shell " & $sCommand)
EndFunc   ;==>_Android_Shell

Func _Android_ShellAsRoot($sCommand)
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Error: Device Not Found!")
	Return _Android_Shell("su -c \""" & $sCommand & "\""")
EndFunc   ;==>_Android_ShellAsRoot

Func _Android_Call($sPhoneNumber)
	Local $sOutput
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Error: Device Not Found!")
	$sOutput = StringStripWS(_Android_Shell("service call phone 2 s16 \""" & __URLEncode($sPhoneNumber) & "\"""), 3)
	If $sOutput <> "Result: Parcel(00000000    '....')" Then Return SetError(2, 0, "Error: Failure!")
EndFunc   ;==>_Android_Call

Func _Android_SendSMS($sPhoneNumber, $sSMSBody)
	Local $sOutput
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Error: Device Not Found!")
	$sOutput = StringStripWS(_Android_Shell("service call isms 5 s16 \""" & __URLEncode($sPhoneNumber) & "\"" i32 0 i32 0 s16 \""" & $sSMSBody & "\"""), 3)
	If $sOutput <> "Result: Parcel(00000000    '....')" Then Return SetError(2, 0, "Error: Failure!")
EndFunc   ;==>_Android_SendSMS

Func _Android_GetDeviceState()
	If _Android_IsDeviceOnline() Then
		Return "Normal Mode"
	ElseIf _Android_IsDeviceBootloader() Then
		Return "Bootloader Mode"
	Else
		Return "Unknown"
	EndIf
EndFunc   ;==>_Android_GetDeviceState

Func _Android_GetDeviceSerialNumber()
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	Return _Android_GetProperty("ro.serialno")
EndFunc   ;==>_Android_GetDeviceSerialNumber

Func _Android_GetDeviceManufacturer()
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	Return _Android_GetProperty("ro.product.manufacturer")
EndFunc   ;==>_Android_GetDeviceManufacturer

Func _Android_GetDeviceModel()
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	Return _Android_GetProperty("ro.product.model")
EndFunc   ;==>_Android_GetDeviceModel

Func _Android_GetProductID()
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	If Not _Android_IsDeviceTablet() Then
		Return __Android_GenerateProductID(_Android_GetDeviceModel(), _Android_GetDeviceID())
	Else
		Return __Android_GenerateProductID(_Android_GetDeviceModel(), _Android_GetDeviceSerialNumber())
	EndIf
EndFunc   ;==>_Android_GetProductID

Func _Android_GetAndroidVersion()
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	Return _Android_GetProperty("ro.build.version.release")
EndFunc   ;==>_Android_GetAndroidVersion

Func _Android_GetAPILevel()
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	Return Number(_Android_GetProperty("ro.build.version.sdk"))
EndFunc   ;==>_Android_GetAPILevel

Func _Android_GetBuildNumber()
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	Return _Android_GetProperty("ro.build.display.id")
EndFunc   ;==>_Android_GetBuildNumber

Func _Android_GetPlugType()
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	If __Android_GetBatteryInfo($AC_POWERED) = "true" Then
		Return "AC Charger"
	ElseIf __Android_GetBatteryInfo($USB_POWERED) = "true" Then
		Return "USB Port"
	Else
		Return "Unknown"
	EndIf
EndFunc   ;==>_Android_GetPlugType

Func _Android_GetBatteryStatus()
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	Switch __Android_GetBatteryInfo($EXTRA_STATUS)
		Case $BATTERY_STATUS_CHARGING
			Return "Charging"
		Case $BATTERY_STATUS_DISCHARGING
			Return "Discharging"
		Case $BATTERY_STATUS_NOT_CHARGING
			Return "Not Charging"
		Case $BATTERY_STATUS_FULL
			Return "Full"
		Case Else
			Return "Unknown"
	EndSwitch
EndFunc   ;==>_Android_GetBatteryStatus

Func _Android_GetBatteryHealth()
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	Switch __Android_GetBatteryInfo($EXTRA_HEALTH)
		Case $BATTERY_HEALTH_GOOD
			Return "Good"
		Case $BATTERY_HEALTH_OVERHEAT
			Return "Overheat"
		Case $BATTERY_HEALTH_DEAD
			Return "Dead"
		Case $BATTERY_HEALTH_OVER_VOLTAGE
			Return "Over Voltage"
		Case $BATTERY_HEALTH_UNSPECIFIED_FAILURE
			Return "Unspecified Failure"
		Case $BATTERY_HEALTH_COLD
			Return "Cold"
		Case Else
			Return "Unknown"
	EndSwitch
EndFunc   ;==>_Android_GetBatteryHealth

Func _Android_GetBatteryLevel()
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	Return (__Android_GetBatteryInfo($EXTRA_LEVEL) * 100) / __Android_GetBatteryInfo($EXTRA_SCALE) & "%"
EndFunc   ;==>_Android_GetBatteryLevel

Func _Android_GetBatteryVoltage()
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	Return __Android_GetBatteryInfo($EXTRA_VOLTAGE) / 1000 & "V"
EndFunc   ;==>_Android_GetBatteryVoltage

Func _Android_GetBatteryTemperature()
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	Return StringFormat("%.1f", __Android_GetBatteryInfo($EXTRA_TEMPERATURE) / 10) & "°C"
EndFunc   ;==>_Android_GetBatteryTemperature

Func _Android_GetBatteryTechnology()
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	Return __Android_GetBatteryInfo($EXTRA_TECHNOLOGY)
EndFunc   ;==>_Android_GetBatteryTechnology

Func _Android_GetRadioVersion()
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	Return _Android_GetProperty($PROPERTY_BASEBAND_VERSION)
EndFunc   ;==>_Android_GetRadioVersion

Func _Android_GetPhoneType($iSIMNumber = 1)
	Local $sPhoneType, $iOffset
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	$sPhoneType = _Android_GetProperty($CURRENT_ACTIVE_PHONE)
	$iOffset = StringInStr($sPhoneType, ",")
	If $iOffset <> 0 Then
		If $iSIMNumber = 2 Then
			$sPhoneType = StringRight($sPhoneType, StringLen($sPhoneType) - $iOffset)
		Else
			$sPhoneType = StringLeft($sPhoneType, $iOffset - 1)
		EndIf
	EndIf
	Switch $sPhoneType
		Case $PHONE_TYPE_NONE
			Return "None"
		Case $PHONE_TYPE_GSM
			Return "GSM"
		Case $PHONE_TYPE_CDMA
			Return "CDMA"
		Case $PHONE_TYPE_SIP
			Return "SIP"
		Case Else
			Return "Unknown"
	EndSwitch
EndFunc   ;==>_Android_GetPhoneType

Func _Android_GetDeviceID()
	Local $sOutput
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	$sOutput = StringStripWS(__Run("@echo off && for /f ""tokens=2 delims=="" %i in ('adb shell ""dumpsys iphonesubinfo"" ^| find /i ""Device ID""') do echo.%i"), 3)
	Return $sOutput
EndFunc   ;==>_Android_GetDeviceID

Func _Android_GetNetworkOperatorName($iSIMNumber = 1)
	Local $sNetworkOperatorName, $iOffset
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	$sNetworkOperatorName = _Android_GetProperty($PROPERTY_OPERATOR_ALPHA)
	$iOffset = StringInStr($sNetworkOperatorName, ",")
	If $iOffset <> 0 Then
		If $iSIMNumber = 2 Then
			$sNetworkOperatorName = StringRight($sNetworkOperatorName, StringLen($sNetworkOperatorName) - $iOffset)
		Else
			$sNetworkOperatorName = StringLeft($sNetworkOperatorName, $iOffset - 1)
		EndIf
	EndIf
	Return $sNetworkOperatorName
EndFunc   ;==>_Android_GetNetworkOperatorName

Func _Android_GetNetworkOperator($iSIMNumber = 1)
	Local $sNetworkOperator, $iOffset
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	$sNetworkOperator = _Android_GetProperty($PROPERTY_OPERATOR_NUMERIC)
	$iOffset = StringInStr($sNetworkOperator, ",")
	If $iOffset <> 0 Then
		If $iSIMNumber = 2 Then
			$sNetworkOperator = StringRight($sNetworkOperator, StringLen($sNetworkOperator) - $iOffset)
		Else
			$sNetworkOperator = StringLeft($sNetworkOperator, $iOffset - 1)
		EndIf
	EndIf
	Return $sNetworkOperator
EndFunc   ;==>_Android_GetNetworkOperator

Func _Android_GetNetworkOperatorCountry($iSIMNumber = 1)
	Local $sNetworkOperatorCountry, $iOffset
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	$sNetworkOperatorCountry = _Android_GetProperty($PROPERTY_OPERATOR_ISO_COUNTRY)
	$iOffset = StringInStr($sNetworkOperatorCountry, ",")
	If $iOffset <> 0 Then
		If $iSIMNumber = 2 Then
			$sNetworkOperatorCountry = StringRight($sNetworkOperatorCountry, StringLen($sNetworkOperatorCountry) - $iOffset)
		Else
			$sNetworkOperatorCountry = StringLeft($sNetworkOperatorCountry, $iOffset - 1)
		EndIf
	EndIf
	Return $sNetworkOperatorCountry
EndFunc   ;==>_Android_GetNetworkOperatorCountry

Func _Android_GetNetworkType($iSIMNumber = 1)
	Local $sNetworkType, $iOffset
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	$sNetworkType = _Android_GetProperty($PROPERTY_DATA_NETWORK_TYPE)
	$iOffset = StringInStr($sNetworkType, ",")
	If $iOffset <> 0 Then
		If $iSIMNumber = 2 Then
			$sNetworkType = StringRight($sNetworkType, StringLen($sNetworkType) - $iOffset)
		Else
			$sNetworkType = StringLeft($sNetworkType, $iOffset - 1)
		EndIf
	EndIf
	Return StringLeft($sNetworkType, StringInStr($sNetworkType, ":") - 1)
EndFunc   ;==>_Android_GetNetworkType

Func _Android_GetSIMState($iSIMNumber = 1)
	Local $sSIMState, $iOffset
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	$sSIMState = _Android_GetProperty($PROPERTY_SIM_STATE)
	$iOffset = StringInStr($sSIMState, ",")
	If $iOffset <> 0 Then
		If $iSIMNumber = 2 Then
			$sSIMState = StringRight($sSIMState, StringLen($sSIMState) - $iOffset)
		Else
			$sSIMState = StringLeft($sSIMState, $iOffset - 1)
		EndIf
	EndIf
	Switch $sSIMState
		Case "ABSENT"
			Return "Absent"
		Case "PIN_REQUIRED"
			Return "PIN Required"
		Case "PUK_REQUIRED"
			Return "PUK Required"
		Case "NETWORK_LOCKED"
			Return "Network Locked"
		Case "READY"
			Return "Ready"
		Case Else
			Return "Unknown"
	EndSwitch
EndFunc   ;==>_Android_GetSIMState

Func _Android_GetSIMOperatorName($iSIMNumber = 1)
	Local $sSIMOperatorName, $iOffset
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	$sSIMOperatorName = _Android_GetProperty($PROPERTY_ICC_OPERATOR_ALPHA)
	$iOffset = StringInStr($sSIMOperatorName, ",")
	If $iOffset <> 0 Then
		If $iSIMNumber = 2 Then
			$sSIMOperatorName = StringRight($sSIMOperatorName, StringLen($sSIMOperatorName) - $iOffset)
		Else
			$sSIMOperatorName = StringLeft($sSIMOperatorName, $iOffset - 1)
		EndIf
	EndIf
	Return $sSIMOperatorName
EndFunc   ;==>_Android_GetSIMOperatorName

Func _Android_GetSIMOperator($iSIMNumber = 1)
	Local $sSIMOperator, $iOffset
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	$sSIMOperator = _Android_GetProperty($PROPERTY_ICC_OPERATOR_NUMERIC)
	$iOffset = StringInStr($sSIMOperator, ",")
	If $iOffset <> 0 Then
		If $iSIMNumber = 2 Then
			$sSIMOperator = StringRight($sSIMOperator, StringLen($sSIMOperator) - $iOffset)
		Else
			$sSIMOperator = StringLeft($sSIMOperator, $iOffset - 1)
		EndIf
	EndIf
	Return $sSIMOperator
EndFunc   ;==>_Android_GetSIMOperator

Func _Android_GetSIMOperatorCountry($iSIMNumber = 1)
	Local $sSIMOperatorCountry, $iOffset
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	$sSIMOperatorCountry = _Android_GetProperty($PROPERTY_ICC_OPERATOR_ISO_COUNTRY)
	$iOffset = StringInStr($sSIMOperatorCountry, ",")
	If $iOffset <> 0 Then
		If $iSIMNumber = 2 Then
			$sSIMOperatorCountry = StringRight($sSIMOperatorCountry, StringLen($sSIMOperatorCountry) - $iOffset)
		Else
			$sSIMOperatorCountry = StringLeft($sSIMOperatorCountry, $iOffset - 1)
		EndIf
	EndIf
	Return $sSIMOperatorCountry
EndFunc   ;==>_Android_GetSIMOperatorCountry

Func _Android_GetProperty($sPropertyName)
	Local $sOutput
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	$sOutput = StringStripWS(_Android_Shell("getprop " & $sPropertyName & ""), 3)
	Return $sOutput
EndFunc   ;==>_Android_GetProperty

Func _Android_IsDeviceOnline()
	Local $sOutput, $bNormalMode = False
	$sOutput = StringStripWS(__Run("@echo off && for /f ""skip=1 tokens=* delims="" %i in ('adb devices') do echo.%i"), 3)
	If $sOutput <> "" Then $bNormalMode = True
	Return $bNormalMode
EndFunc   ;==>_Android_IsDeviceOnline

Func _Android_IsDeviceBootloader()
	Local $sOutput, $bBootloaderMode = False
	$sOutput = StringStripWS(__Run("fastboot devices"), 3)
	If $sOutput <> "" Then $bBootloaderMode = True
	Return $bBootloaderMode
EndFunc   ;==>_Android_IsDeviceBootloader

Func _Android_IsDeviceOffline()
	Return Not (_Android_IsDeviceOnline() Or _Android_IsDeviceBootloader())
EndFunc   ;==>_Android_IsDeviceOffline

Func _Android_IsDeviceTablet()
	Return StringInStr(_Android_GetProperty("ro.build.characteristics"), "tablet") <> 0
EndFunc   ;==>_Android_IsDeviceTablet

Func _Android_IsDeviceRooted()
	Local $sOutput, $bRootAccess = False
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	$sOutput = StringStripWS(_Android_ShellAsRoot("echo Root Checker"), 3)
	If $sOutput = "Root Checker" Then $bRootAccess = True
	Return $bRootAccess
EndFunc   ;==>_Android_IsDeviceRooted

Func _Android_IsNetworkRoaming($iSIMNumber = 1)
	Local $sNetworkRoaming, $iOffset, $bNetworkRoaming = False
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	$sNetworkRoaming = _Android_GetProperty($PROPERTY_OPERATOR_ISROAMING)
	$iOffset = StringInStr($sNetworkRoaming, ",")
	If $iOffset <> 0 Then
		If $iSIMNumber = 2 Then
			$sNetworkRoaming = StringRight($sNetworkRoaming, StringLen($sNetworkRoaming) - $iOffset)
		Else
			$sNetworkRoaming = StringLeft($sNetworkRoaming, $iOffset - 1)
		EndIf
	EndIf
	If $sNetworkRoaming = "true" Then $bNetworkRoaming = True
	Return $bNetworkRoaming
EndFunc   ;==>_Android_IsNetworkRoaming

Func __Run($sCommand)
	Local $iPID, $sLine, $sOutput = ""
	$iPID = Run(@ComSpec & " /c " & $sCommand, $sBinaryPath, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	While 1
		$sLine = StdoutRead($iPID)
		If @error Then ExitLoop
		$sOutput &= $sLine
	WEnd
	Return SetError(@error, @extended, $sOutput)
EndFunc   ;==>__Run

Func __RunWait($sCommand)
	Local $iPID = RunWait(@ComSpec & " /c " & $sCommand, $sBinaryPath, @SW_HIDE)
	Return SetError(@error, @extended, $iPID)
EndFunc   ;==>__RunWait

Func __Android_GenerateProductID($sDeviceModel, $sDeviceID)
	_Crypt_Startup()
	Local $sData, $aChar, $sProductID = ""
	$sData = _Crypt_HashData($sDeviceModel & $sDeviceID, $CALG_MD5)
	$aChar = StringSplit(Hex(BitXOR(Dec(StringMid($sData, 3, 8)), Dec(StringRight($sData, 8))), 8), "")
	For $i = 1 To $aChar[0]
		If StringInStr("ABCDEF", $aChar[$i]) Then
			$sProductID &= Chr(Asc($aChar[$i]) - 17)
		Else
			$sProductID &= $aChar[$i]
		EndIf
	Next
	While StringLeft($sProductID, 1) = "0"
		$sProductID = StringMid($sProductID, 2) & "0"
		If StringLeft($sProductID, 1) <> "0" Then ExitLoop
	WEnd
	_Crypt_Shutdown()
	Return $sProductID
EndFunc   ;==>__Android_GenerateProductID

Func __Android_GetBatteryInfo($sBatteryReceiver)
	Local $sOutput
	If Not _Android_IsDeviceOnline() Then Return SetError(1, 0, "Unknown")
	$sOutput = StringStripWS(__Run("@echo off && for /f ""tokens=2 delims=:"" %i in ('adb shell ""dumpsys battery"" ^| find /i """ & $sBatteryReceiver & """') do echo.%i"), 3)
	Return $sOutput
EndFunc   ;==>__Android_GetBatteryInfo

Func __URLEncode($sURL)
	Local $aChar, $sEncode = ""
	$aChar = StringSplit($sURL, "")
	For $i = 1 To $aChar[0]
		If Not StringInStr("$-_.+!*'(),;/?:@=&abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890", $aChar[$i]) Then
			$sEncode &= "%" & Hex(Asc($aChar[$i]), 2)
		Else
			$sEncode &= $aChar[$i]
		EndIf
	Next
	Return $sEncode
EndFunc   ;==>__URLEncode
