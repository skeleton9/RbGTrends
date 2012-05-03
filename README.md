RbGTrends
=========

ruby API to get google trends data

```
r = RbGTrends.new('email', 'passwd')
r.csv
```


Use `csv` to get data:

- `section` is part of the csv, '' for whole csv, 'main' for the main data part, there may be others like City/Region/Language
- `q` is the query word
- `date` is the date range, such as 'ytd' means 1 year to now
- `geo` is the region, '' for all regions

You can find details for these parameters in google trends.