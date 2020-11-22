######################################################################
#
# Set your working directory 
#
######################################################################

setwd("C:\\Users\\Erola\\Documents\\Penn State\\Capstone\\data\\part1\\gridstats")

# Confirm working directory location
getwd()

######################################################################
#
# Read in the data file 
# Standardize the data
# Create the initial resemblance coefficient matrix
#
######################################################################

# Reading in the grid data .csv file
grid.data <- read.csv("plasco_after.csv", header= TRUE, sep = ",")

# Standardize the data by computing z-scores for the numeric data
grid.data.z <- scale(grid.data[,c(4,5,8,11)], center = TRUE, scale=TRUE)

# Create a Distance Matrix
grid.data.dist = dist(grid.data.z)

# Cluster the data using the "complete" method
grid.data.cluster = hclust(grid.data.dist, method = "average")

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

# Plot the results (4 classes seems appropriate)
wssplot(grid.data.z, nc=8) 

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
N <- 4
plot(grid.data.cluster, labels=grid.data$id, main = "Dendogram", xlab="Grenfell Data", ylab="Distance", frame.plot = TRUE, sub = "Average Method")
rect.hclust(grid.data.cluster, k=N, border = "blue") 

# Examine group membership for N groups
# Shows into which cluster each county has membership.
grid.data.groups.N = cutree(grid.data.cluster,N) 
grid.data.groups.N

write.table(grid.data.groups.N,"plasco_after_clusters_average_4.csv", sep=",")
