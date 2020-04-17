# Introduction

Please refer to this [Apigee Community Article](https://community.apigee.com/articles/27779/how-to-mock-a-target-backend-with-a-nodejs-api-pro.html) for more information about this project.

# Requirements

You can deploy both API proxies (mock and shop) and the environment configuration (config folder containing cache, kvm, target server) using maven, a pom.xml file is provided in the root directory of each of them.

Node.js and NPM (Node package manager) need to be installed to be able to deploy the API proxies and run the integration tests using cucumber-js.

## Required software
* Maven
* Node.js
* NPM

# Environment setup

## Setup using maven (apigee-config-maven-plugin)


* Run the following command in the ``config`` directory. Make sure to replace with your own credentials and Apigee organization/environment details.

    ~~~perl
    $ mvn install \
        -Dapigee.config.options=update \
        -Dapigee.username={email} \
        -Dapigee.password={password} \
        -Dapigee.org={org_name} \
        -Dapigee.env={env_name}
    ~~~

* You can inspect the ``edge.json`` file to see how the Cache, KVM and Target Server are defined. For mode details on how to use the ``apigee-config-maven-plugin`` please refer to the official [repo](https://github.com/apigee/apigee-config-maven-plugin).

## Setup using curl commands

* Create a target server called "movies" that points to OMDb API server

    ~~~perl
    $ curl -v -X POST -u {email}:{password} -H "Content-Type: application/json" -d '{
        "name" : "movies",
        "host" : "{org_name}-{env_name}.apigee.net",
        "port" : 80
    }' "https://api.enterprise.apigee.com/v1/organizations/{org_name}/environments/{env_name}/targetservers"`
    ~~~

* Create a KeyValueMap named "movies" with an entry named "targetBasepath" that stores the basepath to hit on the target server

    ~~~perl
    $ curl -v -X POST -u {email}:{password} -H "Content-Type: application/json" -d '{
          "name" : "movies",
          "entry" : [
                {
                    "name" : "targetBasepath",
                    "value" : "/mock"
                }
            ]
    }' "https://api.enterprise.apigee.com/v1/organizations/{org_name}/environments/{env_name}/keyvaluemaps"
    ~~~


* Create a cache called "movies" where we would be caching the value of the key value map created for a better performance.

    ~~~perl
    $ curl -v -X POST -u {email}:{password} -H "Content-Type: application/json" -d '{
      "name" : "movies"
    }' "https://api.enterprise.apigee.com/v1/organizations/{org_name}/environments/{env_name}/caches"
    ~~~

# Deploying and testing Apigee proxies

Make sure you have created the Cache, KVM and Target Server before continuing on this step. Refer to [environment setup](#environment-setup).

Once the [environment setup](#environment-setup) has been completed. Deploy the following proxies in order (steps are identical):
  1. mock
  2. shop

## API proxy deployment

~~~perl
$ mvn install \
    -Dapigee.username={email} \
    -Dapigee.password={password} \
    -Dapigee.org={org_name} \
    -Dapigee.env={env_name}
~~~


NOTE: Make sure that the mock API proxy is deployed first.

## API proxy testing

Whenever you deploy the API proxy the integration tests will be run. If you would like to just run the tests without deploying, use the following command:

~~~perl
$ mvn install \
    -Dapigee.org={org_name} \
    -Dapigee.env={env_name} \
    -DskipDeployment
~~~

# Switch target server

If we would like to change the target server to be the real/implemented API proxy follow the steps below.

## Update using maven

* To update the target server, edit and update the ``edge.json`` file in the ``config`` directory. Find the targetServer config and update the ``host`` value to the real endpoint. You can use ``www.omdbapi.com``, but you will need your own API Key. Head to wwww.omdbapi.com to get your own key.
    ~~~json
    "targetServers": [
      {
        "name": "movies",
        "host": "www.omdbapi.com",
        "isEnabled": true,
        "port": 80
      }
    ]
    ~~~
* To update the targetBasepath in the KVM, edit and update the ``edge.json`` file in the ``config`` directory. Find the kvm config and update the ``value`` for the ``targetBasepath``. You can use ``/`` if you are using ``www.omdbapi.com``.  You will need your own API Key. Head to wwww.omdbapi.com to get your own key.
    ~~~json
    "kvms": [
      {
        "name": "movies",
        "entry": [
          {
            "name": "targetBasepath",
            "value": "/"
          }
        ]
      }
    ]
    ~~~

## Update using curl commands

* Update target server "movies"

    ~~~json
    $ curl -v -X PUT -u {email}:{password} -H "Content-Type: application/json" -d '{
        "name" : "movies",
        "host" : "www.omdbapi.com",
        "port" : 80
    }' "https://api.enterprise.apigee.com/v1/organizations/{org_name}/environments/{env_name}/targetservers"
    ~~~

* Update entry "targetBasepath" in key value map "movies"

    ~~~json
    $ curl -v -X POST -u {email}:{password} -H "Content-Type: application/json" -d '{
        "name" : "targetBasepath",
        "value" : "/"
    }' "https://api.enterprise.apigee.com/v1/organizations/{org_name}/environments/{env_name}/keyvaluemaps/movies/entries/targetBasepath"
    ~~~

* Invalidate the cache entries

    ~~~json
    $ curl -v -X POST -u {email}:{password} "https://api.enterprise.apigee.com/v1/organizations/{org_name}/environments/{env_name}/caches/movies/entries?action=clear
    ~~~
