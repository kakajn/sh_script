@REM  first of all, pull the remote code to local.
git pull origin master

@REM  add all the file to temporary
git add .

@REM  commit code to local
git commit -m "提交代码"

@REM push local code to the remote repository.
git push master master

@REM pause execute and see whether is successful.
pause

echo "THE PROCESSING IS END"