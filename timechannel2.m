function [sum_tmc ] = timechannel2(data_compress,tm3compres)

siz=size(data_compress);
tm3compres=siz(2);
%%%%%%detect burst through time channnel%%%
sum_tmc=zeros(1,tm3compres);

for i=1:tm3compres
    sum_tmc(i)=sum(data_compress(:,i));%%the best plot by using summation of int coz all data int cantik plotting 
end

end




