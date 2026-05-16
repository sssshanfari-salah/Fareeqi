@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem create_fareeqi_project.cmd
rem Usage: create_fareeqi_project.cmd ProjectName [TargetPath]
rem Creates a new project folder with the same structure as this workspace (Fareeqi-style).

if "%~1"=="" (
  echo Usage: %~nx0 ProjectName [TargetPath]
  echo Example: %~nx0 MyNewApp
  exit /b 1
)

set "PROJECT_NAME=%~1"
if "%~2"=="" (
  set "TARGET_DIR=%~dp0%PROJECT_NAME%"
) else (
  set "TARGET_DIR=%~2\%PROJECT_NAME%"
)

rem Create destination root
if not exist "%TARGET_DIR%" (
  mkdir "%TARGET_DIR%" >nul 2>&1 || (echo Failed to create "%TARGET_DIR%" & exit /b 1)
)

echo Creating project "%PROJECT_NAME%" at "%TARGET_DIR%"

rem Copy root files if they exist in the template workspace
for %%F in (LICENSE package.json README.md requirements.txt) do (
  if exist "%~dp0%%F" (
    copy /Y "%~dp0%%F" "%TARGET_DIR%\%%F" >nul
  )
)

rem Copy common directories (use robocopy for robust recursive copy). If a source directory doesn't exist, create empty one.
for %%D in (assets docs src templates tests) do (
  if exist "%~dp0%%D\" (
    robocopy "%~dp0%%D" "%TARGET_DIR%\%%D" /E /NFL /NDL /NJH /NJS >nul
  ) else (
    mkdir "%TARGET_DIR%\%%D" >nul 2>&1
  )
)

rem Ensure assets subfolders exist (common in Fareeqi structure)
if not exist "%TARGET_DIR%\assets\files\" mkdir "%TARGET_DIR%\assets\files" >nul 2>&1
if not exist "%TARGET_DIR%\assets\Pictures\" mkdir "%TARGET_DIR%\assets\Pictures" >nul 2>&1

echo Project skeleton created.
echo - Path: "%TARGET_DIR%"
echo - Edit files under the new project to customize them (README, package.json, etc.).

endlocal
exit /b 0
