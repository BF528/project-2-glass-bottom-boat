## biologist code
# glass bottom boat
# marinant

setwd("/projectnb2/bf528/users/glass_bottom_boat/project_2/biologist")

##########################################
#################  7.1 ###################
##########################################


# in shell $ DATADIR=/projectnb/bf528/project_2/data/

library(dplyr) #select columns
library(ggplot2)
library(reshape2)
library(tidyverse)
library(pheatmap)

# list of gene names in figure 1D of O'Meara et al. (2015)
sarcomere_genes <- c("Pdlim5", "Pygm", "Myoz2", "Des", "Csrp3", "Tcap", "Cryab")
mitochondria_genes <- c("Mpc1", "Prdx3", "Acat1", "Echs1", "Slc25a11", "Phyh")# FUN FACT Slc25a11 made me cry A LOT during my undergrad thesis I hate this guy
cellcycle_genes <- c("Cdc7", "E2f8", "Cdk7", "Cdc26", "Cdc6", "E2f1", "Cdc27", "Bora", "Cdc45", "Rad51", "Aurkb", "Cdc23")

# FPKM matrix from P4 vs P7, we'll add P0 later
fpkm_matrix <- read.csv("/projectnb/bf528/project_2/data/fpkm_matrix.csv", header = TRUE, sep = "\t")

# read genes.fpkm_tracking files from $DATADIR/samples/
# f(pkm)NAME
fAd_1 <- read.table("/projectnb/bf528/project_2/data/samples/Ad_1/genes.fpkm_tracking", header = TRUE)
fAd_2 <- read.table("/projectnb/bf528/project_2/data/samples/Ad_2/genes.fpkm_tracking", header = TRUE)
fP0_2 <- read.table("/projectnb/bf528/project_2/data/samples/P0_2/genes.fpkm_tracking", header = TRUE)
fP4_1 <- read.table("/projectnb/bf528/project_2/data/samples/P4_1/genes.fpkm_tracking", header = TRUE)
fP4_2 <- read.table("/projectnb/bf528/project_2/data/samples/P4_2/genes.fpkm_tracking", header = TRUE)
fP7_1 <- read.table("/projectnb/bf528/project_2/data/samples/P7_1/genes.fpkm_tracking", header = TRUE)
fP7_2 <- read.table("/projectnb/bf528/project_2/data/samples/P7_2/genes.fpkm_tracking", header = TRUE)
# our sample
fP0_1 <- read.table("/projectnb/bf528/users/b42nato/P2_programmer/P0_1_cufflinks/genes.fpkm_tracking", header = TRUE)

# There must be a more elegant way of doing this and I would truly appreciate it if you shared it with me.

## colnames(fAd_1)

x <- c("gene_short_name", "FPKM")
# p(lot)NAME
# if gene_short_name is in sarcomere_genes list, append fpkm column

sarcomere_plot_data <- c(fP0_1[fP0_1$gene_short_name %in% sarcomere_genes, x],
                         fP0_2[fP0_2$gene_short_name %in% sarcomere_genes, x],
                         fP4_1[fP4_1$gene_short_name %in% sarcomere_genes, x],
                         fP4_2[fP4_2$gene_short_name %in% sarcomere_genes, x],
                         fP7_1[fP7_1$gene_short_name %in% sarcomere_genes, x],
                         fP7_2[fP7_2$gene_short_name %in% sarcomere_genes, x],
                         fAd_1[fAd_1$gene_short_name %in% sarcomere_genes, x], 
                         fAd_2[fAd_2$gene_short_name %in% sarcomere_genes, x])


mitochondria_plot_data <- c(fP0_1[fP0_1$gene_short_name %in% mitochondria_genes, x],
                            fP0_2[fP0_2$gene_short_name %in% mitochondria_genes, x],
                            fP4_1[fP4_1$gene_short_name %in% mitochondria_genes, x],
                            fP4_2[fP4_2$gene_short_name %in% mitochondria_genes, x],
                            fP7_1[fP7_1$gene_short_name %in% mitochondria_genes, x],
                            fP7_2[fP7_2$gene_short_name %in% mitochondria_genes, x],
                            fAd_1[fAd_1$gene_short_name %in% mitochondria_genes, x], 
                            fAd_2[fAd_2$gene_short_name %in% mitochondria_genes, x])
                    

cellcycle_plot_data <- c(fP0_1[fP0_1$gene_short_name %in% cellcycle_genes, x],
                         fP0_2[fP0_2$gene_short_name %in% cellcycle_genes, x],
                         fP4_1[fP4_1$gene_short_name %in% cellcycle_genes, x],
                         fP4_2[fP4_2$gene_short_name %in% cellcycle_genes, x],
                         fP7_1[fP7_1$gene_short_name %in% cellcycle_genes, x],
                         fP7_2[fP7_2$gene_short_name %in% cellcycle_genes, x],
                         fAd_1[fAd_1$gene_short_name %in% cellcycle_genes, x], 
                         fAd_2[fAd_2$gene_short_name %in% cellcycle_genes, x])
                         

# I really need to learn R functions this is embarrassing I apologise
# Also I think other biologists were going to plot the replicates separetely but I don't think
# we're supposed to do that to get our results to look more like the paper's #cherrypicking
# so I did a mean of the replicates, did not do sd bc n=2

titles <- c("Gene", "P0_1", "P0_2", "P4_1", "P4_2", "P7_1", "P7_2", "Ad_1", "Ad_2")
S <- as.data.frame(sarcomere_plot_data) #so I have gene name and fpkm for each sample
S <- S[-c(3, 5, 7, 9, 11, 13, 15)]
names(S) <- titles

# ok I know this is a weird thing I did but it's the only thing that worked
# see if I only appended the FPKM I got a list and then adding the gene names 
#was a mess or I'm a mess and couldn't figure it out but this worked so... 

