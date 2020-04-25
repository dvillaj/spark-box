# NoSQL Box

Vagrant to create a Spark box following this [article](https://towardsdatascience.com/tutorial-building-your-own-big-data-infrastructure-for-data-science-579ae46880d8) from Ashton Sidhu
 
This box is based in Ubuntu 18.04 and Docker.

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


## Jupyter Lab

http://localhost:8888


### Spark 

http://localhost:8080


### Hadoop 

http://localhost:9870

### Yarn

http://localhost:8088
