@ECHO ON
set d=%date:~0,10%
set d=%date:~0,4%%date:~5,2%%date:~8,2%
set t=%time:~0,5%

set stamp=%p%%d%
set bakupfolder=F:\DatabaseBackup\
rem 1按子目录保存备份文件;0不按   
set lay_in_subfolder=1

rem 表示注释
rem call :backupone xwx
rem 要备份的数据库名
call :backupone xxx_pay
call :backupone xxx_record



goto :EOF  

@ECHO OFF

:backupone 
setlocal 
echo %1 
set dbname=%1
if not exist %bakupfolder%%dbname% mkdir %bakupfolder%%dbname%

if %lay_in_subfolder%==1 (
set subfolder=%dbname%\
)else set subfolder=
rem echo %bakupfolder%%subfolder%%dbname%%stamp%.bak
sqlcmd -U userxxx -P "xxx%%" -S localhost -Q "backup database %dbname% to disk='%bakupfolder%%subfolder%%dbname%%stamp%.bak'"
"C:\Program Files\WinRAR\RAR.exe" a -ep1 -r -o+ -m5 -s -df "%bakupfolder%%subfolder%%dbname%%stamp%".rar "%bakupfolder%%subfolder%%dbname%%stamp%.bak"

endlocal&goto :EOF
