function [cl2_2 cl3_2 cl4_2] = classify2(totalchangestime)

cl2_2=0;
cl3_2=0;
cl4_2=0;
if (totalchangestime >=150 && totalchangestime <=600)
   cl2_2=1;
else
   cl2_2=0;
end

if (totalchangestime >=0 && totalchangestime <=300)
   cl3_2=1;
else
   cl3_2=0;
end

if (totalchangestime >=150 && totalchangestime <=899)
   cl4_2=1;
else
   cl4_2=0;
end

end



