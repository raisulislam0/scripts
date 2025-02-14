@echo off
setlocal

:: Prompt user for directory (or use current directory if none is provided)
set /p dir="Enter directory path (Press Enter for current directory): "

:: If no input, use current directory
if "%dir%"=="" set dir=%cd%

:: Generate tree structure and save to file
tree "%dir%" /F /A > tree_structure.txt

echo Tree structure saved to tree_structure.txt
exit
