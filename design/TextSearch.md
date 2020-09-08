# Text Search Design

(aka "BigSearch")

## Key ideas

- Users create text files that provide text data to index and search.
- Search indexing builds internal resources for faster query results.
- Each search query leads to zero or more search matches.
- Each search match includes an internal file position.
- Files permit queries for data surrounding each match (each internal file position).

### File

- Uniquely-identified resource.
- All content is text (for now).
- CRUD API for creating, reading and updating files.

#### File data model

 - Each file is a Sequence of text.
 - Each file is potentially very large in size.
 - Use BigMap to store file chunks, if needed.

### Search

Concepts:

- Indexing
- Matches
- Queries

#### Search indexing

 - Indexing constructs structures that accelerate search
 - Text tokenized as words, at whitespace boundaries (for now).
 - Each token (word) is ranked by its frequency in the dataset.
 - KISS: No natural language model yet. (e.g., we should ignore certain words or letters, such as "the")

#### Search queries

 - Each query is (for now) a list of words/phrases
 - Each word has (for now) equal rank
 - The results represent an aggregation of seaching for all words

#### Search matches

 - Each query leads to zero or more ranked search matches
 - Each search match permits further queries (e.g., for match context)
