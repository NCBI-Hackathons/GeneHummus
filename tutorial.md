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
library(curl)
library(httr)
```

### Load the R functions

```r
source("hummusFunctions.R")
```


### Read Legumes taxids
Load the object `ARFLegumes`. It contains the vector `legumesIds` with the legumes taxids. From NCBI you can download the taxids from your own family or species. 

```r
file = "data/ARFLegumes.RData"
load(file)
```


### Conserved domains

Plant gene families are characterized by common protein structure. 
The structure that defines a given family can be found in literature.   

You can specify the conserved domain accession number as a query. For example, the three conserved domains that define the ARF gene family are: 

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
  
NCBI databases host those domains in this way : 
  * B3_DNA
  * Auxin_resp
  * AUX_IAA


### SPARCLE architectures

Now, we want to get the SPARCLE architectures. For example: the SPARCLE architectures for Pfam02362 are:  
```r
getArchids(arf[1])
```
12034188, 12034184, 12034182, 12034166, 12034151, 11279088, 11279084, 11266712, 11130507, 11130491, 11130489, 11130478, 10975108, 10889850, 10874725, 10803150, 10492348, 10492347, 10178159, 10178158.  
Not all those architectures link to ARF proteins. But the architecture ids for the ARF proteins will be definitely among them. 

The SPARCLE architectures for `arf` at once using the function `getArchids`. 
```r
archids <- getArchids(arf)
```
We know from literature that the last domain (AUX/IAA) in an ARF protein may be/not be present. So, at least two domains have to be present. In other words, we want to get only (=filter) the SPARCLE architectures that contain at least those 2 domains. 
The function `getSparcleArchs` will do the job : 

```r
my_filter <- c("B3_DNA", "Auxin_resp")
my_labelsIds <- getSparcleIds(archids, my_filter)
```

### SPARCLE labels
We can look at their labels using the `getSparcleLabels` function. 
```r
getSparcleLabels(my_labelsIds)
```
All our proteins have any of these SPARCLE ids and labels:  
```
[1] "12034188 protein containing domains B3_DNA, Auxin_resp, Activator_LAG-3, and AUX_IAA"
[1] "12034184 protein containing domains B3_DNA, Auxin_resp, Med15, and PB1"
[1] "12034182 protein containing domains B3_DNA, Auxin_resp, Atrophin-1, and AUX_IAA"
[1] "12034166 protein containing domains B3_DNA, Auxin_resp, PAT1, and AUX_IAA"
[1] "11130507 B3_DNA and Auxin_resp domain-containing protein"
[1] "11130491 protein containing domains B3_DNA, Auxin_resp, and PEARLI-4"
[1] "11130489 B3_DNA and Auxin_resp domain-containing protein"
[1] "10492348 protein containing domains B3_DNA, Auxin_resp, and PB1"
[1] "11279093 protein containing domains B3_DNA, Auxin_resp, and PB1"
[1] "10332700 protein containing domains B3_DNA, Auxin_resp, and AUX_IAA"
[1] "10332698 B3_DNA and Auxin_resp domain-containing protein"
```


### Protein ids 
Now we'll get the whole proteins ids that show any of those SPARCLE architectures. 
For that, we use the `getProteins` function. 

```{r}
my_values = getProteins(my_labelsIds)
```

At this point we have likely identified the whole set of ARF protein ids from the Legume family.  

```r
length(my_values)
```

```
## [1] 564
```
  
---
  
    
Let's look at the first ten ARF protein ids : 
```{r}
my_values[1:10]
```

```{r}
## [1] "593705262"  "1379669790" "357520645"  "1150156484"
## [5] "1150156482" "1012097438" "1012221046" "1021547479"
## [9] "1012097433" "1012221050"
```


Now, we want to get the legume species and the number of proteins per species. 

```{r}
my_values_subset <-  subsetIds(my_values, 300)
spp = extract_spp(my_values_subset)
```

Confirm that a species was obtained from any ARF id.  
```{r}
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
##                         56                         52 
##            Cicer arietinum            Vigna angularis 
##                         45                         43 
## Vigna radiata var. radiata         Phaseolus vulgaris 
##                         41                         31
```

Finally, we use the function `extract_XP_from_spp` to obtain for each species, the RefSeq XP accession for each protein id. For example, the XP accessions for chickpea, medicago and soybean are : 

```
chickpea = extract_XP_from_spp(my_values_subset, "Cicer")
medicago = extract_XP_from_spp(my_values_subset, "Medicago")
soybean = extract_XP_from_spp(my_values_subset, "Glycine")
```

We have summarized the data and the protein XP accessions for each species are contained in the object list `my_legumes`. The XPs are sorted in the following order :   
  * chickpea
  * medicago
  * soybean
  * arachis_duranensis
  * arachis_ipaensis
  * cajanus
  * vigna_angulata
  * vigna_radiata
  * phaseolus
  * lupinus
  
For example, the ARF proteins for chickpea are : 
```{r}
my_legumes[[1]]
```
```
## [1] "XP_012573396" "XP_004503803" "XP_004490828"
## [4] "XP_012568938" "XP_012573395" "XP_004504543"
## [7] "XP_012572776" "XP_004497510" "XP_004508020"
## [10] "XP_012571326" "XP_004504542" "XP_004505104"
## [13] "XP_012569005" "XP_004485845" "XP_012574137"
## [16] "XP_004511136" "XP_004508021" "XP_004485416"
## [19] "XP_004510661" "XP_004508019" "XP_004487099"
## [22] "XP_004508018" "XP_004485417" "XP_004505967"
## [25] "XP_004485979" "XP_004508022" "XP_004506012"
## [28] "XP_012571810" "XP_004488112" "XP_012570270"
## [31] "XP_004510646" "XP_004490754" "XP_012574328"
## [34] "XP_012570274" "XP_004488113" "XP_004510662"
## [37] "XP_012574145" "XP_012567350" "XP_012572936"
## [40] "XP_012570835" "XP_012571327" "XP_004485844"
## [43] "XP_004505103" "XP_004503551" "XP_004503553"
```
