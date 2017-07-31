
<#

This is a wrapper over some of the methods the Netlife EPMS API

A list of all available API methods can be found at http://volume-photography.com/api/v1/docs/index.html or at https://<yourdomain>/api/v1/docs/index.html .

#>


#Global variables
$timeoutlimit = 20;


function makeApiCall($method, $baseUrl, $route, $data, $username, $password ){

    write-Verbose "Method: $method, Route: $route, Data: $data" 
    
    $pair = "${username}:${password}"
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
    $base64 = [System.Convert]::ToBase64String($bytes)
    $basicAuthValue = "Basic $base64"
    $headers = @{ Authorization = $basicAuthValue }

    $url = "$($baseUrl)/$route"

    $result = $null;

    try{
        switch($method){
            "GET"{
                Write-Verbose "GET $url" 
                $result = Invoke-WebRequest  -Method Get -Uri $url -Headers $headers  -Body $data  -TimeoutSec $timeoutlimit -Credential $credential -ErrorAction Stop
            }
            "POST"{
                Write-Verbose "Post $url"
                $result = Invoke-WebRequest  -Method Post -Uri $url -Body  $data -Headers $headers -TimeoutSec $timeoutlimit -ContentType application/x-www-form-urlencoded -Credential $credential -ErrorAction Stop
            }
            "PUT"{
                Write-Verbose "PUT $url"
                $result = Invoke-WebRequest  -Method Put -Uri $url -Body $data -Headers $headers -TimeoutSec $timeoutlimit -ContentType application/x-www-form-urlencoded -ErrorAction Stop
            }
            "DELETE"{
                Write-Verbose "DELETE $url"
                $result = Invoke-WebRequest  -Method Delete -Uri $url -Body  $data -Headers $headers -TimeoutSec $timeoutlimit  -ErrorAction Stop
            }
            default {
                throw "Not supporte web method defined: $method"    
            }
        }
    }catch{

        $statusCode = $_.Exception.Response.StatusCode;
        $statusDescription = $_.Exception.Response.StatusDescription
        $errorContent = $_.Exception.Response.Content

        switch($statusCode){
            NotFound {
                $result = $null;
                Write-Verbose "Data not found (404)"   
            }            
            Gone {
                $result = $null;
                Write-Verbose "Data gone (410)"   
            }
            Unauthorized{
                throw "Unauthorized access for user $username"
            }
            default{
                Write-error "Failed to call $url, result:  $statusCode - $statusDescription - with token: $cirrusGlobalToken : $errorContent"    
                throw "request ($url) failed with $statusCode for method $method" 
            }
        }
    }

    Write-Verbose "request finished with status $($result.StatusCode)"

    if($result -ne $null) {
        Write-Verbose "content: $($result.Content)"    
        $jsonResult = $result.Content |  ConvertFrom-Json 
        if($jsonResult.errorCode -ne $null){
            Write-Output  "Failed to call $url resulting in errorcode: $($jsonResult.errorCode)"  
        }

        $jsonResult; 
    }else{
        $null
    }

}



function Get-NetlifePortals {
   <#
        .SYNOPSIS
        
        .DESCRIPTION
            
        .EXAMPLES
           
    #>
    [CmdletBinding()]
       param(
        [Parameter(Mandatory=$True,Position=1)]
        [String] $username,
        [Parameter(Mandatory=$True,Position=2)]
        [String] $password,
        [Parameter(Mandatory=$True,Position=3)]
        [String] $portal
      )

    try{
       $payload = @{}
       $BASEURL = "$portal/api/v1" 
       makeApiCall "GET" $BASEURL "portals" $payload $username $password;    
    }catch {
       throw "failed to get portals $portal : $($_.Exception)" 
    }

}


