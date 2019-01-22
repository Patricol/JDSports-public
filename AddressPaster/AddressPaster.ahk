; Address Paster
; Descriptions and some functions and static variables have been REDACTED from this public version.

VersionNumber := "25p"
DelayScale := 1


#NoEnv

SendMode Input
SetWorkingDir %A_ScriptDir%

#singleinstance force

; Static Vars
BBBBillingEmail := "REDACTED"
TRUSBillingEmail := "REDACTED"
CostcoShippingEmail := "REDACTED"
BillingFirstName := "REDACTED"
BillingLastName := "REDACTED"
BillingStreet1 := "REDACTED"
BillingStreet2 := "REDACTED"
BillingCity := "REDACTED"
BillingFullLowerState := "REDACTED"
BillingStateAbbreviation := "REDACTED"
BillingZip := "REDACTED"

OfficePhone1 := "REDACTED"
OfficePhone2 := "REDACTED"
OfficePhone3 := "REDACTED"
FakePhone1 := "REDACTED"
FakePhone2 := "REDACTED"
FakePhone3 := "REDACTED"
FakeFullPhone = %FakePhone1%-%FakePhone2%-%FakePhone3%
BillingFullPhoneNoDash = %OfficePhone1%%OfficePhone2%%OfficePhone3%

createStateDictionaries() {
  global

  ; Keeping these as redundant static lists because using one to make the others was actually trickier to maintain in this narrow usecase.

  StateFullFromAnySpacelessUpper := {"AA":"Armed Forces Americas", "ARMEDFORCESAMERICAS":"Armed Forces Americas", "AE":"Armed Forces other", "ARMEDFORCESOTHER":"Armed Forces other", "AK":"Alaska", "ALASKA":"Alaska", "AL":"Alabama", "ALABAMA":"Alabama", "AP":"Armed Forces Pacific", "ARMEDFORCESPACIFIC":"Armed Forces Pacific", "AR":"Arkansas", "ARKANSAS":"Arkansas", "AS":"American Samoa", "AMERICANSAMOA":"American Samoa", "AZ":"Arizona", "ARIZONA":"Arizona", "CA":"California", "CALIFORNIA":"California", "CO":"Colorado", "COLORADO":"Colorado", "CT":"Connecticut", "CONNECTICUT":"Connecticut", "DC":"District of Columbia", "DISTRICTOFCOLUMBIA":"District of Columbia", "DE":"Delaware", "DELAWARE":"Delaware", "FL":"Florida", "FLORIDA":"Florida", "GA":"Georgia", "GEORGIA":"Georgia", "GU":"Guam", "GUAM":"Guam", "HI":"Hawaii", "HAWAII":"Hawaii", "IA":"Iowa", "IOWA":"Iowa", "ID":"Idaho", "IDAHO":"Idaho", "IL":"Illinois", "ILLINOIS":"Illinois", "IN":"Indiana", "INDIANA":"Indiana", "KS":"Kansas", "KANSAS":"Kansas", "KY":"Kentucky", "KENTUCKY":"Kentucky", "LA":"Louisiana", "LOUISIANA":"Louisiana", "MA":"Massachusetts", "MASSACHUSETTS":"Massachusetts", "MD":"Maryland", "MARYLAND":"Maryland", "ME":"Maine", "MAINE":"Maine", "MI":"Michigan", "MICHIGAN":"Michigan", "MN":"Minnesota", "MINNESOTA":"Minnesota", "MO":"Missouri", "MISSOURI":"Missouri", "MP":"N. Mariana Islands", "NMARIANAISLANDS":"N. Mariana Islands", "MS":"Mississippi", "MISSISSIPPI":"Mississippi", "MT":"Montana", "MONTANA":"Montana", "NC":"North Carolina", "NORTHCAROLINA":"North Carolina", "ND":"North Dakota", "NORTHDAKOTA":"North Dakota", "NE":"Nebraska", "NEBRASKA":"Nebraska", "NH":"New Hampshire", "NEWHAMPSHIRE":"New Hampshire", "NJ":"New Jersey", "NEWJERSEY":"New Jersey", "NM":"New Mexico", "NEWMEXICO":"New Mexico", "NV":"Nevada", "NEVADA":"Nevada", "NY":"New York", "NEWYORK":"New York", "OH":"Ohio", "OHIO":"Ohio", "OK":"Oklahoma", "OKLAHOMA":"Oklahoma", "OR":"Oregon", "OREGON":"Oregon", "PA":"Pennsylvania", "PENNSYLVANIA":"Pennsylvania", "PR":"Puerto Rico", "PUERTORICO":"Puerto Rico", "PW":"Palau", "PALAU":"Palau", "RI":"Rhode Island", "RHODEISLAND":"Rhode Island", "SC":"South Carolina", "SOUTHCAROLINA":"South Carolina", "SD":"South Dakota", "SOUTHDAKOTA":"South Dakota", "TN":"Tennessee", "TENNESSEE":"Tennessee", "TX":"Texas", "TEXAS":"Texas", "UT":"Utah", "UTAH":"Utah", "VA":"Virginia", "VIRGINIA":"Virginia", "VI":"Virgin Islands", "VIRGINISLANDS":"Virgin Islands", "VT":"Vermont", "VERMONT":"Vermont", "WA":"Washington", "WASHINGTON":"Washington", "WI":"Wisconsin", "WISCONSIN":"Wisconsin", "WV":"West Virginia", "WESTVIRGINIA":"West Virginia", "WY":"Wyoming", "WYOMING":"Wyoming"}

  StateAbbreviationFromAnySpacelessUpper := {"AA":"AA", "ARMEDFORCESAMERICAS":"AA", "AE":"AE", "ARMEDFORCESOTHER":"AE", "AK":"AK", "ALASKA":"AK", "AL":"AL", "ALABAMA":"AL", "AP":"AP", "ARMEDFORCESPACIFIC":"AP", "AR":"AR", "ARKANSAS":"AR", "AS":"AS", "AMERICANSAMOA":"AS", "AZ":"AZ", "ARIZONA":"AZ", "CA":"CA", "CALIFORNIA":"CA", "CO":"CO", "COLORADO":"CO", "CT":"CT", "CONNECTICUT":"CT", "DC":"DC", "DISTRICTOFCOLUMBIA":"DC", "DE":"DE", "DELAWARE":"DE", "FL":"FL", "FLORIDA":"FL", "GA":"GA", "GEORGIA":"GA", "GU":"GU", "GUAM":"GU", "HI":"HI", "HAWAII":"HI", "IA":"IA", "IOWA":"IA", "ID":"ID", "IDAHO":"ID", "IL":"IL", "ILLINOIS":"IL", "IN":"IN", "INDIANA":"IN", "KS":"KS", "KANSAS":"KS", "KY":"KY", "KENTUCKY":"KY", "LA":"LA", "LOUISIANA":"LA", "MA":"MA", "MASSACHUSETTS":"MA", "MD":"MD", "MARYLAND":"MD", "ME":"ME", "MAINE":"ME", "MI":"MI", "MICHIGAN":"MI", "MN":"MN", "MINNESOTA":"MN", "MO":"MO", "MISSOURI":"MO", "MP":"MP", "NMARIANAISLANDS":"MP", "MS":"MS", "MISSISSIPPI":"MS", "MT":"MT", "MONTANA":"MT", "NC":"NC", "NORTHCAROLINA":"NC", "ND":"ND", "NORTHDAKOTA":"ND", "NE":"NE", "NEBRASKA":"NE", "NH":"NH", "NEWHAMPSHIRE":"NH", "NJ":"NJ", "NEWJERSEY":"NJ", "NM":"NM", "NEWMEXICO":"NM", "NV":"NV", "NEVADA":"NV", "NY":"NY", "NEWYORK":"NY", "OH":"OH", "OHIO":"OH", "OK":"OK", "OKLAHOMA":"OK", "OR":"OR", "OREGON":"OR", "PA":"PA", "PENNSYLVANIA":"PA", "PR":"PR", "PUERTORICO":"PR", "PW":"PW", "PALAU":"PW", "RI":"RI", "RHODEISLAND":"RI", "SC":"SC", "SOUTHCAROLINA":"SC", "SD":"SD", "SOUTHDAKOTA":"SD", "TN":"TN", "TENNESSEE":"TN", "TX":"TX", "TEXAS":"TX", "UT":"UT", "UTAH":"UT", "VA":"VA", "VIRGINIA":"VA", "VI":"VI", "VIRGINISLANDS":"VI", "VT":"VT", "VERMONT":"VT", "WA":"WA", "WASHINGTON":"WA", "WI":"WI", "WISCONSIN":"WI", "WV":"WV", "WESTVIRGINIA":"WV", "WY":"WY", "WYOMING":"WY"}

  SamsClubStates := ["AA", "AE", "AK", "AL", "AP", "AR", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VT", "WA", "WI", "WV", "WY"]

  KinseysStates := ["Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona", "California", "Colorado", "Connecticut", "District of Columbia", "Delaware", "Florida", "Georgia", "Guam", "Hawaii", "Iowa", "Idaho", "Illinois", "Indiana", "Kansas", "Kentucky", "Louisiana", "Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Northern Mariana Islands", "Mississippi", "Montana", "North Carolina", "North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "United States Minor Outlying Islands", "Utah", "Virginia", "Virgin Islands, U.S.", "Vermont", "Washington", "Wisconsin", "West Virginia", "Wyoming"]

  return
}


saveClipboard() {
  global
  InitialClipboard := ClipboardAll
  return
}

restoreClipboard() {
  global
  Clipboard := InitialClipboard
  return
}

clearClipboard() {
  global
  Clipboard =
  ClipWait, 0
  return
}

releaseModifierKeys() {
  Send {CtrlUp}
  Send {AltUp}
  return
}

basicSleep(MinorDelayScale:=1) {
  global
  Sleep ((MinorDelayScale*80)*DelayScale)
  return
}

tabSleep(MinorDelayScale:=1) {
  global
  Send {Tab}
  basicSleep(MinorDelayScale)
  return
}

copyAndReturnSelected() {
  global
  Clipboard =
  Send ^c
  ClipWait, 0
  basicSleep()
  return Clipboard
}

pasteVar(Var) {
  global
  Clipboard =
  Clipboard := Var
  ClipWait, 0
  Send ^v
  basicSleep()
  return
}

RemoveSymbols(Var) {
  global
  ; Removes characters that are not alphanumeric or spaces.
  CleanVar := RegExReplace(Var, "[^a-zA-Z0-9 ]", "")
  return CleanVar
}

typeVar(Var) {
  global
  if (Var = "") ; Check if the var exists first.
  {
    return
  }
  SendRaw, %Var% ; Type the letters one-by-one.
  basicSleep()
  return
}

typeVarIntoDropdown(Var) {
  global
  typeVar(Var)
  basicSleep(4)
  return
}

setClipboard(Var) {
  global
  Clipboard =
  Clipboard := Var
  ClipWait, 0
  basicSleep()
  return
}

pasteClipboard() {
  global
  Send ^v
  basicSleep()
  return
}

pasteEmpty() {
  ; Safer than backspace.
  global
  clearClipboard()
  pasteClipboard()
  return
}


changeDelay(NewDelayScale) {
  global
  if NewDelayScale in 1,2,3,4,5,10
  {
    DelayScale := NewDelayScale
  }
  return
}

StateAnyToStateAnySpacelessUpper(StateAny) {
  global
  StringUpper, StateAnyUpper, StateAny
  StateAnySpacelessUpper := RegExReplace(StateAnyUpper, "[^A-Z]", "")
  return StateAnySpacelessUpper
}

StateAnyToStateAbbreviation(StateAny) {
  global
  StateAnySpacelessUpper := StateAnyToStateAnySpacelessUpper(StateAny)
  StateAbbreviation := StateAbbreviationFromAnySpacelessUpper[StateAnySpacelessUpper]
  return StateAbbreviation
}

StateAnyToStateFull(StateAny) {
  global
  StateAnySpacelessUpper := StateAnyToStateAnySpacelessUpper(StateAny)
  StateFull := StateFullFromAnySpacelessUpper[StateAnySpacelessUpper]
  return StateFull
}

StateAnyToStateFullLower(StateAny) {
  global
  StateFull := StateAnyToStateFull(StateAny)
  StringLower, StateFullLower, StateFull
  return StateFullLower
}


GetIndexOfItemInArray(array, item, case_sensitive:=false) {
	for i, val in array {
		if (case_sensitive ? (val == item) : (val = item))
			return i
	}
}

GetIndexOfFirstItemSharingFirstLetterInArray(array, item, case_sensitive:=false) {
  FirstLetterToFind := SubStr(item, 1, 1)
	for i, val in array {
    FirstLetterOfVal := SubStr(val, 1, 1)
		if (case_sensitive ? (FirstLetterOfVal == FirstLetterToFind) : (FirstLetterOfVal = FirstLetterToFind))
			return i
	}
}

GetPositionsSeparatingItemInArrayFromFirstArrayEntrySharingItemsFirstLetter(array, item) {
  ; Needed for dealing with terribly designed state dropdown boxes.
  return GetIndexOfItemInArray(array, item) - GetIndexOfFirstItemSharingFirstLetterInArray(array, item)
}

SelectFromDropdownOnlyTypingFirstLetter(array, item) {
  FirstLetter := SubStr(item, 1, 1)
  typeVar(FirstLetter)
  TimesToLoop := GetPositionsSeparatingItemInArrayFromFirstArrayEntrySharingItemsFirstLetter(array, item)
  Loop %TimesToLoop%
  {
    basicSleep()
    Send {Down}
  }
  return
}

ResetStateDropdownOnlyTypingFirstLetter() {
  ; Resets the contents of the box in a reliable way.
  ; The letter must be something that is the start of only one entry, so that the up brings it to the end of the previous occupied letter.
  ; That way, any letter will bring the selection to the first entry starting with that letter.
  ; Note that this won't work with every implementation of a dropdown, and was indeed specifically made to work around terrible implementations.
  typeVar("f") ; This and the Up resets the status of the box in a reliable way.
  basicSleep()
  Send {Up}
  basicSleep()
}

SelectSamsClubState(StateAbbreviation) {
  global
  ResetStateDropdownOnlyTypingFirstLetter()
  SelectFromDropdownOnlyTypingFirstLetter(SamsClubStates, StateAbbreviation)
  basicSleep()
  Send {Enter}
  return
}

SelectKinseysState(FullLowerState) {
  ; Space resets the field and messes things up.
  global
  if (InStr(FullLowerState, " ")) {
    ResetStateDropdownOnlyTypingFirstLetter()
    SelectFromDropdownOnlyTypingFirstLetter(KinseysStates, FullLowerState)
  } else {
    typeVarIntoDropdown(FullLowerState)
  }
  return
}


LastWordFromString(InputString) {
  StringArray := StrSplit(InputString, A_Space)
  LastWord := StringArray[StringArray.MaxIndex()]
  return LastWord
}

SplitName() {
  global
  LastName := LastWordFromString(FullName)
  StringTrimRight, FirstNameWithSpace, FullName, StrLen(LastName)
  FirstName := Trim(FirstNameWithSpace) ; Avoids errors if FullName has no spaces.
  if (FirstName = "")
  {
    FirstName := LastName ; Was told to handle single word name by entering it as both first and last when there are two fields.
  }
  FirstNameUpTo25 := FirstName ; So that it will paste correctly if it's not a long name.
  LastNameUpTo25 := LastName ; So that it will paste correctly if it's not a long name.
  if (StrLen(FirstName) > 25) ; If the first name is too long, move the rest of it to the start of the last name.
  {
    ExtraNamePart := SubStr(FirstName, 26)
    FirstNameUpTo25 := SubStr(FirstName, 1, 25)
    LastNameUpTo25 := ExtraNamePart . LastName
  }
  if (StrLen(LastName) > 25) ; If the last name is too long, move the rest of it to the end of the first name.
  {
    ExtraNamePart := SubStr(LastName, 1, -25)
    LastNameUpTo25 := SubStr(LastName, -24, 25)
    FirstNameUpTo25 := FirstName . ExtraNamePart
  }
  if (StrLen(FullName) > 50) ; If the whole name is too long, set the first and last names as the first and last 25 characters.
  {
    FirstNameUpTo25 := SubStr(FullName, 1, 25)
    LastNameUpTo25 := SubStr(FullName, -24, 25)
  }
  return
}

RawPhoneToPhoneParts() {
  global
  StrippedRawPhone := RegExReplace(RawPhone, "[^0-9]", "")
  HasLeadingOne := 0
  if not (StrLen(StrippedRawPhone) = 10)
  {
    if (SubStr(StrippedRawPhone, 1, 1) = 1)
    {
      HasLeadingOne := 1
    }
  }
  Phone1 := SubStr(StrippedRawPhone, HasLeadingOne+1, 3)
  Phone2 := SubStr(StrippedRawPhone, HasLeadingOne+4, 3)
  Phone3 := SubStr(StrippedRawPhone, HasLeadingOne+7, 4)
  return
}


openDelayBox() {
  global
  InputBox, NewDelayScale, Change Delay Scale for AddressPaster, Please input a new scale for the delays used throughout this program.`nHigher numbers increase reliability by slowing down the operations that AddressPaster performs.`nThe valid options are 1`,2`,3`,4`,5`, and 10.,,,,,,,, 1
  IfMsgBox, OK
    basicSleep(5) ; Necessary, or functionality breaks.
    changeDelay(NewDelayScale)
  return
}


openDoneMessage(Title) {
  SplashTextOn, 50, 20, %Title%, Done!
  Sleep, 1000
  SplashTextOff
  return
}

openPastingDoneMessage() {
  openDoneMessage("Pasting")
  return
}

openCopyingDoneMessage() {
  openDoneMessage("Copying")
  return
}


StartAnyFunction() {
  global
  saveClipboard()
  basicSleep(2)
  return
}

StartCopyFunction() {
  global
  StartAnyFunction()
  ; Clear all the non-intermediate variables.
  Copied_FullName := ""
  Copied_Street1 := ""
  Copied_Street2 := ""
  Copied_City := ""
  Copied_State := ""
  Copied_Zip := ""
  Copied_Phone1 := ""
  Copied_Phone2 := ""
  Copied_Phone3 := ""
  FullName := ""
  Street1 := ""
  Street2 := ""
  City := ""
  State := ""
  Zip := ""
  Phone1 := ""
  Phone2 := ""
  Phone3 := ""
  FirstName := ""
  LastName := ""
  FullLowerState := ""
  FullPhone := ""
  return
}

StartPasteFunction() {
  global
  StartAnyFunction()
  return
}

EndAnyFunction() {
  global
  restoreClipboard()
  releaseModifierKeys()
  return
}

EndCopyFunction() {
  global
  ; Set Copied_ Variables. (Used by the Help Box.)
  Copied_FullName := RemoveSymbols(FullName)
  Copied_Street1 := Street1
  Copied_Street2 := Street2
  Copied_City := City
  Copied_State := State
  Copied_Zip := Zip
  Copied_Phone1 := Phone1
  Copied_Phone2 := Phone2
  Copied_Phone3 := Phone3
  if (Copied_Phone1 = "") && (Copied_Phone2 = "") && (Copied_Phone3 = "")
  {
    ; No phone number pulled, so default to the office phone number.
    Copied_Phone1 := OfficePhone1
    Copied_Phone2 := OfficePhone2
    Copied_Phone3 := OfficePhone3 . " (Defaulted to Office #)"
    Phone1 := OfficePhone1
    Phone2 := OfficePhone2
    Phone3 := OfficePhone3
  }
  ; Make it create extra variables and format existing ones.
  FullName := RemoveSymbols(FullName)
  SplitName() ; Sets FirstName, LastName, FirstNameUpTo25, and LastNameUpTo25.
  State := StateAnyToStateFull(State) ; Default State format.
  FullLowerState := StateAnyToStateFullLower(State) ; For selecting from dropdowns.
  StateAbbreviation := StateAnyToStateAbbreviation(State) ; For selecting from certain other dropdowns.
  FullPhone = %Phone1%-%Phone2%-%Phone3% ; note that it's "=", not ":=".
  FullPhoneNoDash = %Phone1%%Phone2%%Phone3% ; note that it's "=", not ":=".

  openCopyingDoneMessage()
  EndAnyFunction()
  return
}

EndPasteFunction() {
  global
  openPastingDoneMessage()
  EndAnyFunction()
  return
}



openHelpBox() { ; Ctrl + Alt + H
  global
  ; Don't use StartAnyFunction/EndAnyFunction because future versions of them might have sleeps.
  saveClipboard()
  ; Tells version, var values, delays, and gives options to scale delays.
  MsgBox, 260, AddressPaster Help,
(
This is Version %VersionNumber% of AddressPaster.

This is a non-functional, public version of AddressPaster.


The hotkeys are:
`tCtrl + Alt + C: Copy from Amazon
`tCtrl + Alt + N: Copy from Amazon (Alternate)
`tCtrl + Alt + E: Copy from eBay
`tCtrl + Alt + S: Copy from ShipStation

`tCtrl + Alt + A: Paste into Amazon
`tCtrl + Alt + W: Paste into Walmart
`tCtrl + Alt + B: Paste into Bed Bath & Beyond Shipping Address
`tCtrl + Alt + Y: Paste into Bed Bath & Beyond Billing Address
`tCtrl + Alt + K: Paste into Kinseys
`tCtrl + Alt + G: Paste into Green Supply
`tCtrl + Alt + J: Paste into Sam's Club
`tCtrl + Alt + M: Paste into Kmart
`tCtrl + Alt + T: Paste into Costco

`tCtrl + Alt + P: Paste in one line
`tCtrl + Alt + H: Open this Help Menu
`tCtrl + Alt + L: Release stuck Ctrl and Alt keys and restart


The pieces of the currently stored address are as follows:
`tName =`t`t%Copied_FullName%
`tStreet (Line 1) =`t%Copied_Street1%
`tStreet (Line 2) =`t%Copied_Street2%
`tCity =`t`t%Copied_City%
`tState =`t`t%Copied_State%
`tZIP Code =`t%Copied_Zip%
`tPhone Number =`t%Copied_Phone1% %Copied_Phone2% %Copied_Phone3%

Special characters will be removed when pasting into certain fields.

If copying doesn't work for a specific page even when the Delay Scale is set to 10, please email Patrick a screenshot of that page.

The Delay Scale is set to %DelayScale%.

Would you like to change the Delay Scale to improve reliability or speed?
)
  IfMsgBox, Yes
    openDelayBox()
  releaseModifierKeys()
  restoreClipboard()
  return
}



reloadAndRelease() { ; Ctrl + Alt + L
  Reload
  releaseModifierKeys()
}

pasteData() { ; Ctrl + Alt + P
  global
  StartPasteFunction()
  pasteVar(FullName)
  Send {space}
  pasteVar(Street1)
  Send {space}
  pasteVar(Street2)
  Send {space}
  pasteVar(City)
  Send {space}
  pasteVar(State)
  Send {space}
  pasteVar(Zip)
  Send {space}
  pasteVar(FullPhone)
  EndPasteFunction()
  return
}


copyDataFromAmazon() { ; Ctrl + Alt + C (or N)
  ; REDACTED
  return
}


copyDataFromEbay() { ; Ctrl + Alt + E
  ; REDACTED
  return
}


copyDataFromShipStation() { ; Ctrl + Alt + S
  ; REDACTED
  return
}


pasteDataIntoAmazon() { ; Ctrl + Alt + A
  ; REDACTED
  return
}


pasteDataIntoWalmart() { ; Ctrl + Alt + W
  ; REDACTED
  return
}


pasteDataIntoCollectionsEtc() {
  ; REDACTED
  return
}


pasteDataIntoNewToysRUs() {
  global
  StartPasteFunction()
  Send ^a
  basicSleep()
  pasteVar(FirstName)
  tabSleep(2)
  pasteVar(LastName)
  tabSleep(2)
  pasteVar(Street1)
  tabSleep(2)
  pasteVar(Street2)
  tabSleep(2)
  pasteVar(City)
  tabSleep(4)
  typeVarIntoDropdown(StateAbbreviation)
  tabSleep(4)
  pasteVar(Zip)
  tabSleep(4)
  pasteVar(FullPhoneNoDash)
  tabSleep(4) ; So the phone field isn't red at the end.
  EndPasteFunction()
  return
}

pasteDataIntoNewToysRUsBilling() {
  global
  StartPasteFunction()
  Send ^a
  basicSleep()
  pasteVar(BillingFirstName)
  tabSleep()
  pasteVar(BillingLastName)
  tabSleep()
  pasteVar(BillingStreet1)
  tabSleep()
  pasteVar(BillingStreet2)
  tabSleep()
  pasteVar(BillingCity)
  tabSleep()
  typeVarIntoDropdown(BillingStateAbbreviation)
  tabSleep()
  typeVar(BillingZip) ; Can't paste into this box.
  tabSleep()
  typeVar(BillingFullPhoneNoDash) ; Can't paste into this box.
  tabSleep()
  pasteVar(TRUSBillingEmail)
  tabSleep() ; So the email field isn't red at the end.
  EndPasteFunction()
  return
}

pasteDataIntoOldToysRUsBilling() {
  global
  StartPasteFunction()
  Send ^a
  basicSleep()
  pasteVar(FirstName)
  tabSleep()
  pasteVar(LastName)
  tabSleep()
  pasteVar(Street1)
  tabSleep()
  pasteVar(Street2)
  tabSleep()
  pasteVar(City)
  tabSleep()
  typeVarIntoDropdown(StateAbbreviation)
  tabSleep()
  typeVar(Zip) ; Can't paste into this box.
  tabSleep()
  typeVar(FullPhone) ; Can't paste into this box.
  tabSleep()
  pasteVar(TRUSBillingEmail)
  EndPasteFunction()
  return
}

pasteDataIntoOldToysRUsShipping() {
  global
  StartPasteFunction()
  Send ^a
  basicSleep()
  pasteVar(FirstName)
  tabSleep()
  pasteVar(LastName)
  tabSleep()
  tabSleep() ; Skipping Country.
  pasteVar(Street1)
  tabSleep()
  pasteVar(Street2)
  tabSleep()
  pasteVar(City)
  tabSleep()
  typeVarIntoDropdown(StateAbbreviation)
  tabSleep()
  typeVar(Zip) ; Can't paste into this box.
  tabSleep()
  typeVar(FullPhone) ; Can't paste into this box.
  EndPasteFunction()
  return
}

pasteDataIntoOldToysRUsMultiple() {
  global
  StartPasteFunction()
  Send ^a
  basicSleep()
  pasteVar(FirstName)
  tabSleep()
  pasteVar(LastName)
  tabSleep()
  pasteVar(Street1)
  tabSleep()
  pasteVar(Street2)
  tabSleep()
  pasteVar(City)
  tabSleep()
  typeVarIntoDropdown(StateAbbreviation)
  tabSleep()
  typeVar(Zip) ; Can't paste into this box.
  tabSleep()
  typeVar(FullPhone) ; Can't paste into this box.
  EndPasteFunction()
  return
}


pasteDataIntoBedBathBeyondShipping() { ; Ctrl + Alt + B
  ; REDACTED
  return
}


pasteDataIntoBedBathBeyondBilling() { ; Ctrl + Alt + Y
  ; REDACTED
  return
}


pasteDataIntoKinseys() { ; Ctrl + Alt + K
  ; REDACTED
  return
}


pasteDataIntoGreenSupply() { ; Ctrl + Alt + G
  ; REDACTED
  return
}


pasteDataIntoSamsClub() { ; Ctrl + Alt + J
  ; REDACTED
  return
}


pasteDataIntoKmart() { ; Ctrl + Alt + M
  ; REDACTED
  return
}


pasteDataIntoCostco() { ; Ctrl + Alt + T
  ; REDACTED
  return
}



createStateDictionaries()
openHelpBox() ; Update hotkeys in the Help Menu if you add/change any.


; Release modifier keys and reload the script.
^!l::
reloadAndRelease()
return

; Open Help Box.
^!h Up::
openHelpBox()
return

; Copy Data from eBay.
^!e Up::
copyDataFromEbay()
return

; Copy Data from Amazon.
^!c Up::
copyDataFromAmazon()
return

; Copy Data from ShipStation.
^!s Up::
copyDataFromShipStation()
return

; Copy Data from Amazon. (Alternate)
^!n Up::
copyDataFromAmazon()
return

; Paste Data into Amazon.
^!a Up::
pasteDataIntoAmazon()
return

; Paste Data into Walmart.
^!w Up::
pasteDataIntoWalmart()
return

; Paste Data into Bed Bath & Beyond Shipping Address.
^!b Up::
pasteDataIntoBedBathBeyondShipping()
return

; Paste Data into Bed Bath & Beyond Billing Address.
^!y Up::
pasteDataIntoBedBathBeyondBilling()
return

; Paste Data into Kinseys.
^!k Up::
pasteDataIntoKinseys()
return

; Paste Data into Green Supply.
^!g Up::
pasteDataIntoGreenSupply()
return

; Paste Data into Sam's Club.
^!j Up::
pasteDataIntoSamsClub()
return

; Paste Data into Kmart.
^!m Up::
pasteDataIntoKmart()
return

; Paste Data into Costco.
^!t Up::
pasteDataIntoCostco()
return

; Paste Data into Costco. (Backup for development; Ctrl + Alt + T opens a terminal on my machine.)
^!u Up::
pasteDataIntoCostco()
return

; Test Paste.
^!p Up::
pasteData()
return
