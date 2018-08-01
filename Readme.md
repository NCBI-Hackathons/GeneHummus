---
title: "GeneHummus"
author: "Visiting Bioinformaticians Program"
date: "6/15/2018"
output: 
  html_document: 
    keep_md: yes
---

### Dependencies

```r
library(rentrez)
library(stringr)
library(dplyr)
```

### Load the R functions

```r
source("hummusFunctions.R")
```


### Read Legumes taxids
Load the object `my_hummus`. It contains the vector `legumesIds` with the legumes taxids. You can download from the NCBI the taxids from your own family or species. 

```r
file = "my_hummus.RData"
load(file)
```


### Conserved domains

Plant gene families are characterized by common protein structure. 
The structure that defines a given family can be found in literature.   

You can specify the conserved domain accession number as a query. For example, the 
three conserved domains that define the ARF gene family are: 

```r
arf <- c("pfam02362", "pfam06507", "pfam02309")
arf
```

```
## [1] "pfam02362" "pfam06507" "pfam02309"
```

Those three accessions correspond with the three ARF conserved domains:  
  
  * B3 DNA binding domain
  * Auxin response factor
  * AUX/IAA family
  
We know from literature that the last domain AUX/IAA may be/not be present. 

### SPARCLE architectures
Then, you can get the SPARCLE architectures for each conserved domain using the `getSparcleArchs` function. 

```r
cd1 = getSparcleArchs(arf[1])
cd2 = getSparcleArchs(arf[2])
cd3 = getSparcleArchs(arf[3])
```

For example, the SPARCLE architectures for Pfam02362 are:  
12034188, 12034184, 12034182, 12034166, 12034151, 11279088, 11279084, 11266712, 11130507, 11130491, 11130489, 11130478, 10975108, 10889850, 10874725, 10803150, 10492348, 10492347, 10178159, 10178158.  
Not all those architectures link to ARF proteins. But the architecture ids for the ARF proteins will be definitely among any of them. 

### SPARCLE labels
Thus, next step, is to identify the architecture ids corresponding to ARF proteins. For this, the SPARCLE labels come in handy. We do not need to get all the labels for each architecture ids. We just need those labels that could be present in the ARF proteins. So, we can filter by any word that we know will be present in the ARF family. For example, we know that a given ARF protein at least contain the domain "B3_DNA".


```r
getSparcleLabels(cd1, "B3_DNA")
```

```
## [1] "12034188 protein containing domains B3_DNA, Auxin_resp, Activator_LAG-3, and AUX_IAA"
## [1] "12034184 protein containing domains B3_DNA, Auxin_resp, Med15, and PB1"
## [1] "12034182 protein containing domains B3_DNA, Auxin_resp, Atrophin-1, and AUX_IAA"
## [1] "12034166 protein containing domains B3_DNA, Auxin_resp, PAT1, and AUX_IAA"
## [1] "12034151 protein containing domains B3_DNA, LRR_3, and zf-CCCH"
## [1] "11279088 B3_DNA domain-containing protein"
## [1] "11279084 B3_DNA domain-containing protein"
## [1] "11130507 B3_DNA and Auxin_resp domain-containing protein"
## [1] "11130491 protein containing domains B3_DNA, Auxin_resp, and PEARLI-4"
## [1] "11130489 B3_DNA and Auxin_resp domain-containing protein"
## [1] "10975108 B3_DNA domain-containing protein"
## [1] "10889850 AP2 and B3_DNA domain-containing protein"
## [1] "10874725 B3_DNA domain-containing protein"
## [1] "10492348 protein containing domains B3_DNA, Auxin_resp, and PB1"
## [1] "10492347 B3_DNA domain-containing protein"
## [1] "10178159 B3_DNA domain-containing protein"
## [1] "10178158 B3_DNA domain-containing protein"
```

We can run the `getSparcleLabels` function on the other two architectures (Pfam06507, Pfam02309). After examination of the labels, based on the number of domains (>=3), the only architecture ids making sense for the ARF are: 

```r
my_labelsIds <-  c(10332700, 11130507, 10332698, 10492348, 12034166, 11130489)
```

### Protein ids 
Now for each SPARCLE architecture we'll get the whole protein ids list showing that architecture. We'll start by analizing the first architecture (n = 1). 

```r
n = 1
sparcleArch = my_labelsIds[n]
```
To get the protein ids for the architecture id 10332700, we'll call the function `getProtlinks`:

