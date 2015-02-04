---
title: Using Tor to anonymize your web scrapping on OS X
date: '2014-08-07'
tags: []
dc:creator: Javier
---
Sometimes you need to scrap some content from a few sites and you want to remain anonymous. You can try to Google for a list of free proxies to use, but most of the free proxies you'll find probably will be very slow.

![Tor](http://blog.diacode.com/wp-content/uploads/2014/08/tor.png)The simplest solution we've found is to use 
[Tor](https://www.torproject.org). It directs all your traffic through a free, worldwide network consisting of more than five thousand relays that will protect your IP address and location. There a few software packages related to Tor but the two more relevantes are the 
[Tor Browser](https://www.torproject.org/projects/torbrowser.html.en) (a Firefox for that has Tor ingtegrated) and the 
[Tor proxy.](https://www.torproject.org/docs/tor-doc-osx.html.en) We'll use the Tor proxy for this task.

Installing the Tor proxy is quite simple if you have Homebrew, open a terminal and type:brew install tor

Then you'll need to setup your computer to use the Tor proxy for every application. To do so go to Network Settings and configure the SOCKS Proxy to 
**localhost**
as server and  
**9050**
 as port. You will probably want to whitelist a few domains on this screen such as 
localhost.

Finally go back to the terminal and run Tor:

tor
That's all, it doesn't matter which language you're using (obviously we use Ruby) or which library you use to scrap data (we like 
[Nokogiri](http://nokogiri.org/) and 
[Mechanize](https://github.com/sparklemotion/mechanize)), now all your request will go through the Tor network with a different IP address.

Finally if for whatever reason you want to get a Tor IP for a particular country, before you run Tor, you can edit /usr/local/etc/tor/torrc and add select the country where you want to get the IP from (the ExitNode):

ExitNodes {pt}
You'll have to specify the country with its 
[ISO country code](http://countrycode.org/) (
pt here is Portugal).

Hope this is useful to you! Happy web scrapping!
