---
title: "normalization (lab meeting)"
author: "JD"
date: "May 22, 2018"
output: 
  html_document: 
    keep_md: yes
---

### Read object 

```r
load("./my_SRA.RData")
```

### Check df

```r
head(df2, 10)
```

```
##         Query    Reference Count Ref_Total    MbRun
## 1  SRR5927129 LOC101489666  7927     30857 9964.302
## 2  SRR5927129 LOC101491204 22493     44592 9964.302
## 3  SRR5927129 LOC101492112  7280     34286 9964.302
## 4  SRR5927129 LOC101492136  4859     15526 9964.302
## 5  SRR5927129 LOC101492451   564      2320 9964.302
## 6  SRR5927129 LOC101492916  1170      8148 9964.302
## 7  SRR5927129 LOC101493974  1772      8098 9964.302
## 8  SRR5927129 LOC101496441  1448      4537 9964.302
## 9  SRR5927129 LOC101498188 23547     97849 9964.302
## 10 SRR5927129 LOC101498659  7709     21714 9964.302
```


### Normalization

```r
df2$norm_Moamen=df2$Count*mean(df2$MbRun)/df2$MbRun
df2$norm_Jose=df2$Count/df2$MbRun*df2$Ref_Total
head(df2,7)
```

```
##        Query    Reference Count Ref_Total    MbRun norm_Moamen   norm_Jose
## 1 SRR5927129 LOC101489666  7927     30857 9964.302   7550.5741  24547.9753
## 2 SRR5927129 LOC101491204 22493     44592 9964.302  21424.8851 100660.1221
## 3 SRR5927129 LOC101492112  7280     34286 9964.302   6934.2979  25049.6302
## 4 SRR5927129 LOC101492136  4859     15526 9964.302   4628.2629   7571.1108
## 5 SRR5927129 LOC101492451   564      2320 9964.302    537.2176    131.3168
## 6 SRR5927129 LOC101492916  1170      8148 9964.302   1114.4407    956.7313
## 7 SRR5927129 LOC101493974  1772      8098 9964.302   1687.8538   1440.1065
```
We can compare expression levels (based on counts) of a given ARF sequence across the libraries. 


```r
df3 = df2[df2$Reference == "LOC101489666",]
plot(df3$norm_Moamen, df3$norm_Jose, pch = 19, type = "l", col = "red")
```

![](Normalization_files/figure-html/unnamed-chunk-4-1.png)<!-- -->
