//%attributes = {"invisible":true}

#DECLARE($text : Text; $size : Integer)->$splitted : Collection

$splitted:=[]

var $begin; $limit : Integer
$begin:=1
$limit:=(Length:C16($text)+1)
While (($begin+$size)<=$limit)
	$splitted.push(Substring:C12($text; $begin; $size))
	$begin+=$size
End while 