---
title: 'Integración continua con Jenkins: Parte 2 (Configurar proyecto Rails e integración
  con Bitbucket y HipChat)'
date: '2013-11-18'
tags:
- devops
dc:creator: hopsor
---

[![](http://blog.diacode.com/wp-content/uploads/2013/10/jenkins-rails.png)](http://blog.diacode.com/wp-content/uploads/2013/10/jenkins-rails.png)
Lo prometido es deuda y tras ofreceros el post sobre 
[cómo instalar y configurar Jenkins](http://blog.diacode.com/integracion-continua-con-jenkins-parte-1-introduccion-e-instalacion) hoy os traemos una segunda parte en la cual os explicaremos como poner en marcha nuestro proyecto 
**Ruby on Rails**
 con 
**Jenkins CI**
 e integrarlo con 
**Bitbucket**
 y 
**Hipchat**
. Siguiendo los pasos de este tutorial conseguiremos que cada vez que 
pusheamos commits al repositorio nuestro servidor de integración continua se entere de estos cambios, los descargue y ejecute la batería de tests para verificar que no se ha roto nada. El resultado de ejecutar la batería de tests será notificado en una sala de chat. Este viene siendo el 
approach que seguimos desde hace algún tiempo para nuestros proyectos y queremos compartirlo con todos vosotros.


<!--more-->

##Pre-requisitos

En nuestro caso nos hemos decantado por 
[RVM](http://rvm.io/) como gestor de versiones de Ruby para nuestro servidor de Jenkins ya que es lo que venimos usando habitualmente. Aunque no ahondaremos en la explicación de como instalar rvm ya que deberíais saberlo si habéis llegado hasta aquí, sí que aclararemos que la instalación de esta herramienta debe hacerse en su modalidad single user empleando para ello vuestro usuario de Jenkins. Os recomendamos también como buena práctica que dediquéis un gemset a cada proyecto que vayáis a ejecutar en vuestro entorno de integración continua.

Además de rvm habrá que instalar un par de plugins en Jenkins para la integración con 
[Bitbucket](https://wiki.jenkins-ci.org/display/JENKINS/Git+Plugin) y 
[Hipchat](http://wiki.jenkins-ci.org/display/JENKINS/HipChat+Plugin). Podéis hacerlo pinchando en 
**Administrar Jenkins**
 y 
**Administrar Plugins**
 a continuación.

###Autorización de acceso al código en Bitbucket


Omitir este paso en caso de que el proyecto sea público.

Accederemos a la configuración de nuestro repositorio en Bitbucket. Una vez dentro nos iremos al menú de 
**Deployment keys**
 y añadiremos la clave pública del servidor de integración. De este modo el servidor de integración ya podrá hacer pull del proyecto.

La clave pública de nuestro servidor de integración la podremos encontrar en la ruta 
**/var/lib/jenkins/.ssh/id_rsa.pub**
.


###Prueba aislada de proyecto


Antes de crear la tarea en Jenkins es recomendable que accedamos por ssh a nuestro servidor con nuestra cuenta de usuario jenkins, clonemos el repositorio y hagamos bundle install de forma aislada ya que es bastante probable que falten algunas dependencias en el sistema derivadas del uso de gemas como pq, mysql2 o carrierwave entre otras. En ese caso las instalaremos del mismo modo que haríamos en nuestro entorno de desarrollo o producción.

Así mismo tendremos que crear en el sistema la base de datos que vaya a usarse para el entorno de test acorde a los credenciales del 
**database.yml**
.


###Configurando el plugin de Hipchat

Para que nuestro servidor Jenkins pueda comunicarse con nuestras salas de Hipchat en primer lugar es necesario generar un token en el servicio de Atlassian. Para ello nos loguearemos en nuestra cuenta de Hipchat desde la web, clickaremos en 
**Group Admin**
 y a continuación entraremos en la pestaña de API. Abajo aparacerá un formulario con el cual crearemos un nuevo token de tipo 
**Notification**
 y al cual pondremos de label 'Jenkins CI'. Una vez creado copiaremos el token para usarlo posteriormente en Jenkins.


[![](http://blog.diacode.com/wp-content/uploads/2013/11/hipchat-api-token.png)](http://blog.diacode.com/wp-content/uploads/2013/11/hipchat-api-token.png)

Una vez copiado el token nos iremos a la administración del servidor de Jenkins y dentro de 
**Configurar el sistema**
 pegaremos el token que hemos generado anteriormente en el apartado de 
**Global HipChat Notifier Settings**
. Además, en el campo de Jenkins URL pondremos la url de nuestro servidor de Jenkins para que los enlaces que se muestran en Hipchat apunten correctamente a donde corresponde.

##Creación y configuración del proyecto en Jenkins


Tras loguearnos en el servidor de integración con nuestros credenciales creamos el proyecto pinchando en 
**Nueva Tarea**
. En la pantalla que se nos mostrará a continuación escribiremos el nombre del proyecto en el campo 
**Nombre de la tarea**
 y seleccionaremos como tipo el de 
**estilo libre**
.

A continuación, en la siguiente pantalla, añadiremos información del proyecto en cuestión que vamos asociar. Iremos detallando sección por sección explicándolo.


###Hipchat notifications


En la sección de HipChat Notifications escribiremos el nombre de la sala donde queremos enviar las notificaciones y marcaremos el checkbox de 
**Start Notification**
.


###Configurar el origen del código fuente


En el origen del código fuente seleccionamos el tipo git y rellenamos con la URL donde está el repositorio de nuestro proyecto.


###Disparadores de ejecuciones


Aquí marcaremos el checkbox de 
**Lanzar ejecuciones remotas (ejem: desde 'scripts')**
 y en el campo de texto que se desplegará generaremos un token de seguridad que será necesario para emplearlo más tarde con los web hooks de Bitbucket.

Para generar este token bien podría usarse alguna extensión de vuestro navegador que genere strings aleatorios.


###Ejecutar


En este apartado pincharemos en el desplegable de 
**Añadir un nuevo paso**
 y seleccionaremos la acción 
**Ejecutar linea de comandos (shell)**
. Al agregar el nuevo paso aparecerá un textarea donde escribiremos las instrucciones a ejecutar para correr los tests del proyecto.


source /var/lib/jenkins/.bashrc
bundle install
rake

En caso de que no tengáis versionado en el repositorio el 
**database.yml**
 por razones de seguridad deberíais subirlo a vuestro homedir de Jenkins y añadir esta linea justo antes del rake del bloque de código anterior:


cp /var/lib/jenkins/conf_projects/nombre_proyecto/database.yml config/database.yml

###Acciones para ejecutar después


En este último paso clickearemos sobre el botón de 
**Añadir una acción**
 y seleccionaremos 
**HipChat Notifications**
.


##Configuración de Webhooks (comunicación entre Jenkins y Bitbucket)


Para que el servidor de Jenkins CI se entere de nuevos cambios en el proyecto tendremos que habilitar un hook en nuestro repositorio de Bitbucket. Para ello, yéndonos de nuevo a la pantalla de configuración de nuestro repositorio dentro de Bitbucket seleccionaremos esta vez el menú de 
**Hooks**
,  usaremos el hook de tipo 
**Jenkins**
 y pulsaremos 
**Add Hook**
. Acto seguido emergerá un formulario modal con cuatro campos.


###Endpoint


Endpoint es la URL de nuestro servidor de jenkins a la cual habremos de incorporar nuestro nombre de usuario y como contraseña el API token de nuestro usuario dentro de Jenkins. El API token de nuestro usuario de Jenkins lo podréis encontrar accediendo al servidor de integración pinchando sobre vuestro perfil en la esquina superior derecha y a continuación en el link de Configurar. El botón de 
**Show API Token**
 os dejará ver vuestro token para incorporarlo a la URL de modo que vuestro campo Endpoint debería quedar algo así como:
http://
**nombre_usuario**
:
**api_token**
@
**host_servidor_jenkins**


###Project name


Este es obvio y será el nombre del proyecto que hayamos usado en Jenkins.


###Token


Por último el token del proyecto. Este token es el que generamos en el apartado 
**disparadores de ejecuciones**
.
Seguidos estos pasos deberíamos tener configurado correctamente nuestro proyecto en Jenkins con su correspondiente integración con Bitbucket y Hipchat.

Si tenéis cualquier duda sobre el proceso podéis dejarnos un comentario o darnos un toque por Twitter e intentaremos echar una mano.
