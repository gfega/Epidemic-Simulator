function [sHolder,iHolder,rHolder,dHolder,time] = DiseaseSimulate(SStart,IStart,RStart,h,a,b,nSteps,dr)
%this will give the output arrays for plotting

S=SStart;
I=IStart;
R=RStart;
D=0;

sHolder=zeros(1,nSteps+1); sHolder(1)=S;
iHolder=zeros(1,nSteps+1); iHolder(1)=I;
rHolder=zeros(1,nSteps+1); rHolder(1)=R;
dHolder=zeros(1,nSteps+1); dHolder(1)=D;

for x=1:nSteps
    N=S+I+R;
    [Sout Iout Rout,Dout]=DiseaseStep(S,I,R,h,a,b,N,dr);
    sHolder(x+1)=Sout;
    iHolder(x+1)=Iout;
    rHolder(x+1)=Rout;
    dHolder(x+1)=dHolder(x)+Dout;
    
    S=sHolder(x+1);
    I=iHolder(x+1);
    R=rHolder(x+1);
    N=S+I+R;
end

time=1:nSteps+1;