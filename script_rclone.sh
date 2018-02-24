#!/bin/bash
#
# Este script comprueba si una lista de remotes de rclone está correctamente montada, y en caso de no ser así, realiza su montaje.
# Es necesario personalizar:
# listremotes: 	referido al fichero que contiene la lista de remotes y por linea la config del remote (consultar fichero para personalizarlo). 
#		Por defecto se almacena junto a este script (no obstante se puede personalizar en la variable que inicia el script).
# rclone_path: ruta absoluta donde se encuentra el binario de rclone.
#

listremotes="./remoteslist"
rclone_path="/bin"
while read -r line
do
	if [[ ${line:0:1} != "#"  &&  $line != "" ]]
	then
		your_remote_name=`echo $line | cut -d $ -f 1`
		path_in_remote=`echo $line | cut -d $ -f 2`
       		mount_path=`echo $line | cut -d $ -f 3`
        	mount_options=`echo $line | cut -d $ -f 4`
        	rclone_options=`echo $line | cut -d $ -f 5`
		check_mount=$your_remote_name:$path_in_remote
        	is_mount=`mount | grep $check_mount | grep $mount_path`
        	date=`date +%d-%m-%Y:%H:%M:%S`

        	if [ "$is_mount" == "" ]
        	then
               		echo $date": Unidad no montada, realizando montaje del remote: "$your_remote_name:/$path_in_remote
               		$rclone_path/rclone $rclone_options mount $mount_options $your_remote_name:/$path_in_remote $mount_path &
        	else
               		echo $date": Montaje del remote "$your_remote_name:/$path_in_remote" correcto."
        	fi

	fi
done < $listremotes

