### Load the package

    library(geneHummus)

### Read Legumes taxids

Load the object `ARFLegumes`. It contains the vector `legumesIds` with
the legumes taxids. From NCBI you can download the taxids for your own
family or species.

    file = "../geneHummus/data/legumesIds.rda"
    load(file)

### Conserved domains

Plant gene families are characterized by common protein structure. The
structure that defines a given family can be found in literature.

You can specify the conserved domain accession number as a query (Where do you get info from?). For
example, the three conserved domains that define the ARF gene family
are:

    arf <- c("pfam02362", "pfam06507", "pfam02309")

Those three accessions correspond to the following ARF conserved domains:

-   B3 DNA binding domain
-   Auxin response factor
-   AUX/IAA family

NCBI databases host the conserved domains as written in this way:

-   B3\_DNA
-   Auxin\_resp
-   AUX\_IAA

### SPARCLE architectures

Now, we want to get the SPARCLE architectures. For example: the first
SPARCLE architectures for Pfam02362 are:

    head(getArchids(arf[1]))
    #> [1] "12034188" "12034184" "12034182" "12034166" "12034151" "11279088"

Not all of the architectures link to ARF proteins. But the architecture
ids for the ARF proteins will be definitely between them.

We want to get the SPARCLE architectures for the vector `arf` at once
using the function `getArchids`.

    archids <- getArchids(arf)

We know from the literature that the last domain (AUX/IAA) in the
canonical ARF protein structure may be/not be present. So, at least two
domains have to be present. In other words, we want to get only (filter)
the SPARCLE architectures that contain at least those 2 domains. The
function `getSparcleIds` will do the job :

    my_filter <- c("B3_DNA", "Auxin_resp")
    my_labelsIds <- getSparcleIds(archids, my_filter)

#### SPARCLE labels

We can look at their labels using the `getSparcleLabels` function. Our
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

### Protein ids

Now we'll get the whole proteins ids with any of those SPARCLE
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
