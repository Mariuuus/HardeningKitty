<#
    .DESCRIPTION

        This scripted can by used to Translate a csv list for the HardeningKitty Skript.
        You just need the paths of:
            [1] the csv list you want to translate
            [2] a Translations csv
            [3] and the export
        Then you can run the Skript :)
    .EXAMPLE
        
        . .\TranslatorSkript.ps1 ".\lists\finding_list_cis_microsoft_windows_10_enterprise_20h2_machine.csv" ".\english2german.csv" ".\Translation.csv"
        
    #>

#
#get all paths via parameter
#

$ToBeTranslatedListPath=$args[0]
$TranslateTxtPath=$args[1]
$ExportCSVPath=$args[2]


#
#import the csv
#

$TranslateTxt = Import-Csv -Path $TranslateTxtPath -Delimiter ";"
$ToBeTranslatedList = Import-Csv -Path $ToBeTranslatedListPath -Delimiter ","

#
#Find and Translate the Skript
#And export new csv

$number = 1

foreach ($Translation in $TranslateTxt) {
    $ToBeTranslatedList | ForEach-Object{
        if($_.DefaultValue.contains($Translation.Keyword))
        {
            $tempValue = $_.DefaultValue
            $_.DefaultValue = $_.DefaultValue -replace [regex]::escape($Translation.Keyword),$Translation.GermanWord
            Write-Host $number "~" $_.ID "~" $Translation.Keyword "~~ DefaultValue: " $tempValue "=>" $_.DefaultValue
            $number++
        }
    }
    $ToBeTranslatedList | ForEach-Object{
        if($_.RecommendedValue.contains($Translation.Keyword))
        {
            $tempValue = $_.RecommendedValue
            $_.RecommendedValue = $_.RecommendedValue -replace [regex]::escape($Translation.Keyword),$Translation.GermanWord
            Write-Host $number "~" $_.ID "~" $Translation.Keyword "~~ Recommended Value: " $tempValue "=>" $_.RecommendedValue
            $number++
        }
    }

}

$ToBeTranslatedList | export-csv $ExportCSVPath -Delimiter "," -Encoding UTF8 -NoType
