version 1.0

import "tasks/ncov_ingest.wdl" as ncov_ingest
#import "tasks/nextstrain.wdl" as nextstrain

workflow Nextstrain_WRKFLW {
  input {
    # ncov ingest
    String GISAID_API_ENDPOINT
    String GISAID_USERNAME_AND_PASSWORD
##    File? cache_nextclade_old

#    String pathogen_giturl = "https://github.com/nextstrain/ncov/archive/refs/heads/master.zip"
#    String docker_path = "nextstrain/base:latest"
    Int? cpu
    Int? memory       # in GiB
    Int? disk_size
  }

  call ncov_ingest.fetch_main_ndjson as fetch_main_ndjson {
    input:
      GISAID_API_ENDPOINT = GISAID_API_ENDPOINT,
      GISAID_USERNAME_AND_PASSWORD = GISAID_USERNAME_AND_PASSWORD,
#      # caches
#      cache_nextclade_old = cache_nextclade_old,
#
       cpu = cpu,
       memory = memory,
       disk_size = disk_size
  }
  
  call ncov_ingest.transform_gisaid_data as transform_gisaid_data {
    input:
      gisaid_ndjson=fetch_main_ndjson.gisaid_ndjson,
      cpu = cpu,
      memory = memory,
      disk_size = disk_size
  }

  output {
    # ncov-ingest output - only gisaid
    File gisaid_ndjson = fetch_main_ndjson.gisaid_ndjson
    File sequences_fasta = transform_gisaid_data.sequences_fasta
    File metadata_tsv=transform_gisaid_data.metadata_transformed_tsv

#    File nextclade_tsv = ingest.nextclade_cache
  }
}
