Class extends OTP
property after : Real
property before : Real
property period : Real

Class constructor($secret : Text; $opt : Object)
	ASSERT:C1129(Count parameters:C259>=1)
	ASSERT:C1129(Count parameters:C259<=2)
	
	Super:C1705($secret; $opt)
	This:C1470._optSet($opt; "period"; Is real:K8:4; 30)
	This:C1470._optSet($opt; "before"; Is real:K8:4; 1)
	This:C1470._optSet($opt; "after"; Is real:K8:4; 1)
	
Function at($timestamp : Integer)->$return : Integer
	$return:=This:C1470.generateOTP(This:C1470.timecode($timestamp))
	
Function now()->$return : Integer
	$return:=This:C1470.generateOTP(This:C1470.timecode(time_))
	
Function verify($otp : Integer; $timestamp : Integer)->$return : Boolean
	ASSERT:C1129(Count parameters:C259>=1)
	ASSERT:C1129(Count parameters:C259<=2)
	If (Count parameters:C259<2)
		$timestamp:=time_
	End if 
	
	$return:=($otp=This:C1470.at($timestamp))
	If (Not:C34($return))
		If (This:C1470.before>0)  // support only one period for the moment
			$return:=($otp=This:C1470.at($timestamp-This:C1470.period))
			// Here we could register the drift for later call
		End if 
	End if 
	If (Not:C34($return))
		If (This:C1470.after>0)  // support only one period for the moment
			$return:=($otp=This:C1470.at($timestamp+This:C1470.period))
			// Here we could register the drift for later call
		End if 
	End if 
	
Function provisioningUri($issuer : Text)->$url : Text
	$url:="otpauth://totp/"+urlencode($issuer)+"?secret="+This:C1470.secret
	If (This:C1470.period#30)
		$url:=$url+"&period="+String:C10(This:C1470.period)  // not managed by all ap
	End if 
	
Function timecode($timestamp : Integer)->$timecode : Integer
	$timecode:=($timestamp\This:C1470.period)  // trims any remainder