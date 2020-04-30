function [x] = decToBin(dividendo)
divisor=2;
cociente=0;
residuo=0; 
a=0;
i=1;
j=1;
b=1;
c=2;
x=0;1;

residuo=dividendo;
while c>1
    while residuo>=divisor
        cociente=cociente+1;
        residuo=residuo-divisor;
    end
    a(j,i)= residuo;
    i=i+1;
    residuo=cociente;
    c=cociente;
    cociente=0;
    
end
a(j,i)=c;   
f=i;
while b<=i
    x(j,b)=a(j,f);
    f=f-1;
    b=b+1;
end
end

