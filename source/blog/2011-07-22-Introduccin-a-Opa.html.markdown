---
title: Introducción a Opa
date: '2011-07-22'
tags:
- programacion
dc:creator: Javier
---

![](http://blog.diacode.com/wp-content/uploads/2011/07/opa1.png)
Hace un par de meses surgió 
[Opa](http://opalang.org), un nuevo lenguaje de programación diseñado para el desarrollo web, que promete el desarrollo ágil de aplicaciones web seguras, altamente escalables y distribuidas.

En Diacode acogimos la noticia con cierto escepticismo y antes de caer en juicios fáciles decidimos darle una oportunidad y empezar a trastear con este lenguaje. Antes de continuar vamos a enumerar algunos puntos interesantes sobre Opa:

*Es un 
**lenguaje funcional**
, por tanto nos olvidamos de la programación orientada a objetos.

	
*Opa no es solo un lenguaje, sino que viene con un 
**framework incorporado**
 para todo el desarrollo. A diferencia de otros frameworks web como 
[Ruby On Rails](http://rubyonrails.org/) o 
[Django](https://www.djangoproject.com/), Opa además 
**incluye una base de datos propia**
 (no relacional y basada en paths), y un 
**sistema para hacer deploy**
 de las aplicaciones en un solo servidor o en varios.

	
<!--more-->*Opa es un lenguaje fuertemente tipado, es decir, la comprobación de los tipos de datos es estricta. Esto está directamente relacionado con la seguridad que promete el lenguaje.

	
*Es un lenguaje 
**compilado**
, no interpretado (a diferencia de la mayoría de lenguajes web a excepción de Java y alguno más). Todo se compila en un único archivo .exe (lo cual para los que usamos Mac resulta un poco extraño). Al ejecutar este archivo .exe arrancará el servidor con nuestra aplicación.

	
*El framework de 
**Opa no es MVC**
 (Modelo, Vista, Controlador). Es más, el código del cliente y el servidor se escribe en los mismos archivos. Y aunque Opa incorpora un sistema de templates para las vistas, es habitual ver HTML dentro del propio código Opa.

	
*El código del cliente que habitualmente se escribe en Javascript, se escribe también en Opa, usando una serie de funciones que cuando se compila se transforman a Javascript (usando jQuery por debajo). En este sentido es similar a 
[Coffescript](http://jashkenas.github.com/coffee-script/). Tiene la ventaja de que no hay que hacer "marshalling" (conversión) de datos entre cliente y servidor, ya que al tratarse del mismo lenguaje, usamos los mismos tipos siempre.
Tras leer brevemente la 
[documentación](http://opalang.org/resources/book/index.html) y echar un ojo a algunos artículos en el 
[blog oficial](http://blog.opalang.org/), decidí coger una de las aplicaciónes que ofrecen de ejemplo y hacerle algunas modificaciones. Se trata de un 
[chat](http://chat.opalang.org/) distribuido (pueden ejecutarse servidores en diferentes máquinas compartiendo la misma sala de chat). El código de servidor y cliente (incluyendo HTML pero no CSS) se reduce a 100 líneas, bastante impresionante.

El código de ejemplo no incluye uso de la base de datos para guardar el historial de mensajes, de forma que cuando un usuario se conecta no ve lo escrito anteriormente. Por esto y por la curiosidad de probar la base de datos que incorpora Opa, decidí modificar el código para incluir el guardado de mensajes en la base de datos y su posterior recuperación. Además invertí el orden en el que se muestran los mensajes (los más recientes arriba).

[![](http://blog.diacode.com/wp-content/uploads/2011/07/diacode_chat_opa_thumb.png)](http://blog.diacode.com/wp-content/uploads/2011/07/diacode_chat_opa.png)
Tras estar unas horas trasteando con Opa, esta son algunas de las 
**conclusiones**
 que he sacado:

*Tener que compilar toda la aplicación para hacer cambios en el CSS es bastante incómodo.

	
*Los mensajes del compilador a veces son un galimatías que te llevan a empezar a mover trozos de código para arriba y para abajo hasta conseguir que compile.

	
*Algunas líneas de código dan miedo por su "magia negra". Por ejemplo, para crear una sala de chat basta con esta línea:

room = Network.cloud("room"): Network.network(message)

	
*Trabajar sin orientación a objetos y sin una base de datos relacional se hace bastante raro.

	
*Echo de menos la separación de conceptos de un framework MVC. No obstante he de decir que no he tenido tiempo de probar el sistema de templates de Opa.

	
*La documentación aún es bastante escasa. En 
[Stackoverflow](http://stackoverflow.com/questions/tagged/opa) apenas hay 13 preguntas relativas a Opa. La comunidad aún está muy verde.

	
*Trabajar sin highlight de sintaxis (no hay bundle para TextMate aún) es bastante incómodo. Existe soporte para Emacs y un plugin para Eclipse en desarrollo.

	
*Aun así, un chat con soporte para servidores distribuidos, en poco más de 100 líneas de código es bastante interesante.

En definitiva, lo más interesante de jugar con Opa es ver como un problema como el desarrollo de una aplicación web se puede atacar de una forma completamente diferente a la que la mayoría estamos acostumbrados. Hace falta tiempo para ver si la comunidad evoluciona y se convierte en una alternativa real para nuestros proyectos. Aún recuerdo la primera vez que use Ruby on Rails hace ya varios años, no me gusto nada, y en cambio hoy es la apuesta que hacemos en la mayoría de proyectos de Diacode.

Por último he publicado el 
**[código en GitHub](https://github.com/javiercr/OpaChat)**
, por si queréis descargarlo y probarlo. Necesitaréis 
[instalar Opa](http://opalang.org/get.xmlt) (bastante sencillo). Si tenéis cualquier problema para hacerlo correr, no dudéis en dejarnos un comentario aquí mismo.
