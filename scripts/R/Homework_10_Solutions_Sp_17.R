###########################################################################
# R Homework #10: In this week's project, you will use the NY_Data.csv as a 
# demonstration of cluster analysis in R. Then you will use the same process on 
# data for This homework will allow you the opportunity to 
# experiment with some of the parameters with these interpolation methods. 
#
# Please submit this completed R script to Canvas.
#
# INSTRUCTIONS ARE BELOW
#
# Consider using the vast R resources that are available on the Web to help your coding!!  
# You would be surprised how helpful performing a Web search for R questions can be
# For example, you could search on "how do I create a scatterplot in R"

# Please, please: DO NOT submit a Word Doc of this script for this homework
# To receive full credit you must submit THIS completed R script to Canvas
#########################################################################################

######################################################################
#
# Set your working directory 
#
######################################################################

setwd("C:/PSU/Course_Materials/GEOG_464/Homework/Week_11/")

# Confirm working directory location
getwd()

######################################################################
#
# Read in the data file 
# Standardize the data
# Create the initial resemblance coefficient matrix
#
######################################################################

# Reading in the NY data .csv file
ny.data <- read.csv("NY_Data.csv", header= TRUE, sep = ",")

# Standardize the data by computing z-scores for the numeric data
ny.data.z <- scale(ny.data[,c(2,3,4,5)], center = TRUE, scale=TRUE)

# Create a Distance Matrix
ny.data.dist = dist(ny.data.z)

######################################################################
#
# Cluster the data and experiment with different clustering methods
# Plot a dendogram to view the clustering
#
######################################################################

# Cluster the data using the "complete" method
ny.data.cluster = hclust(ny.data.dist, method = "average")

# Set parameters of the labels used on the dendogram
# cex() sets the text size to 60% of the default size
# mar() is a numeric vector of length 4, which sets the margin sizes in the following order: 
# bottom, left, top, and right. The default margin sizes are c(5.1, 4.1, 4.1, 2.1).
par(cex=0.6, mar=c(7,5,4,1), family="serif") 
# Turn off the y lables on the dendogram
plot(ny.data.cluster,labels=ny.data$County, yaxt="n", xlab="", ylab="", main="", sub="", frame.plot = TRUE)
par(cex = 0.75, cex.main=1.75) # Reset the text size to 75% of the default size
title(xlab="NY Data", line = 1) # Set the text for the x-axis label and move the lable closer to the axis line
title(ylab="Distance", line = 4) # Set the text for the y-axis label and move the lable closer to the axis line
title(main="Dendogram")
title(sub="Complete Method", line = 3) # Set the position for the sub title below the dendogram
axis(2) # Turn on the numerical values along the y-axis

# Examine the dendogram
plot(ny.data.cluster,labels=ny.data$County, main = "Dendogram", xlab="NY Data", ylab="Distance", frame.plot = TRUE, sub = "Complete Method")

# Cluster the data using the "average" (UPGMA) method
ny.data.cluster = hclust(ny.data.dist, method = "complete")

# Examine the dendogram
plot(ny.data.cluster,labels=ny.data$County, main = "Dendogram", xlab="NY Data", ylab="Distance", frame.plot = TRUE, sub = "UPGMA Method")

######################################################################
#
# Determine the cluster membership
# 
######################################################################

# Plot the percentage of variance explained by the clusters against the number of clusters
# Doing so will result with the first cluster explaining a lot of variation. However,
# at some point additional clusters will no longer explain significant variation.
# The following function determines the WSS for different number of clusters.

# Use a "function" to determine the within variation between clusters
wssplot <- function(data, nc=8, seed=1234){
  wss <- (nrow(data)-1)*sum(apply(data,2,var))
  for (i in 2:nc){
    set.seed(seed)
    wss[i] <- sum(kmeans(data, centers=i)$withinss)}
  plot(1:nc, wss, type="o", pch=19, xlab="Number of Clusters",
       ylab="Within Group Sum of Squares")}

