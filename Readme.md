# ELK stack in Bluemix
I use Cuba to create an application with an endpoint */health-check* that returns
an *HTTP 200* in the *80%* of cases and *HTTP 500* in the other *20%* of cases.
Also there is a button in the index page that **alter** the **/health-check** endpoint
returning an *HTTP 500* in the *70%* of cases, and *slow down response* time in the
other *30%* of requests, then after 10 requests, returns to his original behaviour.

With the ELK stack and [Watcher](https://www.elastic.co/guide/en/watcher/current/introduction.html)
I detect anomalies in the application (slow responses or HTTP 500 consecutive)
and send an email if any of the anomalies happen.

## Installation

#### Elasticsearch
Is [installed](https://www.elastic.co/downloads/elasticsearch) like a service
in Ubuntu with the *.deb* package.

#### Logstash
I [download](https://www.elastic.co/downloads/logstash) the *.tar.gz* package
because is easy to select what configuration file load when Logstash start.

To test the Logstash installation works execute in the extracted folder
```
bin/logstash -e 'input { stdin { } } output { stdout {} }'
```

The -e flag enables you to specify a configuration directly from the command line.
This pipeline takes input from the standard input, stdin, and moves that input
to the standard output, stdout, in a structured format. Type hello world at the
command prompt to see Logstash response.

#### Kibana
I chose the *.tar.gz* [package](https://www.elastic.co/downloads/kibana), then in the extracted folder, run
```
bin/kibana
```

**Before running Kibana service, you need to have the Elasticsearch service running.**

#### Watcher
Is a plugin for Elasticsearch, so you need to install in the path/to/elasticsearch/bin/plugin.
In my case (using the .deb package) I need to execute:
```
sudo /usr/share/elasticsearch/bin/plugin install elasticsearch/license/latest
sudo /usr/share/elasticsearch/bin/plugin install elasticsearch/watcher/latest
```

To send an email first you need to modify the Elasticsearch configuration file,
to do that you need to find elasticsearch.yml file
([here](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-dir-layout.html#default-paths) you can see where is),
[here](https://www.elastic.co/guide/en/watcher/current/email-services.html) you can find details about email configuration.

## Running the stack
If you use all the files in this repo, you'll have all the services running in
your localhost.

#### Application
```
rackup
```

#### Elasticsearch
```
sudo service elasticsearch start
```

#### Logstash
In the extracted folder
```
bin/logstash -f path/to/config_file.conf
```

I created a gist with the configuration to run Logstash in
[localhost](https://gist.github.com/lcostantini/a1379aa6ec7328644d32) and in
[Bluemix](https://gist.github.com/lcostantini/85d02e421aa2fd69be50).

#### Kibana
In the extracted folder
```
bin/kibana
```

#### Watcher
You need to make a request to the Elasticsearch API to create a new watch.

I created a gist with the configuration for watcher. To detect
[HTPP 500](https://gist.github.com/lcostantini/6296ac20cd268be8a345) and
[slow requests](https://gist.github.com/lcostantini/6d531fa611daa2b2830d).

I use the curl command
```
curl -X PUT 'http://localhost:9200/_watcher/watch/500_detection' -d @500_watch
```

I create a new index in Elasticsearchm, with the name *500_detection*,
you can choose any one you want, with **-d @** flag I’m telling to curl read the
watch file to load the settings.
