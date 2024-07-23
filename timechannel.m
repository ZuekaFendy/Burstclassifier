function [sum_tm ] = timechannel(data_filt3,tm3)

siz=size(data_filt3);
tm3=siz(2);
%%%%%%detect burst through time channnel%%%
sum_tm=zeros(1,tm3);

for i=1:tm3
    sum_tm(i)=sum(data_filt3(:,i));%%the best plot by using summation of int coz all data int cantik plotting 
end

end




