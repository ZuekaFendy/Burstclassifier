function [frq_fnc] = frequencychannel2(data_compress,fn3compres)

%%%%detect burst through frequency channel%%%%%%
frq_fnc=zeros(1,fn3compres);

for x=1:fn3compres
    frq_fnc(x)=sum(data_compress(x,:));
end
 
end



   


        















