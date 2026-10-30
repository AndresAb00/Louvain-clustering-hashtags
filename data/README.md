# Research Data

## Dataset description

This repository contains R scripts developed to analyze hashtag usage and detect user communities on X (formerly Twitter), in the context of the Astesiano case in Uruguay.

The research focuses on the relationships between users and hashtags, using social network analysis and the Louvain community detection algorithm.

## Data availability

The original dataset is not publicly distributed through this repository due to data access conditions and privacy considerations associated with social media research.

The repository provides the analytical code and methodological documentation to support transparency and reproducibility.

## Required input data

The scripts require an RData file containing an object named `Data`.

The input dataset must include the following fields:

- `id`: publication identifier.
- `author.username`: username associated with the publication.
- `entities.hashtags`: hashtags associated with the publication.
- `referenced_tweets.retweeted.id`: identifier used to detect retweets.

The expected input file is named `dados01.RData`.

Its location can be specified through the environment variable `ASTESIANO_DATA_PATH`.

## Reproducibility

Researchers with authorized access to a compatible dataset can execute the analysis through the `main.R` script.

The procedure includes:

1. Data filtering and hashtag normalization.
2. User–hashtag frequency analysis.
3. Binary user–hashtag matrix construction.
4. User–user network projection.
5. Weighted network filtering.
6. Louvain community detection.
7. Community-level hashtag analysis.
8. Export of network data for Gephi.

The inclusion of the analytical scripts does not imply public access to the original research dataset.
