## 3Dvowelspace
R code for generating 3d graphs of vowel systems with apparent time as 3rd dimension

## Input
Requires two csv files that contain minimally the following columns:

File 1:

Subject ID (named Subject)

Vowel Class (named VClass)

F1 measurement (named F1)

F2 measurement (named F2)


File 2:

Subject ID (named Subject)

Birth year (named birthyear)

## Output
Zoomable and rotatable 3D graph of the vowel space with the following dimensions:

x = -F2

y = -F1

z = Speaker's birth year

The graph relies on smoothed by-speaker normalized data using the R scripts discussed below.

## Files
# normalize-data.R
Performs the following steps:

1. Calculated speaker means and standard deviations for F1 and F2

2. Normalizes F1 and F2 values using speaker means and standard deviations

3. Calculates population mean and standard deviation (average of speaker means and speaker standard deviations)

4. Rescales normalized values from 2 using population mean and standard deviation

# generate-graph.R
Uses moving window averages to smooth F1 and F2 for graphing. The moving window average means that the F1 and F2 value for a given vowel in a given year is equal to the mean F1 and F2 value for all tokens from X years before the current year and X years after the current year, where X is the window size (default size of 10 years).

The smoothed data is then used to generate the 3d graph.
