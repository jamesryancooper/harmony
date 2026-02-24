@echo off
setlocal enabledelayedexpansion

REM Engine-owned launcher for harmony-policy.
set RUNTIME_DIR=%~dp0
if "%RUNTIME_DIR:~-1%"=="\" set RUNTIME_DIR=%RUNTIME_DIR:~0,-1%
for %%I in ("%RUNTIME_DIR%\..") do set ENGINE_DIR=%%~fI
for %%I in ("%ENGINE_DIR%\..") do set HARMONY_DIR=%%~fI

if defined HARMONY_POLICY_BIN (
  if exist "%HARMONY_POLICY_BIN%" (
    "%HARMONY_POLICY_BIN%" %*
    exit /b %ERRORLEVEL%
  )
)

set TARGET_DIR=%ENGINE_DIR%\_ops\state\build\runtime-crates-target
set BIN=%TARGET_DIR%\debug\harmony-policy.exe

if not exist "%BIN%" (
  if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"
  set CARGO_TARGET_DIR=%TARGET_DIR%
  cargo build -q --manifest-path "%RUNTIME_DIR%\crates\Cargo.toml" -p policy_engine --bin harmony-policy
  if errorlevel 1 exit /b %ERRORLEVEL%
)

"%BIN%" %*
exit /b %ERRORLEVEL%
