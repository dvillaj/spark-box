# NoSQL Box

Automatization of "Building your Own Big Data Infrastructure for Data Science" article written by [Ashton Sidhu](https://towardsdatascience.com/tutorial-building-your-own-big-data-infrastructure-for-data-science-579ae46880d8)

# Requirements

- vagrant
- vagrant plugin vagrant-disksize

## Software 


The build process uses Vagrant to create a virtual machine with Ubuntu 18.10 and install the following software:

- [Hadoop](http://localhost:9870)
- [Yarn](http://localhost:8088)
- Hive
- [Spark](http://localhost:8080)
- MySQL
- [Jupyter Lab](http://localhost:8888)
- Docker


## Build the box

```
vagrant plugin install vagrant-disksize
vagrant up
```

## Logging into the box

```
vagrant ssh
```

## Start Services 

```
start-all-services.sh
```


## Stop Services 

```
stop-all-services.sh
```

## Integration Test


[Integration_Test.ipynb](./resources/notebooks/Integration_Test.ipynb)


