## ===========================================================================
## NAME:        FullSystemScan.ps1 
## CREATED:     06-MAR-2025
## BY:          DAVID RADOICIC
## VERSION:     1.0
## DESCRIPTION: Checks the Windows system logs for detected threats and emails reports.
##
##
## NOTE:
## Enables Windows Defender Real-Time Protection to ensure active monitoring.
## Schedules a full-system scan at a predefined interval (every 12 hours).
## Logs scan results and captures detected threats.
## Emails scan logs using Outlook’s SMTP server to the security team.
## ===========================================================================

# Enable Windows Defender Real-Time Protection
Set-MpPreference -DisableRealtimeMonitoring $false

# Define Email Parameters for Outlook SMTP
$SMTPServer = "smtp.office365.com"  
$SMTPPort = "587"  
$From = "your-email@outlook.com"  # Replace with your Outlook email  
$To = "YOUR EMAIL HERE"  
$Subject = "Daily Windows Defender Scan Report"  
$Username = "your-email@outlook.com"  # Your Outlook username  
$Password = "your-secure-password"  # Your Outlook email password (consider using SecureString) 

# It is recomended to us use PowerShell’s SecureString for safer password handling, rather than plain text
# Convert the plain text password "your-password" to a secure string
# $SecurePassword = ConvertTo-SecureString "your-password" -AsPlainText -Force

# Create a new PSCredential object using the provided username and secure password
# $Creds = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword) 

# Define Log File Path
$LogFile = "C:\DefenderScanReport.log"

# Start Full Scan & Log Output
Start-MpScan -ScanType FullScan | Out-File -FilePath $LogFile -Append
Start-Sleep -Seconds 1800  # Wait for scan to complete (adjust timing if needed)

# Collect Windows Defender Threat Log
$ThreatLog = Get-MpThreatDetection | Format-Table -AutoSize | Out-String
Add-Content -Path $LogFile -Value "`nThreat Detection Summary:`n$ThreatLog"

# Send Email with Scan Report via Outlook SMTP
$Body = Get-Content -Path $LogFile | Out-String
$SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer, $SMTPPort)
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)
$MailMessage = New-Object System.Net.Mail.MailMessage($From, $To, $Subject, $Body)
$SMTPClient.Send($MailMessage)

# Confirm Email Sent
Write-Output "Defender Scan Log sent to $To"

# Schedule Daily Scan Task at 2 AM
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-Command Start-MpScan -ScanType FullScan"
$trigger = New-ScheduledTaskTrigger -Daily -At 2am
$principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
Register-ScheduledTask -TaskName "DailyFullSystemScan" -Action $action -Trigger $trigger -Principal $principal -Settings $settings

Write-Output "Scheduled a full system scan daily at 2 AM."
