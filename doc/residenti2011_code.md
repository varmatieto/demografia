Residenti nel Comune di Torino nell'anno 2011
----------------------------

### Fonte

Sul sito dedicati agli [Opendata del Comune di Torino] (http://aperto.comune.torino.it)  sono stati pubblicati le [Età e regione di nascita dei residenti, anno 2011] (http://aperto.comune.torino.it/?q=node/287).

Il database *Residenti 2011*, ha informazioni sul numero di residenti suddivisi per sesso, età e regione di nascita, anno 2011. Esso contiene 4096 osservazioni su  4 variabili.

Ciascuna osservazione riporta:

- l'eta', 

- il sesso, 

- la regione di nascita, 

- il numero di residenti.

Il file .csv scaricato da web e' stato editato al fine di eliminare un doppio ";;" finale,  presente nelle prime 16 osservazioni.

Le prime osservazioni del database risultano:


```r
url<- 'http://aperto.comune.torino.it/sites/default/files/residenti-et-sesso-regione-nascita_2011.csv'

if(!file.exists('~/GitHub/demografia/data/residenti_sesso_regione_nascita_2011.csv')){
 download.file(url,"~/GitHub/demografia/data/residenti_sesso_regione_nascita_2011.csv",method='internal')
 }

DT<- read.table ("~/GitHub/demografia/data/residenti_sesso_regione_nascita_2011.csv" , header=T, sep=";",  
                 stringsAsFactors=F)


names(DT) <- c("eta" ,"sesso","regione", "nresidenti")

# str(DT)
DT <- DT[order(DT$regione, DT$eta, DT$sesso),]
rownames(DT) <- NULL

DT$sesso<-as.factor(DT$sesso)
DT$regione<-as.factor(DT$regione)

myregioni <- read.table("~/GitHub/demografia/data/regioni.txt", stringsAsFactors=F)

levels (DT$regione)<-myregioni[,1]

myregions <- myregioni[,1]
myoss<-21*108+2

head(DT,addrownums=F)
```

```
##   eta sesso regione nresidenti
## 1   0     F Abruzzo          1
## 2   1     F Abruzzo          2
## 3   2     F Abruzzo          3
## 4   3     F Abruzzo          1
## 5   3     M Abruzzo          3
## 6   4     F Abruzzo          3
```
Al fine di semplificare la rappresentazione dei dati nei grafici si e' approntato un file con i nomi abbreviati delle Regioni ( Abruzzo, Basilicata, Calabria, Campania, EmiliaRomagna, ESTERO, Friuli-VG, Lazio, Liguria, Lombardia, Marche, Molise, Piemonte, Puglia, Sardegna, Sicilia, Toscana, Trentino, Umbria, ValleAosta, Veneto).  




### Elaborazioni

Sono presenti  21 Regioni  (le 20 regioni + chi nato all'estero  ) e l'eta va da 0 a 108 anni.    
Ci possiamo aspettare che ciascuna Regione abbia al massimo 108 osservazioni sia per  maschi che femmine.     
Il grafico complessivo delle osservazioni per Regione ci dice che non tutte le Regioni hanno tutte le eta' e che il numero di osservazioni per sesso e' differente.


```r
library (ggplot2)

ggplot(data=DT, aes(x=regione, fill=sesso)) + 
  geom_bar(stat="bin", position=position_dodge() ) +
  coord_flip()  +  
  ggtitle("n. osservazioni per regione") + 
  xlab("Regione") + ylab( "") + scale_fill_brewer(palette="Set1") + 
  theme(legend.position = "bottom")
```

![plot of chunk plot1](figure/plot1.png) 

La figura che segue dettaglia per Regione se ci sono piu' anni con femmine o maschi.     In generale le femmine sono presenti su piu' anni; solo la Basilicata ha una prevalenza di maschi.



```r
regsex<-table (DT$regione, DT$sesso)

diffregsex <- regsex[,1] -regsex[,2]

difrgsex <- as.data.frame(diffregsex,stringsAsFactors=F )
drgsex <- cbind (rownames(difrgsex), difrgsex)

colnames(drgsex) <- c("regione", "diff_FM")


ggplot(data=drgsex, aes(x=regione, y= diff_FM )) + 
  geom_point (show_guide = F, size=5, color= "#FF0000") +
  coord_flip() + scale_y_continuous(breaks=c(-4,-3, 0,7,8)) +
  ggtitle("differenza n.osservazioni fra sessi") + 
  xlab("Regione") + ylab("Femmine - Maschi") 
```

![plot of chunk plot2](figure/plot2.png) 

Osserviamo ora come si ripartiscono i residenti. Partiamo dalla visione generale. I nati in Piemonte sono la maggioranza con oltre 500mila residenti.


```r
library (plyr)

DTtot<-ddply(DT, .(regione,sesso), summarise,
              qta= sum(nresidenti))
ggplot(data=DTtot, aes(x=regione, y= qta/1000, fill = sesso )) + 
  geom_bar(stat="identity", show_guide = F) +
  coord_flip() +
  ggtitle("regione di nascita dei residenti") + 
  xlab("Regione") + ylab("in migliaia") + scale_fill_brewer(palette="Set1")
```

![plot of chunk plot3](figure/plot3.png) 

La figura che segue, che non riporta il Piemonte, meglio permette di apprezzare le differenze fra Regioni. I residenti nati all'estero sono quasi 150mila. 


```r
DT_tot_noPie <- subset(DTtot, regione !=  "Piemonte" )

ggplot(data=DT_tot_noPie, aes(x=regione, y= qta/1000, fill = sesso )) + 
  geom_bar(stat="identity", show_guide = F) +
  coord_flip() +
  ggtitle("regione di nascita dei residenti (senza piemontesi)") + 
  xlab("Regione") + ylab("in migliaia") + scale_fill_brewer(palette="Set1")
```

![plot of chunk plot4](figure/plot4.png) 

Le figure precedenti non permettono di apprezzare le differenze fra sessi.   
La figura che segue riporta per ogni Regione la percentuale di prevalenza delle femmine sui maschi.    
Ad esempio la Regione Friuli ha oltre il 20% in piu' di femmine.



```r
myregione<-levels (DTtot$regione)

dsex<-sapply(myregione, 
       function(x) DTtot$qta[DTtot$regione==x & DTtot$sesso=="F"]  - DTtot$qta[DTtot$regione==x & DTtot$sesso=="M"]  )
ssex<-sapply(myregione, 
             function(x) DTtot$qta[DTtot$regione==x & DTtot$sesso=="F"]  + DTtot$qta[DTtot$regione==x & DTtot$sesso=="M"]  )

d_sex<- as.data.frame(dsex)
s_sex<- as.data.frame(ssex)
psex <- round (dsex / ssex,2)

d_sex <- cbind (rownames(d_sex), d_sex, s_sex, psex)
# str(d_sex)
# head(d_sex)

colnames(d_sex) <- c("regione", "diff_FM", "total", "perdiff")
# head(d_sex)

library(scales)
ggplot(data=d_sex, aes(x=regione, y= perdiff )) + 
  geom_bar(stat="identity", show_guide = F, fill= "#66CC99") +
  coord_flip()  + scale_y_continuous(labels=percent)  +
  ggtitle("differenza percentuale F>M") + 
  xlab("Regione") + ylab("")
```

![plot of chunk plot5](figure/plot5.png) 

```r
#theme(plot.title = element_text(size = rel(.8), colour = "blue"))
```

Passiamo ora ad osservare la distribuzione dei residenti per eta e sesso in alcune regioni.


```r
DT_Pie <- subset(DT, regione ==  "Piemonte" )

ggplot(data=DT_Pie, aes(x=eta, y= nresidenti, fill=sesso)) + 
  geom_bar(stat="identity" ) +
  ggtitle("distribuzione per eta nati in Piemonte") + 
  xlab("eta") + ylab("n. residenti") + scale_fill_brewer(palette="Set1")
```

![plot of chunk plot6](figure/plot61.png) 

```r
DT_EX <- subset(DT, regione ==  "ESTERO" )

ggplot(data=DT_EX, aes(x=eta, y= nresidenti, fill=sesso)) + 
  geom_bar(stat="identity" ) +
  ggtitle("distribuzione per eta nati all'estero") + 
  xlab("eta") + ylab("n. residenti") + scale_fill_brewer(palette="Set1")
```

![plot of chunk plot6](figure/plot62.png) 

```r
DT_si <- subset(DT, regione ==  "Sicilia" )

ggplot(data=DT_si, aes(x=eta, y= nresidenti, fill=sesso)) + 
  geom_bar(stat="identity" ) +
  ggtitle("distribuzione per eta nati in Sicilia") + 
  xlab("eta") + ylab("n. residenti")  + scale_fill_brewer(palette="Set1")
```

![plot of chunk plot6](figure/plot63.png) 

```r
DT_pu <- subset(DT, regione ==  "Puglia" )

ggplot(data=DT_pu, aes(x=eta, y= nresidenti, fill=sesso)) + 
  geom_bar(stat="identity" ) +
  ggtitle("distribuzione per eta nati in Puglia") + 
  xlab("eta") + ylab("n. residenti")  + scale_fill_brewer(palette="Set1")
```

![plot of chunk plot6](figure/plot64.png) 

```r
DT_li <- subset(DT, regione ==  "Liguria" )

ggplot(data=DT_li, aes(x=eta, y= nresidenti, fill=sesso)) + 
  geom_bar(stat="identity" ) +
  ggtitle("distribuzione per eta nati in Liguria") + 
  xlab("eta") + ylab("n. residenti")   + scale_fill_brewer(palette="Set1")
```

![plot of chunk plot6](figure/plot65.png) 

Per ultimo prendiamo in esame le tre comunita' maggiori rispetto alla regione di nascita: i nati in Piemonte, i nati in altre regioni italiane, i nati all'estero. 


```r
DTtot3 <- DTtot

myregt3<-levels(DTtot3$regione)
pieest<- c("Piemonte","ESTERO")
myregt3[!myregt3%in%pieest] <- c("AltreRegioni")
levels(DTtot3$regione)<- myregt3
DTtot3$regione<- as.factor(DTtot3$regione)

DTtot3<-DTtot3[ order(DTtot3$sesso),]

ggplot(data=DTtot3, aes(x=regione, y= qta/1000, fill = sesso )) + 
  geom_bar(stat="identity", show_guide = F) +
  coord_flip() +
  ggtitle("residenti per macro-regione di nascita") + 
  xlab("Regione") + ylab("in migliaia") + scale_fill_brewer(palette="Set1")
```

![plot of chunk plot7](figure/plot7.png) 

La distribuzione delle eta' mostra una comunita' nata all'estero piu' giovane di quella che proviene dalle altre Regioni.   
Inoltre dai 50 anni in avanti la comunita' piu' grande e' quella dei nati in altre regioni dìItalia. 



```r
DT3 <- DT

myreg3<-levels(DT3$regione)
pieest<- c("Piemonte","ESTERO")
myreg3[!myreg3%in%pieest] <- c("AltreRegioni")
levels(DT3$regione)<- myreg3
DT3$regione<- as.factor(DT3$regione)


DT3 <- DT3 [ order(DT3$regione ),]

ggplot(data=DT3, aes(x=eta, y= nresidenti, fill=regione)) + 
  geom_bar(stat="identity" ) +
  ggtitle("distribuzione per eta") + 
  xlab("eta") + ylab("n. residenti") + theme(legend.position = "bottom") + 
  scale_fill_brewer(palette="Set2") + guides(fill=guide_legend(title=NULL))
```

![plot of chunk plot8](figure/plot8.png) 

La medesima informazione viene riportata mostrando il valore che ciascuna delle tre comunita' assume negli anni.


```r
DT3tot<-ddply(DT3, .(regione,eta), summarise,
             qta= sum(nresidenti))

ggplot(data=DT3tot, aes(x=eta, y= qta, color= regione)) + 
  geom_point (size=4) + geom_line() + theme(legend.position = "bottom") + 
  ggtitle("residenti per eta") +   xlab("eta") + ylab("n. residenti ") +
  scale_fill_brewer(palette="Set2") +   guides(color=guide_legend(title=NULL))
```

![plot of chunk plot9](figure/plot9.png) 



Si e' voluto riportare un dettaglio sulla fascia di eta' fra 60 ed 80 anni.   
All'eta' di 66 anni pare esistervi un calo di residenti. 



```r
DT6080t <- DT3tot [ DT3tot$eta> 59 & DT3tot$eta < 81 ,]

ggplot(data=DT6080t, aes(x=eta, y= qta, color= regione)) + 
  geom_point (size=4) + geom_line() + theme(legend.position = "bottom") + 
  ggtitle("residenti per eta") +   xlab("eta") + ylab("n. residenti ") +
  scale_fill_brewer(palette="Set2") +   guides(color=guide_legend(title=NULL))
```

![plot of chunk plot10](figure/plot10.png) 


