Content
-------

1.  Working with `geneHummus`

-   load the [package](#load-the-package)
-   [Legume](#read-legumes-taxids) family ids
-   conserved [domains](#retrieve-conserved-domains)
-   [SPARCLE](#obtain-sparcle-architectures) architectures
-   [protein](#collect-protein-ids) ids
    -   species table
    -   XP accessions

1.  [Customizing](#customizing-genehummus) `geneHummus`

-   Brassicaceae
-   Cucurbitaceae
-   Rosaceae
-   Solanaceae

**geneHummus**
--------------

### Load the package

    library(geneHummus)

### Read Legumes taxids

Load the object `legumesIds` that contains the legumes taxonomy
identifiers. You can easily download the taxids for your own family or
species from the NCBI.

    data("legumesIds")

### Define conserved domains

Plant gene families are characterized by common protein structures. The
structure that defines a given family can be found in relevant
literature. For example, the three conserved domains that define the ARF
gene family are:

-   B3 DNA binding domain
-   Auxin response factor
-   AUX/IAA family

NCBI databases host these conserved domains written in this way :

-   B3\_DNA
-   Auxin\_resp
-   AUX\_IAA

You can find this nomenclature or search for your own domains by typing
in the search box on top of the [Conserved Domain
Database](https://www.ncbi.nlm.nih.gov/cdd) (NCBI). That search will
give the accession number for each conserved domain.

    arf <- c("pfam02362", "pfam06507", "pfam02309")

### Obtain SPARCLE architectures

Now, we want to get the protein architectures. The conserved domain
architectures are retrieved from the SPARCLE database (NCBI), a resource
for the functional characterization and labeling of protein sequences.
For example: the first SPARCLE architectures for "pfam02362" are:

    head(getArch_ids(arf[1]), n=10)
    #>  [1] "13674487" "13674483" "13674476" "13674465" "13674455" "13674450"
    #>  [7] "13674431" "12034184" "11279088" "11279084"

Not all of the architectures link to ARF proteins. But the architecture
ids for the ARF proteins will be definitely among them. We want to get
the SPARCLE architectures for the vector `arf` at once using the
function `getArchids`.

    archids <- getArch_ids(arf)

We know from relevant literature that the last domain (AUX/IAA) in the
canonical ARF protein structure may or may not be present. Therefore, at
least two domains have to be present. In other words, we want to filter
the SPARCLE architectures that contain, at least, those 2 domains (in
that sequential order!). The function `filterArch_ids` will do the job :

    my_filter <- c("B3_DNA", "Auxin_resp")
    filtered_archids <- filterArch_ids(archids, my_filter)

#### Get SPARCLE labels

We can look at the labels of the architectures using the
`getArch_labels` function. Our proteins will have any of these SPARCLE
ids and labels:

    getArch_labels(filtered_archids)
    #> [1] "13674487 protein containing domains B3_DNA, Auxin_resp, and AUX_IAA"
    #> [1] "13674483 protein containing domains B3_DNA, Auxin_resp, Pox_F17, and AUX_IAA"
    #> [1] "13674476 protein containing domains B3_DNA, Auxin_resp, and AUX_IAA"
    #> [1] "13674465 protein containing domains B3_DNA, Auxin_resp, and AUX_IAA"
    #> [1] "13674455 protein containing domains B3_DNA, Auxin_resp, and AUX_IAA"
    #> [1] "13674450 protein containing domains B3_DNA, Auxin_resp, Activator_LAG-3, and AUX_IAA"
    #> [1] "12034184 protein containing domains B3_DNA, Auxin_resp, Med15, and PB1"
    #> [1] "11130507 B3_DNA and Auxin_resp domain-containing protein"
    #> [1] "11130491 protein containing domains B3_DNA, Auxin_resp, and PEARLI-4"
    #> [1] "11130490 protein containing domains B3_DNA, Auxin_resp, and AUX_IAA"
    #> [1] "11130489 B3_DNA and Auxin_resp domain-containing protein"
    #> [1] "10492348 protein containing domains B3_DNA, Auxin_resp, and PB1"
    #> [1] "11279093 protein containing domains B3_DNA, Auxin_resp, and PB1"
    #> [1] "11279092 B3_DNA and Auxin_resp domain-containing protein"
    #> [1] "10332700 protein containing domains B3_DNA, Auxin_resp, and AUX_IAA"
    #> [1] "10332698 B3_DNA and Auxin_resp domain-containing protein"

### Collect protein ids

Now we'll get all proteins identifiers with any of those architectures.
For that, we use the `getProteins_from_tax_ids` function. Depending on
your dataset this step may take from seconds to 3-5 minutes. The
taxonomy family is given as second argument to the function:

    arf_legumes = getProteins_from_tax_ids(filtered_archids, legumesIds)

In the exceptional case, the function call causes an error in the HTTP2
framing layer, it is recommended to call again the
`getProteins_from_tax_ids` function after running the following code
first:

    httr::set_config(httr::config(http_version = 0))

At this point we have likely identified the whole set of ARF protein ids
for the Legume family. Let's look at the first ten ARF protein ids:

    arf_legumes[1:10]
    #>  [1] "1150156484" "1150156482" "950933327"  "593705262"  "1379669790"
    #>  [6] "357520645"  "1021547483" "1431757174" "1150137558" "593188509"

Collect protein accessions
--------------------------

Finally we will get the protein accessions (usually referred as "XP" ids
in the RefSeq database). We want to use here the `getAccessions`
function.

    arf_accs = getAccessions(arf_legumes)

This is our final results. The object is a data frame with two columns
(`accession`, and `organism`). Let's look at the first elements of the
object.

    head(arf_accs)
    #>      accession                   organism
    #> 1 XP_025621726           Arachis hypogaea
    #> 2 XP_014518560 Vigna radiata var. radiata
    #> 3 XP_006592682                Glycine max
    #> 4 XP_025665252           Arachis hypogaea
    #> 5 XP_003600594        Medicago truncatula
    #> 6 XP_003616115        Medicago truncatula

#### Number of proteins per species

At this point, we can go over the results with two different approaches.
The first one generates a summary of total number of proteins per species 
by using the function `accessions_by_spp`.

    knitr::kable(accessions_by_spp(arf_accs))

<table>
<thead>
<tr class="header">
<th align="left">organism</th>
<th align="right">N.seqs</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Abrus precatorius</td>
<td align="right">94</td>
</tr>
<tr class="even">
<td align="left">Arachis duranensis</td>
<td align="right">57</td>
</tr>
<tr class="odd">
<td align="left">Arachis hypogaea</td>
<td align="right">120</td>
</tr>
<tr class="even">
<td align="left">Arachis ipaensis</td>
<td align="right">63</td>
</tr>
<tr class="odd">
<td align="left">Cajanus cajan</td>
<td align="right">56</td>
</tr>
<tr class="even">
<td align="left">Cicer arietinum</td>
<td align="right">52</td>
</tr>
<tr class="odd">
<td align="left">Glycine max</td>
<td align="right">87</td>
</tr>
<tr class="even">
<td align="left">Lupinus angustifolius</td>
<td align="right">92</td>
</tr>
<tr class="odd">
<td align="left">Medicago truncatula</td>
<td align="right">52</td>
</tr>
<tr class="even">
<td align="left">Phaseolus vulgaris</td>
<td align="right">31</td>
</tr>
<tr class="odd">
<td align="left">Vigna angularis</td>
<td align="right">43</td>
</tr>
<tr class="even">
<td align="left">Vigna radiata var. radiata</td>
<td align="right">42</td>
</tr>
</tbody>
</table>

#### Proteins for a given species

The second approach uses the function `accessions_from_spp` to obtain
the proteins for a given species. For example, the XP accessions for
Medicago are :

    medicago = accessions_from_spp(arf_accs, "Medicago truncatula")

Look at the first elements of the object `medicago` :

    head(medicago, n = 10)
    #>  [1] "XP_003600594" "XP_003616115" "XP_013445290" "XP_024638199"
    #>  [5] "XP_024640656" "XP_013448901" "XP_003614872" "XP_003593664"
    #>  [9] "XP_003593869" "XP_024638577"

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

    data("my_legumes")
    my_legumes[[1]]
    #>  [1] "XP_012573396" "XP_004503803" "XP_004490828" "XP_012568938"
    #>  [5] "XP_012573395" "XP_004504543" "XP_012572776" "XP_004497510"
    #>  [9] "XP_004508020" "XP_012571326" "XP_004504542" "XP_004505104"
    #> [13] "XP_012569005" "XP_004485845" "XP_012574137" "XP_004511136"
    #> [17] "XP_004508021" "XP_004485416" "XP_004510661" "XP_004508019"
    #> [21] "XP_004487099" "XP_004508018" "XP_004485417" "XP_004505967"
    #> [25] "XP_004485979" "XP_004508022" "XP_004506012" "XP_012571810"
    #> [29] "XP_004488112" "XP_012570270" "XP_004510646" "XP_004490754"
    #> [33] "XP_012574328" "XP_012570274" "XP_004488113" "XP_004510662"
    #> [37] "XP_012574145" "XP_012567350" "XP_012572936" "XP_012570835"
    #> [41] "XP_012571327" "XP_004485844" "XP_004505103" "XP_004503551"
    #> [45] "XP_004503553"
  
<br> 
    
Customizing GeneHummus
----------------------

`geneHummus` can be customized to be suitable for other agronomically
important taxonomic families beyond legumes. For that, we´ll use the
same functions as we did earlier and pass the corresponding taxonomic
filter as argument. You can download from the NCBI other taxonomy ids
and customize your search for your own species. When installing the
`genehummus` package, you'll have access to several objects that contain
the taxonomy ids for the families:

-   Brassicaceae: `brassicaceaeIds`
-   Cucurbitaceae: `cucurbitaceaeIds`
-   Rosaceae: `rosaceaeIds`
-   Solanaceae: `solanaceaeIds`

You can see the ids by calling, for example :

    head(geneHummus:::brassicaceaeIds)
    #> [1] "2358338" "2340982" "2340889" "2340888" "2340887" "2340886"

For example, this chunk will get the ARF protein ids for the Solanaceae
family:

    solids = geneHummus:::solanaceaeIds
    arf_sol = getProteins_from_tax_ids(filtered_archids, solids)

Then, we can get the the XP accessions for each species in the same way
we did for the legume species.

    sol_accs = getAccessions(arf_sol)
    head(accessions_from_spp(sol_accs, "Solanum tuberosum"))
    #> [1] "XP_006349280" "XP_006350452" "XP_015170637" "XP_006339723"
    #> [5] "XP_006343312" "XP_006357892"
    head(accessions_from_spp(sol_accs, "Nicotiana tabacum"))
    #> [1] "XP_016445203" "XP_016513811" "XP_016510734" "XP_016435534"
    #> [5] "XP_016487494" "XP_016441644"

Using `geneHummus` with the identifiers for the default taxonomy
families, we have already identified the deduced ARF gene family members
based on current genomic resources for the following species:

<table>
<thead>
<tr class="header">
<th>Family</th>
<th>Species</th>
<th># ARF proteins</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Brassicaceae</td>
<td><em>Brassica napus</em></td>
<td>123</td>
</tr>
<tr class="even">
<td>Brassicaceae</td>
<td><em>Camelina sativa</em></td>
<td>86</td>
</tr>
<tr class="odd">
<td>Brassicaceae</td>
<td><em>Raphanus sativus</em></td>
<td>52</td>
</tr>
<tr class="even">
<td>Brassicaceae</td>
<td><em>Brassica oleracea</em></td>
<td>49</td>
</tr>
<tr class="odd">
<td>Brassicaceae</td>
<td><em>Brassica rapa</em></td>
<td>48</td>
</tr>
<tr class="even">
<td>Brassicaceae</td>
<td><em>Arabidopsis thaliana</em></td>
<td>44</td>
</tr>
<tr class="odd">
<td>Brassicaceae</td>
<td><em>Capsella rubella</em></td>
<td>28</td>
</tr>
<tr class="even">
<td>Brassicaceae</td>
<td><em>Eutrema salsugineum</em></td>
<td>26</td>
</tr>
<tr class="odd">
<td>Brassicaceae</td>
<td><em>Arabidopsis lyrata</em></td>
<td>24</td>
</tr>
<tr class="even">
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td>Cucurbitaceae</td>
<td><em>Cucurbita maxima</em></td>
<td>71</td>
</tr>
<tr class="even">
<td>Cucurbitaceae</td>
<td><em>Cucurbita pepo</em></td>
<td>71</td>
</tr>
<tr class="odd">
<td>Cucurbitaceae</td>
<td><em>Cucurbita moschata</em></td>
<td>67</td>
</tr>
<tr class="even">
<td>Cucurbitaceae</td>
<td><em>Cucumis sativus</em></td>
<td>27</td>
</tr>
<tr class="odd">
<td>Cucurbitaceae</td>
<td><em>Momordica charantia</em></td>
<td>26</td>
</tr>
<tr class="even">
<td>Cucurbitaceae</td>
<td><em>Cucumis melo</em></td>
<td>24</td>
</tr>
<tr class="odd">
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td>Rosaceae</td>
<td><em>Pyrus x bretschneideri</em></td>
<td>51</td>
</tr>
<tr class="odd">
<td>Rosaceae</td>
<td><em>Malus domestica</em></td>
<td>48</td>
</tr>
<tr class="even">
<td>Rosaceae</td>
<td><em>Prunus avium</em></td>
<td>33</td>
</tr>
<tr class="odd">
<td>Rosaceae</td>
<td><em>Rosa chinensis</em></td>
<td>28</td>
</tr>
<tr class="even">
<td>Rosaceae</td>
<td><em>Prunus persica</em></td>
<td>27</td>
</tr>
<tr class="odd">
<td>Rosaceae</td>
<td><em>Prunus mume</em></td>
<td>25</td>
</tr>
<tr class="even">
<td>Rosaceae</td>
<td><em>Fragaria vesca</em></td>
<td>23</td>
</tr>
<tr class="odd">
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td>Solanaceae</td>
<td><em>Nicotiana tabacum</em></td>
<td>103</td>
</tr>
<tr class="odd">
<td>Solanaceae</td>
<td><em>Nicotiana tomentosiformis</em></td>
<td>73</td>
</tr>
<tr class="even">
<td>Solanaceae</td>
<td><em>Nicotiana sylvestris</em></td>
<td>56</td>
</tr>
<tr class="odd">
<td>Solanaceae</td>
<td><em>Nicotiana attenuata</em></td>
<td>49</td>
</tr>
<tr class="even">
<td>Solanaceae</td>
<td><em>Capsicum annuum</em></td>
<td>46</td>
</tr>
<tr class="odd">
<td>Solanaceae</td>
<td><em>Solanum tuberosum</em></td>
<td>43</td>
</tr>
<tr class="even">
<td>Solanaceae</td>
<td><em>Solanum lycopersicum</em></td>
<td>39</td>
</tr>
<tr class="odd">
<td>Solanaceae</td>
<td><em>Solanum pennellii</em></td>
<td>34</td>
</tr>
<tr class="even">
<td></td>
<td></td>
<td></td>
</tr>
</tbody>
</table>

If you run into problem using `geneHummus` , or just need help with the
package, you can contact us by opening an issue at the
[github](https://github.com/NCBI-Hackathons/GeneHummus/issues)
repository.
