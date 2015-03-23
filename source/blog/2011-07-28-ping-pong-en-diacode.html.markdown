---
title: Ping Pong en Diacode
date: '2011-07-28'
tags:
- diacode
- programacion
author: Javier
---

![Nuestros amigos Álvaro y Teö jugando en nuestra mesa](https://diacode-blog.s3-eu-west-1.amazonaws.com/2011/07/pingpong2.jpg)

Como algunos de vosotros ya sabéis, en Diacode nos hemos aficionado al Ping Pong. Todo empezó cuando nos compramos una 
[red de 
quita y pon](http://www.decathlon.es/rollnet-id_8071028.html) para nuestra nueva mesa de reuniones. Empezamos siendo bastante torpes, pero con el tiempo nos hemos ido picando y a día de hoy se podría decir que el Ping Pong es deporte oficial en Diacode.


Tal es nuestro entusiasmo que se nos ocurrió hacer una 
[pequeña aplicación](http://pingpong.diacode.com) con un ranking basado en los resultados de nuestros partidos. Nos preguntábamos cual sería la forma más justa de averiguar quién era el mejor jugador, (teniendo en cuenta diversos factores más allá de si era una derrota o victoria), y tras indagar un poco dimos con el 
[algoritmo de Elo](http://en.wikipedia.org/wiki/Elo_rating_system). Este algoritmo es bastante conocido en el mundo del ajedrez, y usado en la liga americana de Baseball entre otras. Tiene en cuenta diversos factores a la hora de otorgar puntos, entre ellos fundamentalmente cuantos puntos tenía el jugador contra el que has perdido/ganado.

Como el mundo del Open Source y Ruby On Rails es maravilloso, nos encontramos con una 
[gema de Ruby](https://github.com/iain/elo/blob/master/README.rdoc) desarrollada por el holandés 
[Iain Hecker](http://twitter.com/#!/iain_nl) que implementa el algoritmo de Elo. Esta 
gema no nos fue útil tal cual ya que no tenía persistencia en base de datos, pero nos sirvió como base para desarrollar nuestra aplicación.

Por otro lado, nuestro amigo 
[Teö](http://ilusteo.blogspot.com) nos hizo el magnífico logo para nuestro "club" de Ping Pong. Partiendo de ahí, dedicamos un rato al diseño y en un par de tardes ya teníamos nuestro ranking.


[![](https://diacode-blog.s3-eu-west-1.amazonaws.com/2011/07/pingpong_ranking.png)](http://pingpong.diacode.com)


[![](https://diacode-blog.s3-eu-west-1.amazonaws.com/2011/07/pingpong_stats.png)](http://pingpong.diacode.com)

Para los más curiosos decir que la 
app esta implementada en Rails (obvio por lo que comentábamos arriba) y que usa la API de 
[Google Charts](http://code.google.com/apis/chart/) para generar el sencillo gráfico con el porcentaje de victorias y derrotas.

De aquí a un par de meses podremos proclamar con certeza al rey del Ping Pong en Diacode. De momento parece que 
[Jose](http://pingpong.diacode.com/players/2) está en racha...
