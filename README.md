
<img src="./headerImage.jpg">

# Combined Task Report
This project creates an overview of all your completed CI/CD tasks in a single place, the HTML generated by it can  be mailed or displayed on a web page.

It has **no dependency** and requires only Powershell to run, you can use  [PowerShell Core](https://github.com/PowerShell/PowerShell) if you are not on Windows

### Output sample:

<p align="center">
  <img src="./img.png">
</p>

The HTML is generated based on a JSON string containing the necessary data, here is an example:

```powershell
{
    "Options" :
    {
        "EncloseWithBody" : "True",
        "LabelWidth" : 250
    },
    "Blocks" : [
        {
            "Type" : "Header",
            "Label" : "NODE RELATED JOBS"
        },
        {
            "Type" : "JobStatus",
            "Label" : "COMPILE NODE",
            "Success" : "True",
            "BadgeImage" : "./image_js.png"
        },
    ]
}
```

#### JSON Elements:

The ```Options``` object is required, its two fields are:
- ```EncloseWithBody : True/False``` Will return the HTML enclosed in ```<body> CONTENT </body>``` tags, for ease of display in emails or web pages
- ```LabelWidth: WidthValue``` Controls the width of the Label cell, you can experiment with this value based on your largest job Label

The ```Blocks``` array is required, it needs to contain at least one item, the two types of items are ```Header``` and ```JobStatus```.
Header Block Type required fields:
- ```Type``` Can only have one value: ```Header```
- ```Label``` The header desired name

JobStatus Block required field:
- ```Type``` Can only have one value: ```JobStatus```
- ```Label``` The Job Status desired name
- ```Success``` Whether if the job was successful, possible values: ```True/False``` 
- ```BadgeImage``` An image URL to be displayed to the left side of the label


## Invoke Example
```powershell
$jsonConfig =
@"
{
	"Options": {
		"EncloseWithBody": "True",
		"LabelWidth": 310
	},
	"Blocks": [{
			"Type": "Header",
			"Label": "THIS IS A SAMPLE HEADER"
		},
		{
			"Type": "JobStatus",
			"Label": "THIS IS A SAMPLE JOB STATUS",
			"Success": "True",
			"BadgeImage": "http://placekitten.com/100/100"
		}
	]
}
"@

GenerateCombinedReport.ps1 -JsonString $jsonConfig
```
This sample will output the following HTML:
<p align="center">
  <img src="./sample.png">
</p>

## Included Samples
```powershell
$jsonContentAsString = Get-Content -Path sample.json
$html = ..\GenerateCombinedReport.ps1 -JsonString $jsonContentAsString
Out-File -FilePath ".\output.html" -InputObject $html
```

The included sample reads the content of the ```sample.json``` file and passes it as argument to ```GenerateCombinedReport.ps1```, the output is then writtent to file for display.

Feel free to provide input on how to make this small project better.