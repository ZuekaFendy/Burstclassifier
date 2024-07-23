
function [arr max_v temp]=distribution(data_complete,fn,tm)
for i=1:fn
    for j=1:tm
        data_complete(i,j)=ceil(data_complete(i,j));
    end
end
temp=zeros(1,fn);
for x=1:fn
    temp(x)=max(data_complete(x,:));
end

max_v=max(temp);

arr=zeros(max_v+1,1);
for i=1:fn
    for j=1:tm
        for k=0:max_v
            if(data_complete(i,j)==k)
                arr(k+1)=arr(k+1)+1;
            
            end
        end
    end
end

