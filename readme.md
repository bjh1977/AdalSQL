# What
A short script which can be used to install Active Directory Authentication Library for SQL Server (adalSQL), either by passing the URL of the MSI file, or by referencing a local file.

# Why
Microsoft have still not made available the latest version of ADAL for SQL Server.  As of April 2019 their [site](https://www.microsoft.com/en-us/download/details.aspx?id=48742) still only makes version 13.0.1300.275 available.  

This is a problem because it no longer works.  If you try to authenticate with Active Directory password you get the following error:

`Exception calling "open" with "0" argument(s)
... AADSTS70002: Error validating credentials. AADSTS50126: Invalid username or password`

It appears to be to do with the way the authentication token is obtained. 

The solution currently is to use version 15 of ADAL for SQL Server, which first appeared inside the MSI of the preview of SSMS 18 as 15.0.600.33 and is now at 15.0.1000.16.  

I've been using the `InstallAdalSQL.ps1` script (based on [Richie Lee's](https://github.com/RichieBzzzt)) since October 2018 without issue to get the right version on our deploy agents.  I've since updated it to also accept a URL if Mirosoft ever make it available.  In the meantime if you want it, you'll find it in the MSI folder.

# How
Either clone the repo or download the file and run:

`& ".\Install-AdalSQL.ps1" -MSIPath 'C:\Path\To\adalsql.msi'`

or

`& ".\Install-AdalSQL.ps1" -MSIUrl 'https://github.com/bjh1977/AdalSQL/blob/master/MSI/15.0.1000.16/x64/adalsql.msi?raw=true'` 