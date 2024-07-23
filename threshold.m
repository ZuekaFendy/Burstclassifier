 
 function [cont half data_fn]=threshold(arr,max_v,data_complete,cn,tm)


max_arr=max(arr);
cont=1;
for i=1:max_v+1
    
    if (max_arr==arr(i))
        break;
    else
        cont=cont+1;
    end
end

half=ceil(arr(cont)/4);
for i=cont+1:max_v+1
    
    if (arr(i)<=half)
        break;
    else
        cont=cont+1;
    end
end

data_fn=data_complete;

for i=1:cn
    for j=1:tm
        if (data_fn(i,j)<=cont)
            data_fn(i,j)=0;
        end
    end
end
        
    



