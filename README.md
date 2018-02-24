# rclone_script_mount
A script that checks if 'remotes' are mounted in system. If not, it mount them.

Este script comprueba si una lista de remotes de rclone está correctamente montada, y en caso de no ser así, realiza su montaje. Para saber que remotes debe montar, las opciones, y todo lo referente a cada cual, hace uso de un fichero de texto en el que definimos todo esto.

SOBRE EL SCRIPT:
----------------
Es necesario personalizar estas variables dentro del script:
·listremotes: referido al fichero que contiene la lista de remotes y por linea la config del remote (consultar fichero para personalizarlo). Por defecto he indicado que se almacena junto a este script manteniendo el mismo nombre (no obstante se puede personalizar tanto el nombre del fichero como la ruta en la que se encuentra, y para ello está la variable al inicio del script).
·rclone_path: ruta absoluta donde se encuentra el binario de rclone. 

SOBRE EL FICHERO REMOTESLIST:
-----------------------------
Este fichero contiene un Remote por línea. El separador de campo, actualmente es el símbolo '$'.
· RemName: 	es el nombre del remote a secas.
· PathInRem: 	Directorio (si se requiere) del que se parte para realizar el punto de montaje en el Remote. No se tiene en cuenta el caracter raíz /. Lo dejamos vacío para dejar la raíz por defecto.  
· MountPoint:	Directorio del sistema sobre el que vamos a realizar el montaje.	
· MountPointOptions: Opciones específicas del montaje (flags como --allow-other --read only).
· RCloneOptions: Opciones específicas de rclone (como -v, --stats...).

Quedando así el patron por línea: RemName$PathInRem$MountPoint$MountPointOptions$RCloneOptions

Vamos a ver un par de ejemplos para entenderlo mejor. Imaginemos que tengo 2 remotes definidos, temp1 y temp2 respectivamente. Manualmente los montaría de esta forma (escogidos como ejemplos para presentar las casuísticas principales):
1. rclone --tpslimit 6 --transfers=4 mount --allow-other temp1: /mnt/temp1 
2. rclone -v --tpslimit 4 mount --allow-other ---read-only temp2:/Data/ex /mnt/temp2

De esta forma traduciría estos comandos de montaje al fichero remoteslist:
1. temp1$$/mnt/temp1$--allow-other$--tpslimit 6 --transfers=4
2. temp2$Data/ex$/mnt/temp2$--allow-other --read-only$-v --tpslimit 4 


MODO DE USO:
------------
1. Descargar el script, y el fichero remoteslist.
2. Darle permisos de ejecución al script, y revisar que hay permisos de lectura para poder llegar al fichero remoteslist.
3. Personalizar el fichero remoteslist con nuestros remotes (que ya deberíamos tener definidos previamente). Al igual comprobar que las rutas para el montaje están creadas y que todo está correctamente para realizar el montaje. VER APARTADO SOBRE EL FICHERO REMOTESLIST para dudas.
4. Programar el script en cron, como una tarea cualquiera, para que se ejecute como queremos y con el mismo usuario con el que hemos realizado la config de los remotes (o en su defecto, darle el conf de rclone en el comando de montaje). Por ejemplo para que se ejecute cada minuto: "*/1 * * * *  script_rclone.sh" ó cada 5 min: "*/5 * * * *  script_rclone.sh". 
5. Listo. Esperar a que se ejecute la tarea (en algunos sistemas puede ser conveniente reiniciar).

ANOTACIONES:
------------
- Controla el que haya líneas vacías en el fichero de remotes.
- Se permite el montaje de directorios del remote (se puede montar un subárbol del árbol completo del remote).
- El carácter reservado para separar los campos es el símbolo '$'. Este carácter no se puede usar para definir remotes ni rutas; si se ha usado, no va a funcionar correctamente.
- El fichero de remotes permite comentar líneas comenzando por la almohadilla # (cualquier linea que comience con dicho caracter es descartada).
- Se puede redirigir la salida a un fichero log para obtener un pequeño debug de las ejecuciones del script. No obstante, tener en cuenta que si siempre se almacena el log, puede ser un problema con el tiempo, por el espacio que puede llegar a consumir. Hay que tener en cuenta que si ejecutamos el script cada minuto, en una hora tendriamos 60 lineas en el log, y así consecutivamente.

Cualquier sugerencia o correcciones que se consideren necesarias, abrir un issue.
