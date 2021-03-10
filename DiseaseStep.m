function [Sout,Iout,Rout,Dout] = DiseaseStep(Sin,Iin,Rin,h,a,b,N,dr)
%calculates a time step
dSdt=-a*Sin*Iin/N;
dIdt=(a*Sin*Iin/N)-(Iin/b)-(dr*Iin);
dRdt=Iin/b;
    Sout=Sin+h*dSdt;
    Iout=Iin+h*dIdt;
    Rout=Rin+h*dRdt;
    Dout=h*dr*Iin;
end