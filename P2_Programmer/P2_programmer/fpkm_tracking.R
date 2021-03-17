#Read in the genes.fpkm_tracking file 
fpkm <- read.table("C:/Users/b42na/Documents/BF528/genes.fpkm_tracking", header = TRUE, sep = "\t")
#Filter out genes where FPKM<500
fpkm <- fpkm[fpkm$FPKM>=2500,]
#Create histogram of gene name vs. log(FPKM)
par(mar=c(6,5,4,2))
options(scipen=999)
barplot(fpkm$FPKM,names.arg = fpkm$gene_short_name,main="Gene Expression - FPKM (FPKM Value Filtering: >= 4000)",ylab="log(FPKM)             ",ylim=c( 0.0001,10^7),log="y",las=2, cex.axis=0.75, cex.lab=.75)
box(which="plot",lty="solid")
