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
rownames(DT) <- NULL

head(DT )

DT$sesso<-as.factor(DT$sesso)
DT$regione<-as.factor(DT$regione)
str(DT)  

##################
qq<-levels (DT$regione)
fix(qq)
write.table(qq, "~/GitHub/demografia/data/regioni.txt")

##########################

myregioni <- read.table("~/GitHub/demografia/data/regioni.txt", stringsAsFactors=F)
str (myregioni)
myregioni[,1]
levels (DT$regione)<-myregioni[,1]

barplot(table (DT$regione))

summary(DT$eta)


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

plot(regsex)
str(regsex)

# dfregsex<- as.data.frame(regsex)

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


DT_si <- subset(DT, regione ==  "Sicilia" )
str(DT_si)

ggplot(data=DT_si, aes(x=eta, y= nresidenti, fill=sesso)) + 
  geom_bar(stat="identity" ) +
  ggtitle("distribuzione per eta nati in Sicilia") + 
  xlab("eta") + ylab("n. cittadini") 

DT_pu <- subset(DT, regione ==  "Puglia" )
str(DT_pu)

ggplot(data=DT_pu, aes(x=eta, y= nresidenti, fill=sesso)) + 
  geom_bar(stat="identity" ) +
  ggtitle("distribuzione per eta nati in Puglia") + 
  xlab("eta") + ylab("n. cittadini") 

DT_li <- subset(DT, regione ==  "Liguria" )
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
pippo[which (pippo[,2]>0),][,1]

###################################################


library (plyr)

DTtot<-ddply(DT, .(regione,sesso), summarise,
              qta= sum(nresidenti))
str(DTtot)
head(DTtot)

ggplot(data=DTtot, aes(x=regione, y= qta/1000, fill = sesso )) + 
  geom_bar(stat="identity", show_guide = F) +
  coord_flip() +
  ggtitle("regione di nascita dei residenti") + 
  xlab("Regione") + ylab("in migliaia") 

DT_tot_noPie <- subset(DTtot, regione !=  "Piemonte" )

ggplot(data=DT_tot_noPie, aes(x=regione, y= qta/1000, fill = sesso )) + 
  geom_bar(stat="identity", show_guide = F) +
  coord_flip() +
  ggtitle("provenienza dei residenti (senza piemontesi)") + 
  xlab("Regione") + ylab("in migliaia") 

### macro regioni 
DTtot3 <- DTtot
str(DTtot3)

myregt3<-levels(DTtot3$regione)
pieest<- c("Piemonte","ESTERO")
myregt3[!myregt3%in%pieest] <- c("AltreRegioni")
levels(DTtot3$regione)<- myreg3
DTtot3$regione<- as.factor(DTtot3$regione)

str(DTtot3)
table(DTtot3$regione)

DTtot3<-DTtot3[ order(DTtot3$sesso),]
ggplot(data=DTtot3, aes(x=regione, y= qta/1000, fill = sesso )) + 
  geom_bar(stat="identity", show_guide = F) +
  coord_flip() +
  ggtitle("regione di nascita dei residenti") + 
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

library(scales)
ggplot(data=d_sex, aes(x=regione, y= perdiff )) + 
  geom_bar(stat="identity", show_guide = F, fill= "#FFCC00") +
  coord_flip()  + scale_y_continuous(labels=percent)  +
  ggtitle("differenza percentuale F>M") + 
  xlab("Regione") 

#########################################

ggplot(data=DT, aes(x=eta, y= nresidenti, fill=regione)) + 
  geom_bar(stat="identity" ) +
  ggtitle("distribuzione per eta") + 
  xlab("eta") + ylab("n. cittadini") 

DT3 <- DT
str(DT3)

myreg3<-levels(DT3$regione)
pieest<- c("Piemonte","ESTERO")
myreg3[!myreg3%in%pieest] <- c("AltreRegioni")
levels(DT3$regione)<- myreg3
DT3$regione<- as.factor(DT3$regione)

str(DT3)
table(DT3$regione)

DT3tot<-ddply(DT3, .(regione,eta), summarise,
             qta= sum(nresidenti))
str(DT3tot)
head(DT3tot)

ggplot(data=DT3tot, aes(x=eta, y= qta, color= regione)) + 
  geom_point (size=4) + geom_line() + theme(legend.position = "bottom") + 
  scale_fill_brewer(palette="Set2") + guides(color=guide_legend(title=NULL))


DT36080 <- DT3tot [ DT3tot$eta> 59 & DT3tot$eta < 81 ,]

ggplot(data=DT36080, aes(x=eta, y= qta, color= regione)) + 
  geom_point (size=4) + geom_line() + theme(legend.position = "bottom") + 
  scale_fill_brewer(palette="Set2") + guides(color=guide_legend(title=NULL))

ggplot(data=DT6080, aes(x=eta, y= nresidenti, fill = regione )) + 
  geom_bar(stat="identity") +
  ggtitle("residenti fra 60 ed 80 anni di eta") + 
  xlab("eta") + ylab("n. residenti ") + theme(legend.position = "bottom") + 
  scale_fill_brewer(palette="Set2") + guides(fill=guide_legend(title=NULL))



DT3tot[DT3tot$eta==1,]

myeta <- unique(DT3tot$eta)

DT3split<-split (DT3tot, DT3tot$regione)
str(DT3split[[1]])

altre<- as.data.frame(DT3split[[1]])
estero<- as.data.frame(DT3split[[2]])
piem<- as.data.frame(DT3split[[3]])

altre_est<-merge (altre, estero, by="eta")
tutti<-merge (altre_est, piem, by="eta")
str(tutti)
head (tutti)
tutte_eta <- cbind (tutti[,1], tutti[,3],tutti[,5],tutti[,7]    )
head (tutte_eta)
colnames (tutte_eta) <-c("eta", "altre", "estero", "piemonte")

write.table (tutte_eta, "~/GitHub/demografia/data/tutte.eta.txt")

tutteta<-as.data.frame(tutte_eta)

ggplot(data=tutteta, aes(x=eta, y= altre)) + 
  geom_point (size=2, color="blue") 


+
  ggtitle("distribuzione per eta") + 
  xlab("eta") + ylab("n. cittadini") 




DT3 <- DT3 [ order(DT3$regione ),]

ggplot(data=DT3, aes(x=eta, y= nresidenti, fill=regione)) + 
  geom_bar(stat="identity" ) +
  ggtitle("distribuzione per eta") + 
  xlab("eta") + ylab("n. cittadini") 


DT_28 <- subset(DT, eta ==  28 )
str(DT_28)

ggplot(data=DT_28, aes(x=regione, y= nresidenti, fill = sesso )) + 
  geom_bar(stat="identity", show_guide = F) +
  coord_flip() +
  ggtitle("residenti di 28 anni eta") + 
  xlab("Regione") + ylab(" ") 


DT_70 <- subset(DT, eta ==  70 )
str(DT_70)

ggplot(data=DT_70, aes(x=regione, y= nresidenti, fill = sesso )) + 
  geom_bar(stat="identity", show_guide = F) +
  coord_flip() +
  ggtitle("residenti di 70 anni eta") + 
  xlab("Regione") + ylab(" ") 

### fascia 60 80 anni

DT6080 <- DT3 [ DT3$eta> 60 & DT3$eta < 80 ,]
str (DT6080)



ggplot(data=DT6080, aes(x=eta, y= nresidenti, fill = regione )) + 
  geom_bar(stat="identity", show_guide = F) +
  ggtitle("residenti fra 60 ed 80 anni di eta") + 
  xlab("Regione") + ylab(" ") 

