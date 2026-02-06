## What are aggregations?

Aggregations summarize data from a lower grain to a higher grain
using functions like COUNT, SUM, AVG, MIN, and MAX.

## Why this matters in data engineering

Aggregations are used to:
- Build metrics tables
- Power dashboards
- Create fact tables
- Avoid double counting in pipelines

Incorrect aggregation logic is one of the most common causes of bad data.

## Common mistakes

- Aggregating before filtering
- Grouping on the wrong grain
- Double-counting after joins
- Using DISTINCT as a band-aid


## Related solved problems

- Histogram of Tweets
