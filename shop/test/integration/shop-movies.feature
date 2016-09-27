Feature: As an API user I would like to fetch information from movies using their IMDB identifier

    Scenario: Titanic
        When I GET /movies/tt0120338
        Then response code should be 200
        And response body should be valid json
        And response body path $.Response should be True
        And response body path $.Title should be Titanic

    Scenario: Frozen
        When I GET /movies/tt2294629
        Then response code should be 200
        And response body should be valid json
        And response body path $.Response should be True
        And response body path $.Title should be Frozen

    Scenario: Bad request
        When I GET /movies/xxxx
        Then response code should be 400
        And response body should be valid json
        And response body path $.code should be 400.01.001
        And response body path $.error should be bad_request
        And response body path $.message should be Bad request

    Scenario: Resource not found
        When I GET /books/1234
        Then response code should be 404
        And response body should be valid json
        And response body path $.code should be 404.01.001
        And response body path $.error should be resource_not_found
        And response body path $.message should be Resource not found
