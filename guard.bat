@echo off

::���ʱ��������λ����
set _interval=5

::��Ҫ�ػ��Ľ�������
set _processName=pythonw.exe

::��Ҫ�ػ��Ľ�����������
set _processCmd=D:\pakpoboxclient\PakpoboxClient.pyw

::��Ҫ�ػ��Ľ���Ԥ�������������ʱ�䣬��λ����
set _processTimeout=5

::��Ҫ�ػ��Ľ����������Ķ˿�
::set _port=8080

::�����û�����һ����Administrator
::set _username=Administrator 

:LOOP
set /a isAlive=false

::ͨ���������Ƽ��
tasklist | find /C "%_processName%" > temp.txt
set /p num= < temp.txt
del /F temp.txt

::ͨ�����̵Ķ˿��Ƿ����ڱ��������
::netstat -an | find /C "0.0.0.0:%_port%" > temp.txt
::set /p num= < temp.txt
::del /F temp.txt

if "%num%" == "0" (
python %_processCmd% | echo ���� %_processName% �� %time%
choice /D y /t %_processTimeout% > nul
)

if "%num%" NEQ "0" echo ������

::ping -n %_interval% 127.1>nul
choice /D y /t %_interval% >nul

goto LOOP