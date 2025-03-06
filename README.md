# full-system-threat-scan
Checks the Windows system logs for detected threats and emails reports.

Full System Scan Implementation

Overview

This document outlines the steps to automate security tasks, including scheduling full-system scans, enabling real-time protection, configuring Windows Task Scheduler to run scans every 12 hours, and emailing scan logs to the security team. These steps will ensure continuous protection and monitoring of security threats.
________________________________________

1. PowerShell Script Functionality

This PowerShell script performs the following security tasks:

•	Enables Windows Defender Real-Time Protection to ensure active monitoring.

•	Schedules a full-system scan at a predefined interval (every 12 hours).

•	Logs scan results and captures detected threats.

•	Emails scan logs using Outlook’s SMTP server to the security team.

⚠Security Considerations

⚠ Avoid storing plaintext passwords in scripts. Instead, use PowerShell’s SecureString for safer password handling.

⚠ If you prefer to schedule the job through Task Scheduler comment out the Daily Scan Task code. Then follow the below instructions. ⚠

2. Scheduling the Script to Run Every 12 Hours Using Task Scheduler
3. 
To automate the execution of this script, configure Windows Task Scheduler to run it every 12 hours.

Step 1: Open Task Scheduler

1.	Press Win + R, type taskschd.msc, and press Enter.

2.	Click Create Basic Task in the right-hand panel.

Step 2: Set Task Name and Description

1.	Name the task "Windows Defender Scheduled Scan".

2.	Add a description: "Runs a full-system scan and emails security logs every 12 hours.".

3.	Click Next.

Step 3: Set Trigger (Schedule Task Every 12 Hours)

1.	Select Daily and click Next.

2.	Set the start time (e.g., 6:00 AM) and select Recur every 1 days.

3.	Click Next.

4.	Select Repeat Task Every 12 Hours.

Step 4: Set Action (Run PowerShell Script)

1.	Select Start a Program and click Next.

2.	In the Program/Script field, type: 

3.	powershell.exe

4.	In the Add Arguments field, enter: 

5.	-File "C:\Path\To\Your\Script.ps1"

6.	Click Next.

Step 5: Set Additional Security Options

1.	Select Run whether user is logged on or not.

2.	Check Run with highest privileges.

3.	Click Finish.

Step 6: Test Task Execution

1.	Right-click the created task and select Run.

2.	Verify that the scan starts and completes successfully.

3.	Check your Outlook Sent Items for the email log.
________________________________________

3. Security Enhancements & Best Practices

To further improve security:

•	Use SecureString for storing email passwords securely.

•	Set up email alerts for failed scans.

•	Regularly review Defender threat detection logs.

•	Ensure Windows Defender definitions are always up to date.
________________________________________

Conclusion

This automation setup ensures continuous protection by: ✔ Running a full-system scan every 12 hours. ✔ Logging and capturing potential threats. ✔ Emailing scan logs to the security team for review. ✔ Enhancing overall security monitoring.
By implementing this script and scheduled task, On Time Decorations will maintain proactive cybersecurity defenses with minimal manual intervention. 🚀


