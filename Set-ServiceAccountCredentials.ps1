
# Stops Service, Changes account and starts service

# Note these must be valid for the machine or you will get a bad return code from WMI
$UserName           = 'domain\username'  
$Password           = 'Password' 

# Will take a wildcard such as Microsoft*
#Change service name with your service name 
$ServiceDisplayName = 'SQL*' 

$Services           = Get-WmiObject win32_service | Where-Object {$_.DisplayName -match $ServiceDisplayName}

# For each Service it will stop it and set the password

ForEach ($service in $services)
{
  $StopStatus = $service.StopService() 
  If ($StopStatus.ReturnValue -eq '0')
  {write-Output "$service -> Service Stopped Successfully"} 
  
  $ChangeStatus = $service.change($null,$null,$null,$null,$null,$null,$UserName,$Password,$null,$null,$null) 
  If ($ChangeStatus.ReturnValue -eq '0')  
  {write-Output "$service -> Sucessfully Changed User Name"} 
  
}

# Then start all services

ForEach ($service in $services)
{
  $StartStatus = $service.StartService() 
  If ($ChangeStatus.ReturnValue -eq '0')  
  {write-Output "$service -> Service Started Successfully"} 
}



# validating status - http://msdn.microsoft.com/en-us/library/aa393673(v=vs.85).aspx 
# http://gallery.technet.microsoft.com/scriptcenter/79644be9-b5e1-4d9e-9cb5-eab1ad866eaf