# NoSQL Box

Vagrant to create a virtual machine following this [turorial](https://towardsdatascience.com/tutorial-building-your-own-big-data-infrastructure-for-data-science-579ae46880d8) of how build your own Big data Infrastructure for Data Science written by Ashton Sidhu
 

## Installed Software 

This box is based in Ubuntu 18.04 and docker.

The build process will install and configure the following software:

- [Hadoop](http://localhost:9870)
- [Yarn](http://localhost:8088)
- Hive
- [Spark](http://localhost:8080)
- MySQL
- [Jupyter Lab](http://localhost:8888)


## Build the box

```
vagrant up
```

## Logging into the box

```
vagrant ssh
```

## Start Services 

```
init-all.sh
```

## Integration Test


[Integration_Test.ipynb](./resources/notebooks/Integration_Test.ipynb)


