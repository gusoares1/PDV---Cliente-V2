@echo off
SETLOCAL EnableDelayedExpansion

REM --- Configurações ---
SET "MYSQL_DIR={app}\MySQL"  REM Diretório onde o MSI instalou o MySQL
SET "SERVICE_NAME=MySQL"
SET "ROOT_PASSWORD=123"
SET "SQL_SCRIPT=pdvbkp.sql"
SET "LOG_FILE=%CD%\mysql_install.log"

REM --- Inicialização do Log ---
echo [%DATE% %TIME%] Iniciando configuração do MySQL... > "%LOG_FILE%"

REM --- Verifica se o serviço já existe ---
echo Verificando se o serviço %SERVICE_NAME% existe... >> "%LOG_FILE%"
sc query %SERVICE_NAME% >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo Serviço já existe. Reiniciando... >> "%LOG_FILE%"
    net stop %SERVICE_NAME% >> "%LOG_FILE%" 2>&1
    IF !ERRORLEVEL! NEQ 0 (
        echo ERRO: Não foi possível parar o serviço. >> "%LOG_FILE%"
        exit /b 1
    )
    net start %SERVICE_NAME% >> "%LOG_FILE%" 2>&1
) ELSE (
    REM --- Instalação do Serviço ---
    echo Instalando serviço %SERVICE_NAME%... >> "%LOG_FILE%"

    REM Garante diretório de dados
    if not exist "%MYSQL_DIR%\data" (
        mkdir "%MYSQL_DIR%\data" >> "%LOG_FILE%"
    )

    REM Inicialização do MySQL (sem senha)
    echo Inicializando banco de dados... >> "%LOG_FILE%"
    "%MYSQL_DIR%\bin\mysqld.exe" --initialize-insecure --basedir="%MYSQL_DIR%" --datadir="%MYSQL_DIR%\data" >> "%LOG_FILE%" 2>&1
    IF !ERRORLEVEL! NEQ 0 (
        echo ERRO: Falha na inicialização do banco. >> "%LOG_FILE%"
        exit /b 1
    )

    REM Instala o serviço
    echo Instalando serviço... >> "%LOG_FILE%"
    "%MYSQL_DIR%\bin\mysqld.exe" --install "%SERVICE_NAME%" --defaults-file="%MYSQL_DIR%\my.ini" >> "%LOG_FILE%" 2>&1
    IF !ERRORLEVEL! NEQ 0 (
        echo ERRO: Falha na instalação do serviço. >> "%LOG_FILE%"
        exit /b 1
    )

    REM Inicia o serviço
    echo Iniciando serviço... >> "%LOG_FILE%"
    net start %SERVICE_NAME% >> "%LOG_FILE%" 2>&1
    IF !ERRORLEVEL! NEQ 0 (
        echo ERRO: Falha ao iniciar o serviço. >> "%LOG_FILE%"
        exit /b 1
    )
)

REM --- Aguarda até 30 segundos pelo serviço ---
echo Aguardando inicialização do MySQL... >> "%LOG_FILE%"
set COUNTER=0
:LOOP
net start %SERVICE_NAME% | find "already running" >nul
IF %ERRORLEVEL% EQU 0 (
    echo Serviço em execução. >> "%LOG_FILE%"
    goto CONTINUE
)
timeout /t 1 >nul
set /a COUNTER+=1
IF %COUNTER% GEQ 30 (
    echo ERRO: Timeout ao aguardar serviço. >> "%LOG_FILE%"
    exit /b 1
)
goto LOOP

:CONTINUE
REM --- Define senha do root ---
echo Definindo senha... >> "%LOG_FILE%"
"%MYSQL_DIR%\bin\mysqladmin.exe" -u root password "%ROOT_PASSWORD%" >> "%LOG_FILE%" 2>&1
IF !ERRORLEVEL! NEQ 0 (
    echo ERRO: Falha ao definir senha. >> "%LOG_FILE%"
    exit /b 1
)

REM --- Importa o banco de dados ---
echo Importando %SQL_SCRIPT%... >> "%LOG_FILE%"
"%MYSQL_DIR%\bin\mysql.exe" -u root -p"%ROOT_PASSWORD%" --execute="source %~dp0%SQL_SCRIPT%" >> "%LOG_FILE%" 2>&1
IF !ERRORLEVEL! NEQ 0 (
    echo ERRO: Falha ao importar o banco. >> "%LOG_FILE%"
    exit /b 1
)

echo Configuração concluída com sucesso! >> "%LOG_FILE%"
ENDLOCAL
exit /b 0