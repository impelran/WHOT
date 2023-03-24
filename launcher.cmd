@echo off
echo Veillez a bien prendre en compte les informations suivantes :
echo - Un point de restoration sera cree sous le nom de [101m"RestorePointBeforeHardening"[0m.
echo[

echo - Le programme va modifier les permissions/parametre/autorisation/... de certains fichiers/dossiers/registres/services/... de votre ordinateur (plus d'informations dans le fichier "README.md")
echo[

echo - Le programme peut afficher des messages d'erreurs, ne pas les prendre en compte (sauf si le programme s'arrete).
echo[

echo - Le programme peut prendre du temps a s'executer, ne pas fermer le programme avant la fin [101mTOTALE[0m de l'execution.
echo[

echo - Ne [101mJAMAIS[0m relancer le programme meme si il s'est arrete, cela peut entrainer des problemes (utiliser le point de restauration cree au debut du programme).
echo[

echo - Fermez [101mTOUS[0m les programmes avant de lancer le programme.
echo[
    
echo - Ne [101mJAMAIS[0m cliquer sur aucun bouton pendant l'execution du programme meme si propose (toutes les actions sont automatiques).


@echo off
REM  :: Analyse les permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM :: Si une erreur est detecte les autorisations admin sertont refusees
if '%errorlevel%' NEQ '0' (
    echo Demande des droits administrateurs...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

@echo off
setlocal
:PROMPT
SET /P AREYOUSURE=Etes vous sur de lancer le programme (Y/N)? 
IF /I "%AREYOUSURE%" NEQ "Y" OR "y" GOTO END

echo Lancement du programme

::#######################################################################
::#######################################################################
:: PowerShell
::#######################################################################
::#######################################################################
powershell.exe -ExecutionPolicy Bypass -File "Script.ps1"