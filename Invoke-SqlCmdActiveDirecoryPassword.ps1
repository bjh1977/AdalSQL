
# Install ADALSql
#& "$PSScriptRoot\Install-AdalSQL.ps1" -MSIPath "$PSScriptRoot\MSI\15.0.1000.16\x64\adalsql.msi"


# Test
$query="EXEC sp_who2"
$Server='yourazuresqlserver.database.windows.net'
$Database='master'
$User='username@blah.com'
$Passwrd='thepassword'

$connectionString = "Data Source=$Server; Authentication=Active Directory Password; Initial Catalog=$Database;  UID=$User; PWD=$Passwrd";

try{
    $SqlConnection = New-Object System.Data.SqlClient.SqlConnection 
    $SqlConnection.ConnectionString=$connectionString 
    $SqlConnection.Open()
    $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
    $SqlCmd.CommandText=$query
    $SqlCmd.Connection=$SqlConnection

    $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
    $SqlAdapter.SelectCommand=$SqlCmd
    $DataSet= New-Object System.Data.DataSet
    $SqlAdapter.Fill($DataSet)|Out-Null
    $DataSet.Tables
}
catch{
   $e=$_.Exception
   $msg=$e.Message
   while($e.InnerException){
       $e=$e.InnerException
       $msg+="`n"+$e.Message
   }
   Write-Host $msg -ForegroundColor Red 
   
    throw
}