library(raster)
library(rgdal)
library(sp)

# downloading and unzipping the data
download.file(url = 'https://github.com/GeoScripting-WUR/VectorRaster/raw/gh-pages/data/MODIS.zip', destfile = 'data/modis.zip', method = 'auto')
unzip(zipfile='data/modis.zip', exdir='data/modis')

# getting path of the data and making a bricklayer
modisPath <- list.files('data/modis/', pattern = glob2rx('MOD*.grd'), full.names = TRUE)
modis <- brick(modisPath)
plot(modis)

# getting the city boundaries
nlCity <- getData('GADM',country='NLD', level=3)

# reprojecting the city boundaries
nlCityUTM <- spTransform(nlCity, CRS(proj4string(modis)))

#source('R/greenest_city.R')

#greenest_city('January')

# calculate which city has the highest NDVI in January
# the greenest municipality is "Littenseradiel"
meanNDVI_Jan <- extract(modis$January, nlCityUTM, fun = mean, sp=T, df=T)
maxNDVI_Jan <- max(meanNDVI_Jan$January, na.rm=TRUE, df=T, sp=T)
placenr_Jan <- which(meanNDVI_Jan$January == maxNDVI_Jan)
cityname_Jan <- meanNDVI_Jan$NAME_2[placenr_Jan]

# calculate which city has the highest NDVI in August
# the greenest municipality is "Vorden"
meanNDVI_Aug <- extract(modis$August, nlCityUTM, fun = mean, sp=T, df=T)
maxNDVI_Aug <- max(meanNDVI_Aug$August, na.rm=TRUE, df=T, sp=T)
placenr_Aug <- which(meanNDVI_Aug$August == maxNDVI_Aug)
cityname_Aug <- meanNDVI_Aug$NAME_2[placenr_Aug]

# calculate which municipality has the highest NDVI over the whole year
# the greenest municipality is "Graafstroom"
averageNDVI_WY <- mean(modis)
meanNDVI_WY <- extract(averageNDVI_WY, nlCityUTM, fun = mean, sp=T, df=T)
maxNDVI_WY <- max(meanNDVI_WY$layer, na.rm=TRUE, df=T, sp=T)
placenr_WY <- which(meanNDVI_WY$layer == maxNDVI_WY)
cityname_WY <- meanNDVI_WY$NAME_2[placenr_WY]

# plotting the mean NDVI over the year for all municipalities
spplot(meanNDVI_WY, zcol="layer", color.regions= 'green')
