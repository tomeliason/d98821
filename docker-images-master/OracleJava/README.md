Oracle Java on Docker
=====
Build a Docker image containing Oracle Java (Server JRE specifically).

The Oracle Java Server JRE provides the same features as Oracle Java JDK commonly required for Server-side Applications (i.e. Java EE application servers). For more information about Server JRE, visit this [release notes](http://www.oracle.com/technetwork/java/javase/7u21-relnotes-1932873.html#serverjre).

## Java 8
[Download Server JRE 8](http://www.oracle.com/technetwork/java/javase/downloads/server-jre8-downloads-2133154.html) `.tar.gz` file and drop it inside folder `java-8`. 
Build it:

```
$ cd java-8
$ docker build -t oracle/serverjre:8 .
```

## Java 7
[Download Server JRE 7](http://www.oracle.com/technetwork/java/javase/downloads/java-archive-downloads-javase7-521261.html#sjre-7u80-oth-JPR) `.tar.gz` file and drop it inside folder `java-7`:
Build it: 

```
$ cd java-7
$ docker build -t oracle/serverjre:7 .
```
