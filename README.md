Jangaroo Version of "Jumper"
============================

"Jumper" has been created by Chipacabra as a [tutorial on developing a Flash game with flixel](http://chipacabra.blogspot.com/2011/02/project-jumper-part-12-odds-and-ends.html). This is the Jangaroo version of the game: the original source code is compiled to JavaScript so that it runs in HTML5-enabled browsers without a Flash plugin. This means they even run on iOS devices! However, mind user input (no keyboard/mouse) and JS/canvas performance in mobile Safari.

[Click here to run the game!](http://www.jangaroo.net/files/examples/flash/jumper/)

For Jangaroo background information, please visit the [Jangaroo Home Page](http://www.jangaroo.net).

To build the application yourself and play around with the code, you need to have installed the usual Jangaroo prerequisites

1. [Java 6](http://java.sun.com/javase/downloads/) and
2. [Maven 3](http://maven.apache.org/download.html).

Note that you do not have to download and / or install Jangaroo itself!

**Checkpoint:** opening a command prompt and entering `mvn -v` should output something like

    Apache Maven 3.0.2 (r1056850; 2011-01-09 01:58:10+0100)
    Java version: 1.6.0_21, vendor: Sun Microsystems Inc.
    Java home: C:\Program Files\Java\jdk1.6.0_21\jre
    Default locale: de_DE, platform encoding: Cp1252
    OS name: "windows 7", version: "6.1", arch: "amd64", family: "windows"

If you want to start your own Jangaroo Flash project from scratch, have a look at the [Jangaroo Flash Application Template](https://github.com/fwienber/jooflash-app-template) or, if you work with FlashDevelop (see below), the [FlashDevelop Project Template for Jangaroo Flash Applications](https://github.com/fwienber/jooflash-fd-project) here on github.

Otherwise, download and unzip the "Jumper" project files (if you have `git` installed, you can of course also clone the repository):

1. Press the [`Downloads`](https://github.com/fwienber/jumper/archives/master) button at the top right of this page,
2. choose `Download .zip`, and
3. unzip to a directory of your choice

**Starting the Web Server**

For technical reasons, most Jangaroo Flash applications, like most Web applications in general, cannot be run from the local file system (security issues). Fortunately, Maven also allows starting a local Web server serving your Web app in three simple steps:

1. open a command prompt
2. `cd` into your project root directory
3. enter `mvn jetty:run`

A Jetty Web server is started, serving your Web application at `http://localhost:8080/`.
Now, you can open this URL in your favorite Web browser and try the game.

**Development**

You can use several IDEs to work with AS3 source code. Currently, the best IDE for Jangaroo development is [IntelliJ IDEA 10 Ultimate](http://www.jetbrains.com/idea/download/index.html), but since you probably prefer a free IDE, the following "getting started" refers to [FlashDevelop](http://www.flashdevelop.org). FlashDevelop is Windows-only (I think there is an experimental Mac version).

So please start by downloading and installing the latest version of [FlashDevelop](http://www.flashdevelop.org).

Then, double-click the provided file `jumper.as3proj` (located directly inside the unpacked zip), which should launch FlashDevelop, opening the project.

Now you can build the project using the `Build Project` toolbar button. Maven is invoked and compiles and builds your Web application.
Then, your default browser opens your Jangaroo Jumper game!
Now you can edit source code, using FlashDevelop's nice code assist features, click `Build Project` again, and watch the result in the browser window.

Note that for every turn-around, a new browser window is opened, so be sure to close the old one. If you do not want FlashDevelop to open a new browser window, click on the `Project Properties` button, then on the `Build` tab, and clear the `Post-Build Command Line`. Then, the most convenient round-trip is to rebuild the project, `Alt-Tab` to the existing browser window and hit `F5`.

If code changes do not appear in the browser, try clearing the browser cache.

If your browser window stays empty, please check for JavaScript errors and have a look at the [Jangaroo debugging tutorial](http://www.jangaroo.net/tutorial/debugging).
