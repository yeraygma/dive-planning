#DIVING MANAGER SOFTWARE PROJECT DMS

#Gas Management section

#Total gas volume calculation script
#Goal: calculates the gas volume consumed along the dive, calculates the min tanks volume (in order to choose the optimal tanks) at a given tank refilled preassure, and depths for minimum DECO stops

rm(list=ls()) #clear workspace
graphics.off() 
#libraries


#SET WORKING DIRECTORY AND LOAD DATA FILE
setwd("D:\\PROYECTOS_CCM\\Investigacion\\ProyectoDMS\\R")

#Variables definition
#Tb=bottom time;Tvol= Min tank volume; Fp=tank fill preassure; SCR=Surface Consumtion Rate;A; SCRs=SCR stress stuation
#Dmax=Max depth in ATA; Dad=average bottom depth in AT; Dav=average depth in ATA;Tas=total ascention time;; Vtg=total gas volume consumed per diver
#S=penetration strategy (S can be=1 if strategy is all available gas, S=2 if rule of halve or S=3 if rule of thirds RT=3)

#Outcome variable Vtg=Total gas volume; Tas=total ascencion time; MDS=Minimun DECO stops
#Income variables Tb,Dab,Dmax

##insert INCOME VARIABLES values
Tb<-40
Dad<-2.8
Dmax<-2.8
S<-1
Fp<-200 #tanks initial preassure in BAR
  
#setting up parameters
SCR<-20 #this values can be adjusted 
SCRs<-30#this values can be adjusted
Dav<-(Dmax/2)+0.5

#Transform ATA in meters for Dmax and Dab to insert in results table
Dmax2<-(Dmax-1)*10
Dad2<-(Dad-1)*10


#Sub-script DECO stops (and ascension times)
#d,e,f,g,h are colume values of the table that shows the numbers of DECO stops

a<-ceiling(((Dav-1)*10)/9) #transform ATA into meters and calculate how many minutes gets to reach first half of the depth
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

#End of sub-code DECO stops

#Calculate Volume of consumed gas

Vtg<-((Tb*SCR*Dad)+(SCRs*Dav*Tas*2))*S

#Calculate min tank volume
Tvol<-Vtg/Fp


 
#create and write a csv file with results of MDS

p<-matrix(c(Tb,Dmax2,Dad2,Fp,S,SCR,SCRs),ncol=7,byrow=TRUE)
rownames(p)<-("Parameters")
colnames(p)<-c("Bottom time (')","Max depth (m)","Average bottom depth (m)","tanks initial preassure (BAR)","strategy","SCR","stressedSCR")

r<-matrix(c(Tvol,Vtg,Tas,d,e,f,g,h),ncol=8,byrow=TRUE)
rownames(r)<-("Results")
colnames(r)<-c("Min tank volume","Total gas","Ascension time","Depth stop1","D_stop2","D_stop3","D_stop4","D_stop5")




#hay que pulir la escritura de parametros y resultados en el mismo archivo csv
write.csv(p,file='D:\\PROYECTOS_CCM\\Investigacion\\ProyectoDMS\\R\\scripts\\results\\totalgasvolume\\parameters.csv')
write.csv(r,file='D:\\PROYECTOS_CCM\\Investigacion\\ProyectoDMS\\R\\scripts\\results\\totalgasvolume\\results.csv')
#intentando insertar las dos matrices de resultados en el mismo csv






