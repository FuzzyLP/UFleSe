UFleSe is a search tool that provides a user-friendly Web interface for users to be able to make expressive queries (using fuzzy searching criteria, fuzzy rules, synonyms, antonyms, similarity, negation, and fuzzy qualifiers) over conventional and crisp data. UFleSe allows users to upload their data and define the similarity concepts.


## Run in docker (Dockerfile):

```
cd docker
docker build -t uflese .
docker run -p 8080:8080 uflese
```

And then open http://localhost:8080/flese.

## Run in docker (image in registry)

```
docker pull ufleseproject/uflese
docker run -p 8080:8080 ufleseproject/uflese
```


