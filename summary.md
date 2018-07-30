# GeneHummus

An Automated Pipeline to Study **Plant Gene Families based on Protein Domain Organization** using Auxin Response Factors in **chickpea** and other Legumes as an Example.

 - [Workflow](#workflow)
 - [CDART](#conserved-domain-architecture)
 - [Phylogeny](#phylogeny)
 - [Expression](https://github.com/NCBI-Hackathons/SimpleGeneExpression)


<br>

## Workflow

![](figures/workflow.png)


## Conserved Domain Architecture  

In total, we have identified **350 Auxin Response Factor protein** sequences across **10 different Legume species**. 

| Species  | # ARF |
|---------|----------------|
| *Glycine max* | 61     |
| *Lupinus angustifolius* | 49 |
| *Arachis ipaensis* | 41
| *Arachis duranensis* | 39
| *Cajanus cajan* |  33
| *Vigna angularis* | 30
| *Vigna radiata* | 29
| ***Cicer arietinum*** | **24**
| *Medicago truncatula* | 23 
| *Phaseolus vulgaris* | 21


Question  
* What does this information tell us about the expansion of the ARF in Legumes? -in terms of gene duplications (early/ancestral)-  


## Phylogeny  
* We have 3 main clusters, being cluster II and III more close-related. 
* Each cluster is made of a number of subclases or subgroups.   
* Vast majority of subclases are multi-species

![](figures/treeARF.png)

A **subclass in cluster II is made only** of proteins from the genus ***Arachis*** with no homology to any other genera. This subclass is well-supported by bootstrap values. 

![](figures/arachisTree.png)


Questions  
* How many sister pairs are between two different species?   
* How many sister pairs are between the same species?   
* Proteins belonging the same group within a species, do they locate on the same chromosome?  

### Data Interpretation: 
The vast majority of ARF legume proteins were present in the last common ancestor before the species diverged from each other.     
  
Should we expect the **same evolutionary history with other gene family**? For example, resistance-like genes? Shouldn't we expect more species-specific clades meaning the certains challenges that each species has met during its evolutionary development?
