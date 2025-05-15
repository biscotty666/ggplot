# 6 - Summarized Data Distributions


``` r
library(tidyverse)
library(gcookbook)
library(patchwork)
```

[Source](https://r-graphics.org/RECIPE-LINE-GRAPH-LINE-APPEARANCE.html)

# Summarized Data Distributions

## Basic histogram

``` r
ggplot(faithful, aes(x = waiting)) +
  geom_histogram()
```

    `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-2-1.png)

> Default grouping is 30 bins. Change with `binwidth` or `binsize`

``` r
ggplot(faithful, aes(x = waiting)) +
  geom_histogram(binwidth = 5, fill = "white", colour = "black")
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-3-1.png)

``` r
binsize <- diff(range(faithful$waiting))/15

ggplot(faithful, aes(x = waiting)) +
  geom_histogram(binwidth = binsize, fill = "white", colour = "black")
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-4-1.png)

``` r
faithful_p <- ggplot(faithful, aes(x = waiting))

faithful_p +
  geom_histogram(binwidth = 8, fill = "white", colour = "black", boundary = 31)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-5-1.png)

``` r
faithful_p +
  geom_histogram(binwidth = 8, fill = "white", colour = "black", boundary = 35)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-5-2.png)

## Multiple Histograms from grouped data

``` r
library(MASS)

ggplot(birthwt, aes(x = bwt)) +
  geom_histogram(fill = "white", color = "black") +
  facet_grid(smoke ~ .)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-6-1.png)

> Label the facets

``` r
birthwt_mod <- birthwt
birthwt_mod$smoke <- recode_factor(birthwt_mod$smoke, 
                                   '0' = 'No Smoke', 
                                   '1' = 'Smoke')

ggplot(birthwt_mod, aes(x = bwt)) +
  geom_histogram(fill = "white", color = "black") +
  facet_grid(smoke ~ .)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-7-1.png)

> If the groups have different size, the scales can be resized

``` r
ggplot(birthwt, aes(x = bwt)) +
  geom_histogram(fill = "white", colour = "black") +
  facet_grid(race ~ .)
```

    `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-8-1.png)

``` r
ggplot(birthwt, aes(x = bwt)) +
  geom_histogram(fill = "white", colour = "black") +
  facet_grid(race ~ ., scales = "free")
```

    `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-9-1.png)

> Map the grouping variable to `fill`
>
> Specifying `position = "identity"` is important. Without it, ggplot
> will stack the histogram bars on top of each other vertically, making
> it much more difficult to see the distribution of each group.

``` r
ggplot(birthwt_mod, aes(x = bwt, fill = smoke)) +
  geom_histogram(position = "identity", alpha = 0.4)
```

    `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-10-1.png)

## Density curve

> `geom_density()`

``` r
ggplot(faithful, aes(x = waiting)) +
  geom_density()
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-11-1.png)

or

``` r
ggplot(faithful, aes(x = waiting)) +
  geom_line(stat = 'density') +
  expand_limits(y = 0)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-12-1.png)

> Look at data not in a data frame

``` r
w <- faithful$waiting

ggplot(NULL, aes(x = w)) +
  geom_density()
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-13-1.png)

> adjust the bandwidth to change the smoothness

``` r
ggplot(faithful, aes(x = waiting)) +
  geom_line(stat = "density") +
  geom_line(stat = "density", adjust = .25, colour = "red") +
  geom_line(stat = "density", adjust = 2, colour = "blue")
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-14-1.png)

> To show more of the curve, set xlim

``` r
ggplot(faithful, aes(x = waiting)) +
  geom_density(fill = "blue", alpha = .2) +
  xlim(35, 105)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-15-1.png)

``` r
# This draws a blue polygon with geom_density(), then adds a line on top
ggplot(faithful, aes(x = waiting)) +
  geom_density(fill = "blue", alpha = .2, colour = NA) +
  xlim(35, 105) +
  geom_line(stat = "density")
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-16-1.png)

> Overlay density and histogram

``` r
ggplot(faithful, aes(x = waiting, y = ..density..)) +
  geom_histogram(fill = "cornsilk", colour = "grey60", size = .2) +
  geom_density() +
  xlim(35, 105)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-17-1.png)

## Multiple density curves from grouped data

> use `geom_density` and map a grouping variable to color or fill
> aesthetic

``` r
birthwt_mod <- birthwt %>%
  mutate(smoke = as.factor(smoke))

ggplot(birthwt_mod, aes(x = bwt, colour = smoke)) +
  geom_density()
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-18-1.png)

``` r
ggplot(birthwt_mod, aes(x = bwt, fill = smoke)) +
  geom_density(alpha = .3)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-19-1.png)

> Using facets

``` r
birthwt_mod$smoke <- recode(birthwt_mod$smoke, '0' = 'No Smoke', '1' = 'Smoke')
ggplot(birthwt_mod, aes(x = bwt)) +
  geom_density() +
  facet_grid(smoke ~ .)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-20-1.png)

> Add a histogram, using `y = ..density..` to scale the histogram

``` r
ggplot(birthwt_mod, aes(x = bwt, y = ..density..)) +
  geom_histogram(binwidth = 200, fill = "cornsilk", colour = "grey60", size = .2) +
  geom_density() +
  facet_grid(smoke ~ .)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-21-1.png)

## Frequency polygon

> `geom_freqpoly()`

``` r
ggplot(faithful, aes(x=waiting)) +
  geom_freqpoly()
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-22-1.png)

``` r
ggplot(faithful, aes(x=waiting)) +
  geom_freqpoly(binwidth = 4)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-23-1.png)

> or

``` r
binsize <- diff(range(faithful$waiting))/15

