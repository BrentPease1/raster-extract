# Extract Values from a Raster in R  

---  
  
#### This repository contains a workflow to extract values from a raster in R. Specifically, an `R` script to extract values from a raster that fall within a buffer around a set of sampling points.  
  
---  
  
#### Repository Contents:  
  1. An `R` script `raster-extract.R` for extracting values.  
  2. Example point data, `example_camera_data.csv`, that we will create buffers around.  
  3. Example raster layer, `nlcd_nc_utm17.tif`, from which we will extract values. This is the 2011 National Land Cover Data for North Carolina, USA, and was retrieved [here](https://www.mrlc.gov/)  
  
#### `raster-extract.R` Work Flow:  
  1. Load points object (typically a .csv or .txt file), prepare for analysis, and then make SpatialPoints object
  2. Load raster layer from which we want to extract values 
  3. Make sure SpatialPoints and raster layer are in the same CRS  
  4. Extract values from raster layer that fall within a defined buffer around each point

