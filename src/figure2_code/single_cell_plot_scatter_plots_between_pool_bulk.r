library(utils)
library(chromVAR)
library(motifmatchr)
library(Matrix)
library(SummarizedExperiment)
library(BiocParallel)
library(devtools)
library(Biobase)
library(preprocessCore)

set.seed(2017)

register(MulticoreParam(16))
register(MulticoreParam(16, progressbar = TRUE))

peaks <- getPeaks('./data/input/Figure2/peakname3.txt',sort_peaks = TRUE)
#peaks <- getPeaks('/data/kuw/biocore/wlku/Keji/scimpute/peakname3.txt',sort_peaks = TRUE)
peaks<-resize(peaks, width = 3000, fix = "center")
peaks <-unique(peaks)
peaks<-sort(peaks)



#sc_cellpeaks<- getPeaks('./data/input/Figure2/singlecell_read1-W200-G200-E.01.scoreisland',sort_peaks = TRUE)
#
##sc_cellpeaks<- getPeaks('/data/kuw/biocore/wlku/Keji/wbc_285_read1_mapped/singlecell_read1-W200-G200-E.01.scoreisland',sort_peaks = TRUE)
#sc_cellpeaks <-unique(sc_cellpeaks)
#sc_cellpeaks<-sort(sc_cellpeaks) 
#
##peaks2<-union(peaks,sc_cellpeaks)
#
#bulk_bedfile<-read.table("/data/kuw/biocore/wlku/Keji/encode_white_blood_cell/encode_bedfile.txt")
#bulk_bedfile2<-paste0("/data/kuw/biocore/wlku/Keji/encode_white_blood_cell/", bulk_bedfile[,1])
#
#nx<-c("bulk")
#for (i in 1:72)
##for (i in 1:6)
#{
#	nx[i]<-"bulk"
#}
#bulk_counts<- getCounts(bulk_bedfile2, 
#                             peaks, 
#                             paired =  FALSE, 
#                             by_rg = FALSE, 
#                             format = "bed", 
#                             colData = DataFrame(celltype =nx ))
                             
                             
#bcounts<-as.matrix(assays(bulk_counts)$counts)*1000000/colSums(as.matrix(assays(bulk_counts)$counts))
#bcounts<-as.matrix(assays(bulk_counts)$counts)
#mbcounts<-bcounts
#mbcounts<-mbcounts[,-c(13:72)];

##mbcounts<-rowSums(bcounts[,c(1:6)]) 

#mbcounts[,1]<-rowSums(bcounts[,c(1:10)])   
#mbcounts[,2]<-rowSums(bcounts[,c(11:16)])                             
#mbcounts[,3]<-rowSums(bcounts[,c(17:24)])                             
#mbcounts[,4]<-rowSums(bcounts[,c(25:30)])                             
#mbcounts[,5]<-rowSums(bcounts[,c(31:47)])                             
#mbcounts[,6]<-bcounts[,48]                            
#mbcounts[,7]<-rowSums(bcounts[,c(49:50)])                             
#mbcounts[,8]<-rowSums(bcounts[,c(51:59)])                             
#mbcounts[,9]<-rowSums(bcounts[,c(60:61)])                             
#mbcounts[,10]<-bcounts[,62]                                  
#mbcounts[,11]<-rowSums(bcounts[,c(63:64)])                             
#mbcounts[,12]<-rowSums(bcounts[,c(65:72)])                             
                                    


            
##bedfile<-read.table("/data/kuw/biocore/wlku/Keji/wbc_285_read1_mapped/single_cell_bedtobam_file/bedfile_batch.txt",header=TRUE)
##bedfile<-read.table("/data/kuw/biocore/wlku/Keji/wbc_285_read1_mapped/single_cell_bedtobam_file/bedfile_batch_nonfil.txt",header=TRUE)
##bedfile2<-paste0("/data/kuw/biocore/wlku/Keji/wbc_285_read1_mapped/single_cell_bedtobam_file/",bedfile[,1])

#bedfile<-read.table("./data/input/Figure2/bedfile_batch.txt",header=TRUE)
##bedfile<-read.table("/data/kuw/biocore/wlku/Keji/wbc_285_read1_mapped/single_cell_bedtobam_file/bedfile_batch_nonfil.txt",header=TRUE)
#bedfile2<-paste0("./data/input/Figure2/filtered_242_bed/",bedfile[,1])

#nx<-c("wbc")
#for (i in 1:242)
#{
#	nx[i]<-"wbc"
#}
#fragment_counts <- getCounts(bedfile2, 
#                             peaks, 
#                             paired =  FALSE, 
#                             by_rg = FALSE, 
#                             format = "bed", 
#                             colData = DataFrame(celltype =nx))
                             
                             
                             
