Feature: As a user I would like my mock to mock anything

    Scenario: Unknow movie

        When I GET /?i=ttinvalid
        Then response code should be 200
        And response body should be valid json
        And response body path $.Response should be False
        And response body path $.Error should be Incorrect IMDb ID.

    Scenario: Titanic

        When I GET /?i=tt0120338
        Then response code should be 200
        And response body should be valid json
        And response body path $.Response should be True
        And response body path $.Title should be Titanic

    Scenario: Frozen

        When I GET /?i=tt2294629
        Then response code should be 200
        And response body should be valid json
        And response body path $.Response should be True
        And response body path $.Title should be Frozen
