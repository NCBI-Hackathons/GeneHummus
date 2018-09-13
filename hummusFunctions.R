
getArchids <- function(gene_family) {
  
  # gene_family, a vector with conserved domains defining a given gene family 
  cd <- vector(mode = "character")
  
  for(i in seq_along(gene_family)) {
    cd <- c(cd, getSparcleArchs(arf[i]))
  }
  
  unique(cd)
}


getSparcleArchs <- function(CD){
  
  # CD, string with the conserved domain
  id = entrez_search(db = "cdd", term = paste0(CD,"[ALL]"))
  cd = entrez_summary(db = "cdd", id = id$ids)
  sparcle = entrez_link(dbfrom = "cdd", db = "sparcle", id = cd$uid)
  sparcle$links$cdd_sparcle
  
  }



getSparcleLabels <- function(my_ids, CD, gene_family) {
  ## CD, string with the conserved domain (used as filter)
  ## sanitty check: some sparcle ids do not give esummary. ex: "12217856"
  
  my_labelsIds <- vector(mode = "character")
  
  for(id in my_ids) {
    sid = entrez_summary(db = "sparcle", id = id)
    
    # only if there is esummary: 
    if(length(sid) > 2) {
      
      # check label contains required CDs
      if(sum(str_count(sid$displabel, required)) == 2) {
        #print(paste(id, sid$displabel))
        my_labelsIds <- c(my_labelsIds, id)
      }
      
      
    }
    
  }
  my_labelsIds
}



getProtlinks <- function(sparcleArch) {
  spar_to_prot = entrez_link(dbfrom = "sparcle", db = "protein", id = sparcleArch)
  prot_links = spar_to_prot$links$sparcle_protein
  prot_links
}


extract_proteins <- function(targets, taxonIds) {
  
  # Initializes vector with the solution
  vals = c()
  
  ## A. Get taxids with protein ids in RefSeq
  #1 For each id : esummary
  prot_summ = entrez_summary(db = "protein", id = targets)
  
  #2 Extract from esummary: 'sourcedb' and 'taxid'
  prot_db = extract_from_esummary(prot_summ, c("sourcedb", "taxid"))
  
  #3 Build df 
  prot_db = data.frame(matrix(unlist(prot_db), nrow = length(prot_db)/2, byrow = T), 
                       row.names = colnames(prot_db), stringsAsFactors = F) #/2 bc 2 columns: sourcedb-taxid
  
  #4 New df: Filter by RefSeq db. Section C extract ids from this table
  #df2_refseq = prot_db %>% filter(X1 == "refseq")
  df2_refseq <- prot_db[prot_db$X1 == "refseq",]
  
  #5 Pull taxids
  taxids_refseq = unique(as.numeric(df2_refseq %>% pull()))
  
  ## B. Get taxids only from Legume family 
  # If Legume: 
  if(sum(taxids_refseq %in% taxonIds) != 0) {
    idx = which(taxids_refseq %in% taxonIds) 
    taxids_refseq[idx] # Legume taxid with refseq protein
    

    # C. If Legume, extract fromm df some stuff
    ## df2_refseq %>% filter(X2 %in% taxids_refseq[idx])
    ## base R
    vals = c(vals, rownames(df2_refseq[df2_refseq$X2 %in% taxids_refseq[idx],]))
    
  }
  
  vals
  
}



subsetIds <- function(x, sizeIds) {
  #''' x, a vector of one or more elements
  #sizeIds, a positive number, the number of items to choose from '''
  
  # initializes an empty list
  vals = list()
  
  foo = sample(x, size = sizeIds, replace = FALSE)        # 1st sample
  vals[[1]] = foo                                         # add 1st element to the list
  
  #update vector x
  x = x[! x %in% foo]
  
  i = 2
  
  while(length(x) >= sizeIds) {
    
    foo = sample(x, size = sizeIds, replace = FALSE)     # n sample
    vals[[i]] = foo                                      # add n-th element to the list
    
    #update vector x
    x = x[! x %in% foo]
    
    i = i+1
    
  }
  
  # remaining elements :
  if(length(x) > 0) {
    foo = sample(x, size = length(x), replace = FALSE)    # last sample
    vals[[i]] = foo                                       # add last element to the list
    
  }
  
  vals
  
}



extract_proteins_from_subset <- function(targets, taxonIds, values) {
  
  for(i in seq_along(targets)) {
    values = c(values, extract_proteins(targets[[i]], taxonIds))
    
  }
  values
  
}


extract_spp_from_subset <- function(targets) {
  
  spp = c()
  
  for(i in seq_along(targets)) {
    
    
    upload <- entrez_post(db="protein", id=targets[[i]]) #create a web_history object 
    prot_summ = entrez_summary(db="protein", web_history=upload)
    prot_title = as.character((extract_from_esummary(prot_summ, c("title"))))
    spp = c(spp, prot_title)
  }
  
  spp
  
}


extract_XP_from_spp <- function(targets, spp) {
  
  # ''' targets, vector/list object with protein ids 
  # ''' spp, spp target to extract its XP ids
  
  prot_test = c()
  
  for(i in seq_along(targets)) {
    upload <- entrez_post(db="protein", id=targets[[i]]) #create a web_history object
    prot_summ = entrez_summary(db="protein", web_history=upload)
    prot_test = c(prot_test, as.character((extract_from_esummary(prot_summ, c("caption","title")))))
    
  }
  
  prot_test_df = data.frame(matrix(unlist(prot_test), nrow = length(prot_test)/2, byrow = T), 
                            stringsAsFactors = F) # /2 bc we have 2 columns: caption,title
  
  idx = which(str_detect(prot_test_df$X2, spp))
  xp = prot_test_df[idx,1]
  
  xp
  
}

## Usage
#targets <- "1012032540" "1117497421" "1012113555"
#extract_XP_from_spp(targets, "Cicer arietinum")



get_spp <- function(description) {
  
  # extract the scientific name from a sequence description 
  # example: "PREDICTED: auxin response factor 19-like isoform X1 [Glycine max]"
  
  spp <- str_sub(description, 
                 start = str_locate(description, "\\[")[1]+1,
                 end = str_locate(description, "\\]")[2]-1)
  spp
}
