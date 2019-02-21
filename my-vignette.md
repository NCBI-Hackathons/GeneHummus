### Install the package?
**I am gonna leave this empty because the vignette is available after installing the pckg. So, you are supossed having installed GH to see this. However, I will describe how to install GH from github or CRAN in a new README available from GITHUB.**

  
1. Working with `geneHummus`  
    
  * load the [package](#load-the-package)
  * [Legume](#read-legumes-taxids) family ids 
  * conserved [domains](#retrieve-conserved-domains)
  * [SPARCLE](#obtain-sparcle-architectures) architectures
  * [protein](#collect-protein-ids) ids
    * species table 
    * XP accessions
  
    
2. [Customizing](#customizing-genehummus) `geneHummus`
  
  * Brassicaceae
  * Cucurbitaceae
  * Rosaceae
  * Solanaceae
  
### Load the package

    library(geneHummus)

### Read Legumes taxids

Load the object `ARFLegumes` that contains the vector `legumesIds` with
the legumes taxids. You can download the taxids for your own
family or species from NCBI.

    file = "../geneHummus/data/legumesIds.rda"
    load(file)

### Retrieve conserved domains

Plant gene families are characterized by common protein structure. 
The structure that defines a given family can be found in relevant literature. For example, the three conserved domains that define the ARF gene family are: 
  
  * B3 DNA binding domain
  * Auxin response factor
  * AUX/IAA family
  
NCBI databases host these conserved domains written in this way :  
  
  * B3_DNA
  * Auxin_resp
  * AUX_IAA

You can find this nomenclature or search for your own domains by 
typing in the search box on top of the [Conserved Domain Database](https://www.ncbi.nlm.nih.gov/cdd). That search will give the accession number for each conserved domain. We want to use these accessions as a query. 

    arf <- c("pfam02362", "pfam06507", "pfam02309")


### Obtain SPARCLE architectures

Now, we want to get the SPARCLE architectures. For example, the first
SPARCLE architectures for Pfam02362 are:

    head(getArchids(arf[1]))
    #> [1] "12034188" "12034184" "12034182" "12034166" "12034151" "11279088"

Not all of the architectures link to ARF proteins. But the architecture
ids for the ARF proteins will be definitely among them.

We want to get the SPARCLE architectures for the vector `arf` at once
using the function `getArchids`.

    archids <- getArchids(arf)

We know from the literature that the last domain (AUX/IAA) in the
canonical ARF protein structure may or may not be present. Therefore, at least two
domains have to be present. In other words, we want to filter
the SPARCLE architectures and keep that contain those 2 domains. The
function `getSparcleIds` will do the job:

    my_filter <- c("B3_DNA", "Auxin_resp")
    my_labelsIds <- getSparcleIds(archids, my_filter)

#### Get SPARCLE labels

We can look at SPARCLE labels of the proteins using the `getSparcleLabels` function. Our
proteins will have any of these SPARCLE ids and labels:

    getSparcleLabels(my_labelsIds)
    #> [1] "12034188 protein containing domains B3_DNA, Auxin_resp, Activator_LAG-3, and AUX_IAA"
    #> [1] "12034184 protein containing domains B3_DNA, Auxin_resp, Med15, and PB1"
    #> [1] "12034182 protein containing domains B3_DNA, Auxin_resp, Atrophin-1, and AUX_IAA"
    #> [1] "12034166 protein containing domains B3_DNA, Auxin_resp, PAT1, and AUX_IAA"
    #> [1] "11130507 B3_DNA and Auxin_resp domain-containing protein"
    #> [1] "11130491 protein containing domains B3_DNA, Auxin_resp, and PEARLI-4"
    #> [1] "11130489 B3_DNA and Auxin_resp domain-containing protein"
    #> [1] "10492348 protein containing domains B3_DNA, Auxin_resp, and PB1"
    #> [1] "11279093 protein containing domains B3_DNA, Auxin_resp, and PB1"
    #> [1] "10332700 protein containing domains B3_DNA, Auxin_resp, and AUX_IAA"
    #> [1] "10332698 B3_DNA and Auxin_resp domain-containing protein"

### Collect protein ids

Now we'll get all proteins ids with any of those SPARCLE
architectures. For that, we use the `getProteins` function. Depending on
your dataset this step may take from seconds to 3-5 minutes. To avoid
errors in the HTTP2 framing layer, it is recommended to run the following
code first:

    httr::set_config(httr::config(http_version = 0))

Now, we use the `getProteins` function to retrieve ARF protein ids
in the Legume family:

    my_values = getProteins(my_labelsIds, legumesIds)

At this point we have likely identified the whole set of ARF protein ids
from the Legume family.

    length(my_values)
    #> [1] 685

Let's look at the first ten ARF protein ids:

    my_values[1:10]
    #>  [1] "593705262"  "1379669790" "357520645"  "1150156484" "1150156482"
    #>  [6] "1191713856" "1150090401" "571559330"  "1379613255" "950936264"

Now, we want to get the legume species and the number of proteins per
species.

    spp = extract_spp(my_values)

Let's confirm that we obtained one species per ARF id.

    length(spp) == length(my_values)
    #> [1] TRUE

### Summary table

Now, get the species table by calling the function `spp_table`.

    knitr::kable(spp_table(spp))

<table>
<thead>
<tr class="header">
<th align="left">Species</th>
<th align="right">Seqs</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Arachis duranensis</td>
<td align="right">57</td>
</tr>
<tr class="even">
<td align="left">Arachis hypogaea</td>
<td align="right">120</td>
</tr>
<tr class="odd">
<td align="left">Arachis ipaensis</td>
<td align="right">63</td>
</tr>
<tr class="even">
<td align="left">Cajanus cajan</td>
<td align="right">56</td>
</tr>
<tr class="odd">
<td align="left">Cicer arietinum</td>
<td align="right">43</td>
</tr>
<tr class="even">
<td align="left">Glycine max</td>
<td align="right">87</td>
</tr>
<tr class="odd">
<td align="left">Lupinus angustifolius</td>
<td align="right">92</td>
</tr>
<tr class="even">
<td align="left">Medicago truncatula</td>
<td align="right">52</td>
</tr>
<tr class="odd">
<td align="left">Phaseolus vulgaris</td>
<td align="right">31</td>
</tr>
<tr class="even">
<td align="left">Vigna angularis</td>
<td align="right">43</td>
</tr>
<tr class="odd">
<td align="left">Vigna radiata var. radiata</td>
<td align="right">41</td>
</tr>
</tbody>
</table>

### XP accessions

Finally, we use the function `extract_XP_from_spp` to obtain the poteins 
for each species, the RefSeq XP accessions For example, the XP accessions
for chickpea, medicago and soybean are:

    chickpea = extract_XP_from_spp(my_values, "Cicer")
    medicago = extract_XP_from_spp(my_values, "Medicago")
    soybean = extract_XP_from_spp(my_values, "Glycine")

We have already summarized the data and the protein XP accessions for
each species are contained in the object list `my_legumes`. The XPs are
sorted in the following order:

-   chickpea
-   medicago
-   soybean
-   arachis\_duranensis
-   arachis\_ipaensis
-   cajanus
-   vigna\_angulata
-   vigna\_radiata
-   phaseolus
-   lupinus

For example, the ARF proteins for chickpea are:

    #my_legumes[[1]]
    
## Customizing GeneHummus
`geneHummus` can be customized to be suitable for other agronomically important taxonomic families beyond legumes. For that, we´ll  use the `getProteins` function and pass the corresponding taxonomy filter as an argument. For example, this chunk will get the ARF protein 
ids for the Solanaceae family: 

```{r sol, cache=T}
data("solanaceaeIds")
arf_sol = getProteins(my_labelsIds, familyID = solanaceaeIds)
```
Then, you can get the XP accessions for each species in the same way we did for the legume species. 
```{r cache=TRUE}
head(extract_XP_from_spp(arf_sol, "Solanum tuberosum"))
head(extract_XP_from_spp(arf_sol, "Nicotiana tabacum"))
```

You can download from the NCBI other taxonomy ids and customize your search for your own species. When installing the `genehummus` package, you'll have access to several objects that contain the taxonomy ids for the families:  
  
  * Brassicaceae: `brassicaceaeIds`
  * Cucurbitaceae: `cucurbitaceaeIds`
  * Rosaceae: `rosaceaeIds`
  * Solanaceae: `solanaceaeIds`
  
You can see the ids by calling, for example : 
```{r}
head(geneHummus:::brassicaceaeIds)
```

Using **GeneHummus** with those ids, we have already identified the deduced ARF gene family members based on current genomic resources for the following species:  

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


