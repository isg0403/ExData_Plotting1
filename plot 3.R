library(lubridate)
library(dplyr)                      # using only pipeline operator %>%

#=== Step 1. Import only required rows ===

# Step 1 is the same in all 4 plotting scripts

# 1a. First figure out which rows contain data for the desired dates.

cols <- rep("NULL", 9)
cols[1] <- "character"

all_dates <- read.table("data/household_power_consumption.txt", header=TRUE, 
                        sep = ";", colClasses = cols)[,1]    %>%
    dmy()              # convert to Date format using f. from lubridate

# which records contain the desired dates? returns indices
days_idx <- which(all_dates == as.Date("2007-02-01") | 
                      all_dates == as.Date("2007-02-02"))

# importing headers separately is needed when using the skip option
# in the next statement
headers <- names(read.table("data/household_power_consumption.txt", sep = ";",
                            nrows=1, header=TRUE))

# 1b. Then perform actual import

df <- read.table("data/household_power_consumption.txt",
                 header = FALSE, sep = ";",
                 skip = days_idx[1], nrows = length(days_idx),
                 as.is = c(1, 2),       # do not convert dates & times to factor
                 col.names = headers)



#=== Step 2 - draw time series plot 

datetme <- paste(df[,1], df[,2]) %>%
           dmy_hms()

with(df, {
    
    plot(datetme, df$Sub_metering_1, type="n",
         ylab = "Energy sub metering", xlab = "")
    points(datetme, Sub_metering_1, col="black", type="l")
    points(datetme, Sub_metering_2, col="red", type="l")
    points(datetme, Sub_metering_3, col="blue", type="l")
})


# the legend did not display automatically well in the png file, hence some
# manual adjustment was necessary to move it more to the left.

       # do not plot yet, just fetch default placement values    
leg <- legend("topright", lty = 1, col = c("black", "red", "blue"),
       legend = headers[7:9], plot=FALSE)

x_left <- leg$rect$left - 15900
x_rigth <- x_left+leg$rect$w * 1.3
y_top <- leg$rect$top
y_bottom <- leg$rect$top - leg$rect$h

legend(x=c(x_left, x_rigth), y=c(y_top, y_bottom),
       lty = 1, col = c("black", "red", "blue"),
       legend = headers[7:9], plot=TRUE)


dev.copy(png,'plot3.png', width=480, height=480)
dev.off()