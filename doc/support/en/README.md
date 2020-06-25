# Online help

## About the technology…

### Does Facefy uses a cloud platform to perform the searches? 

No. Once downloaded and installed, everything takes place in your computer. I personally hate Service as a Software Substitute paradigm to the extent of trying to make the software easy-to-use for everyone. 

### So no photograph is never ever sent to any cloud provider?

No.

### That's good! So have you written a full face recognition system?

No. Facefy is an application that wraps the capabilities of well-known technologies like `Dlib` and `face_recognition` using a custom JSON RPC daemon created ad-hoc in Python 3.6+ (named `pyfaces`) and a GTK-based desktop environment. 

### Where can I found test images to try it?

There is an open database of labelled faces ready to use [here](http://vis-www.cs.umass.edu/lfw/).


### Why using Python for the JSON RPC?

Because `face_recognition` is written in Python and I'm fluent with it.

### And why not using Python for the GUI?

Because I like Vala for creating Desktop applications in the desktop environments I use, mainly elementary OS and Gnome-based ones.

### But come on! Almost nobody knows Vala!

So, you can write your own GUI over `pyfaces` or over `face_recognition`. 

### I noticed that `pyfaces` uses the file system to store things. That's pretty slow!

That's true. But I currently do not need something more complex to make it working. Anyway, the backoffice may use a MongoDB or a SQLite DB to store things. If compatibility with the JSON RPC server client used in Vala is mantained, this may not be hard work. 

## About the ethics…

### So, what's the goal then if most of the core-code is not yours?

As simple as making face recognition available for anyone using a couple of commands using a ready-to-use packaging routine. Thus, we can raise awareness about how the state of the technology for anyone even when using available face recognition engines.  

### But, if you want to raise awareness, making the source code public wouldn't let bad people do bad things with it?

That's a point, but this is a way of making people conscious of how close this technology is to us. It's not the future but the present.

### I've heard that face recognition systems have a certain racial bias. I don't like getting involved with technology in this way!

You're right. The technology has some problems, and current models have been found to work better with people of some ethnic groups. In the case of `face_recognition` it is explained why [here](https://github.com/ageitgey/face_recognition/wiki/Face-Recognition-Accuracy-Problems#question-face-recognition-works-well-with-european -individuals-but-overall-accuracy-is-lower-with-asian-individuals). The issue is linked to the features of the dataset used to train the models.

## About how it is distributed…

### Why Flatpak and not Snap?

Because both share sandboxing approaches and can be run in GNU/Linux systems but Flatpak is not tied to a given repository as Canonical does with the Snap Store. See similar problems of centralized stores involving videogames [here](https://www.youtube.com/watch?v=85Q3D-qIwVw).

### Will this application be available for Windows System?

Not at all.

### Why?

Because it requires a lot of work to mantain releases from multiple operating systems and make things cross-compile.

### I'm a Windows user and I would like to run the application. What can I do?

You may run it in a virtualized environment using VirtualBox or similar software, but forget about efficiency. The GNU/Linux community will help you to change to beautiful desktop environments and flexible platforms. If your main reason to stay in Windows is Microsoft Office compatibility, think about if that was a coincidence.

### And for MacOS users?

Same problem. Same answers.

### And what about making it mobile? It would be great!

In fact, it can be mobile using GNU/Linux-based phones. Many projects are working on that like Pine64 and Purism. Give them a call.

### So, I have a feature request. Where can I propose it?

That's great! Open a new issue in the [Github project page](https://github.com/febrezo/Facefy/issues).

### How much time will it take to be included?

It depends on whether there is someone wanting to face that. But to be clear: don't expect anyone to be coding for free if he/she doesn't need the feature at all. 
