@ECHO ON
rem ����: sunday
rem ����: 20180620
rem ˵����SQL Server�����Զ���

set d=%date:~0,10%
set d=%date:~0,4%%date:~5,2%%date:~8,2%
set t=%time:~0,5%

set stamp=%p%%d%
set backupfolder=F:\DatabaseBackup
set rarfolder=%backupfolder%\%%i\%%i-%stamp%.rar
set bakfolder=%backupfolder%\%%i\%%i-%stamp%.bak

echo %date% %time% >> sqlbackup.log

rem ��ȡ���ݿ���д��dbname.txt
sqlcmd -U XWX_ERP -P "XWX_ERP12345" -S localhost -Q "select name from sysdatabases where name != 'model' and name != 'master' and name != 'msdb' and name != 'tempdb' and name != 'ReportServer' and name != 'ReportServerTempDB' and name != 'ReportServerTempDB' and name != 'tempdb'" | sed 's/\-\-.*\-//g' | grep -v name | grep -v (.*) | sed 's/ \+/\n/g' > dbname.txt


rem ����������Ӧ���ݿ�Ŀ¼
for /f "delims=" %%i in (dbname.txt) do if not exist %backupfolder%\%%i mkdir %backupfolder%\%%i >> sqlbackup.log

rem ��ȡdbname.txt�ļ������������ݿ�
for /f "delims=" %%i in (dbname.txt) do  sqlcmd -U xwx -P "12345!@#$%%" -S localhost -Q "backup database %%i to disk='%bakfolder%'" >> sqlbackup.log
rem ��ע���������һ��%����Ҫ%%��ʾ,�������ʶ��

rem ��ȡdbname.txt�ļ�����ѹ�����ݿⱸ���ļ�
for /f "delims=" %%i in (dbname.txt) do  "C:\Program Files\WinRAR\RAR.exe" a -ep1 -r -o+ -m5 -s -df "%rarfolder%" "%bakfolder%" >> sqlbackup.log