function Get-NetlifeJobs {
   <#
        .SYNOPSIS
        
        .DESCRIPTION
            
        .EXAMPLES
           
    #>
    [CmdletBinding()]
       param(
        [Parameter(Mandatory=$True,Position=1)]
        [String] $username,
        [Parameter(Mandatory=$True,Position=2)]
        [String] $password,
        [Parameter(Mandatory=$True,Position=3)]
        [String] $portal,
        [Parameter(Mandatory=$true)]
        [String] $externalId


      )

    try{
       $payload = @{}
       $BASEURL = "$portal/api/v1" 
       makeApiCall "GET" $BASEURL "jobs/search?external_id=$($externalId)" $payload $username $password;    
    }catch {
       throw "failed to get portals $portal : $($_.Exception)" 
    }

}


function Get-NetlifeJob {
   <#
        .SYNOPSIS
        
        .DESCRIPTION
            
        .EXAMPLES
           
    #>
    [CmdletBinding()]
       param(
        [Parameter(Mandatory=$True,Position=1)]
        [String] $username,
        [Parameter(Mandatory=$True,Position=2)]
        [String] $password,
        [Parameter(Mandatory=$True,Position=3)]
        [String] $portal,
        [Parameter(Mandatory=$true)]
        [String] $jobUuid


      )

    try{
       $payload = @{}
       $BASEURL = "$portal/api/v1" 
       makeApiCall "GET" $BASEURL "jobs/$($jobUuid)" $payload $username $password;    
    }catch {
       throw "failed to get portals $portal : $($_.Exception)" 
    }

}

function Get-NetlifeJobSubjects {
   <#
        .SYNOPSIS
        
        .DESCRIPTION
            
        .EXAMPLES
           
    #>
    [CmdletBinding()]
       param(
        [Parameter(Mandatory=$True,Position=1)]
        [String] $username,
        [Parameter(Mandatory=$True,Position=2)]
        [String] $password,
        [Parameter(Mandatory=$True,Position=3)]
        [String] $portal,
        [Parameter(Mandatory=$true)]
        [String] $jobUuid


      )

    try{
       $payload = @{}
       $BASEURL = "$portal/api/v1" 
       makeApiCall "GET" $BASEURL "jobs/$($jobUuid)/subjects" $payload $username $password;    
    }catch {
       throw "failed to get subjects for job $jobUuid : $($_.Exception)" 
    }

}



function Get-NetlifeJobSubject {
   <#
        .SYNOPSIS
        
        .DESCRIPTION
            
        .EXAMPLES
           
    #>
    [CmdletBinding()]
       param(
        [Parameter(Mandatory=$True,Position=1)]
        [String] $username,
        [Parameter(Mandatory=$True,Position=2)]
        [String] $password,
        [Parameter(Mandatory=$True,Position=3)]
        [String] $portal,
        [Parameter(Mandatory=$true)]
        [String] $jobUuid,
        [Parameter(Mandatory=$true)]
        [String] $subjectUuid

      )

    try{
       $payload = @{}
       $BASEURL = "$portal/api/v1" 
       makeApiCall "GET" $BASEURL "jobs/$($jobUuid)/subjects/$subjectUuid" $payload $username $password;    
    }catch {
       throw "failed to get subjects for job $jobUuid : $($_.Exception)" 
    }

}


function Get-NetlifecataloguesForJob {
   <#
        .SYNOPSIS
        
        .DESCRIPTION
            
        .EXAMPLES
           
    #>
    [CmdletBinding()]
       param(
        [Parameter(Mandatory=$True,Position=1)]
        [String] $username,
        [Parameter(Mandatory=$True,Position=2)]
        [String] $password,
        [Parameter(Mandatory=$True,Position=3)]
        [String] $portal,
        [Parameter(Mandatory=$true)]
        [String] $jobUuid


      )

    try{
       $payload = @{}
       $BASEURL = "$portal/api/v1" 
       makeApiCall "GET" $BASEURL "jobs/$($jobUuid)/catalogues" $payload $username $password;    
    }catch {
       throw "failed to get catalogues  for job $jobUuid : $($_.Exception)" 
    }

}


