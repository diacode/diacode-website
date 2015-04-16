---
title: 'Desplegando Rails II: Heroku'
date: '2013-10-08'
tags:
- programacion
author: Ricardo
---

En el 
[post anterior](http://blog.diacode.com/desplegando-rails-i-eligiendo-hosting-paas-vs-iaa) os contaba como en 
**Diacode**
 nos gusta poder desplegar los proyectos en los que estamos trabajando cuanto antes, para que nuestros clientes formen parte activa en su desarrollo. También os hablé de los dos tipos de 
**servicios en la nube**
 que más usamos para lograr esto, y las diferencias entre ellos.
Aunque ambos servicios son completamente diferentes el uno del otro, usar un 
**PAAS**
 y más concretamente 
**Heroku**
, es probablemente la forma más rápida y cómoda de tener una versión de tu proyecto desplegado y visible para quien queramos en pocos minutos .




 ###[![](https://diacode-blog.s3-eu-west-1.amazonaws.com/2013/09/heroku-logo.png)](heroku.com)


###Empezando

Empezar con 
**Heroku**
 es realmente sencillo. Solo tenemos que registrarte con su plan 
**gratuito**
 y ya puedes empezar a crear y desplegar tus aplicaciones. Para ello solo tenemos que seguir los siguientes pasos:

**Paso 1: Registrarnos**
El sistema de registro es súper simple. Solo tenemos que acceder a su 
[página de registro](https://devcenter.heroku.com/articles/dynos), introducir tu 
email y ya está.

**Paso 2: Instalar las herramientas**
Lo siguiente que tenemos que hacer es instalar las herramientas necesarias para poder trabajar con 
**Heroku**
 desde tu linea de comandos. Estas herramientas vienen reunidas en el 
[Heroku Toolbelt](https://toolbelt.heroku.com/) y consta de:

*El 
[cliente de Heroku](https://github.com/heroku/heroku) para poder manejar nuestras aplicaciones desde la linea de comandos.

	
*[Foreman](https://github.com/ddollar/foreman).

	
*[Git](https://code.google.com/p/git-osx-installer/) el sistema de control de versiones que usaremos para desplegar los cambios realizados en nuestras aplicaciones.

**Paso 3: Hacer logearnos desde la linea de comands**
Teniendo todo instalado correctamente, para logearnos en 
**Heroku**
 tenemos que usar la siguiente instrucción desde la linea de comandos:

$ heroku login Enter your Heroku credentials. 
Email: usuario@ejemplo.com 
Password: Could not find an existing public key. 
Would you like to generate one? [Yn] 
Generating new SSH public key. Uploading ssh public key /Users/usuario/.ssh/id_rsa.pub
 

Como podemos ver, además de pedirnos el email y contraseña que hemos usado para registrarnos anteriormente, también sube nuestra claver pública o nos pregunta si queremos generar una en caso de no tener una. Esta clave la usará posteriormente cuando queramos hacer 
push de nuestros cambios.

###Preparando nuestra aplicación

Ya nos hemos registrado en 
**Heroku**
, instalado todo lo necesario y nos hemos logeado, así que ya estamos listos para desplegar nuestra aplicación (la cual tenemos ya controlando sus versiones mediante Git). Pero antes tenemos que tener en cuenta una serie de cosas, y realizar algunos cambios en ella para que todo vaya como la seda.

Especificar la versión de Ruby
Aunque 
**Heroku**
 usa una versión reciente de 
**Ruby**
, se le puede especificar en nuestro 
Gemfile la versión que queremos que use exactamente:

# Gemfile ruby "2.0.0"

Usar y configurar PostgreSQL
Como base de datos 
**Heroku**
 usa 
PostgreSQL de forma predeterminada, así que nos aconsejan que usemos la misma en caso de que estemos usando otra como 
SQLite:

# Gemfile 
# gem 'sqlite3' 
gem 'pg'
Y también acordarnos de configurar su conexión:

# config/database.yml 
development: 
  adapter: postgresql 
  encoding: utf-8 
  database: miapp_development 
  pool: 5 
  username: miapp 
  password: 

test: 
  adapter: postgresql 
  encoding: utf-8 
  database: miapp_test 
  pool: 5 
  username: miapp 
  password: 

production: 
  adapter: postgresql 
  encoding: utf-8 
  database: miapp_production 
  pool: 5 
  username: miapp 
  password:

Usando Rails 4
Así mismo, si nuestra aplicación usa 
**Rails 4**
, y queremos usar funcionalidades como servir 
assets estáticos, 
logging y demás que han sido separados del core de 
**Rails 4**
 tenemos que añadir esta gema:

# Gemfile 
gem 'rails_12factor', group: :production

Configurando el servidor web
También nos recomiendan usar 
[Unicorn](http://unicorn.bogomips.org/) como servidor web en producción. Para ello añadiremos su respectiva gema a nuestro 
Gemfile:

# Gemfile 
gem 'unicorn'
Para su configuración, crearemos un archivo llamado 
config/unicorn.rb con el siguiente contenido:

# config/unicorn.rb
worker_processes 3
timeout 30
preload_app true

before_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
 

Con esta configuración la gente de se asumen que estamos usando 
ActiverRecord por defecto, y que consultemos la 
[documentación de Unicorn](http://unicorn.bogomips.org/Unicorn/Configurator.html) para conocer otras opciones.

Para cambiar la forma en que vamos a arrancar el servidor usando 
**Foreman**
, tenemos que crear un fichero 
Procfile con el siguiente contenido:

web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
De esta forma arrancará nuestro servidor Unicorn usando el fichero de configuración que hemos creado anteriormente.

Añadiendo el repositorio remoto para Heroku
Una vez preparada nuestra aplicación para el despliegue, tenemos que crear el repositorio remoto que usaremos para hacer push de nuestra aplicación y así desplegarla. Para ello desde desde el directorio raiz de nuestra aplicación tenemos que lanzar la siguiente instrucción:

$ heroku create 
Creating silent-forrest-4552... done, stack is cedar http://silent-forrest-4552.herokuapp.com/ | git@heroku.com:silent-forrest-4552.git Git remote heroku added
Si luego listamos los repositorios remotos, veremos que nos ha creado uno nuevo, llamado 
heroku/master. Ya estamos listos para desplegar!

###Desplegando nuestra aplicación

Desplegar es tan sencillo con realizar un 
push al repositorio remoto que nos ha creado antes:

$ git push heroku master 
Counting objects: 112, done. Delta compression using up to 4 threads. 
Compressing objects: 100% (77/77), done 
...
Mientras se lleva a cabo el despliegue, nos irá informando por consola sobre el progreso. Así que veremos sube la aplicación, instala las gemas, configura la conexión a la base de datos, precompila 
assets y demás operaciones que realiza para preparar nuestra aplicación.

Si todo ha ido bien, ahora tendremos que lanzar las migraciones para la generación de las tablas usando el cliente de 
**Heroku**
 instalado previamente:

$ heroku run rake db:migrate
Y reiniciar nuestra applicación:

$ heroku restart
Para abrir nuestra aplicación en el navegador solo tenemos que ejecutar el siguiente comando:

$ heroku open
En caso de haber habido algún error durante el despliegue, o simplemente querer ver los logs, podemos hacerlo usando:

$ heroku logs --tail
Y para comprobar el estado de los procesos que están corriendo (en nuestro ejemplo el servidor web):

$ heroku ps 
=== web: `bin/rails server -p $PORT -e $RAILS_ENV` web.1: up for 5s
E incluso podemos entrar en la consola de Rails usando:

$ heroku run rails console

###Conclusión


**Heroku**
 es una opción muy 
**rápida y sencilla**
 para desplegar una aplicación ya que el plan gratuito es perfecto para empezar y tener una versión de nuestro trabajo que mostrar en pocos minutos. A medida que queramos ir ampliando los recursos o añadiendo nuevos 
plugins no nos quedará más remedio que empezar a pagar, y si nuestra aplicación no es demasiado grande, no tiene demasiadas visitas ni procesos complicados, probablemente el precio que tengamos que pagar no es tan ajustado como debería. Por eso existen otras opciones que, sacrificando un poquito de sencillez, nos aportan mucha más flexibilidad y potencia por mucho menos dinero. Pero esto lo veremos en el próximo 
post de esta serie.

Happy coding!
