@ECHO ON
set d=%date:~0,10%
set d=%date:~0,4%%date:~5,2%%date:~8,2%
set t=%time:~0,5%

set stamp=%p%%d%
set bakupfolder=F:\DatabaseBackup\
rem 1����Ŀ¼���汸���ļ�;0����   
set lay_in_subfolder=1

rem ��ʾע��
rem call :backupone xwx
rem Ҫ���ݵ����ݿ���
call :backupone xwx_pay
call :backupone xwx_record
call :backupone xwx_company
call :backupone yyq_shop
call :backupone yyq_record

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
sqlcmd -U xwx -P "xwx12345!@#$%%" -S localhost -Q "backup database %dbname% to disk='%bakupfolder%%subfolder%%dbname%%stamp%.bak'"
"C:\Program Files\WinRAR\RAR.exe" a -ep1 -r -o+ -m5 -s -df "%bakupfolder%%subfolder%%dbname%%stamp%".rar "%bakupfolder%%subfolder%%dbname%%stamp%.bak"

endlocal&goto :EOF
