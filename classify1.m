function [cl2_1 cl3_1 cl4_1] = classify1(totalchangesfrequency)

cl2_1=0;
cl3_1=0;
cl4_1=0;
if (totalchangesfrequency >=35 && totalchangesfrequency <=170)
   cl2_1=1;
else
   cl2_1=0;
end


if (totalchangesfrequency >=105 && totalchangesfrequency <=199)
   cl3_1=1;
else
   cl3_1=0;
end

if (totalchangesfrequency >=70 && totalchangesfrequency <=199)
   cl4_1=1;
else
   cl4_1=0;
end

end

