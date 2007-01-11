# Schema for internal-external database mappings (xrefs)


################################################################################
#
# General external annotation.

CREATE TABLE xref (

  xref_id                     int unsigned not null auto_increment,
  accession                   varchar(255) not null,
  version                     int unsigned,
  label                       varchar(255),
  description                 varchar(255),
  source_id                   int unsigned not null,
  species_id                  int unsigned not null,

  PRIMARY KEY (xref_id),
  UNIQUE acession_idx(accession,source_id,species_id)

);

################################################################################

CREATE TABLE primary_xref (

  xref_id                     int unsigned not null,
  sequence                    mediumtext,
  sequence_type               enum('dna','peptide'),
  status                      enum('experimental','predicted'),

  PRIMARY KEY (xref_id)

);

################################################################################

CREATE TABLE dependent_xref (

  master_xref_id              int unsigned not null,
  dependent_xref_id           int unsigned not null,
  linkage_annotation          varchar(255),
  linkage_source_id           int unsigned not null,

  KEY master_idx(master_xref_id),
  KEY dependent_idx(dependent_xref_id)

);

################################################################################

CREATE TABLE synonym (

  xref_id                     int unsigned not null,
  synonym                     varchar(255),

  KEY xref_idx(xref_id),
  KEY synonym_idx(synonym)

);

################################################################################

CREATE TABLE source (

  source_id                   int unsigned not null auto_increment,
  name                        varchar(255) not null,
  source_release                     varchar(255),
  download                    enum('Y', 'N') default 'Y',
  ordered                     int unsigned not null, 
  priority                    int unsigned default 1,
  priority_description        varchar(40) default "",
   
  PRIMARY KEY (source_id),
  KEY name_idx(name) 

);

################################################################################

CREATE TABLE source_url (

  source_url_id               int unsigned not null auto_increment,
  source_id                   int unsigned not null,
  species_id                  int unsigned not null,
  url                         mediumtext,
  checksum                    varchar(255),
  file_modified_date          datetime,
  upload_date                 datetime,
  parser                      varchar(255),

  PRIMARY KEY (source_url_id),
  KEY source_idx(source_id)

);

################################################################################

CREATE TABLE direct_xref (

  general_xref_id             int unsigned not null,
  ensembl_stable_id           varchar(255),
  type                        enum('gene','transcript','translation'),
  linkage_xref                varchar(255),

  KEY primary_idx(general_xref_id),
  KEY ensembl_idx(ensembl_stable_id)

);

################################################################################

CREATE TABLE species (

  species_id                  int unsigned not null,
  taxonomy_id                 int unsigned not null,
  name                        varchar(255) not null,
  aliases                     varchar(255),

  KEY species_idx (species_id),
  KEY taxonomy_idx(taxonomy_id),
  KEY name_idx(name)

);

################################################################################

CREATE TABLE interpro (

  interpro               varchar(255) not null,
  pfam                   varchar(255) not null

);

################################################################################

CREATE TABLE pairs (

  source_id			 int unsigned not null,
  accession1                     varchar(255) not null,
  accession2                     varchar(255) not null

);
################################################################################
