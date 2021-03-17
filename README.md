# Project Description

High-throughput sequencing technologies have helped researchers expand their understanding of genome-wide gene expression through their ability to detect potentially any mRNA molecule in a sample, rather than measuring only molecules with specific sequences as with microarrays. This agnostic approach to molecular profiling allows us to ask different and somewhat more complex questions of a sequencing dataset than a microarray dataset, (e.g. novel splice patterns, lincRNAs, coding mutations, etc), but the most basic information, mRNA abundance, is analogous to microarray expression measurements and extremely useful. In this project, you will download, QC, process, and analyze sequencing data that was generated to better understand how neonatal mice are able to regenerate their heart tissue but lose this ability later in development.
# Contributors

Kyrah Kotary (Data Curator)
Brad Fortunato (Programmer)
Vishwa Talati (Analyst)
Marina Natividad (Biologist)

# Repository Contents
Data curator files inclide run_extract.qsub, P0_1_1_fastqc.html, and P0_1_2_fastqc.html. The run_extract.qsub file contains code for extracting FASTQ files, and the two html files are FastQC quality reports.

Analyst_Role.R has code which takes differential genes with their names, FPKM values, log2 fold change, p_value, q_value and their significance from cuffdiff as input and gives the list of up and down regulated significant genes as output in .csv files. It also plots histogram of log2 fold change of all DEG and significant genes.

biologist.R contains code for replication of O’Meara et al. (2015) Figure 1D of the datasets P0, P4, P7 and Ad. The second part results in a heatmap of the top 100 DE genes in the P4 vs Adult datasets.
