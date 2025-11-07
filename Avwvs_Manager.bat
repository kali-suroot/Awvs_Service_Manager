@echo off
title AWVS 服务管理器

:: ---------- 服务配置 ----------
set "SUPERVISOR_SVC=acunetix"
set "DATABASE_SVC=Acunetix Database"

:: ---------- 主菜单 ----------
:MAIN_MENU
cls
echo.
echo ========================================
echo         	AWVS 服务管理控制台
echo 建议管理员权限来启动服务
echo 请右键点击此脚本，选择"以管理员身份运行"
echo ========================================
echo.
call :CHECK_SERVICE_STATUS
echo.
echo ========================================
echo   1. 启动 AWVS 所有服务
echo   2. 停止 AWVS 所有服务  
echo   3. 重启所有服务
echo   4. 检查服务状态
echo.
echo   Q. 退出脚本
echo ========================================
echo.

set "CHOICE="
set /p "CHOICE= 请选择操作 [1,2,3,4,Q]: "

if /i "%CHOICE%"=="Q" goto EXIT_SCRIPT
if "%CHOICE%"=="1" goto START_ALL
if "%CHOICE%"=="2" goto STOP_ALL
if "%CHOICE%"=="3" goto RESTART_ALL
if "%CHOICE%"=="4" goto CHECK_STATUS

echo [错误] 无效选择，请重新输入！
timeout /t 2 >nul
goto MAIN_MENU

:: ---------- 启动所有服务 ----------
:START_ALL
echo.
echo [信息] 正在启动 AWVS 所有服务...
net start "acunetix" >nul 2>&1 && echo [成功] Acunetix Supervisor 已启动 || echo [信息] Acunetix Supervisor 已在运行
net start "Acunetix Database" >nul 2>&1 && echo [成功] Acunetix Database 已启动 || echo [信息] Acunetix Database 已在运行
echo.
echo [完成] AWVS 服务启动完成！
echo [提示] 访问地址: https://localhost:3443/#/login
goto PAUSE_RETURN

:: ---------- 停止所有服务 ----------
:STOP_ALL
echo.
echo [信息] 正在停止 AWVS 所有服务...
net stop "Acunetix Database" >nul 2>&1 && echo [成功] Acunetix Database 已停止 || echo [信息] Acunetix Database 未运行
net stop "acunetix" >nul 2>&1 && echo [成功] Acunetix Supervisor 已停止 || echo [信息] Acunetix Supervisor 未运行
echo.
echo [完成] AWVS 服务已完全停止！
goto PAUSE_RETURN

:: ---------- 重启所有服务 ----------
:RESTART_ALL
echo.
echo [信息] 正在重启 AWVS 所有服务...
net stop "Acunetix Database" >nul 2>&1 && echo [成功] Acunetix Database 已停止 || echo [信息] Acunetix Database 未运行
net stop "acunetix" >nul 2>&1 && echo [成功] Acunetix Supervisor 已停止 || echo [信息] Acunetix Supervisor 未运行
echo [信息] 等待服务完全停止...
timeout /t 2 >nul
net start "acunetix" >nul 2>&1 && echo [成功] Acunetix Supervisor 已启动 || echo [错误] Acunetix Supervisor 启动失败
net start "Acunetix Database" >nul 2>&1 && echo [成功] Acunetix Database 已启动 || echo [错误] Acunetix Database 启动失败
echo.
echo [完成] AWVS 服务重启完成！
goto PAUSE_RETURN

:: ---------- 状态检查 ----------
:CHECK_STATUS
echo.
call :CHECK_SERVICE_STATUS
goto PAUSE_RETURN

:: ---------- 暂停并返回菜单 ----------
:PAUSE_RETURN
echo.
set /p "=按任意键返回菜单... "<nul
pause >nul
goto MAIN_MENU

:: ---------- 退出脚本 ----------
:EXIT_SCRIPT
cls
echo.
echo ========================================
echo          感谢使用 AWVS 服务管理器
echo ========================================
echo.
echo [信息] 脚本退出
timeout /t 1 >nul
exit /b 0

:: ---------- 服务状态检查函数 ----------
:CHECK_SERVICE_STATUS
echo [信息] 当前服务状态：

sc query "acunetix" | find "RUNNING" >nul
if errorlevel 1 (
    echo    Acunetix Supervisor:   [已停止]
) else (
    echo    Acunetix Supervisor:   [运行中]
)

sc query "Acunetix Database" | find "RUNNING" >nul
if errorlevel 1 (
    echo    Acunetix Database:     [已停止]
) else (
    echo    Acunetix Database:     [运行中]
)
goto :eof