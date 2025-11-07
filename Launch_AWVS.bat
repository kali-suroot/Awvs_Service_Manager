@echo off
title 启动 AWVS 服务

:: 检查管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 需要管理员权限来启动服务
    echo 请右键点击此脚本，选择"以管理员身份运行"
    pause
    exit /b 1
)

:: 切换到脚本目录
cd /d "%~dp0"

echo 正在启动 AWVS 服务...
echo.

:: 启动服务
net start "acunetix" >nul 2>&1 && echo [成功] Acunetix Supervisor 已启动 || echo [信息] Acunetix Supervisor 已在运行
net start "Acunetix Database" >nul 2>&1 && echo [成功] Acunetix Database 已启动 || echo [信息] Acunetix Database 已在运行

echo.
echo AWVS 服务启动完成！
echo 访问地址: https://localhost:3443/#/login
echo.

:: 可选：自动打开浏览器
set /p "OPEN=是否立即打开AWVS网页界面？(Y/N): "
if /i "%OPEN%"=="Y" (
    start https://localhost:3443/#/login
)

echo.
echo 按任意键关闭窗口...
pause >nul
