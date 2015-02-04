---
title: Testeando el rendimiento de tu aplicación con Apache Bench
date: '2013-08-13'
tags:
- programacion
dc:creator: Javier
---

![](http://blog.diacode.com/wp-content/uploads/2013/08/results.png)

Recientemente uno de nuestros clientes nos solicitó realizar unos test de estrés a una aplicación (Ruby on Rails). Después de barajar diferentes opciones, entre ellas el propio 
[framework oficial para Performance Testing de Rails](http://guides.rubyonrails.org/v3.2.13/performance_testing.html), decidimos optar por algo más sencillo y genérico 
[Apache Bench](http://httpd.apache.org/docs/2.2/programs/ab.html).

El funcionamiento de Apache Bench es relativamente sencillo, 
**indicamos la URL a testear, el número de peticiones que queremos realizar y el número de peticiones concurrentes**
.


Además 
**en nuestro caso la aplicación requiere de un login con email y contraseñ**
a, por ello necesitamos pasarle a Apache Bench la cookie con el identificador de sesión. Para averiguar el identificador de sesión basta con abrir la aplicación en Chrome, hacer login, abrir el Inspector y buscar la cookie en la pestaña Resources (en el sidebar de la izquierda bajo Cookies).

Nuestra llamada Apache Bench quedaría así:

ab -g results.tsv -n 1000 -c 20 -C nuestra_app_session=243bae5d57cd962a89831bbaac82db http://nuestra-app.com/
Donde:

*ab es Apache Bench :)

	
*-g results.tsv guarda los resultados en el archivo results.tsv

	
*-n 100 indica que se harán 1000 peticiones

	
*-c 20 indica que se harán 20 peticiones concurrentes

	
*-C nuestra_app_session=243bae5d57cd962a89831bbaac82db pasa el identificador de sesión en forma de cookie

	
*http://nuestra-app.com/ es la URL que vamos a testear

El resultado que obtendremos por consola será algo similar a esto:

Server Software:        Apache
Server Hostname:        nuestra-app.com
Server Port:            80

Document Path:          /
Document Length:        5239 bytes

Concurrency Level:      20
Time taken for tests:   17.604 seconds
Complete requests:      1000
Failed requests:        0
Write errors:           0
Total transferred:      5992584 bytes
HTML transferred:       5248358 bytes
Requests per second:    56.81 [#/sec] (mean)
Time per request:       352.072 [ms] (mean)
Time per request:       17.604 [ms] (mean, across all concurrent requests)
Transfer rate:          332.44 [Kbytes/sec] received

Connection Times (ms)
      min  mean[+/-sd] median   max
Connect:       24   70  62.3     52     403
Processing:    61  257 315.8    153    2953
Waiting:       34  106  94.5     81    1253
Total:         90  328 321.8    221    3039
Lo más relevante de estos resultados es lo siguiente:

***Requests per second**
: peticiones atendidas por segundo durante la prueba.

	
***Time per request (mean)**
: tiempo miedo que el servidor ha tardado en atender a un grupo de peticiones concurrentes (5 o 20).

	
***Time per request (mean, across all concurrent requests)**
: tiempo medio que el servidor ha tardado en atender una petición individual.
Finalmente 
**para crear una gráfica de nuestro test, como la que aparece al inicio de este post**
, podemos utilizar 
[Gnuplot](http://www.gnuplot.info/). Para instalar Gnuplot en Mac OS X usando 
[Homebrew](http://brew.sh/) basta con hacer

brew install gnuplot

Creamos un archivo 
plot.p en el mismo directorio donde hemos generado el archivo 
results.tsv:

# output as png image
set terminal png size 600

# save file to "out.png"
set output "results.png"

# graph title
set title "1000 peticiones, 20 peticiones concurrentes"

# nicer aspect ratio for image size
set size ratio 0.6

# y-axis grid
set grid y

# x-axis label
set xlabel "peticiones"

# y-axis label
set ylabel "tiempo de respuesta (ms)"

# plot data from "out.dat" using column 9 with smooth sbezier lines
# and title of "nodejs" for the given data
plot "results.tsv" using 9 smooth sbezier with lines title "nuestra-app.com"

Y finalmente ejecutamos 

gnuplot plot.p

Es importante destacar que las gráficas generadas por este tipo de pruebas no se han de interpretar de manera secuencial, es decir las peticiones (eje X) no aparecen ordenadas de manera cronológica (orden en el que fueron realizadas) sino por su 
ttime (tiempo que tardaron en ser atendidas). Más info sobre esto en 
[este post](http://www.bradlanders.com/2013/04/15/apache-bench-and-gnuplot-youre-probably-doing-it-wrong/).

Recordad que podéis utilizar Apache Bench para testear cualquier tipo de aplicación web, independientemente del lenguaje o framework que hayáis utilizado para desarrollarla. Esperamos que os resulte útil. Happy testing!
