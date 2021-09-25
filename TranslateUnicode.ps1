$TempFileName = "C:\Users\MariusStrauss\Documents\hisecws3.inf"
$BinarySecedit = "C:\Windows\System32\secedit.exe"

&$BinarySecedit /export /cfg $TempFileName /areas USER_RIGHTS | Out-Null
$ResultOutputList = $ResultOutputRaw.ToString().split("=").Trim()
$Result = $ResultOutputList[1] -Replace "\*",""
$Result = $Result -Replace ",",";"
Get-Content -Encoding unicode $TempFileName


