---
title: Crea tu framework css con Bourbon y Neat
date: '2013-09-18'
tags:
- diseno
- programacion
author: Ricardo
---

Hace unos meses escribí un post 
[acerca de Sass](/blog/2013-01-19-mejores-hojas-de-estilo-con-sass.markdown) y de cómo nos podía ayudar para agilizar y simplificar el desarrollo de nuestras hojas de estilos gracias al uso de 
mixins.

Desde entonces no he parado de usar 
**Sass**
 para generar mis hojas de estilos, al principio usando algún framework css como 
[Bootstrap](http://getbootstrap.com/) en su versión 
[Sass](https://github.com/thomas-mcdonald/bootstrap-sass), luego a medida que me iba sintiendo más cómodo sobrescribiendo estilos de estos frameworks con los mios propios usando mis propios 
mixins y al final he terminado evitando usar estos frameworks y generando los mios propios desde cero, para poder reutilizarlos en distintos proyectos, pudiendo variar la apariencia de las aplicaciones cambiando simplemente unas cuantas 
**variables**
 que usan mis 
mixins.

A la hora de desarrollar el interfaz de una aplicación, intento por todos los medios que mis vistas sean lo más independientes posibles de los estilos. Es decir, que los componentes de mi 
html 
**no estén llenos de clases**
 que sirvan exclusivamente para dotarles de estilos, sino al revés, que mis hojas de estilos sean las encargadas de esta labor usando los selectores apropiados, o lo que viene a llamarse 
**diseño semántico**
, para los que Sass me viene como anillo al dedo.

La base que todo conjunto de estilos que una aplicación o sitio web debería tener es un buen sistema de grid, y un conjunto de reglas que sean lo más compatibles posible con todos los navegadores, para evitar que los elementos se descoloquen o no se muestren como esperábamos, pero tampoco hace falta reinventar la rueda y hacer esto desde cero, ya que disponemos de un par de herramientas que nos pueden ayudar a proporcionarnos esta base y así centrarnos en el diseño en sí.




[![Bourbon](https://github-camo.global.ssl.fastly.net/69ff6aca7073ff74a052d728e1b431c58bb9aa3f/687474703a2f2f626f7572626f6e2e696f2f696d616765732f7368617265642f626f7572626f6e2d6c6f676f2e706e67)](http://bourbon.io/)


**Bourbon**
 es una librería Sass creada por 
[thoughtbot](http://www.thoughtbot.com/) que nos aporta un conjunto de 
mixins 
**fáciles de usar**
 y cuyo css generado es 
**soportado por la mayoría de los navegadores modernos**
.

Vamos a ver un ejemplo verlo mejor. Teniendo este estilo escrito en Sass para las secciones de nuestra aplicación:// .sass
section
  +linear-gradient(to top, red, orange)
  +position(absolute, 10px -13px 0 0)
  +transform(rotate(45deg) skew(20deg, 30deg))
  font-family: $helvetica
Nos generaría el siguiente 
**css**
 una vez compilado:

section {
  background-color: red;
  background-image: -webkit-linear-gradient(bottom, red, orange);
  background-image:         linear-gradient(to top, red, orange);
  position:         absolute;
  right:            -13px;
  top:              10px;
  -webkit-transform: rotate(45deg) skew(20deg, 30deg);
     -moz-transform: rotate(45deg) skew(20deg, 30deg);
      -ms-transform: rotate(45deg) skew(20deg, 30deg);
       -o-transform: rotate(45deg) skew(20deg, 30deg);
  transform: rotate(45deg) skew(20deg, 30deg);
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
}
Como podéis ver, además de aplicar las reglas, se encarga también de añadir todos los 
**prefijos**
 necesarios para que los navegadores no tan modernos puedan soportarlos.

Para poder ver todos los 
mixins y funciones que nos permite usar, solo tenéis que visitar su 
[documentación](), y veréis que cubre prácticamente todas las características de 
CSS3, permitiéndonos usarlas de manera sencilla con una simple llamada.

 


[![Bourbon Neat](https://github-camo.global.ssl.fastly.net/b3d350ec1680fb4d2ddc197812a2a5f0dc7005c3/687474703a2f2f6e6561742e626f7572626f6e2e696f2f696d616765732f6c6f676f747970652e737667)](http://neat.bourbon.io/)

Con 
**Bourbon**
 puedes crear hasta una sistema de 
grid flexible con la ayuda de su función 
[flex-grid](http://bourbon.io/docs/#flex-grid), pero la gente de 
[thoughtbot](http://www.thoughtbot.com/) ha ido un paso más allá y ha creado también 
**Neat**
, un framework que se dedica única y exclusivamente a esto, y lo hace realmente bien.

De nuevo es completamente semántico, es decir, solo tienes que usar una serie de 
mixins en tus selectores css y así evitar llenar tu 
html de clases innecesarias.

Veamos un ejemplo, supongamos que tenemos este 
html para generar una página con la típica barra lateral y a la derecha el contenido:

<section>
  <aside>
    Barra lateral
  </aside>
  <article>
    Aquí el contenido principal de nuestra página
  </article>
</section>
Nuestro Sass sería así:

section
  +outer-container
  aside
    +span-columns(3)
  article
    +span-columns(9)
Este sería el ejemplo más simple, ya que nos ofrece una gran flexibilidad a la hora de crear el grid. Para configurar el número de columnas, ancho y separación entre estas basta con modificar estas variables antes de importar 
**Neat**
 en nuestro fichero Sass:

// _nuestro_grid.sass

$column: 90px
$gutter: 30px
$grid-columns: 12
$max-width: em(1088)

// application.css.sass

@import bourbon
@import nuestro_grid
@import neat

// Aquí irían nuestros estilos
...
Lo que más me gusta de 
**Neat**
 es que te calcula el ancho de las columnas sobre la marcha, anque le especifiques 12 columnas de manera global, siempre puedes cambiar esto al incluir el 
mixin 
span-columns, de la siguiente manera:

section
  div
    +span-columns(3 of 9)
Incluso te lo calcula si le quieres añadir 
padding, para que no se descuadre todo:

section
  div
    +span-columns(3 of 9)
    +pad(2em)
Es 
**completamente responsivo**
, ya que te permite cambiar la configuración del 
grid en cualquier 
breakpoint que le especifiques:

// _nuestro_grid.sass
@import neat/neat-helpers

$column: 90px
$gutter: 30px
$grid-columns: 12
$max-width: em(1088)

$tablet: new-breakpoint(max-width 768px 8)
$mobile: new-breakpoint(max-width 480px 4)

section
  div
    +media($mobile)
      +span-columns(4)
Además de todo esto, si visitáis su 
[documentación](http://neat.bourbon.io/docs/) podréis ver y comprender mejor todas los 
mixins y funciones que nos aporta para exprimirlo al máximo.

###En resumen

Si estáis un poco cansados de usar siempre lo mismo para generar los estilos de vuestros proyectos y os estáis planteando el crear vuestros propios estilos teniendo una buena base que os permita generar CSS3 de manera sencilla, soportado por la gran mayoría de los navegadores actuales y a la vez tener un sistema de 
grid que sea semántico, robusto, responsivo y fácil de usar os recomiendo que le deis una oportunidad tanto a 
**Bourbon**
 como a 
**Neat**
. Una vez que empecéis a usar estas dos pequeñas joyas no vais a querer dejar de hacerlo :)
