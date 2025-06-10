# Elasticsearch

Features:
- Distributed, open-source search and analytics engine, used for indexing, storing, and searching data, especially large datasets, in near real-time. 
- Utilises JSON data format. 
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
