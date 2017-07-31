# PSNetlifeApiWrapper
A simple powershell wrapper around some Netlife api methods


## Usage
1. Store the file `NetlifeApi.psm1` locally 
2. Depending on your settings you may have to modify your [Powershell Execution policy](https://technet.microsoft.com/en-us/library/ee176961.aspx)
3. Import the module into your script `Import-Module -Name $PSScriptRoot\NetlifeApi.psm1` (the name must be changed to match local location)
4. Execute the commands like this `Get-NetlifePortals -username "your username" -password "your password" -portal "https://your portal domain/api/v1/"`
