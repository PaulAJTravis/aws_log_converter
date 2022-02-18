<#
  Program: AWS Log Converter
  Author : Paul Travis, paul.travis@voicefoundry.com
  Created: 01/02/2022

  Desc   : Consumes an AWS Log-Group logfile CSV and generates a more human readable CSV file, 
           also calculates the amount of time spent in each block of a call flow.
#>

#Import the log-group csv file from the path specified in the command line argument
$log = Import-Csv -Path $args[0] -Delimiter ',' -Header 'Timestamp', 'Message'
$outFile = $args[1]

#Create the file populating the first two lines, 
#Populate the first line with the separtor directive to let excel know it's a tab delimited CSV,
#and populate the second line with the column headers.
#It seems that sometimes Excel ignores the sep= directive for inexplicable reasons
echo "sep=`t`nContactId`tContactFlowName`tContactFlowModuleType`tTimeStamp`tTime Spent In Module (ms)`tParameters" | Out-File -FilePath $outFile 

#Start with row 1 to avoid attempting to parse the column headers as JSON
for ($i = 1; $i -lt ($log.Count); $i++) {

  #Convert the message object JSON into a PowerShell Object and store it back into the Message property
  $log[$i].Message = ConvertFrom-Json -InputObject $log[$i].Message

  #This prevents printing nonsense on the last line of the file
  if ($i -lt ($log.Count - 1)) {

    $timeCalc = $log[$i + 1].Timestamp - $log[$i].Timestamp

  } else {

    $timeCalc = ""

  }

  #Write the record to the file in the format provided.
  [string]::Format(
    "{0}`t{1}`t{2}`t{3:yyyy-MM-dd HH:mm:ss:fff}`t{4}`t{5}", 
    $log[$i].Message.ContactId, 
    $log[$i].Message.ContactFlowName, 
    $log[$i].Message.ContactFlowModuleType, 
    $log[$i].Message.TimeStamp, #By default PS Core will convert this to a .Net timestamp obj which will truncate the miliseconds when .ToString() is run on it.
    $timeCalc, 
    $log[$i].Message.Parameters
  ) | Out-File -FilePath $outFile -Append -NoClobber

}