function Get-NetlifeCatalogue {
   <#
        .SYNOPSIS
        
        .DESCRIPTION
            
        .EXAMPLES
           
    #>
    [CmdletBinding()]
       param(
        [Parameter(Mandatory=$True,Position=1)]
        [String] $username,
        [Parameter(Mandatory=$True,Position=2)]
        [String] $password,
        [Parameter(Mandatory=$True,Position=3)]
        [String] $portal,
        [Parameter(Mandatory=$true)]
        [String] $catalogueUuid


      )

    try{
       $payload = @{}
       $BASEURL = "$portal/api/v1" 
       makeApiCall "GET" $BASEURL "catalogues/$($catalogueUuid)" $payload $username $password;    
    }catch {
       throw "failed to get catalogue  for job $catalogueUuid : $($_.Exception)" 
    }

}


function Get-NetlifePricelistProductPrice {
   <#
        .SYNOPSIS
        
        .DESCRIPTION
            
        .EXAMPLES
           
    #>
    [CmdletBinding()]
       param(
        [Parameter(Mandatory=$True,Position=1)]
        [String] $username,
        [Parameter(Mandatory=$True,Position=2)]
        [String] $password,
        [Parameter(Mandatory=$True,Position=3)]
        [String] $portal,
        [Parameter(Mandatory=$true)]
        [String] $pricelistUuid,
        [Parameter(Mandatory=$true)]
        [String] $productUuid


      )

    try{
       $payload = @{}
       $BASEURL = "$portal/api/v1" 
       makeApiCall "GET" $BASEURL "pricelists/$($pricelistUuid)/product/$($productUuid)" $payload $username $password;    
    }catch {
       throw "failed to get portals $portal : $($_.Exception)" 
    }

}


function Get-NetlifePricelist {
   <#
        .SYNOPSIS
        
        .DESCRIPTION
            
        .EXAMPLES
           
    #>
    [CmdletBinding()]
       param(
        [Parameter(Mandatory=$True,Position=1)]
        [String] $username,
        [Parameter(Mandatory=$True,Position=2)]
        [String] $password,
        [Parameter(Mandatory=$True,Position=3)]
        [String] $portal,
        [Parameter(Mandatory=$true)]
        [String] $pricelistUuid

      )

    try{
       $payload = @{}
       $BASEURL = "$portal/api/v1" 
       makeApiCall "GET" $BASEURL "pricelists/$($pricelistUuid)" $payload $username $password;    
    }catch {
       throw "failed to get pricelist $pricelistUuid : $($_.Exception)" 
    }

}


function Get-NetlifeNextEvent {
   <#
        .SYNOPSIS
        
        .DESCRIPTION
            
        .EXAMPLES
           
    #>
    [CmdletBinding()]
       param(
        [Parameter(Mandatory=$True,Position=1)]
        [String] $username,
        [Parameter(Mandatory=$True,Position=2)]
        [String] $password,
        [Parameter(Mandatory=$True,Position=3)]
        [String] $portal
      )

    try{
       $payload = @{}
       $BASEURL = "$portal/api/v1" 
       makeApiCall "GET" $BASEURL "events/next" $payload $username $password;    
    }catch {
       throw "failed to get next event : $($_.Exception)" 
    }

}



function Get-NetlifePQALongPool {
   <#
        .SYNOPSIS
        
        .DESCRIPTION
            
        .EXAMPLES
           
    #>
    [CmdletBinding()]
       param(
        [Parameter(Mandatory=$True,Position=1)]
        [String] $username,
        [Parameter(Mandatory=$True,Position=2)]
        [String] $password,
        [Parameter(Mandatory=$True,Position=3)]
        [String] $portal,
        [Parameter(Mandatory=$false)]
        [int] $id,
        [Parameter(Mandatory=$false)]
        [int] $lastId

        

      )

    try{
       $payload = @{}
       $BASEURL = "$portal/api/v1" 

       $method = "/pqa/longpoll" 
       if ($id){
        $method = $method + "?id=$id"
       }

       
       if ($lastId){
        $method = $method + "?last_serial=$lastId"
       }

       makeApiCall "GET" $BASEURL $method $payload $username $password;    
    }catch {
       throw "failed to get pqa long  poll : $($_.Exception)" 
    }

}





Export-ModuleMember *-*