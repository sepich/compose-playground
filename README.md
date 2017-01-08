# Graphite playground
This is docker-compose folder, enabling you to quickly set-up and play with different components of Graphite monitoring stack.

#### Components:  
 - [Diamond](https://github.com/python-diamond/Diamond), python daemon that collects system metrics (client sends metrics to graphite)
 - [Go-carbon](https://github.com/lomik/go-carbon), Golang implementation of Graphite/Carbon server (receives and writes metriс to disk)
 - [Carbonapi](https://github.com/dgryski/carbonapi), Golang implementation of Graphite API server (provides REST API for reading metrics for grafana etc)
 - [Grafana](https://grafana.net), web-interface for metrics View/Alert

#### Quick start:
```
git clone https://github.com/sepich/graphite-compose.git
cd graphite-compose
docker-compose up -d
```
This would create 4 containers, with metrics data stored in newly created `./whisper/` folder. Data is preserved between runs, grafana settings are in `./grafana/`.  

Now login to [http://localhost:3000](http://localhost:3000) as `admin`/`admin` and configure new Data Source of type Graphite with url `http://carbonapi:8080`  

Configs for all 4 containers are mapped from folder `./configs`. Just edit config in question and restart corresponding container:  
```
docker-compose restart diamond
```
(or you can send signal like `docker kill -s SIGHUP grafana`)  
When done, cleanup everything:  
```
docker-compose stop
docker-compose rm -f
```

#### To scale:
This is minimal number of components, real scalable architecture would be like:  
https://github.com/lomik/go-carbon/issues/130
```
                     |-----------------|
                     | carbon-relay-ng |
                     |-----------------|
                              |
        |---------------------+---------------------|
|-----------------|  |-----------------|  |-----------------|
|    go-carbon    |  |    go-carbon    |  |    go-carbon    |
| (carbonserver)  |  | (carbonserver)  |  | (carbonserver)  |
|-----------------|  |-----------------|  |-----------------|
        |---------------------+---------------------|
                              |
                     |-----------------|
                     |  carbonzipper   |
                     |    carbonapi    |
                     |     grafana     |
                     |-----------------|
```
