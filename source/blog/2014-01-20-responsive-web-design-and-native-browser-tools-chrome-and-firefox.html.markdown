---
title: 'Responsive web design and native browser tools: Chrome and Firefox'
date: '2014-01-20'
tags:
- diseno
dc:creator: Ricardo
---

Since 
**responsive web design**
 started gaining popularity some years ago, the number of tools at our disposal to help us implementing this technics have also grown to unsuspected numbers. Nowadays you can find dozens of responsive and 
**mobile first**
 CSS frameworks, services to checkout the results of your designs in different platforms or devices, applications and tools to simulate or test your work from your computer’s desktop without having to own one of each existing device on the market. At first this may sound a bit crazy, and you may ask where to start or what tools to use but thanks to our favorite 
**web browsers**
 now you don’t need additional tools help you with your responsive designs.


rails_and_flux###Firefox Nightly’s Responsive Design View

Mozilla’s testing version of it’s world wide known browser now comes with a new and useful feature called 
Responsive Design View. To activate this view is as simple as selecting it from the 
Developer Tools menu.

![](http://blog.diacode.com/wp-content/uploads/2014/01/Captura-de-pantalla-2014-01-17-a-las-15.09.04.png)
When you enter this mode you can simulate the resolution of any device by just selecting a preset from the dropdown menu, or use a custom one by using the draggable tool at your disposal (located at the right margin, bottom margin or bottom right corner) and you can watch how your responsive design reacts to these changes.

![](http://blog.diacode.com/wp-content/uploads/2014/01/Captura-de-pantalla-2014-01-17-a-las-15.33.25.png)
You can also simulate screen rotation, touch events and take quick snapshots to share them with your team mates and clients. As you can see, Firefox's new feature is useful, but you can find it quite simple anyway and here is where Google's Chrome Canary comes into play.

###Google Chrome Canary’s Emulation

If you are not using Google’s developer oriented browser, 
[Chrome Canary](https://www.google.com/intl/en/chrome/browser/canary.html), and you are into responsive design then you should give it a try and check out its new mode to emulate different devices conditions, which can be anything but simple.

To activate this mode you need to go to the 
Settings menu within the 
DevTools and enable “Show ‘Emulation’ view in console drawer”. Now you will find the new 
Emulation panel in the browser's console.

![](http://blog.diacode.com/wp-content/uploads/2014/01/Captura-de-pantalla-2014-01-20-a-las-08.11.31.png)
 

Inside this panel you will find a vertical menu with the following options:

***Device**
: This is where the magic begins. You can select the conditions you want to emulate from a wide range of predefined devices and then click the 
Emulate button to set those options automatically.

	
***Screen**
: Here you can change the resolution, rotation, pixel ratio, view port and even change the CSS media.

	
***User agent**
: Here you can choose what 
user-agent header you want to emulate if your project is prepared to serve optimized versions depending on that header.

	
***Sensors**
: Last but not least, in this option you can emulate touch events, geolocation coordinates and even the orientation data and motion events with the accelerometer and test how your designs react to them.

###Wrap-up

Responsive design can be tricky and sometimes a pain, but these two great browsers provides us with some very useful tools to assist us and make our lifes easier, so don’t hesitate and give them a try, you will not regret it :)

Happy coding!
