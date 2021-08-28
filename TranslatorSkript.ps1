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

#
#import the csv´s
#

$ToBeTranslatedList = Import-Csv -Path $ToBeTranslatedListPath -Delimiter ","
$TranslateTxt = Import-Csv -Path $TranslateTxtPath -Delimiter ";"

#
#Find and Translate the Skript
#And export new csv
#

$Message = "ID,Category,Name,Method,MethodArgument,RegistryPath,RegistryItem,ClassName,Namespace,Property,DefaultValue,RecommendedValue,Operator,Severity"
Add-Content -Path $ExportCSVPath -Value $Message -ErrorAction Stop

ForEach ($Object in $ToBeTranslatedList) {

    $NewDefaultValue = $Object.DefaultValue
    $NewRecommendedValue = $Object.RecommendedValue

    ForEach ($Translation in $TranslateTxt) {

        

        if($Object.DefaultValue.contains($Translation.Keyword)){
            $NewDefaultValue = $NewDefaultValue.replace($Translation.Keyword, $Translation.GermanWord)
        }
        
        if($Object.RecommendedValue.contains($Translation.Keyword)) {
            $NewRecommendedValue = $NewRecommendedValue.replace($Translation.Keyword, $Translation.GermanWord)
        }

    }

    $Message = '"'+$Object.ID+'","'+$Object.Category+'","'+$Object.Name+'","'+$Object.Method+'","'+$Object.MethodArgument+'","'+$Object.RegistryPath+'","'+$Object.RegistryItem+'","'+$Object.ClassName+'","'+$Object.Namespace+'","'+$Object.Property+'","'+$NewDefaultValue+'","'+$NewRecommendedValue+'","'+$Object.Operator+'","'+$Object.Severity+'",'
    Add-Content -Path $ExportCSVPath -Value $Message -ErrorAction Stop

}
