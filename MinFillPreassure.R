#DIVING MANAGER SOFTWARE PROJECT DMS

#Gas Management section

#Minnumun Fill Preasure calculation script
#Goal: calculate Minumum Fill Preasure (MFP) for a determined bottom time, tank volume, depth and strategy

rm(list=ls()) #clear workspace
graphics.off() 
#libraries


#SET WORKING DIRECTORY AND LOAD DATA FILE
setwd("D:\\Proyectos\\ProyectoDMS\\R")

#Variables definition
#Tv=Tanks volume; Tb=bottom time; Tvol= Min tank volume; Fp=tank fill preassure; SCR=Surface Consumtion Rate; SCRs=SCR stress stuation
#Dmax=Max depth in ATA; Dav=average depth in ATA;Dad=average of bottom depth in ATA;Tas=total ascention time; Vtg=total gas volume consumed per diver
#S=penetration strategy (S can be=1 if strategy is all available gas, S=2 if rule of halve or S=3 if rule of thirds RT=3)

#Outcome variable Vtg=Total gas volume; Tas=total ascencion time; MDS=Minimun DECO stops
#Income variables Tb,Dab,Dmax

##insert INCOME VARIABLES values
Tb<-22
Dad<-3.3
Dmax<-3.3
S<-1
Tvol<-12


#setting up parameters
SCR<-20 #this values can be adjusted 
SCRs<-30#this values can be adjusted


#Transform ATA in meters for Dmax and Dab to insert in results table

Dad2<-(Dad-1)*10 # profundidad en en fondo media (Bottom average depth)
Pmax <- (Dmax-1)*10#profundidad máxima en mt
Pav<-(Pmax/2)#profundidad media en mt
Dav<-((Pmax/2)/10) + 1

#Sub-script DECO stops (and ascension times)
#d,e,f,g,h are colume values of the table that shows the numbers of DECO stops

#---------------------------Versión corregida
a<-ceiling(Pav/9) #transform ATA into meters and calculate how many minutes gets to reach first half of the depth
b<-ceiling(Pav/3) #transform ATA into meters and calculate how many minutes gets to reach first half of the depth
Tas<-a+b


#Calculate Volume of consumed gas

Vtg<-((Tb*SCR*Dad)+(SCRs*Dav*(Tas +1)*2))*S

#Calculate MFP

Fp<-Vtg/Tvol


#create and write a csv file with results of MFP
#parameters matrix
p<-matrix(c(Tb,Pmax,Dad2,Tvol,S,SCR,SCRs),ncol=7,byrow=TRUE)
rownames(p)<-("Parameters")
colnames(p)<-c("Bottom time (')","Max depth (m)","Average max depth (m)","tanks volume", "strategy","SCR","stressedSCR")

#results matrix
r<-matrix(c(Fp,Tas),ncol=2,byrow=TRUE)
rownames(r)<-("Results")
colnames(r)<-c("Filled preassure","Ascension time")

#hay que pulir la escritura de parametros y resultados en el mismo archivo csv
write.csv(p,file='D:\\R\\results\\buceo\\Min_Fill_Preassure\\parameters.csv')
write.csv(r,file='D:\\R\\results\\buceo\\Min_Fill_Preassure\\results.csv')




#hay que unir las dos tablas de parametros y resultados en un csv