//%attributes = {"invisible":true}
#DECLARE()->$time : Integer
var $currentTime : Time:=Current time:C178
var $timeGMT : Time:=Time:C179(Replace string:C233(Delete string:C232(String:C10(Current date:C33; ISO date GMT:K1:10; $currentTime); 1; 11); "Z"; ""))
var $dateGMT : Date:=Date:C102(Delete string:C232(String:C10(Current date:C33; ISO date GMT:K1:10; $currentTime); 12; 20)+"00:00:00")

// Convert date and time in number of seconds
$time:=(($dateGMT-Add to date:C393(!00-00-00!; 1970; 1; 1))*86400)+($timeGMT+0)