
getSparcleArchs <- function(CD){
  
  # CD, string with the conserved domain
  id = entrez_search(db = "cdd", term = paste0(CD,"[ALL]"))
  cd = entrez_summary(db = "cdd", id = id$ids)
  sparcle = entrez_link(dbfrom = "cdd", db = "sparcle", id = cd$uid)
  sparcle$links$cdd_sparcle
  
  }



getSparcleLabels <- function(my_sparcleIds, CD) {
  # # CD, string with the conserved domain (used as filter)
  
  for(id in my_sparcleIds) {
    sid = entrez_summary(db = "sparcle", id = id)
    if(str_detect(string = sid$displabel, pattern = CD)) {
      print(paste(id, sid$displabel))  
      }
    
    }
  }


getSparcleLabels2 <- function(my_sparcleIds, CD) {
  # # CD, string with the conserved domain (used as filter)
  ## sanitty check: some sparcle ids do not give esummary. ex: "12217856"
  
  for(id in my_sparcleIds) {
    sid = entrez_summary(db = "sparcle", id = id)
    # only if there is esummary: 
    if(length(sid) > 2) {
      if(str_detect(string = sid$displabel, pattern = CD)) {
        print(paste(id, sid$displabel))  
      }
      
    }
    
  }
}


getProtlinks <- function(sparcleArch) {
  spar_to_prot = entrez_link(dbfrom = "sparcle", db = "protein", id = sparcleArch)
  prot_links = spar_to_prot$links$sparcle_protein
  prot_links
}


extract_proteins <- function(targets, taxonIds) {
  
  # Initializes vector with the solution
  ben = c()
  
  # A. Get taxids with protein ids in RefSeq
  #1 Esummary for each id
  prot_summ = entrez_summary(db = "protein", id = targets)
  
  #2 Extract from esummary 'sourcedb' and 'taxid'
  prot_db = extract_from_esummary(prot_summ, c("sourcedb", "taxid"))
  
  #3 Build df 
  # no puedo convertir directamente desde lista a df 
  # truco es unlist
  # https://stackoverflow.com/questions/4227223/r-list-to-data-frame
  prot_db = data.frame(matrix(unlist(prot_db), nrow = length(prot_db)/2, byrow = T), 
                       row.names = colnames(prot_db), stringsAsFactors = F) #/2 bc it??s 2 columns: sourcedb-taxid
  
  #4 New df: Filter by RefSeq db : volvere a este df para extraer todas las prots de legumes
  ## no puedo usar dplyr porq no saca rownmanes (donde tengo el id protein)
  #df2_refseq = prot_db %>% filter(X1 == "refseq")
  df2_refseq <- prot_db[prot_db$X1 == "refseq",]
  
  #5 Pull taxids
  taxids_refseq = unique(as.numeric(df2_refseq %>% pull()))
  
  # B. Get taxids only from Legume family 
  ## Si hay Leguminosa: 
  if(sum(taxids_refseq %in% taxonIds) != 0) {
    idx = which(taxids_refseq %in% taxonIds) 
    taxids_refseq[idx] # taxid from a Legume spp with refseq protein(s)
    
    ## ====================================
    ## only for checking purposes : confirm that spp is Legume
    ## creo web_history por si hay > tax id 
    #upload <- entrez_post(db = "taxonomy", id=taxids_refseq[idx]) # create a weh_history object 
    
    #tax_summ = entrez_summary(db = "taxonomy", web_history = upload)
    #extract_from_esummary(tax_summ, c("scientificname")) 
    
    
    # C. De los que sean leguminosas he de volver a la tabla para sacar todas esas proteinas. 
    # ver untitled 2
    ## no puedo usar dplyr porq no saca rownmanes (donde tengo el id protein)
    ## df2_refseq %>% filter(X2 %in% taxids_refseq[idx])
    ## base R
    ben = c(ben, rownames(df2_refseq[df2_refseq$X2 %in% taxids_refseq[idx],]))
    
  }
  
  ben
  
}

subsetIds <- function(x, sizeIds) {
  #''' x, a vector of one or more elements
  #sizeIds, a positive number, the number of items to choose from '''
  
  
  # initializes an empty list
  jose = list()
  
  faa = sample(x, size = sizeIds, replace = FALSE)        # 1st sample
  jose[[1]] = faa                                         # add 1st element to the list
  
  #update vector x
  x = x[! x %in% faa]
  
  i = 2
  
  while(length(x) >= sizeIds) {
    
    faa = sample(x, size = sizeIds, replace = FALSE)     # n sample
    jose[[i]] = faa                                      # add n-th element to the list
    
    #update vector x
    x = x[! x %in% faa]
    
    i = i+1
    
  }
  
  # ultimos elementos sobrantes:
  if(length(x) > 0) {
    faa = sample(x, size = length(x), replace = FALSE)  # last sample
    jose[[i]] = faa                                       # add last element to the list
    
  }
  
  jose
  
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
    prot_summ = entrez_summary(db="proteins", web_history=upload)
    prot_title = as.character((extract_from_esummary(prot_summ, c("title"))))
    spp = c(spp, prot_title)
  }
  
  spp
  
}


extract_XP_from_spp <- function(targets, spp) {
  
  # ''' targets, vector with protein ids 
  # ''' spp, spp target to extract its XP ids
  
  prot_test = c()
  
  for(i in seq_along(targets)) {
    upload <- entrez_post(db="protein", id=targets[[i]]) #create a web_history object
    prot_summ = entrez_summary(db="proteins", web_history=upload)
    prot_test = c(prot_test, as.character((extract_from_esummary(prot_summ, c("caption","title")))))
    
  }
  
  prot_test_df = data.frame(matrix(unlist(prot_test), nrow = length(prot_test)/2, byrow = T), 
                            stringsAsFactors = F) # /2 bc we have 2 columns: caption,title
  
  idx = which(str_detect(prot_test_df$X2, spp))
  xp = prot_test_df[idx,1]
  
  xp
  
}




get_spp <- function(description) {
  
  # extract the scientific name from a sequence description 
  # example: "PREDICTED: auxin response factor 19-like isoform X1 [Glycine max]"
  
  spp <- str_sub(description, 
                 start = str_locate(description, "\\[")[1]+1,
                 end = str_locate(description, "\\]")[2]-1)
  spp
}
