---
title: 'Integración continua con Jenkins: Parte 1 (Introducción e Instalación)'
date: '2013-10-30'
tags:
- devops
dc:creator: hopsor
---

[![](http://blog.diacode.com/wp-content/uploads/2013/10/jenkins-logo.png)](http://blog.diacode.com/wp-content/uploads/2013/10/jenkins-logo.png)


##Introducción

Desde hace algún tiempo, con el fin de mejorar nuestras prácticas en cuanto al testeo de proyectos, decididmos instalar en uno de nuestros servidores 
[Jenkins](http://jenkins-ci.org/). Para los que no lo conozcáis Jenkins se trata de una herramienta open source de 
**integración continua**
 que nos permite 
**ejecutar la batería de tests de nuestros proyectos**
 en un entorno independiente archivando los resultados de cada build y generando estadísticas. Las ejecuciones se pueden programar periódicamente, realizar bajo demanda o bien mediante disparadores tras realizar un commit en el repositorio del proyecto, siendo esta última la más interesante y la cual trataremos de explicar en detalle en sucesivos posts.


<!--more-->

Jenkins nace en 2011 y es un proyecto que surge como un fork de Hudson, desarrollado inicialmente en 2004 dentro de Sun Microsystems. Actualmente el desarrollo de Jenkins continúa bastante activo y hay gran cantidad de plugins que nos permitirán entre otras cosas integrar nuestro Jenkins con nuestros repositorios en Github o Bitbucket además de con otros servicios de mensajería como Hipchat para recibir las notificaciones del estado de las últimas 
builds.

A lo largo de esta serie de posts explicaremos como instalar Jenkins en un servidor 
**Ubuntu**
, configurar un proyecto 
**Rails**
 e integrarlo con los servicios ofrecidos por Atlassian de 
**[Bitbucket](http://bitbucket.org)**
 y 
**[Hipchat](htp://hipchat.com)**
 que son los que empleamos en la actualidad dentro de nuestro workflow.

##Instalación

La instalación de Jenkins es bastante sencilla y viene bien explicada en la web de Jenkins con lo cual nos limitaremos a traducir y dar alguna pincelada sobre lo que ya hay.

###Dependencias

Antes de empezar debemos asegurarnos de que tenemos las dependencias de Java instaladas en nuestro sistema. En caso de que no sea así las instalaremos mediante:

sudo apt-get install openjdk-7-jre and openjdk-7-jdk

###Instalación

Una vez que tengamos las dependencias instaladas procederemos a la instalación de Jenkins usando como fuente los repositorios de Jenkins para asegurarnos de que estamos instalando la última versión disponible.

wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
La instalación de Jenkins conllevará lo siguiente:

*El servicio de Jenkins se pondrá en funcionamiento al arrancar el sistema.

	
*El usuario 'jenkins' será creado para ejecutar dicho servicio.

	
*Se creará el homedir para el usuario 'jenkins' en la carpeta /var/lib/jenkins donde podremos encontrar el archivo de configuración del servicio (config.xml).

	
*El log de Jenkins podrá encontrarse en la ruta /var/log/jenkins.

	
*Por defecto Jenkins escucha en el puerto 8080.

###Mover Jenkins al puerto 80 (opcional)

Si queremos emplear la interfaz web de Jenkins desde el puerto 80 una de las opciones que tenemos sin tocar nada de la configuración de Jenkins es crear un proxy HTTP con nginx siguiendo 
[estos pasos](https://gist.github.com/rdegges/913102#file-proxy_nginx-sh):

sudo aptitude -y install nginx
cd /etc/nginx/sites-available
sudo rm default
sudo cat > jenkins
upstream app_server {
    server 127.0.0.1:8080 fail_timeout=0;
}

server {
    listen 80;
    listen [::]:80 default ipv6only=on;
    server_name ci.yourcompany.com;

    location / {
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header Host $http_host;
proxy_redirect off;

if (!-f $request_filename) {
    proxy_pass http://app_server;
    break;
}
    }
}
^D # Hit CTRL + D to finish writing the file
sudo ln -s /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/
sudo service nginx restart

###Securizando Jenkins

Por defecto Jenkins viene sin seguridad alguna y por consiguiente es accesible por cualquier persona que acceda a la url del servicio. Para solventar esto haremos lo siguiente:

*Accedemos a la configuración global de seguridad de nuestro servidor de Jenkinks (
[http://servidor/jenkins/configureSecurity/](http://server/jenkins/configureSecurity/))

	
*Marcamos la casilla 'Activar seguridad'.

	
*En el apartado Seguridad marcamos la opción '
**Usar base de datos de Jenkins**
' y marcamos también '
**Permitir que los usuarios se registren**
'.

	
*Seleccionamos la '
**Configuración de seguridad**
' como autorización y dentro de ella le damos permiso de lectura al usuario Anónimo.

	
*En la caja de texto de abajo ingresamos el nombre de usuario que vaya a ser administrador y clickamos en el botón de 
**añadir**
. Aparecerá en la matriz una nueva fila para este usuario para la cual marcaremos todas las casillas ayudándonos del botón que hay al final de la última columna y que facilitará esta labor.

	
*Por último guardamos los cambios.
Ahora que ya están aplicados los cambios será necesario reiniciar el servidor de Jenkins mediante:

sudo service jenkins restart
Por último, solo falta que demos de alta la cuenta del usuario al que dimos permiso anteriormente en el paso 5. Para ello accederemos de nuevo a la URL de nuestro servidor de Jenkins y pincharemos en 
**Registrarse**
 o 
**Crear cuenta**
. Una vez dentro del formulario nos aseguraremos de que el nombre de usuario coincide con el que ingresamos en el paso 5 para que así tengamos todos los permisos que seleccionamos.

Tras completar el formulario ya estaremos dentro del sistema autenticados. Para terminar solo quedará volver a la configuración global de seguridad de nuestro servidor y desmarcar la opción de 'Permitir que los usuarios se registren' para evitar que se registre gente no deseada. Los sucesivos usuarios que queramos que accedan al sistema podrán ser dados de alta manualmente desde la gestión de usuarios de Jenkins (
[http://servidor/securityRealm/](http://servidor/securityRealm7)).

Con todo esto ya tenemos nuestro servidor de Jenkins CI listo para poder empezar a trabajar con él de manera segura. En el próximo post os contaremos como poner en marcha un proyecto de 
**Rails**
 e integrarlo con 
**Bitbucket**
 y 
**Hipchat**
.
