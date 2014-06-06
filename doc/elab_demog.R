# demografia
library (ggplot2)

###################
DT<- read.table ("~/GitHub/demografia/data/residenti_sesso_regione_nascita_2011.csv" , header=T, sep=";",
                 stringsAsFactors=F)
str(DT)                                 # 4092 obs.
    

names(DT) <- c("eta" ,"sesso","regione", "nresidenti")
names(DT)                   # "id"      "cbranca" "bdescr" 
head(DT)
DT <- DT[order(DT$regione, DT$sesso, DT$eta),]
head(DT)


DT$sesso<-as.factor(DT$sesso)
DT$regione<-as.factor(DT$regione)
str(DT)  
qq<-levels (DT$regione)

fix(qq)
levels (DT$regione)<-qq

barplot(table (DT$regione))

####################################################


ggplot(data=DT, aes(x=regione, fill=sesso)) + 
  geom_bar(stat="bin" ) +
  coord_flip()  +  
  ggtitle("frequenza osservazioni per regione") + 
  xlab("Regione") + ylab("n. osservazioni") 

#  facet_grid(. ~ sesso)
# position=position_dodge()

###################################################
regsex<-table (DT$regione, DT$sesso)

str(regsex)
diffregsex <- regsex[,1] -regsex[,2]

str(diffregsex)

difrgsex <- as.data.frame(diffregsex,stringsAsFactors=F )
drgsex <- cbind (rownames(difrgsex), difrgsex)
str(drgsex)
head(drgsex)

colnames(drgsex) <- c("regione", "diff_FM")

ggplot(data=drgsex, aes(x=regione, y= diff_FM )) + 
  geom_bar(stat="identity", show_guide = F, fill= "#FF0000") +
  coord_flip()  +   ylim(-3, 7) +
  ggtitle("differenza n.osservazioni fra sessi") + 
  xlab("Regione") + ylab("F-M") 

###########################################

DT_Pie <- subset(DT, regione ==  "Piemonte" )
str(DT_Pie)

ggplot(data=DT_Pie, aes(x=eta, y= nresidenti, fill=sesso)) + 
  geom_bar(stat="identity" ) +
  ggtitle("distribuzione per eta nati in Piemonte") + 
  xlab("eta") + ylab("n. cittadini") 

DT_EX <- subset(DT, regione ==  "ESTERO" )
str(DT_EX)

ggplot(data=DT_EX, aes(x=eta, y= nresidenti, fill=sesso)) + 
  geom_bar(stat="identity" ) +
  ggtitle("distribuzione per eta nati all'estero") + 
  xlab("eta") + ylab("n. cittadini") 


DT_si <- subset(DT, regione ==  "Sicilia " )
str(DT_si)

ggplot(data=DT_si, aes(x=eta, y= nresidenti, fill=sesso)) + 
  geom_bar(stat="identity" ) +
  ggtitle("distribuzione per eta nati in Sicilia") + 
  xlab("eta") + ylab("n. cittadini") 

DT_pu <- subset(DT, regione ==  "Puglia " )
str(DT_pu)

ggplot(data=DT_pu, aes(x=eta, y= nresidenti, fill=sesso)) + 
  geom_bar(stat="identity" ) +
  ggtitle("distribuzione per eta nati in Puglia") + 
  xlab("eta") + ylab("n. cittadini") 

DT_li <- subset(DT, regione ==  "Liguria " )
str(DT_li)

ggplot(data=DT_li, aes(x=eta, y= nresidenti, fill=sesso)) + 
  geom_bar(stat="identity" ) +
  ggtitle("distribuzione per eta nati in Liguria") + 
  xlab("eta") + ylab("n. cittadini") 

es_li <- table(DT_li$eta, DT_li$sesso)
str(es_li)
es_li[103,2]
rownames(es_li)[103]

dim(es_li)

pippo<-matrix(0,dim(es_li)[1],2)
dim(pippo)
str(pippo)

for (i in 1:dim(es_li)[1]) 
  {
  pippo[i,1] <- rownames(es_li)[i]
  pippo[i,2] <- es_li[i,1] - es_li[i,2]
}
pippo[which (pippo[,2]>0),]

###################################################


library (plyr)

DTtot<-ddply(DT, .(regione,sesso), summarise,
              qta= sum(nresidenti))
str(DTtot)
head(DTtot)

ggplot(data=DTtot, aes(x=regione, y= qta/1000, fill = sesso )) + 
  geom_bar(stat="identity", show_guide = F) +
  coord_flip() +
  ggtitle("provenienza dei residenti") + 
  xlab("Regione") + ylab("in migliaia") 

DT_tot_noPie <- subset(DTtot, regione !=  "Piemonte" )

ggplot(data=DT_tot_noPie, aes(x=regione, y= qta/1000, fill = sesso )) + 
  geom_bar(stat="identity", show_guide = F) +
  coord_flip() +
  ggtitle("provenienza dei residenti (senza piemontesi)") + 
  xlab("Regione") + ylab("in migliaia") 


myregione<-levels (DTtot$regione)

dsex<-sapply(myregione, 
       function(x) DTtot$qta[DTtot$regione==x & DTtot$sesso=="F"]  - DTtot$qta[DTtot$regione==x & DTtot$sesso=="M"]  )
ssex<-sapply(myregione, 
             function(x) DTtot$qta[DTtot$regione==x & DTtot$sesso=="F"]  + DTtot$qta[DTtot$regione==x & DTtot$sesso=="M"]  )

d_sex<- as.data.frame(dsex)
s_sex<- as.data.frame(ssex)
psex <- round (dsex / ssex,2)

d_sex <- cbind (rownames(d_sex), d_sex, s_sex, psex)
str(d_sex)
head(d_sex)

colnames(d_sex) <- c("regione", "diff_FM", "total", "perdiff")
head(d_sex)

ggplot(data=d_sex, aes(x=regione, y= diff_FM )) + 
  geom_bar(stat="identity", show_guide = F, fill= "#FF0000") +
  coord_flip()  + 
  ggtitle("differenza residenti fra sessi") + 
  xlab("Regione") + ylab("F-M") 

ggplot(data=d_sex, aes(x=regione, y= perdiff )) + 
  geom_bar(stat="identity", show_guide = F, fill= "#FFCC00") +
  coord_flip()  + 
  ggtitle("differenza percentuale F>M") + 
  xlab("Regione") + ylab("%") 

