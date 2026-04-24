//%attributes = {"invisible":true}
//%attributes = {}
#DECLARE($object : Object)
var $class : Object:=OB Class:C1730($object)  // new instance to singletonize

If ($class.instance=Null:C1517)
	
	Use ($class)
		$class.instance:=OB Copy:C1225($object; ck shared:K85:29; $class)
		
		Use ($class)
			$class._new:=This:C1470.new
			$class.new:=Formula:C1597(This:C1470.instance)
		End use 
		
	End use 
	
End if 