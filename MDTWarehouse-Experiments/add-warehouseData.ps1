$DBServer = "HOST02\SQLEXPRESS"
$DBName = "MDTWarehouse"
$sqlConnection = New-Object System.Data.SqlClient.SqlConnection
$sqlConnection.ConnectionString = "Server=$DBServer;Database=$DBName;Integrated Security=True;"
$sqlConnection.Open()
 
# Quit if the SQL connection didn't open properly.
if ($sqlConnection.State -ne [Data.ConnectionState]::Open) {
    "Connection to DB is not open."
   
}
 
$sqlCommand = New-Object System.Data.SqlClient.SqlCommand
$sqlCommand.Connection = $sqlConnection
$sqlCommand.CommandText = "INSERT INTO dbo.Deployments (Name,PercentComplete,Warnings,Errors,DeploymentStatus,StartTime,EndTime,UniqueID,CurrentStep,TotalSteps,StepName,LastTime,VMHost,VMName) " +
                          "VALUES (@Name,@PercentComplete,@Warnings,@Errors,@DeploymentStatus,@StartTime,@EndTime,@UniqueID,@CurrentStep,@TotalSteps,@StepName,@LastTime,@VMHost,@VMName); "

    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@Name",[Data.SQLDBType]::nvarchar, 280))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@PercentComplete",[Data.SQLDBType]::Int))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@Warnings",[Data.SQLDBType]::nvarchar, 50))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@Errors",[Data.SQLDBType]::nvarchar, 50))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@DeploymentStatus",[Data.SQLDBType]::nvarchar, 50))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@StartTime",[Data.SQLDBType]::nvarchar, 50 ))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@EndTime",[Data.SQLDBType]::nvarchar, 50 ))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@UniqueID",[Data.SQLDBType]::nvarchar, 50))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@CurrentStep",[Data.SQLDBType]::nvarchar, 50))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@TotalSteps",[Data.SQLDBType]::int))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@StepName",[Data.SQLDBType]::nvarchar, 50))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@LastTime",[Data.SQLDBType]::nvarchar, 50))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@VMHost",[Data.SQLDBType]::nvarchar, 50))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@VMName",[Data.SQLDBType]::nvarchar, 50))) | Out-Null

$Data = Invoke-RestMethod "http://MDT-AP01:9801/MDTMonitorData/Computers"

foreach ($property in ($data.content.properties)){
    
    #Format data
    $Name =  $property.Name;
    $PercentComplete = $($property.PercentComplete.'#text');
    $Settings =  $property.Settings.null;
    $Warnings =  $($property.Warnings.'#text');
    $Errors =   $($property.Errors.'#text');
    $DeploymentStatus =  $(
                        switch ($property.DeploymentStatus.'#text'){
                        1 {"Active/Running"}
                        2 {"Failed"}
                        3 {"Successfully completed"}
                        4 {"Unresponsive"}
                        Default {"Unknown"}
                            }
                            );

    $StartTime =  $($property.StartTime.'#text');
    $EndTime =  $($property.EndTime.'#text');
        $ID =  $($ID.Errors.'#text');
        $UniqueID =  $($property.UniqueID.'#text');
        $CurrentStep =  $($property.CurrentStep.'#text');
        $TotalSteps =  $($property.TotalSteps.'#text');
        $StepName =  $($property.StepName.'#text');
        if ($StepName -eq $null){
        $StepName = "Completed all Steps"
        }
        if (($StepName -ne $null) -and ($DeploymentStatus -eq "Successfully completed")){
        $StepName = "Completed all Steps"
        }
        else {
        $StepName = "Not Completed all Steps"
        }
        $LastTimeRaw =  $($property.LastTime.'#text') -replace"T"," ";
        $LastTime = $LastTimeRaw.Substring(0,16)
        $LastTime = $LastTime = (get-date $LastTime).ToShortDateString()
        $VMHost =  ($property.VMHost.ToString());
                if ($VMHost -eq $null){
        $VMHost = "Not specified"
        }
        $VMName =  ($property.VMName.ToString());
                if ($VMName -eq $null){
        $VMName = "Not specified"
        }
        
        $sqlCommand.Parameters[0].Value = $Name
        $sqlCommand.Parameters[1].Value = $PercentComplete
        $sqlCommand.Parameters[2].Value = $Warnings
        $sqlCommand.Parameters[3].Value = $Errors
        $sqlCommand.Parameters[4].Value = $DeploymentStatus
        $sqlCommand.Parameters[5].Value = $StartTime
        $sqlCommand.Parameters[6].Value = $EndTime
        $sqlCommand.Parameters[7].Value = $UniqueID
        $sqlCommand.Parameters[8].Value = $CurrentStep
        $sqlCommand.Parameters[9].Value = $TotalSteps
        $sqlCommand.Parameters[10].Value = $StepName
        $sqlCommand.Parameters[11].Value = $LastTime
        $sqlCommand.Parameters[12].Value = $VMHost
        $sqlCommand.Parameters[13].Value = $VMName
              
        $query = “SELECT * FROM Deployments”
        $QueryCommand = $sqlConnection.CreateCommand()
        $QueryCommand.CommandText = $query
        $result = $command.ExecuteReader()
        $table = new-object “System.Data.DataTable”
        $table.Load($result)
        $QueryResult = $table | Where-Object {((($_.StartTime -eq $StartTime) -and ($_.UniqueID -eq $UniqueID)))}

        if ((($StartTime -eq $QueryResult.StartTime) -and ($UniqueID -eq $QueryResult.UniqueID)))
        {
        Write-Host "not inserting" $name
        #Notes for later
        #Add Log function to logfile later here
        #Data already exist in warehouse

        }
        else{
        #Add Log function to logfile later here
        #New Data to be inserted, log action 

        if ($DeploymentStatus -ne "Active/Running"){
        $sqlCommand.ExecuteScalar()
        #Add Log function to logfile later here
        #But only insert if its NOT a active/running deployment
        #if it is, log it.

        }
        }

}

$sqlConnection.close()

