#!/bin/bash

# Generate an R script for a given term

samples="10000"

if [ $# -lt 1 ]; then
	echo "Usage: ./generate.sh term [timestamp]"
	exit
fi

term="$1"
timestamp="20111226_0351841"

if [ $# -eq 2 ]; then
	timestamp="$2"
fi

echo "# Tanner Prynn ISTA 116 Final Project
# THIS FILE WAS AUTOMATICALLY GENERATED

# Read in data files
data <- read.csv(\"~/Programming/R/open-advertising-dataset/dataset/keyword_stats_$timestamp.csv\", header=T, stringsAsFactors=F)
$term <- read.csv(\"~/Programming/R/open-advertising-dataset/terms/$term/keyword_stats_$timestamp.csv\", header=F, stringsAsFactors=F)

# Data Frames with NA values removed
kstats <- suppressWarnings(data[!is.na(as.numeric(data\$Global.Monthly.Searches)),])
$term <- suppressWarnings($term[!is.na(as.numeric($term\$V2)),])

# Number of observations we have of the specific term
observations <- length(row.names($term))

# Median Samples -- Unused
#sample_median <- replicate($samples, median(as.numeric(sample(kstats\$Global.Monthly.Searches, observations, replace = FALSE))))
#hist(sample_median)

# Std. Deviation Samples
sample_sd <- replicate($samples, sd(as.numeric(sample(kstats\$Global.Monthly.Searches, observations, replace = FALSE))))
#hist(sample_sd)
# IQR Samples
sample_iqr <- replicate($samples, IQR(as.numeric(sample(kstats\$Global.Monthly.Searches, observations, replace = FALSE))))
#hist(sample_iqr)

# Test IQR at 95% confidence
print(\"IQR Test at 95% Confidence:\")
print(\"Value at 0.05 Quantile for 10000 samples from all data:\")
quantile(sample_iqr, 0.05)
print(\"IQR value for all observations of $term:\")
iqr <- IQR($term\$V2)
iqr
print(\"P-value for observed IQR of $term:\")
length(sample_iqr[sample_iqr <= iqr])/length(sample_iqr)

# Test Std. Deviation at 95% confidence
#print(\"Std. Deviation Test at 95% Confidence:\")
#print(\"Value at 0.05 Quantile for 10000 samples from all data:\")
#quantile(sample_sd, 0.05)
#print(\"Std. Deviation value for all observations of $term:\")
#sd($term\$V2)" > "../stats/stats-$term.R"

echo "File stats/stats-$term.R successfully generated."