```r
my_protIds <- getProtlinks(sparcleArch)
```
Depending on the architecture id, the protein ids can be a long list. Because in the next step we'll interact with the [NCBI's web history](https://www.ncbi.nlm.nih.gov/books/NBK25501/) feature, we have to check the length of that list. Note that if you have a very long list of ids (>300) you may receive a 414 error.


```r
length(my_protIds)
```

```
## [1] 28
```
As we have < 300 ids, now we can call the function `extract_proteins` that has two arguments. The first one is a vector containing the protein ids; the second argument is the taxonomy ids for the species you want to identify the proteins. In this case study, the Legumes ids. The function returns only the protein ids hosted by the RefSeq database.  
Let's create an empty vector called `my_values` where we'll keep track of every ARF protein id from the Legume family.

```r
my_values <- extract_proteins(my_protIds, legumesIds)
```

Now we check the architecture n = 2. 

```r
n = 2
my_protIds <- getProtlinks(my_labelsIds[n])
```


```r
length(my_protIds)
```

```
## [1] 2489
```
Because this time we have a very long list (>>300), we need to subset the elements, so the `extract_proteins` function can work properly. For subsetting, we'll use the function `subsetIds` that takes as first argument the protein ids and as second argument the length of the subsetting. 


```r
protIds_subset <-  subsetIds(my_protIds, 300)
length(protIds_subset)
```

```
## [1] 9
```
Now we have a `protIds_subset` vector, which is a list containing 9 elements. Each element of the list is made of 300 protein ids. 

Now we can call the function `extract_proteins_from_subset`, that in turn will pass the function `extract_proteins` on each of the9 elements. We need three arguments, the vector list, the targeted taxonomy ids and the vector cotaining the values to be updated. 



```r
my_values = extract_proteins_from_subset(protIds_subset, legumesIds, my_values)
length(my_values)
```

```
## [1] 170
```

Let's run the code for the architectures n=3-6. 



```r
n = 3
my_protIds <- getProtlinks(my_labelsIds[n])
length(my_protIds)
```

```
## [1] 29
```

Update `my_values` with the protein ids from SPARCLE architecture n=3:

```r
my_values <- c(my_values, extract_proteins(my_protIds, legumesIds))
length(my_values)
```

```
## [1] 170
```


```r
n = 4
my_protIds <- getProtlinks(my_labelsIds[n])
length(my_protIds)
```

```
## [1] 4577
```


```r
protIds_subset <-  subsetIds(my_protIds, 300)
my_values = extract_proteins_from_subset(protIds_subset, legumesIds, my_values)
length(my_values)
```

```
## [1] 547
```


```r
n = 5
my_protIds <- getProtlinks(my_labelsIds[n])
length(my_protIds)
```

```
## [1] 34
```

```r
my_values <- c(my_values, extract_proteins(my_protIds, legumesIds))
length(my_values)
```

```
## [1] 549
```


```r
n = 6
my_protIds <- getProtlinks(my_labelsIds[n])
length(my_protIds)
```

```
## [1] 142
```

```r
my_values <- c(my_values, extract_proteins(my_protIds, legumesIds))
length(my_values)
```

```
## [1] 561
```

At this point we have likely identified the whole set of ARF protein ids from the Legume family. Because two given SPARCLE architectures may link to the same sequence, finally we want to check that `my_values` does not contain duplicated values. 


```r
my_values = unique(my_values)
length(my_values)
```

```
## [1] 561
```

Now, we want to get the legume species and the number of proteins per species. 

```r
my_values_subset <-  subsetIds(my_values, 300)
spp = extract_spp_from_subset(my_values_subset)
length(spp) == length(my_values)
```

```
## [1] TRUE
```


```r
spp_tidy = c()
for(sp in seq_along(spp)) {
  spp_tidy = c(spp_tidy, get_spp(spp[sp]))
}
sort(table(spp_tidy), decreasing = TRUE)
```

```
## spp_tidy
##      Lupinus angustifolius                Glycine max 
##                         92                         86 
##           Arachis ipaensis         Arachis duranensis 
##                         63                         57 
##              Cajanus cajan        Medicago truncatula 
##                         56                         50 
##            Cicer arietinum            Vigna angularis 
##                         43                         43 
## Vigna radiata var. radiata         Phaseolus vulgaris 
##                         41                         30
```
