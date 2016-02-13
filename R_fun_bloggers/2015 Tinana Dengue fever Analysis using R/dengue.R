# Read Data
dengue <- read.csv("dengue-20151107-utf8.csv")
str(dengue)
summary(dengue)

library(ggmap)
library(mapproj)

map <- get_map(location = "Taiwan", zoom =7,
               language = "zh-TW", maptype = "roadmap")
ggmap(map, darken = c(0.5, "white")) +
  geom_point(aes(x = 經度座標, y = 緯度座標),
             color = "red", data = dengue)

map <- get_map(location = "Tainan", zoom = 9,
               language = "zh-TW", maptype = "roadmap")
ggmap(map, darken = c(0.5, "white")) +
  geom_point(aes(x = 經度座標, y = 緯度座標),
             color = "red", data = dengue) + 
  geom_rect(aes(xmin = 120, xmax = 120.6,
                ymin = 22.8, ymax =23.5),
            alpha = 0.1)

filter.idx1 <- dengue$緯度座標 > 22.8 & dengue$緯度座標 < 23.5
filter.idx2 <- dengue$經度座標 > 120 & dengue$經度座標 < 120.6
dengue.tn <- dengue[filter.idx1 & filter.idx2, ]

map <- get_map(location = c(lon = 120.246100, lat = 23.121198),
               zoom = 10, language = "zh-TW")
ggmap(map, darken = c(0.5, "white")) +
  geom_point(aes(x = 經度座標, y = 緯度座標),
             color = "red", data = dengue.tn)

levels(dengue.tn$區別)

dengue.tn[dengue.tn$區別 == "北　區", ]$區別 <- "北區"
dengue.tn[dengue.tn$區別 == "東　區", ]$區別 <- "東區"
dengue.tn[dengue.tn$區別 == "南　區" | dengue.tn$區別 == "南    區", ]$區別 <- "南區"
dengue.tn[dengue.tn$區別 == "永康區 ", ]$區別 <- "永康區"

dengue.tn$區別 <- factor(dengue.tn$區別)

levels(dengue.tn$區別)

# plot 
hist(as.Date(dengue.tn$確診日), breaks = "weeks",
     freq = TRUE, main = "登革熱每週病例數", xlab = "日期",
     ylab = "病例數", format = "%m/%d")

dengue.tn$month <- format(as.Date(dengue.tn$確診日), "%m")
table(dengue.tn$month)

barplot(table(dengue.tn$month), xlab = "月份", ylab = "病例數",
        main = "登革熱每月病例數")

# plot ggplot2
library(ggplot2)
library(scales)
ggplot(dengue.tn, aes(x=as.Date(確診日))) +
  stat_bin(binwidth=7, position="identity") +
  scale_x_date(breaks=date_breaks(width="1 month")) +
  theme(axis.text.x = element_text(angle=90)) +
  xlab("日期") + ylab("病例數") +
  ggtitle("登革熱每週病例數")

#
dengue.region.summary <- sort(summary(dengue.tn$區別), decreasing = FALSE)
dengue.region.summary
# plot 
barplot(dengue.region.summary, las = 2, horiz = TRUE,
        main = "各行政區病例統計", xlab = "病例數")
pie(dengue.region.summary)
