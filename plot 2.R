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

datetme <- paste(df[,1], df[,2])
datetme <- dmy_hms(datetme)

plot(datetme, df$Global_active_power, type="l",
     ylab="Global Active Power (kilowatts)",
     xlab="")


dev.copy(png,'plot2.png', width=480, height=480)
dev.off()


    