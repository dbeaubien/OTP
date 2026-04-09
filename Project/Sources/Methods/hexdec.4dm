//%attributes = {"invisible":true}
#DECLARE($input : Text)->$result : Integer
$result:=0

var $lLength; $lDigitValue; $i : Integer
$lLength:=Length:C16($input)
For ($i; $lLength; 1; -1)
	
	Case of 
		: ($input[[$i]]="F")
			$lDigitValue:=15
		: ($input[[$i]]="E")
			$lDigitValue:=14
		: ($input[[$i]]="D")
			$lDigitValue:=13
		: ($input[[$i]]="C")
			$lDigitValue:=12
		: ($input[[$i]]="B")
			$lDigitValue:=11
		: ($input[[$i]]="A")
			$lDigitValue:=10
		: ($input[[$i]]="9")
			$lDigitValue:=9
		: ($input[[$i]]="8")
			$lDigitValue:=8
		: ($input[[$i]]="7")
			$lDigitValue:=7
		: ($input[[$i]]="6")
			$lDigitValue:=6
		: ($input[[$i]]="5")
			$lDigitValue:=5
		: ($input[[$i]]="4")
			$lDigitValue:=4
		: ($input[[$i]]="3")
			$lDigitValue:=3
		: ($input[[$i]]="2")
			$lDigitValue:=2
		: ($input[[$i]]="1")
			$lDigitValue:=1
		Else 
			$lDigitValue:=0
	End case 
	
	If ($lDigitValue>0)
		$result:=$result+(($lDigitValue)*(16^($lLength-$i)))
	End if 
	
End for 
