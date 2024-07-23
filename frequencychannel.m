function [frq_fn ] = frequencychannel(data_filt3,fn3)

%%%%detect burst through frequency channel%%%%%%
frq_fn=zeros(1,fn3);

for x=1:fn3
    frq_fn(x)=sum(data_filt3(x,:));
end
 
end



   


        















