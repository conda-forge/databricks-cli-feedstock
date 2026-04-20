@echo on

copy "%RECIPE_DIR%\build.sh" .

set PREFIX=%PREFIX:\=/%
set SRC_DIR=%SRC_DIR:\=/%
set MSYSTEM=MINGW%ARCH%
set MSYS2_PATH_TYPE=inherit
set CHERE_INVOKING=1


bash -lc "./build.sh"
bash -lc "go-licenses save . --save_path ../library_licenses --ignore github.com/mattn/go-localereader"
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

exit /b 0
