---
title: 3 dolores de cabeza comunes en programación
date: '2011-09-06'
tags:
- programacion
dc:creator: Javier
---

Da igual lo que uno programe, el lenguaje que utilize o el framework que use, al final siempre uno acaba pegándose con problemas muy similares. En especial los que desarrollamos software orientado a usuarios no anglosajones nos topamos siempre con 3 bestias negras:![](http://blog.diacode.com/wp-content/uploads/2011/09/diacode_skulls.png)

###1. La codificación de caracteres.

Algo en apariencia tan simple como almacenar caracteres en un ordenador es en realidad una tarea ciertamente compleja debido a la heterogeneidad de los lenguajes y alfabetos. Debido a la fuerte influencia de Estados Unidos en el desarrollo de la tecnología, muchas decisiones fueron tomadas pensando únicamente en el uso del Inglés. Estas decisiones se han ido arrastrando a lo largo de los años y se han convertido en un quebradero de cabeza para los programadores que tenemos que trabajar con datos en otros idiomas.
rails_and_flux

Con la expansión de Internet por todo el globo se buscaron soluciones universales como el uso de 
[UTF-8](http://en.wikipedia.org/wiki/UTF-8), pero incluso estas presentan 
[deficiencias](http://yehudakatz.com/2010/05/05/ruby-1-9-encodings-a-primer-and-the-solution-for-rails/) a la hora de realizar conversiones desde otras codificaciones (como la 
[SHIFT-JIS](http://en.wikipedia.org/wiki/Shift_JIS) del Japonés).

Además hay que tener en cuenta que hoy en día cualquier software usa un gran número de capas y componentes que interactuan entre si. Pongamos el ejemplo de una aplicación web: tenemos datos almacenados en una BBDD con su correspondiente codificación, estos serán leídos por el driver de la BBDD quien tendrá que encargarse de entender esta codificación y comunicarsela a nuestra aplicación, la cual estará escrita en un lenguaje que decidirá como almacenar esos caracteres en memoria. A continuación nuestra aplicación jugará con esos datos, pasándolos de una función a otra para finalmente generar una salida: un documento HTML con sus respectiva codificación. Por último tenemos que cruzar los dedos para que el navegador del usuario se entere correctamente de que codificación debe emplear para leer ese documento HTML y mostrarlo correctamente.


###2. El formato de fechas.

La 
[diferencia entre países](http://en.wikipedia.org/wiki/Date_format_by_country) a la hora de escribir una fecha supone otro problema con el que lidiar frecuentemente.

Aunque en este caso el camino es menos escabroso gracias a que la mayoría de lenguajes tienen funciones para el manejo de fechas que imitan el comportamiento de las funciones clásicas de C, de modo que al cambiar de un lenguaje a otro no notamos grandes diferencias. Aún así se presenta el mismo problema que con la codificación de caracteres, ya que tenemos que mantener el mismo criterio para el formato de una fecha a lo largo de la interacción entre diferentes componentes de una aplicación (base de datos, framework, etc.).


###3. Las zonas horarias.

Supongamos que hemos superado los problemas del punto anterior y ya tenemos nuestra fecha con su formato correcto en toda nuestra aplicación, ahora necesitamos almacenar también la hora de un suceso determinado. ¿Qué zona horaria tomamos como referencia? ¿Nuestra base de datos está almacenando las horas con respecto a la zona horaria local, en 
[GMT](http://en.wikipedia.org/wiki/Greenwich_Mean_Time) o en 
[UTC](http://en.wikipedia.org/wiki/Coordinated_Universal_Time)?. Aunque las soluciones en este caso suelen ser sencillas, es bastante habitual que durante el desarrollo nos tengamos que realizar este tipo de preguntas más de una vez.

En definitiva, estos 3 puntos aunque siempre terminan teniendo una solución, antes o después acaban consumiendo un valioso tiempo de desarrollo. Esperemos que en el futuro los lenguajes y frameworks evolucionen para darnos soluciones universales y sencillas que nos permitan concentrarnos en lo que realmente importa: desarrollar nuestra idea.
