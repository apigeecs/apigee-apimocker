# Introduction

Please refer to this [Apigee Community Article](https://community.apigee.com/articles/27779/how-to-mock-a-target-backend-with-a-nodejs-api-pro.html) for more information about this project.

# Requirements

You can deploy both API proxies (mock and shop) using maven, a pom.xml file is provided in the root directory of each of them.

Node.js and NPM (Node package manager) need to be installed to be able to deploy the API proxies and run the integration tests using cucumber-js.

# Environment setup

* Create a target server called "movies" that points to OMDb API server

    ~~~
    $ curl -v -X POST -u {email}:{password} -H "Content-Type: application/json" -d '{
        "name" : "movies",
        "host" : "www.omdbapi.com",
        "port" : 80
    }' "https://api.enterprise.apigee.com/v1/organizations/{org_name}/environments/{env_name}/targetservers"`
    ~~~

* Create a KeyValueMap named "movies" with an entry named "targetBasepath" that stores the basepath to hit on the target server

    ~~~
    $ curl -v -X POST -u {email}:{password} -H "Content-Type: application/json" -d '{
          "name" : "movies",
          "entry" : [
                {
                    "name" : "targetBasepath",
                    "value" : "/"
                }
            ]
    }' "https://api.enterprise.apigee.com/v1/organizations/{org_name}/environments/{env_name}/keyvaluemaps"
    ~~~


* Create a cache called "movies" where we would be caching the value of the key value map created for a better performance.

    ~~~
    $ curl -v -X POST -u {email}:{password} -H "Content-Type: application/json" -d '{
      "name" : "movies"
    }' "https://api.enterprise.apigee.com/v1/organizations/{org_name}/environments/{env_name}/caches"
    ~~~

# Deploying and testing

## API proxy deployment

	$ mvn install -Dapigee.username=USERNAME -Dapigee.password=PASSWORD -Dapigee.org=ORGANIZATION -Dapigee.env=ENVIRONMENT

NOTE: Make sure that the mock API proxy is deployed first.

## API proxy testing

Whenever you deploy the API proxy the integration tests will be run. If you would like to just run the tests without deploying, use the following command:

	$ mvn install -Dapigee.org=ORGANIZATION -Dapigee.env=ENVIRONMENT -DskipDeployment

# Switch target server

If we would like to change the target server to be the mock API proxy follow the steps below:

* Update target server "movies"

    ~~~
    $ curl -v -X PUT -u {email}:{password} -H "Content-Type: application/json" -d '{
        "name" : "movies",
        "host" : "{org_name}-{env_name}.apigee.net",
        "port" : 80
    }' "https://api.enterprise.apigee.com/v1/organizations/{org_name}/environments/{env_name}/targetservers"
    ~~~

* Update entry "targetBasepath" in key value map "movies"

    ~~~
    $ curl -v -X POST -u {email}:{password} -H "Content-Type: application/json" -d '{
        "name" : "targetBasepath",
        "value" : "/mock"
    }' "https://api.enterprise.apigee.com/v1/organizations/{org_name}/environments/{env_name}/keyvaluemaps/movies/entries/targetBasepath"
    ~~~

* Invalidate the cache entries

    ~~~
    $ curl -v -X POST -u {email}:{password} "https://api.enterprise.apigee.com/v1/organizations/{org_name}/environments/{env_name}/caches/movies/entries?action=clear
    ~~~