ggplot(faithful, aes(x = waiting)) +
  geom_freqpoly(binwidth = binsize)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-24-1.png)

## Box plot

> `geom_boxplot()`

``` r
ggplot(birthwt, aes(x = factor(race), y = bwt)) +
  geom_boxplot()
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-25-1.png)

> set width

``` r
ggplot(birthwt, aes(x = factor(race), y = bwt)) +
  geom_boxplot(width = .5)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-26-1.png)

> outlier shape and size

``` r
ggplot(birthwt, aes(x = factor(race), y = bwt)) +
  geom_boxplot(outlier.size = 1.5, outlier.shape = 21)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-27-1.png)

> For a single group, must provide an arbitrary `x` value

``` r
ggplot(birthwt, aes(x = 1, y = bwt)) +
  geom_boxplot() +
  scale_x_continuous(breaks = NULL) +
  theme(axis.title.x = element_blank())
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-28-1.png)

## Boxplot with notches

``` r
ggplot(birthwt, aes(x = factor(race), y = bwt)) +
  geom_boxplot(notch = TRUE)
```

    Notch went outside hinges
    ℹ Do you want `notch = FALSE`?

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-29-1.png)

## Boxplot with mean averages

``` r
ggplot(birthwt, aes(x = factor(race), y = bwt)) +
  geom_boxplot() +
  stat_summary(fun = "mean", geom = "point",
               shape = 23, size = 3, fill = "white")
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-30-1.png)

## Violin plot

> `geom_violin()`

``` r
hw_p <- ggplot(heightweight, aes(x = sex, y = heightIn))
```

``` r
hw_p + geom_violin()
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-32-1.png)

> With boxplot overlay

``` r
hw_p +
  geom_violin() +
  geom_boxplot(width = .1, fill = "navy", outlier.colour = NA) +
  stat_summary(fun = median, geom = "point", fill = "white",
               shape = 21, size = 2.5)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-33-1.png)

> Keep the tails

``` r
hw_p + geom_violin(trim = FALSE)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-34-1.png)

> Default is to scale to equal areas. To have the size represent the
> number of observations

``` r
hw_p + geom_violin(scale = "count")
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-35-1.png)

> Change the smooting

``` r
p1 <- hw_p + geom_violin(adjust = 2)
p2 <- hw_p + geom_violin(adjust = .5)
p1 + p2
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-36-1.png)

## Wilkinson dot plot

``` r
c2009 <- countries |> 
  filter(Year == 2009 & healthexp > 2000)

c2009_p <- ggplot(c2009, aes(x = infmortality))

c2009_p + 
  geom_dotplot()
```

    Bin width defaults to 1/30 of the range of the data. Pick better value with
    `binwidth`.

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-37-1.png)

> y axis ticks should be removed as they aren’t meaningful.

``` r
c2009_p + 
  geom_dotplot(binwidth = .25) + 
  geom_rug() +
  scale_y_continuous(breaks = NULL) +
  theme(axis.title.y = element_blank())
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-38-1.png)

> To use regular intervals

``` r
c2009_p + 
  geom_dotplot(method = "histodot", binwidth = .25) + 
  geom_rug() +
  scale_y_continuous(breaks = NULL) +
  theme(axis.title.y = element_blank())
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-39-1.png)

``` r
c2009_p + 
  geom_dotplot(stackdir = "center", binwidth = .25) + 
  geom_rug() +
  scale_y_continuous(breaks = NULL) +
  theme(axis.title.y = element_blank())
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-40-1.png)

``` r
c2009_p + 
  geom_dotplot(stackdir = "centerwhole", binwidth = .25) + 
  geom_rug() +
  scale_y_continuous(breaks = NULL) +
  theme(axis.title.y = element_blank())
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-41-1.png)

## Multiple dot plots for grouped data

``` r
ggplot(heightweight, aes(x = sex, y = heightIn)) +
  geom_dotplot(binaxis = "y", binwidth = .5, stackdir = "center")
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-42-1.png)

> with boxplot

``` r
ggplot(heightweight, aes(x = sex, y = heightIn)) +
  geom_boxplot(outlier.color = NA, width = .4) +
  geom_dotplot(binaxis = "y", binwidth = .5,
               stackdir = "center", fill = NA)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-43-1.png)

> boxplot and dotplot side-by-side

``` r
ggplot(heightweight, aes(x = sex, y = heightIn)) +
  geom_boxplot(aes(x = as.numeric(sex) + .2, group = sex), width = .25) +
  geom_dotplot(
    aes(x = as.numeric(sex) - .2, group = sex),
    binaxis = "y",
    binwidth = .5,
    stackdir = "center"
  ) +
  scale_x_continuous(
    breaks = 1:nlevels(heightweight$sex),
    labels = levels(heightweight$sex)
  )
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-44-1.png)

## Density plot of two-dimensional data

``` r
faithful_p <- ggplot(faithful, aes(x = eruptions, y = waiting))

faithful_p +
  geom_point() +
  stat_density2d()
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-45-1.png)

> Map the heith of the density curve

``` r
faithful_p +
  stat_density2d(aes(colour = ..level..))
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-46-1.png)

> With tiles instead of contours

``` r
faithful_p +
  stat_density2d(aes(fill = ..density..), geom = "raster", contour = F)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-47-1.png)

``` r
faithful_p +
  geom_point() +
  stat_density2d(aes(alpha = ..density..), geom = "tile", contour = F)
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-48-1.png)

> Adjusting the bandwidth

``` r
faithful_p +
  stat_density2d(aes(fill = ..density..), 
                 geom = "raster", contour = F,
                 h = c(.5, 5)) # x and y
```

![](6-SummarizedDataDistributions_files/figure-commonmark/unnamed-chunk-49-1.png)