# Plot the results (5 classes seems appropriate)
wssplot(ny.data.z, nc=8) 

#####################################################################
#
# Make a note of the number of classes. You will need to enter this 
# number in some of the code that follows
#
#####################################################################
#####################################################################
#
# Using the number of clusters determined through the previous wssplot
# process, plot a blue border around the N cluster solution on the dendogram
# created using the "average" method
#
#####################################################################
#Examine the results of this plot to choose the number of classes that will form the individual clusters
# Enter the number of clusters for N <- X
N <- 5 
plot(ny.data.cluster, labels=ny.data$County, main = "Dendogram", xlab="NY Data", ylab="Distance", frame.plot = TRUE, sub = "Average Method")
rect.hclust(ny.data.cluster, k=N, border = "blue") 

# Examine group membership for N groups
# Shows into which cluster each county has membership.
ny.data.groups.N = cutree(ny.data.cluster,N) 
ny.data.groups.N

# How many observations are in each cluster
table(ny.data.groups.N)
ny.data.groups.N

# Shows the county membership in each cluster. 
# Here, for a N cluster solution
ny.data.groups.N = cutree(ny.data.cluster,N)

# If you want to view only those counties in the first cluster
ny.data.5_cluster <- ny.data$County[ny.data.groups.N == 1] 
ny.data.5_cluster

# Categorizes all of the clusters and their county membership for the N solutions.
ny_cluster.membership <- sapply(unique(ny.data.groups.N),function(g)ny.data$County[ny.data.groups.N == g]) 
ny_cluster.membership

################################################################
#
# Determine the mean z-scores for each of the clusters
#
################################################################
# Computes the mean for specific groups. Here, the mean z-scores are computed for the 7 clusters
aggregate(ny.data.z,list(ny.data.groups.N),mean) 

# Interpreting the z-scores
# For z-scores near + or - 0.0 label this category as near state averages
# For z-scores near + or - 1.0 label this category as moderately high or low, respectively
# For z-scores near + or - 2.0 label this category as distinctively high or low, respectively

#################################################################
#
# Compute the copheneitc matrix of the original distances and
# The resemblance coefficients for the final clustering
#
#################################################################

# Compute the original distance matrix
ny.data.dist = dist(ny.data.z)
ny.data.cluster = hclust(ny.data.dist)

# Computes the cophenetic matrix
ny.data.cophenetic = cophenetic(ny.data.cluster) 

# Compute the Pearson's product-moment correlation
# Computes the correlation coefficient and assocatied statistical tests
cor.test(ny.data.dist, ny.data.cophenetic) 

############################################################################
#
# Create a map in ArcMap that shows the spatial association of the clusters
#
############################################################################




############################################################################
#
# A few additional visualizations of cluster analysis
#
############################################################################
# Create a graphical representation of the clustering solution 
# Plot the cluster assignments on percent change in population and percent unemployment
# Note that this process only works for two variables.
plot(ny.data$Pct_pop_change, ny.data$Pct_unemploy, type="n", xlab="Percent Population Change", ylab="Percent Unemployment")
text(x=ny.data$Pct_pop_change, y=ny.data$Pct_unemploy, labels=ny.data$County, col=ny.data.groups.N)

# Library clusters allow us to represent (with the aid of PCA) the cluster solution into 2 dimensions:
install.packages("cluster")
library(cluster)

# k-means clustering aims to partition the n observations into 
# (k???nk???n) S={S1,S2,.,Sk}S={S1,S2,.,Sk} so as to minimize the within-cluster sum of squares (WCSS).
k.means.fit <- kmeans(ny.data.z, N) # Number of clusters = N
# Clusters
k.means.fit$cluster

# Cluster centroids
k.means.fit$centers

# Cluster sizes
k.means.fit$size

# PCA assessment of the clustering
clusplot(ny.data.z, k.means.fit$cluster, main='2D representation of the Cluster solution',
         color=TRUE, shade=TRUE, labels=2, lines=0, plotchar = TRUE)
