# Extract values from raster layer to camera buffer
# Brent Pease
# North Carolina State University

#Load libraries
library(data.table)
library(raster)
library(sp)
library(rgdal)
library(maptools)
library(rgeos)
library(here)

#Set Working directory to repository home
setwd(here())

######Work Flow#########
## 1. Load points object (typically a .csv or .txt file), prep, and then make SpatialPoints object (SpatialPoints objects are essentially equivalent to point shapefiles in ArcGIS)
## 2. Load raster layer from which we want to extract values
## 3. Make sure SpatialPoints and raster layer are in the same CRS
## 4. Extract values from raster layer that fall within a defined buffer around each point
######End work Flow#####

#### 1. Load point data ####
cameras <- fread("example_camera_data.csv") #Example data - all Candid Critters observations as of 11/19/2017
names(cameras) <- gsub(" ",".",names(cameras))  #remove spaces from column headers and replace with '.'

#We really only need Latitude / Longitude information and a single line for each Deploy.ID from the 'cameras' object
x <- cameras[!duplicated(Deploy.ID), .(Deploy.ID,Actual.Lon,Actual.Lat)] #subset cameras to have one row for each Deploy.ID and only return 3 columns
names(x) <- c("Deploy.ID","Longitude","Latitude")

# Make point data a SpatialPoints object
coordinates(x) <- ~Longitude + Latitude #"Longtitude" and "Latitude" are column names in 'cameras' object
proj4string(x) <- CRS("+init=epsg:4326") #'x' Coordinate Reference System (CRS) is currently unassigned. first assign CRS that match the CRS of the dataset (WGS84) before any transformations

#Visualize points to check whether it looks correct
plot(x,pch=19,cex=0.5)


#### 2. Load raster layer(s) #####

raster <- raster("nlcd_nc_utm17.tif") #Example data: National Land Cover Data for North Carolina

# plot(raster) #If you would like to visualize your raster layer, just plot it. Can take a while depending on file size. plot(raster) took 14 seconds on my machine.



#### 3. Make sure SpatialPoints and Raster layer are in the same CRS ####
## You will usually always want to transform your points layer to match your raster, not raster to points.

x <- spTransform(x, CRSobj = CRS(proj4string(raster))) #transform SpatialPoints to match raster layer's CRS

##check whether CRS match
print(identicalCRS(raster, x))


#### 4. Extract values from raster layer that fall within a defined buffer around each point ####
## Note: this takes a little over 8 minutes on my machine. 

extract <- extract(x = raster,                #raster layer
          y = x,                #SpatialPoints* object
          buffer = 10,          #circular buffer size, unites depend on CRS(utm = meters)
          na.rm = TRUE,         #Remove NAs
          df = TRUE,             #return a dataframe?
          small=TRUE
            )
#extract sometimes outputs to class "matrix". Change to data.frame
a <- data.frame(extract)

#add Deploy.ID column to extracted data frame
b <- cbind(a, x$Deploy.ID)

#change column names in 'a'
colnames(b) <- c("ID","NLCD","Deploy.ID")

#The final data.frame is now an object called 'b'
head(b)