##pool_counts <- getCounts("/data/kuw/biocore/wlku/Keji/wbc_285_read1_mapped/sel_281bed/combined_281cell_noDup.bed", 
##                             peaks, 
##                             paired =  FALSE, 
##                             by_rg = FALSE, 
##                             format = "bed", 
##                             colData = "wbc")
                             
##pool_counts2 <- getCounts("/data/kuw/biocore/wlku/Keji/wbc_285_read1_mapped/sel_242bed/combined_242cell_nodup.bed", 
##                             peaks, 
##                             paired =  FALSE, 
##                             by_rg = FALSE, 
##                             format = "bed", 
##                             colData = "wbc")
                             
                                            
aa1<-read.table('./data/temp/Figure2/scH3K4me3_242_cells_counts_at_WBCpeaks.txt')
aa2<-read.table('./data/temp/Figure2/scH3K4me3_242_filtertxt_precision.txt')
aa3<-read.table('./data/input/Figure2/mean_bulk_cells_chipseq_counts_at_WBCpeaks.txt')
aa4<-read.table('./data/input/Figure2/bulk_cells_72_chipseq_counts_at_WBCpeaks.txt')

                                            
                                            
xx2<-as.matrix(aa1)
yy <-as.matrix(aa2)
zz<-grep(TRUE,yy>0.549)  ### 0.549 for top 40 cells, 0 for all cells
xx3<-xx2[,zz]
mbcounts<- as.matrix(aa3)
bulk_cpm<-rowMeans((mbcounts[,c(1:12)]*1000000/colSums(mbcounts[,c(1:12)])))
sc_cpm<-rowMeans(log2(xx3*1000000/colSums(xx3)+1))

             

xdata<-data.frame(log2(bulk_cpm+1),sc_cpm)
norm_data = normalize.quantiles(as.matrix(xdata[bulk_cpm>3,]))
acor<-cor(norm_data, method="pearson")

#################################              

pdf("./Figures/Figure2/scatter_bulk_pooledsc_at_H3K4me3peaks.pdf")
      
smoothScatter(norm_data, nbin = 300,
              colramp = colorRampPalette(c("white", "blue")),
              nrpoints = 300, pch = "", cex = 2, col = "black", xlab="Bulk WBC (log2 CPM)", ylab ="Pooled single cells (log2 CPM)",main = "", xlim=c(2.5,12), ylim=c(2.5,12),cex.main=1.5, cex.lab=1.5,cex.axis=1.5)
                       
text(9,10,labels=paste0("Correlation = ",toString(format(round(acor[1,2], 2), nsmall = 2))), cex=1.5)
dev.off() 
#################################    




library(ChIPseeker)            
library(TxDb.Hsapiens.UCSC.hg18.knownGene)
library(org.Hs.eg.db)
peakAnno <- annotatePeak(peaks, tssRegion=c(-3000, 3000),
                         TxDb=TxDb.Hsapiens.UCSC.hg18.knownGene, annoDb="org.Hs.eg.db")              
              
Peaks3<-as.data.frame(peakAnno)              
nx<-paste0(Peaks3[,1],"_",Peaks3[,2],"_",Peaks3[,3],'_',Peaks3[,14],'_',Peaks3[,16])  

#rownames(aa)<-nx
#aa<-assays(bulk_counts)$counts            
#write.table(as.matrix(aa),'/data/kuw/biocore/wlku/Keji/bulk_wbc_rc_52798_72_mat.txt')
#write.table(as.matrix(colnames(aa)),'/data/kuw/biocore/wlku/Keji/bulk_wbc_file_name.txt')
     
rownames(aa4)<-nx
#write.table(as.matrix(aa4),'./data/output/Figure2/bulk_wbc_rc_52798_72_mat.txt')
#write.table(as.matrix(colnames(aa4)),'./data/output/Figure2/bulk_wbc_file_name.txt')
    
    
     
mx<-c("cell")
for (i in 1:242)
{
	mx[i]<-paste0("cell_",i)
}        

#sc_wbc<-fragment_counts
#rownames(sc_wbc)<-nx
#colnames(sc_wbc)<-mx
#B2<-assays(sc_wbc)$counts            

sc_wbc<-aa1
rownames(sc_wbc)<-nx
colnames(sc_wbc)<-mx


#write.table(as.matrix(B2),'/data/kuw/biocore/wlku/Keji/scwbc_rc_52798_242_mat.txt',sep = ",")
write.table(as.matrix(sc_wbc),'./data/temp/Figure2/scwbc_rc_52798_242_mat.txt',sep = ",")
