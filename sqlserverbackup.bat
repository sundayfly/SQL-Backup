@ECHO ON
rem 作者: sunday
rem 日期: 20180620
rem 说明：SQL Server备份自动化

set d=%date:~0,10%
set d=%date:~0,4%%date:~5,2%%date:~8,2%
set t=%time:~0,5%

set stamp=%p%%d%
set backupfolder=F:\DatabaseBackup
set rarfolder=%backupfolder%\%%i\%%i-%stamp%.rar
set bakfolder=%backupfolder%\%%i\%%i-%stamp%.bak

echo %date% %time% >> sqlbackup.log

rem 读取数据库名写入dbname.txt
sqlcmd -U XWX_ERP -P "XWX_ERP12345" -S localhost -Q "select name from sysdatabases where name != 'model' and name != 'master' and name != 'msdb' and name != 'tempdb' and name != 'ReportServer' and name != 'ReportServerTempDB' and name != 'ReportServerTempDB' and name != 'tempdb'" | sed 's/\-\-.*\-//g' | grep -v name | grep -v (.*) | sed 's/ \+/\n/g' > dbname.txt


rem 遍历创建对应数据库目录
for /f "delims=" %%i in (dbname.txt) do if not exist %backupfolder%\%%i mkdir %backupfolder%\%%i >> sqlbackup.log

rem 读取dbname.txt文件遍历备份数据库
for /f "delims=" %%i in (dbname.txt) do  sqlcmd -U xwx -P "12345!@#$%%" -S localhost -Q "backup database %%i to disk='%bakfolder%'" >> sqlbackup.log
rem 若注意密码包含一个%，则要%%表示,命令才能识别。

rem 读取dbname.txt文件遍历压缩数据库备份文件
for /f "delims=" %%i in (dbname.txt) do  "C:\Program Files\WinRAR\RAR.exe" a -ep1 -r -o+ -m5 -s -df "%rarfolder%" "%bakfolder%" >> sqlbackup.log