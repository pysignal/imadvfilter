% Funzione filtro adattivo locale avanzato
% function R=imadvfilter(I,dim,vR,d)
% 
% Input: 
% I = matrice contenente l'immagine
% dim = dimensione filtro
% vR = varianza rumore immagine
% d = valore di soglia per applicazione algoritmo di rifinitura

function R=imadvfilter(I,dim,vR,d)
if vR==0
	R=I;
    return;
end

pd=(dim-1)/2;
padI=im2double(padarray(I,[pd,pd],'replicate','both'));

if d<1
    d=1;
end

[xmax, ymax]= size(padI);

padIR=padI;

for i=pd+1:xmax-pd
    for j=pd+1:ymax-pd
        S=padI(i-pd:i+pd,j-pd:j+pd);      
        vl=var(S(:),1);
        
        if pd>1 && vl/vR>d
            padIR(i,j)=centerpoint(S,pd,vR,d);
        else
            if vR>vl
                vl=vR;
            end                 
            ml=mean(S(:));
            z=padIR(i,j);
            padIR(i,j)=z-vR/vl*(z-ml);
        end
    end
end

depadI=(padIR(pd+1:end-pd,pd+1:end-pd));
depadI=im2uint8(depadI);

if isa(I,'double')
    depadI=im2double(depadI);
end
R=depadI;
end

% funzione di rifinitura per le zone ricche di particolari
function p=centerpoint(I,pd,vR,d)
center=pd+1;
newpd=ceil(pd/2);
padI=I(center-newpd:center+newpd,center-newpd:center+newpd);
vl=var(padI(:),1);
if newpd>1 && vl/vR > d
    p=centerpoint(padI,newpd,vR,d);
else
    z=I(center,center);
    ml=mean(padI(:));
    if vl>vR
        p=z-vR/vl*(z-ml);
    else
        p=ml;
    end
end
end


