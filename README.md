# NOC list homework

Simple ruby script to fetch the NOC list from BADSEC API, implementation of [Noclist Ad Hoc Homework](https://homework.adhoc.team/noclist/)


## Requirements

- Ensure that you have [Docker](https://docs.docker.com/engine/install/) and [Ruby](https://www.ruby-lang.org/en/downloads/) installed in your system.


## Running locally

1. Clone this repo and cd into the newly created directory
2. Open a terminal and run the API with `docker runn --rm -p 8888:8888 adhocteam/noclist`
3. On another terminal run `./noclist_retriever.rb`, it should output the user id list
