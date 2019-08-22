#DIVING MANAGER SOFTWARE PROJECT DMS

#Gas Management section

#Bottom time calculation
#Goal: calculates the bottom time for a given tank volume, tank fill preassure, max bottom depth, average bottom depth and penetration strategy.

rm(list=ls()) #clear workspace  
graphics.off() 
#libraries


#SET WORKING DIRECTORY AND LOAD DATA FILE
setwd("D:\\R")

#Income Variables definition
#Tb=Bottom time; Tvol= Min tank volume; Fp=tank fill preassure; SCR=Surface Consumtion Rate;A; SCRs=SCR stress stuation
#Dmax=Max depth in ATA; Dad=average bottom depth in AT; Dav=average depth for whole diving profile in ATA;Tas=total ascention time;
#S=penetration strategy (S can be=1 if strategy is all available gas, S=2 if rule of halves or S=3 if rule of thirds RT=3)

#Outcome variables definition
#Vtg=Total gas volume; Tas=total ascencion time; MDS=Minimun DECO stops
#Income variables Tb,Dab,Dmax




##insert INCOME VARIABLES values
Tvol<-15
Fp<-220
Dmax<-4.3
Dad<-4.3   #!!!in case this is unknown MUST BE ENTERED Dmax as Dab
S<-1

Pmax <- (Dmax-1)*10
Dav<-((Pmax/2)/10) + 1

#setting up parameters
SCR<-20 #default value.But can be adjusted to a specific diver
SCRs<-30 #default value.But can be adjusted to a specific diver



  
#Calculate Average depth  
Pav<-(Pmax/2)

#Sub-script DECO stops (and ascension times)
#d,e,f,g,h are colume values of the table that shows the numbers of DECO stops

#---------------------------Versión corregida
a<-ceiling(Pav/9) #transform ATA into meters and calculate how many minutes gets to reach first half of the depth
b<-ceiling(Pav/3) #transform ATA into meters and calculate how many minutes gets to reach first half of the depth


Pstop1 = ceiling(((Dmax-1)*10)/2) # mitad de la profundidad máxima; y primera parada en el ascenso
Pstop2 = Pstop1 - 3 # segunda parada y así sucesivamente
Pstop3 = Pstop2 - 3
Pstop4 = Pstop3 -3

tstop1 <- ceiling(Pstop1/9) # tiempo hasta la primera parada desde el fondo. 
Pmax <- (Dmax-1)*10 # profundidad máxima en metros
b  <- (Pmax-Pstop1)/3 #tiempo de ascenso desde la primera parada hasta la superficie

Tas = tstop1 + b #Tiempo total de ascenso

tstop2 <- 1 #tiempo desde la primera parada hasta la segunda
tstop3 <- 1

#---------------------------
-ceiling(((Dav-1)*10)/9) #transform ATA into meters and calculate how many minutes gets to reach first half of the depth
b<-ceiling(((Dav-1)*10)/3) #transform ATA into meters and calculate how many minutes gets to reach first half of the depth
Tas<-1+a+b

d<-ceiling((Dav-1)*10)
if (d<0) d=0
e<-ceiling(((Dav-1)*10)-3)
if (e<0) e=0
f<-ceiling(((Dav-1)*10)-6)
if (f<0) f=0
g<-ceiling(((Dav-1)*10)-9)
if (g<0)  g=0
h<-ceiling(((Dav-1)*10)-12)
if (h<0)  h=0
#------------------------------

#Minimum gas calculation in BAR
MG<-(SCRs*Dav*Tas*2)/Tvol

#Usable gas in BAR

UG<-(Fp-MG)

#Turn preassure  HAY QUE REVISAR ESTO ESTA MAL
if(S==1) {TP<-NA} else {TP<-Fp-(UG/S)}

#Calculate bottom time
Tb<-(UG*Tvol)/(SCR*Dad)

#Transform ATA in meters for Dmax and Dab to insert in results table
Dmax2<-(Dmax-1)*10
Dad2<-(Dad-1)*10

if (S==1) {
  q<-"All available"
} else {
if (S==2) {q<-"Rule of halves"
} else {
  if (S==3) q<-"Rule of thirds"
}
}

##parameters matrix
p<-matrix(c(Fp,Dmax2,Dad2,q,SCR,SCRs),ncol=6,byrow=TRUE)
rownames(p)<-("Parameters")
colnames(p)<-c("Filled preassure(BAR)","Max depth(m)","Average bottom depth(m)","strategy","SCR(lt/min)","stressedSCR(lit/min)")

#results matrix
r<-matrix(c(Tb,MG,TP,UG,Tas,Pstop1,tstop1,tstop2, tstop3),ncol=9,byrow=TRUE)
rownames(r)<-("Results")
colnames(r)<-c("Bottom time (')","Minimum gas","Turn preassure","Usable gas","Total ascenst time", "first stop depth","first stop time", "second stop time", "third stop time")

#hay que pulir la escritura de parametros y resultados en el mismo archivo csv
write.table(p,file='D:\\R\\results\\buceo\\bottom_time\\parameters.csv', sep = ",")
write.csv(r,file='D:\\R\\results\\buceo\\bottom_time\\results.csv')

