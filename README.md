# docker-REPET

The REPET package in a container.

## Background

The REPET package has many dependencies, including a MySQL database
and the a scheduler such as the Sun Grid Engine (SGE). If you want to
identify repetitive elements in a single genome, installing all of
these prerequisites is quite onerous.

## Instructions

### Building the image

One of the important prerequisites are the RepBase libraries from
[girinst.org](http://www.girinst.org/). Licencing prevents
redistribution of these data, so you have to pull these in yourself
when you build the image. The `Dockerfile` includes a step to download
the libraries, but you need to supply your username and password to
the wget command by changing the lines:

```
ENV GIRINST_USERNAME AzureDiamond
ENV GIRINST_PASSWORD hunter2
```

to your own username and password.

After than, you can build the image with:

`docker build -t repet .` from the same folder as the `Dockerfile`.
