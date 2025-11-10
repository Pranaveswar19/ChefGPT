@echo off
cd /d "C:\Users\mpran\OneDrive\Desktop\Project\chefgpt_ai_recipe"
echo Running Flutter pub get...
flutter pub get
echo.
echo Analyzing code...
flutter analyze
echo.
echo Done!
pause
