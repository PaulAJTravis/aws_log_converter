# AWS Log Converter
Takes a Cloudwatch Log-group log downloaded as a CSV and converts it to a more human readable format including calculating the amount of time spent in each block of a flow.
To run the script, 

This script requires PowerShell or PowerShell Core to run.
PowerShell Core is available for multiple systems including Windows, Mac, and Linux and can be found ![here](https://github.com/PowerShell/PowerShell)

1. Make sure your PowerShell execution policy is set to "unrestricted" (if you are running PowerShell from a non-Windows device this should be set by default).
```PowerShell
set-executionPolicy unrestricted
```
2. Execute the script on the CSV Log file you downloaded.
```PowerShell
.\convert.ps1 <path to file to convert> <path to preferred output file>
```

This will output a file named "Output.csv" which is a tab delimited CSV file.
Excel will _usually_ recognize a tab delimited CSV, but in the event it doesn't automatically recognize it,

1. Open a blank Excel sheet.
2. In the "Data" tab select the "From Text/CSV" option.
3. Locate and open the Output.csv file from earlier.
4. In the window that appears, under the "Delimiter" dropdown choose the "Tab" option.
7. CLick "Load" in the bottom right corner. 

Sometimes you will see "sep=" in the first row, it is safe to delete this.
This is just used to tell Excel which kind of delimiter the file is using to ensure Excel opens it correctly.
Normally Excel should consume this and not display it as part of the CSV, but for reasons I cannot determine it occasionally does not.

## Example Input/Ouput

*Input*
| Timestamp | Message
| --------- | -------
| 1645130907868 | "{""ContactId"":""abcd12345"",""ContactFlowId"":""arn:aws:connect:us-east-1:stuff&things"",""ContactFlowName"":""Stuff&Things Flow"",""ContactFlowModuleType"":""SetLoggingBehavior"",""Timestamp"":""2022-02-17T20:48:27.868Z"",""Parameters"":{""LoggingBehavior"":""Enable""}}" |
| 1645130907870 | "{""ContactId"":""abcd12345"",""ContactFlowId"":""arn:aws:connect:us-east-1:stuff&things"",""ContactFlowName"":""Stuff&Things Flow"",""ContactFlowModuleType"":""SetVoice"",""Timestamp"":""2022-02-17T20:48:27.870Z"",""Parameters"":{""GlobalVoice"":""Joanna""}}" |

*Output*
| ContactId | ContactFlowName | ContactFlowModuleType | TimeStamp | Time Spent in Module (ms) | Parameters |
| --------- | --------------- | --------------------- | --------- | ------------------------- | ---------- |
| abcd12345 | stuff&Things    | SetLoggingBehavior    | 2022-02-17T20:48:27.868 | 2 | @{LoggingBehavior=Enable} |
| abcd12345 | stuff&Things    | SetVoice              | 2022-02-17T20:48:27.870 | 2 | @{GlobalVoice=Joanna} | 
