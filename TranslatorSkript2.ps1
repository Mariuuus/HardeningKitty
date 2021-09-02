<#
    .DESCRIPTION

        This scripted can by used to Translate a csv list for the HardeningKitty Skript.
        You just need the paths of:
            [1] the csv list you want to translate
            [2] a Translations csv
            [3] and the export
        Then you can run the Skript :)
    .EXAMPLE
        
        Description: HardeningKitty performs an audit, saves the results and creates a log file:
        Invoke-HardeningKitty -Mode Audit -Log -Report

        Description: HardeningKitty performs an audit with a specific list and does not show machine information:
        Invoke-HardeningKitty -FileFindingList .\lists\finding_list_0x6d69636b_user.csv -SkipMachineInformation

        Description: HardeningKitty ready only the setting with the default list, and saves the results in a specific file:
        Invoke-HardeningKitty -Mode Config -Report -Report C:\tmp\my_hardeningkitty_report.log
        
    #>

#
#get all paths via parameter
#

$ToBeTranslatedListPath=$args[0]
$TranslateTxtPath=$args[1]
$ExportCSVPath=$args[2]
$ReportTxTPath=$args[3]

#
#import the csv´s
#

$ToBeTranslatedList = Import-Csv -Path $ToBeTranslatedListPath
$TranslateTxt = Import-Csv -Path $TranslateTxtPath -Delimiter ";"

#
#Find and Translate the Skript
#And export new csv
#

$Message = "ID,Category,Name,Method,MethodArgument,RegistryPath,RegistryItem,ClassName,Namespace,Property,DefaultValue,RecommendedValue,Operator,Severity"
Add-Content -Path $ExportCSVPath -Value $Message -ErrorAction Stop

ForEach ($Object in $ToBeTranslatedList) {

    
    $NewObject = $Object

    ForEach ($Translation in $TranslateTxt) {

        if($Object.contains($Translation.Keyword)){
            $NewObject = $NewObject.replace($Translation.Keyword, $Translation.GermanWord)
        }
        
        if($Object.contains($Translation.Keyword)) {
            $NewObject = $NewObject.replace($Translation.Keyword, $Translation.GermanWord)
        }

    }

    Add-Content -Path $ExportCSVPath -Value $NewObject -ErrorAction Stop

    if(!($Object == $NewObject)) {
        Add-Content -Path $ReportTxTPath -Value ($NewObject + " \/ " + $Object) -ErrorAction Stop
    }

}
