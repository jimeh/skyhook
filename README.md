# Skyhook

This is a set of Ruby scripts, and unix service configuration files I put together in a hurry back in September to scale a then fast growing Facebook application using Amazon EC2's AutoScaling technologies.

It's a combination of service controlling and project deployment. It's not great, but it did do what I needed it for. I haven't touched the code since September when the system went live.


## For Learning

This project depends highly on custom changes within the Linux OS that you are running on EC2. As well as it's alpha quality, I'm putting it on Github for learning purposes mainly. Hopefully you'll find some parts of this project interesting.


## SVN and no Git?!

The project Skyhook was initially intended for was using Subversion, despite my cries. As such, Git is not supported.


## The Future

I am planning on cleanup, rewrite, add Git support, and many other things to Skyhook in the future when I have time. For now, dig through the code and config files if you're curious.


## Forking

Please don't hesitate to fork and improve if you feel like it :)


## Notes

To control multiple auto-scaled instances on EC2, I created [Skyline][skyline].


# License

(The MIT License)

Copyright (c) 2009 Jim Myhrberg

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.





[skyline]: http://github.com/jimeh/skyline