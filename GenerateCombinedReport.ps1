param (
    [string] $JsonString = ''
    )

$ColorSuccess = "#97CA00"
$ColorFailure = "#E05D44" 
$TextSuccess  = "SUCCESS"
$TextFailure  = "FAILURE" 

function BuildReport {
    
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $jsonString
    )

    $json = ConvertFrom-Json $jsonString
    $options = $json.Options
    $blocks = $json.Blocks

    $htmlTableElements = New-Object Collections.Generic.List[string]
    foreach ($block in $blocks) {
        
        switch ($block.Type) {
            "Header" { 
                $htmlTableElements.Add( $(GetHeader -Label $block.Label)) 
            }
            "JobStatus" { 
                $colorToUse = ""
                $textToUse = ""
                
                If ($block.Success -eq $true) { 
                    $colorToUse = $ColorSuccess 
                    $textToUse = $TextSuccess
                } 
                Else { 
                    $colorToUse = $ColorFailure
                    $textToUse = $TextFailure
                }
                $htmlTableElements.Add( $(GetJobStatus `
                    -Label $block.Label `
                    -Color $colorToUse `
                    -Result $textToUse `
                    -BadgeURL $block.BadgeImage `
                    -LabelWidth $options.LabelWidth)) 
            }
        }
    }

    $finalHTML = GetFinalHTML -TableElements $htmlTableElements -EncloseWithBodyTag $options.EncloseWithBody
    
    return $finalHTML
}

function GetFinalHTML {
    param (
        [string] $EncloseWithBodyTag,
        [string[]] $TableElements
    )

    $html = 
@"  
    <table style="
        padding-left: 5;
        height: 43px;
        border-style: hidden;
        border-collapse: collapse;
        font-family: Roboto;
        letter-spacing: 2px;
    ">
"@
    
    foreach ($item in $TableElements) {
        $html += $item
    }

    $html += "</table>"

    if($EncloseWithBodyTag -eq $true) {
        $html = "<body>" + $html + "</body>" 
    }

    return $html
}

function GetHeader {
    param(
        [string] $Label
    )

    return @"
    <tr>
        <td height=20>
            <!-- Spacer -->
        </td>
    </tr>
    <tr>
        <td colspan="3" style="
        background-color :#555555;
        color: white;
        width: 295px;
        height: 27px;
        text-align: left;
        font-size: 13;
        padding-left: 12px
        ">
         $($Label)
        </td>
    <tr>
        <td height=3>
        <!-- Spacer -->
        </td>
    </tr>
"@
}

function GetJobStatus {
    param (
        [string] $BadgeURL,
        [string] $Label,
        [string] $ResultLabel,
        [string] $Color = "#97CA00",
        [string] $LabelWidth = 230
    )

    $stuff = `
            @"
            <tr style="
            height: 39px;
            border-bottom: 10px;
            ">
                <td style="
                    background-color :#555555;
                    width: 40px;">
                    <img src="$($BadgeURL)" style="
                                                height: 23px;
                                                padding-left: 10px;
                                                padding-right: 10px;
                    " />
                </td>

                <td style="
                        background-color :#555555;
                        color: white;
                        width: $($LabelWidth)px;
                        text-align: left;

                ">
                    $($Label)
                </td>
                <td style="
                        background-color: $($Color);
                        color: white;
                        width: 125px;
                        text-align: center;
                ">
                    $($ResultLabel)
                </td>
            </tr> 
            <tr>
            <td height=5>
                <!-- Spacer -->
            </td>
            </tr>
"@

    return $stuff
}

If($JsonString -eq '') {
    Write-Output "No input provided"
    return
}

BuildReport -jsonString $JsonString