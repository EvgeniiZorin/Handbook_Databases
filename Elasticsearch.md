# Elasticsearch

Features:
- Distributed, open-source search and analytics engine, used for indexing, storing, and searching data, especially large datasets, in near real-time. 
- You could call it a document-based searchengine
- Utilises JSON data format. 
- Elasticsearch makes use of a data structure called Inverted Index that gives it the ability to perform exceptionally fast full-text searches. Elasticsearch stores all documents and builds an Inverted Index during the indexing process allowing it to make the document data searchable in real-time.
- Can perform lexical and semantic search on both sparse and dense vectors; 
- Semantic search can utilise built-in embeddings from ELSER, E5, or a third-party and self-managed embeddings. 

Examples of query: https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-bool-query

Query development:
- Elasticsearch is very flexible
  - Lexical search:
    - analysers
    - stemmers
    - matching algorithms
    - score boosting
  - Dense vector search
  - Sparse vector search
  - Rank fusion, custom functions
- Queries can be tailored to the specific use case
