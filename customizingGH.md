---
title: "GeneHummus"
author: "Visiting Bioinformaticians Program"
date: "6/15/2018"
output: 
  html_document: 
    keep_md: yes
---
<br>  
  
GeneHummus can be customized to be suitable for other agronomically important 
taxonomic families beyond legumes. 
For that, we´ll  use the `getProteins` function and pass the corresponding 
taxonomy filter as an argument. For example, this chunk will get the ARF protein 
ids for the Solanaceae family: 

```{r}
my_values_sol = getProteins(my_labelsIds, familyID = solanaceaeIds)
```

Then, you can the XP accessions for each species in the same way we did for the 
legume species. 
```{r}
extract_XP_from_spp(my_values_sol, "Solanum tuberosum")
extract_XP_from_spp(my_values_sol, "Nicotiana tabacum")
```

You can download from the NCBI other tax ids and customize your search for your own species. The `Families.RData` object (in the data folder on this repository) contains already the 
taxonomy ids for the families:  
  
  * **Brassicaceae**
  * **Cucurbitaceae**
  * **Rosaceae**
  * **Solanaceae**
 
Using **GeneHummus** with those ids, we have identified the deduced ARF gene 
family members based on current genomic resources for :  
  
  
| Family | Species | # ARF proteins|
|---------|---------------|---------|
| Brassicaceae | *Brassica napus* | 123 |
| Brassicaceae | *Camelina sativa* | 86 |
| Brassicaceae | *Raphanus sativus* | 52 |
| Brassicaceae | *Brassica oleracea* | 49 |
| Brassicaceae | *Brassica rapa* | 48 |
| Brassicaceae | *Arabidopsis thaliana* | 44 |
| Brassicaceae | *Capsella rubella* | 28 |
| Brassicaceae | *Eutrema salsugineum* | 26 |
| Brassicaceae | *Arabidopsis lyrata* | 24 |
| | | |
| Cucurbitaceae | *Cucurbita maxima* | 71 | 
| Cucurbitaceae | *Cucurbita pepo* | 71 | 
| Cucurbitaceae | *Cucurbita moschata* | 67 | 
| Cucurbitaceae | *Cucumis sativus* | 27 | 
| Cucurbitaceae | *Momordica charantia* | 26 | 
| Cucurbitaceae | *Cucumis melo* | 24 | 
| | | |
| Rosaceae | *Pyrus x bretschneideri* | 51 | 
| Rosaceae | *Malus domestica* | 48 | 
| Rosaceae | *Prunus avium* | 33 | 
| Rosaceae | *Rosa chinensis* | 28 | 
| Rosaceae | *Prunus persica* | 27 | 
| Rosaceae | *Prunus mume* | 25 | 
| Rosaceae | *Fragaria vesca* | 23 | 
| | | |
| Solanaceae | *Nicotiana tabacum* | 103 | 
| Solanaceae | *Nicotiana tomentosiformis* | 73 | 
| Solanaceae | *Nicotiana sylvestris* | 56 | 
| Solanaceae | *Nicotiana attenuata* | 49 | 
| Solanaceae | *Capsicum annuum* | 46 | 
| Solanaceae | *Solanum tuberosum* | 43 | 
| Solanaceae | *Solanum lycopersicum* | 39 | 
| Solanaceae | *Solanum pennellii* | 34 | 
| | | |

