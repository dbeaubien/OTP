// Original code from https://discuss.4d.com/t/base32-encode-decode-in-native-4d/11129/4

Class constructor
	singletonize(This:C1470)
	
	
Function encodeText($text : Text; $include_padding : Boolean)->$encoded_text : Text
	var $blob : Blob
	If (Count parameters:C259=1)
		$include_padding:=True:C214
	End if 
	TEXT TO BLOB:C554($text; $blob; UTF8 text without length:K22:17)
	$encoded_text:=This:C1470.encode($blob; $include_padding)
	
	
Function encode($blob : Blob; $include_padding : Boolean)->$encoded : Text
	If (Count parameters:C259=1)
		$include_padding:=True:C214  // default padding
	End if 
	
	var $alfa : Text
	$alfa:="ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
	
	var $i; $index : Integer
	var $next_byte; $numBitsLeftOver : Integer
	var $fiveBits; $shiftToGet5Bits : Integer
	
	$index:=0
	$numBitsLeftOver:=0
	For ($i; 1; BLOB size:C605($blob))
		$next_byte:=($next_byte << 8)+$blob{$index}  // fetch a single byte from the input blob
		$numBitsLeftOver:=$numBitsLeftOver+8
		
		While ($numBitsLeftOver>=5)
			$shiftToGet5Bits:=($numBitsLeftOver-5)
			
			$fiveBits:=($next_byte >> $shiftToGet5Bits)+1  // get high 5 bits
			If ($fiveBits>0) & ($fiveBits<=Length:C16($alfa))
				$encoded:=$encoded+$alfa[[$fiveBits]]
			End if 
			
			$numBitsLeftOver:=$numBitsLeftOver-5
			Case of 
				: ($numBitsLeftOver=0)
					$next_byte:=0
				: ($numBitsLeftOver=1)
					$next_byte:=$next_byte & (0x0001)
				: ($numBitsLeftOver=2)
					$next_byte:=$next_byte & (0x0003)
				: ($numBitsLeftOver=3)
					$next_byte:=$next_byte & (0x0007)
				: ($numBitsLeftOver=4)
					$next_byte:=$next_byte & (0x000F)
				: ($numBitsLeftOver=5)
					$next_byte:=$next_byte & (0x001F)
				: ($numBitsLeftOver=6)
					$next_byte:=$next_byte & (0x003F)
				: ($numBitsLeftOver=7)
					$next_byte:=$next_byte & (0x007F)
				: ($numBitsLeftOver=8)
					$next_byte:=$next_byte & (0x00FF)
				: ($numBitsLeftOver=9)
					$next_byte:=$next_byte & (0x01FF)
				: ($numBitsLeftOver=10)
					$next_byte:=$next_byte & (0x03FF)
				: ($numBitsLeftOver=11)
					$next_byte:=$next_byte & (0x07FF)
				: ($numBitsLeftOver=12)
					$next_byte:=$next_byte & (0x0FFF)
				Else 
					
			End case 
			
		End while 
		
		$index:=$index+1
	End for 
	
	// deal with any left over bits
	If ($numBitsLeftOver>0)
		$next_byte:=($next_byte << (5-$numBitsLeftOver))  // pad on right with 0's
		$fiveBits:=($next_byte & 0x001F)+1  // get high 5 bits
		$encoded:=$encoded+$alfa[[$fiveBits]]
	End if 
	
	If ($include_padding)
		If (Length:C16($encoded)%8#0)
			$encoded:=$encoded+("="*(8-(Length:C16($encoded)%8)))
		End if 
	End if 
	
	
Function decode($b32 : Text)->$blob : Blob
	SET BLOB SIZE:C606($blob; 0)
	
	var $alfa : Text
	var $z; $x; $i; $cc; $flt; $padc; $bf; $offset; $index : Integer
	
	$x:=Length:C16($b32)
	
	var $bits : Integer
	$bf:=0
	$bits:=0
	$padc:=0
	$alfa:="ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
	For ($i; 1; $x)
		If ($bits>=16)
			$flt:=$bits-16
			$cc:=($bf >> $flt) & 0xFFFF
			INTEGER TO BLOB:C548($cc; $blob; Macintosh byte ordering:K22:2; *)
			
			$bf:=$bf & ((2^$flt)-1)
			$bits:=$bits-16
		End if 
		$z:=Position:C15(Substring:C12($b32; $i; 1); $alfa)
		Case of 
			: ($z>0)
				$bf:=($bf << 5) | ($z-1)
				$bits:=$bits+5
			: (Substring:C12($b32; $i; 1)="=")
				$bf:=($bf << 5)
				$bits:=$bits+5
				$padc:=$padc+1
			Else 
		End case 
	End for 
	If ($bits>=16)
		$flt:=$bits-16
		$cc:=($bf >> $flt) & 0xFFFF
		INTEGER TO BLOB:C548($cc; $blob; Macintosh byte ordering:K22:2; *)
		
		$bf:=$bf & ((2^$flt)-1)
		$bits:=$bits-16
	End if 
	If ($bits>0)
		$bf:=$bf << (16-$bits)
		
		INTEGER TO BLOB:C548($bf & 0xFFFF; $blob; Macintosh byte ordering:K22:2; *)
	End if 
	If ($padc>0)
		$padc:=$padc*5
		$padc:=Int:C8($padc/8)
		
		If ($padc>0)
			$z:=BLOB size:C605($blob)
			SET BLOB SIZE:C606($blob; $z-$padc)
		End if 
	End if 
	