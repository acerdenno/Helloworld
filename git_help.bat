@REM Crear un nuevo repositorio
git init 

@REM Añadir cambios que se quieren guardar
git add <nombre-del-archivo>

@REM Con un punto se añaden todos los cambios
@REM del directorio actual
git add .

@REM Ver situación actual
git status

@REM Confirmar los cambios [dando un nombre]
git commit -m <titulo>

@REM Actualizar los cambios en el repositorio de GH
git push




@REM Para añadir como remoto un repo de GH
git remote add origin <URL-del-repo>

@REM La primera vez que se hace git push 
@REM con una rama nueva:
git push --set-upstream origin master
