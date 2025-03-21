@echo off
echo Running git add .
git add .
echo.

echo Running git commit
set /p commit_msg="Enter commit message (or press Enter to use 'Update'): "
if "%commit_msg%"=="" (
  set commit_msg=Update
)
git commit -m "%commit_msg%"
echo.

echo Running git push
git push
echo.

echo Done!
pause