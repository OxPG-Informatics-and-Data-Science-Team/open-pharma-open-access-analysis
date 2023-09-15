# Benchmarking the open-access rates of publications with authors from the pharmaceutical industry

This repository contains the R code and query strings to analyse open access trends across universities and pharmaceutical companies as described in the 'Benchmarking the open-access rates of publications with authors from the pharmaceutical industry' manuscript. 
Data for the analysis are collected directly from The Lens using the Aggregration API: https://docs.api.lens.org/aggregations-beta.html.

## Getting Started
### The Lens API queries
* Contact The Lens to request an API key and create an .env file to store the key.
* Run the R code in the '1.Lens API queries.qmd' file.
* Query strings are stored in the 'Query doc.xlsx' file.
* Results from the API requests are stored as .csv files in the 'output' folder.
  
### Data processing
* The R code in the '2.Data processing and visualizations.qmd' file can be used to preprocess the output from the API requests, create basic visualizations and calculate open access trends.
