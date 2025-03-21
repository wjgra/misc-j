NB. This file is a solution to ACCU Homework Challenge 27, as set in C Vu Volume 37, March 2024
load 'plot'

NB. Verb to plot an x-day moving average of blood pressure data in a tab-separated file y
plot_bp_data =: {{
    NB. Load the datafile into a string and split into rows on LFs (ignoring CRs)
    datafile =. {{(LF=y) <;._2 y}}((CR-.~fread < y), LF)

    headings =. >;:>{. datafile
    data =. }. datafile

    NB. Strip any boxed empties caused by extra newlines and convert strings to numerics
    data =. ".>(a:-.~data)

    NB. Calculate x-day moving average of blood pressure data
    mva_data =: x (# %~ +/)\ data

    assert. ((#mva_data) > 0)

    options =. 'title ', (":x), '-Day Moving Average of Blood Pressure Measurements; '
    options =. options, 'xcaption Day of measurement; '
    options =. options, 'ycaption Blood pressure (mmHg); '
    options =. options, 'keypos left middle inside; '
    options =. options, 'key ', }.,/',',.headings

    options plot (] (; |:) ~ [: i. #)mva_data
}}

NB. Usage (7-day moving average)
NB.    7 plot_bp_data 'bp_data.tsv'