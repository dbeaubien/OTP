property functions : Collection

Class constructor
	This:C1470.functions:=[]  // CANNOT FIND autommatically test_ functions by name or annotation using 4d
	
Function beforeClass
	
Function afterClass
	
Function beforeTest
	
Function afterTest
	
Function run()
	This:C1470.beforeClass()
	var $function : Object
	For each ($function; This:C1470.functions)
		This:C1470.beforeTest()
		$function.call(This:C1470)
		This:C1470.afterTest()
	End for each 
	This:C1470.afterClass()
	
Function assertEquals($value_1 : Variant; $value_2 : Variant; $message : Text)
	
	If (Count parameters:C259<=2)
		$message:="'"+This:C1470._toString($value_2)+"' not equals to expected '"+This:C1470._toString($value_1)+"'"
	End if 
	
	Case of 
		: (Value type:C1509($value_1)=Is object:K8:27)
			ASSERT:C1129(Value type:C1509($value_2)=Is object:K8:27; $message)
			ASSERT:C1129(New collection:C1472($value_1).equal(New collection:C1472($value_2)); $message)
		: (Value type:C1509($value_2)=Is object:K8:27)
			ASSERT:C1129(False:C215; $message)
		: (Value type:C1509($value_1)=Is collection:K8:32)
			ASSERT:C1129(Value type:C1509($value_2)=Is collection:K8:32)
			ASSERT:C1129($value_1.equal($value_2); $message)
		: (Value type:C1509($value_2)=Is collection:K8:32)
			ASSERT:C1129(False:C215; $message)
		Else 
			ASSERT:C1129($value_1)
	End case 
	
	
Function _toString($var : Variant)->$result : Text
	Case of 
		: (Value type:C1509($var)=Is collection:K8:32)
			$result:=JSON Stringify:C1217($var)
		: (Value type:C1509($var)=Is object:K8:27)
			$result:=JSON Stringify:C1217($var)
		: (Value type:C1509($var)=Is BLOB:K8:12)
			$result:="Blob[size="+String:C10(BLOB size:C605($var))+",utf8"+BLOB to text:C555($var; UTF8 text without length:K22:17)+"]"
		Else 
			$result:=String:C10($var)
	End case 
	
	