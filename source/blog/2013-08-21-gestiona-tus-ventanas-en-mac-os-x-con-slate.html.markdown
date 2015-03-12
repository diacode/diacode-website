---
title: Gestiona tus ventanas en Mac OS X con Slate
date: '2013-08-21'
tags:
- productividad-2
author: Javier
---

![](http://blog.diacode.com/wp-content/uploads/2013/08/windows1.png)
Desde que di el salto de Linux a Mac siempre eché en falta un buen gestor de ventanas que me permitiera redimensionar, centrar y mover ventanas de un monitor a otro con atajos de teclado. Durante años he ido probando diferentes alternatives como 
[Divvy](http://mizage.com/divvy/), 
[SizeUp](http://www.irradiatedsoftware.com/sizeup/) o 
[ShiftIt](https://github.com/fikovnik/ShiftIt).

Recientemente empecé a utilizar una nueva app llamada 
[Slate](https://github.com/jigish/slate) con la que he quedado encantado. A diferencia de sus competidores Slate no tiene una bonita interfaz gráfica pero a cambio ofrece 
**infinitas posibilidades de configuración**
.


Para configurar Slate tenemos dos opciones, crear un archivo de configuración en el 
[DSL propio de Slate](https://github.com/jigish/slate/blob/master/Slate/default.slate) o (la recomendada) crear un 
**[archivo de configuración en JavaScript](https://github.com/jigish/slate/wiki/JavaScript-Configs)**
.

Para trabajar normalmente utilizo un monitor de 24", dejando mi MacBook Air de 13" como pantalla auxiliar a mi izquierda, por ello las acciones que más utilizo son redimensionar las ventanas para que ocupen la mitad de una pantalla, centrarlas o moverlas a otro monitor.

Esta es mi configuración de Slate en Javascript:

// Full screen width and height
var fullScreen = slate.operation("move", {
  "x"       : "screenOriginX",
  "y"       : "screenOriginY",
  "width"   : "screenSizeX",
  "height"  : "screenSizeY",
});
slate.bind("m:ctrl,alt,cmd", fullScreen);

// Center window
var centered = slate.operation("move", {
  "x"       : "screenOriginX+screenSizeX/8",
  "y"       : "screenOriginY",
  "width"   : "screenSizeX/8*6",
  "height"  : "screenSizeY",
});
slate.bind("c:ctrl,alt,cmd", centered);

// Left half window
var leftHalf = slate.operation("corner", {
  "direction" : "top-left",
  "width"     : "screenSizeX/2",
  "height"    : "screenSizeY"
});
slate.bind("left:ctrl,alt,cmd", leftHalf);

// Right half window
var rightHalf = slate.operation("corner", {
  "direction" : "top-right",
  "width"     : "screenSizeX/2",
  "height"    : "screenSizeY"
});
slate.bind("right:ctrl,alt,cmd", rightHalf);

// Send to laptop
var moveToLaptop = slate.operation("move", {
  "screen"  : "0",
  "x"       : "screenOriginX",
  "y"       : "screenOriginY",
  "width"   : "screenSizeX",
  "height"  : "screenSizeY"
});
slate.bind("pad1:ctrl,alt,cmd", moveToLaptop);

// Send to big screen
var moveToBigScreen = slate.operation("move", {
  "screen"  : "1",
  "x"       : "screenOriginX",
  "y"       : "screenOriginY",
  "width"   : "screenSizeX",
  "height"  : "screenSizeY"
});
slate.bind("pad2:ctrl,alt,cmd", moveToBigScreen);
Esta configuración os permitirá utilizar los siguientes atajos de teclado:

*Maximizar ventana:
CTRL + ALT + CMD + 
**M**

	
*Centrar ventana:
CTRL + ALT + CMD + 
**C**

	
*Redimensionar y mover ventana para que ocupe la mitad izquierda de la pantalla:
CTRL + ALT + CMD + 
**IZQUIERDA**

	
*Redimensionar y mover ventana para que ocupe la mitad derecha de la pantalla:
CTRL + ALT + CMD + 
**DERECHA**

	
*Mover ventana a pantalla principal:
CTRL + ALT + CMD + 
**2**
 (teclado numérico)

	
*Mover ventana a pantalla secundaria:
CTRL + ALT + CMD + 
**1**
 (teclado numérico)
Para utilizar esta de configuración de Slate basta con que 
**[descargar](https://github.com/jigish/slate/archive/master.zip) e instalar Slate y crear el archivo 
.slate.js con el contenido anterior en vuestro directorio Home**
.
