setwd("C:\\Users\\Erola\\Documents\\Penn State\\Capstone\\data\\part2\\delaunay_working")

# Load data
require(sqldf)
nodes <- read.csv.sql("event_user_nodes_ghostship.csv", "select lat, lon from file where uid = 339581")

deduped.nodes <- unique(nodes[, 1:2])

# add id
deduped.nodes$ID <- seq.int(nrow(deduped.nodes))

# Projection
library(mapproj)
nodes_projected <- mapproject(deduped.nodes$lon, nodes$lat, "mercator")

# Plot points
par(mar=c(0,0,0,0))
plot(deduped.nodes, asp=1, type="n", bty="n", xlab="", ylab="", axes=FALSE)
points(deduped.nodes, pch=20, cex=0.1, col="red")

# Delaunay triangulation
library(deldir)
vtess <- deldir(deduped.nodes$x, deduped.nodes$y)
plot(vtess, wlines="triang", wpoints="none", number=FALSE, add=TRUE, lty=1)

mylist <- triang.list(vtess)


my.data <- data.frame(id = deduped.nodes$ID, x_coor = deduped.nodes$lon, y_coor = deduped.nodes$lat)

# When I perform Delaunay triangulation, I can see the distances....
library(tripack)
my.triangles<-tri.mesh(my.data$x_coor, my.data$y_coor)
plot(my.triangles, do.points=FALSE, lwd=0.2)

# Create a list of neighbors
neiblist <- neighbours(my.triangles)

names(neiblist) <- my.data$id 

euc_dist <- as.matrix(dist(cbind(x=my.triangles$x, y=my.triangles$y)))

#Append dimnames for reference

colnames(euc_dist) <- my.data$row
rownames(euc_dist) <- my.data$row

# Find max neighbors a point could have (for memory)
max_n <- max(unlist(lapply(neiblist, length)))
npoints <- length(my.data$id)

#Create results matrix
dist_2neigh_mat <- matrix(nrow=npoints, ncol=max_n)    

rownames(dist_2neigh_mat) <- my.data$id
colnames(dist_2neigh_mat) <- colnames(data.frame(dist=matrix(data=1:29, nrow=1)))


for (i in my.data$id){
  neighbors_i <- neiblist[[i]]
  dist2neighbours_i <- euc_dist[,i][neighbors_i]
  
  #Append vector with NAs to match ncol of results matrix
  
  dist2neighbours_i <- c(dist2neighbours_i, rep(NA, 
                                                times=(max_n-length(dist2neighbours_i))))
  
  dist_2neigh_mat[i,] <- dist2neighbours_i   #Update results matrix with i'th distances
}