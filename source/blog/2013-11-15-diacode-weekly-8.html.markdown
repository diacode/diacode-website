---
title: 'Diacode weekly #8'
date: '2013-11-15'
tags:
- diacode-weekly-posts
dc:creator: Javier
---

###Links seleccionados de la semana

Esta semana os traemos tantas cosas que nos hemos visto obligados a clasificarlas en diferentes temáticas para facilitaros la lectura. Por otro lado, si queréis colaborar compartiendo enlaces interesantes para el próximo Diacode Weekly, no tenéis más que comentárnoslo por Twitter (
[@diacode](http://twitter.com/diacode)) con el hashtag 
**#diacodeweekly**
.



##Videos y conferencias


[Videos – Øredev 2013](http://oredev.org/2013/videos)
  
La semana pasada tuvo lugar en Malmö la conferencia Øredev 2013 que trata diferentes temas, desde UX hasta Agile, pasando por las tecnologías más comunes en desarrollo web. Estos son los vídeos que más nos han gustado:
    
*[The Art of Ruby on Rails – Steve Klabnik](http://oredev.org/2013/wed-fri-conference/the-art-of-ruby-on-rails)
Un gran repaso a la historia de Rails y su comunidad desde su primera beta hasta hoy en día. Muy interesante tanto para novatos en Rails como para gente con experiencia.

      
*[Adopting Continuous Delivery – Jez Humble](http://oredev.org/2013/wed-fri-conference/adopting-continuous-delivery)
Una muy buena argumentación de los motivos para adoptar 
Continuous Integration y 
Continuos Delivery, y el impacto que tienen en el valor de negocio.

      
*[Lean UX: Building products people want – Adrian Howard](http://oredev.org/2013/wed-fri-conference/lean-ux-building-products-people-want)
Buena reflexión sobre como a veces las metodologías 
Ágile dejan de lado el diseño UX.
  
  
[Bajar del monorraíl: microservicios (madrid.rb)](http://vimeo.com/78712143)
  
En el pasado 
[madrid.rb](https://madridrb.jottit.com/), @porras y @pellegrino, dos desarrolladores en SoundCloud explicaron como esta startup pasó de una arquitectura monolítica (basada en Rails) a muchos microservicios integrados entre sí.  


##Back-end


[Why You Should Never Use MongoDB](http://www.sarahmei.com/blog/2013/11/11/why-you-should-never-use-mongodb/)
  
Probablemente el post más interesante y más controvertido de la semana. Sarah Mei, ex-desarrolladora en Pivotal Labs y colaboradora en 
[Diaspora](http://en.wikipedia.org/wiki/Diaspora_(social_network)) (la red social distribuida que se suponía que mataría a Facebook), establece una comparativa entre un proyecto de Pivotal Labs y el desarrollo de Diaspora para explicarnos porque MongoDB no es una buena opción en la mayoría de proyectos. Según ella solo existe un único caso en el que MongoDB tiene sentido: si las relaciones en tu modelo de datos no tienen valor de negocio.
    


    Además en su blog hemos encontrado otro par de perlas:
    
*[Thoughts on two months of pairing](http://www.sarahmei.com/blog/2010/04/14/thoughts-on-two-months-of-pairing/)

      
*[Outside-In BDD: How?!](http://www.sarahmei.com/blog/2010/05/29/outside-in-bdd/)

##Ruby / Rails


[CapybaraExtensions](https://github.com/dockyard/capybara-extensions)
  
Esta gema añade esteroides al Capybara que todos conocemos: nuevos 
finders y 
matchers.
  
[Content Compression via Rack::Deflater](http://robots.thoughtbot.com/content-compression-with-rack-deflater/)
  
Los robots de Thoughbot nos enseñan esta a vez a configurar un 
middleware de Rack para reducir el tamaño de las respuestas HTML y JSON de nuestros controladores Rails.


##Entrepreneurship y Startups


[Running an English speaking company](http://micho.biz/post/66768255943/running-an-english-speaking-company)
  
Pablo Villaba (@micho), es un español fundador de 
[Teambox](http://teambox.com/). En este post habla de la experiencia de crear una empresa usando el inglés como lenguaje común desde el primer día.   

  
[Postmortem of a Venture-backed Startupy](https://medium.com/p/72c6f8bec7df)
  
El fundador de @Sonar, nos cuenta las lecciones que ha aprendido después de levantar $2M de diferentes fondos de Venture Capital para acabar fracasando y vendiendo la empresa.


##Javascript


[Offline – Automatically detect when a browser is offline](http://github.hubspot.com/offline/)
  
Librería Javascript para detectar cuando un usuario se ha quedado sin conexión.   

  
[Isomorphic JavaScript: The Future of Web Apps](http://nerds.airbnb.com/isomorphic-javascript-future-web-apps/)
  
El concepto de aplicaciones Javascript Isomórficas se refiere a la posibilidad de tener el mismo código Javascript corriendo indistintamente en el servidor y en el cliente. Un concepto bastante revolucionario que hoy en día ya utilizan algunos frameworks famosos como 
[Meteor](http://www.meteor.com/). En el blog de desarrollo de Airbnb nos explican más a fondo este nuevo paradigma y cuales son sus ventajas.


##Mobile


[Airbnb: Host Experience on Android](http://nerds.airbnb.com/host-experience-android/)
  
Airbnb estrena apps móbiles. En este artículo nos exponen algunos de los detalles técnicos de la implementación en Android de la parte de anfitriones (hosts). 
  
[Airbnb: Guest Experience on iOS7](http://nerds.airbnb.com/guest-experience-ios7/)
  
Este artículo va de la mano con el anterior. En este caso emplean la parte de invitados (guests) para contarnos algunos detalles sorprendentes sobre su implementación en iOS, como por ejemplo la detección de los colores brillantes de una foto para su posterior uso en diferentes elementos de la UI como background. 
  
[Pixate – CSS for iOS](http://www.pixate.com/)
  
Framework que permite utilizar CSS para dar estilo a vistas en aplicaciones nativas de iOS.


##Diseño / CSS


[Which CSS Measurements To Use When](http://demosthenes.info/blog/775/Which-CSS-Measurements-To-Use-When)
  
Un repaso a las diferentes unidades de medida disponibles en CSS (px, %, em, etc.) e indicaciones sobre cuando es conveniente usar cada una de estas medidas.     
  
  
[Efecto difuminado con CSS para imágenes](http://codepen.io/Matori/pen/JFzok)
  
Este codepen usa un pequeño hack con SVG para conseguir difuminar imágenes, ese efecto que está tan de moda ultimamente.

  
[Ink – CSS Framework For Responsive HTML Emails](http://zurb.com/ink/)
  
ZURB, los creadores del famoso framework 
[Foundation](http://foundation.zurb.com/), nos presentan esta vez un nuevo framework para maquetar emails y asegurarnos de que sean responsive y se vean correctamente en todos los clients de email.



##Varios


[Dart 1.0: A stable SDK for structured web apps](http://blog.chromium.org/2013/11/dart-10-stable-sdk-for-structured-web.html)
  
Cuando estuvimos en San Francisco en Marzo, asistimos a un meetup sobre Dart en las oficinas de Yelp. Allí tuvimos ocasión de esuchar a dos de los desarrolladores de Google que trabajan en Dart. Salímos de allí con la sensación de que Dart podría cambiar las reglas de juego pero que en aquel momento era 
too beta. Pues bien, parece ser que esta semana se ha presentado la versión estable de Dart, que incluye un SDK basado en Eclipse. Merece la pena echarle un vistazo. 

  
[Exercism.io – Crowd-sourced code reviews on daily practice problems.](http://exercism.io/)
  
Proyecto que nos propone ir resolviendo diferentes ejercicios de programación para posteriormente someternos a un 
code review con otros desarrolladores.    

  
[Building Vagrant Machines with Packer](http://blog.codeship.io/2013/11/07/building-vagrant-machines-with-packer.html)
  
Para los que no conozcais Vagrant, se trata de una herramienta para crear máquinas virtuales para desarrollo. Nosotros lo utilizamos para poder mantener el entorno de desarrollo de cada proyecto aislando. Por otro lado Packer es una herramienta que permite montar máquinas virtuales a partir de un archivo JSON para múltiples proveedores, locales (Vagrant, VirtualBox) o en la nube (EC2, Digital Ocean). En este artículo nos cuentan como combinar Packer y Vagrant para gestionar nuestros entornos de desarrollo.

  
[Que No Te Tomen El Vuelo](http://quenotetomenelvuelo.es/)
  
Que las webs de venta de billetes de avión almacenaban cookies en nuestros navegadores para posteriormente mostrarnos precios más altos en futuras visitas, es algo sabido por muchos. Lo que no se sabía es que parece ser que también almacenan nuestra IP.