M <- as.data.frame(mitochondria_plot_data)
M <- M[-c(3, 5, 7, 9, 11, 13, 15)]
names(M) <- titles

C <- as.data.frame(cellcycle_plot_data)
C <- C[-c(3, 5, 7, 9, 11, 13, 15)]
names(C) <- titles

# Means tables

S_mean <- data.frame(S$Gene)
S_mean$P0 <- (S$P0_1 + S$P0_2)/2
S_mean$P4 <- (S$P4_1 + S$P4_2)/2
S_mean$P7 <- (S$P7_1 + S$P7_2)/2
S_mean$Ad <- (S$Ad_1 + S$Ad_2)/2

M_mean <- data.frame(M$Gene)
M_mean$P0 <- (M$P0_1 + M$P0_2)/2
M_mean$P4 <- (M$P4_1 + M$P4_2)/2
M_mean$P7 <- (M$P7_1 + M$P7_2)/2
M_mean$Ad <- (M$Ad_1 + M$Ad_2)/2

C_mean <- data.frame(C$Gene)
C_mean$P0 <- (C$P0_1 + C$P0_2)/2
C_mean$P4 <- (C$P4_1 + C$P4_2)/2
C_mean$P7 <- (C$P7_1 + C$P7_2)/2
C_mean$Ad <- (C$Ad_1 + C$Ad_2)/2

samples <- c("P0", "P4", "P7", "Ad")

# sarcomere plot
S_long <- gather(S_mean, Sample, FPKM, 2:5, factor_key=TRUE)

splot = ggplot(S_long, aes(x = Sample, y = FPKM, group = S.Gene, colour = S.Gene)) +
  geom_line() +
  xlab("Sample") + ylab("FPKM") +
  ggtitle("Sarcomere")

# mitochondria plot
M_long <- gather(M_mean, Sample, FPKM, 2:5, factor_key=TRUE)

mplot = ggplot(M_long, aes(x = Sample, y = FPKM, group = M.Gene, colour = M.Gene)) +
  geom_line() +
  xlab("Sample") + ylab("FPKM") +
  ggtitle("Mitochondria")

# cell cycle plot
C_long <- gather(C_mean, Sample, FPKM, 2:5, factor_key=TRUE)

cplot = ggplot(C_long, aes(x = Sample, y = FPKM, group = C.Gene, colour = C.Gene)) +
  geom_line() +
  xlab("Sample") + ylab("FPKM") +
  ggtitle("Cell Cycle")



##########################################
#################  7.3 ###################
##########################################

as.data.frame(fP0_1)
#removing all fpkm values = 0 bc the heatmap looked hideous
fP0_1 <- fP0_1[fP0_1$FPKM != 0, ] 
as.data.frame(fP0_2)
fP0_2 <- fP0_2[fP0_2$FPKM != 0, ]
as.data.frame(fP4_1)
fP4_1 <- fP4_1[fP4_1$FPKM != 0, ]
as.data.frame(fP4_2)
fP4_2 <- fP4_2[fP4_2$FPKM != 0, ]
as.data.frame(fP7_1)
fP7_1 <- fP7_1[fP7_1$FPKM != 0, ]
as.data.frame(fP7_2)
fP7_2 <- fP7_2[fP7_2$FPKM != 0, ]
as.data.frame(fAd_1)
fAd_1 <- fAd_1[fAd_1$FPKM != 0, ]
as.data.frame(fAd_2)
fAd_2 <- fAd_2[fAd_2$FPKM != 0, ]

m0 <- merge(fP0_1, fP0_2, by = "tracking_id", all = TRUE)[,c("tracking_id","gene_short_name.x", "FPKM.x", "FPKM.y")]
m4 <- merge(fP4_1, fP4_2, by = "tracking_id", all = TRUE)[,c("tracking_id", "FPKM.x", "FPKM.y")]
m7 <- merge(fP7_1, fP7_2, by = "tracking_id", all = TRUE)[,c("tracking_id", "FPKM.x", "FPKM.y")]
ma <- merge(fAd_1, fAd_2, by = "tracking_id", all = TRUE)[,c("tracking_id", "FPKM.x", "FPKM.y")]

# adding one at the time
complete <- merge(m0, m4, by = "tracking_id", all = TRUE)
complete <- merge(complete, m7, by = "tracking_id", all = TRUE)
complete <- merge(complete, ma, by = "tracking_id", all = TRUE)
n <- c("tracking_id", "gene", "FPKM.P0_1", "FPKM.P0_2", "FPKM.P4_1", "FPKM.P4_2",
       "FPKM.P7_1", "FPKM.P7_2", "FPKM.Ad_1", "FPKM.Ad_2")
names(complete) <- n
# remove na data
complete_omit <- na.omit(complete) 

ref_genes <- read.table("/projectnb/bf528/users/b42nato/P2_programmer/P0_1_cuffdiff/cuffdiff_out/gene_exp.diff", header = TRUE)
#as.data.frame(ref_genes)
ordered_genes <- ref_genes[order(-ref_genes$q_value),] #sort by descending q_value
top1000 <- ordered_genes[1:1000,]
#names(top1000)
select <- top1000$gene
# "IL13" %in% select # Just wanted to check if this gene appeared bc the authors talk about it a lot
heat_data <- complete[is.element(complete$gene, select),]
n2 <- c("FPKM.P0_1", "FPKM.P0_2", "FPKM.P4_1", "FPKM.P4_2",
          "FPKM.P7_1", "FPKM.P7_2", "FPKM.Ad_1", "FPKM.Ad_2")

pheatmap(heat_data[1:50,3:10],
         cluster_rows = T, cluster_cols = F, show_rownames=F, main = "Heatmap of DE Genes")



