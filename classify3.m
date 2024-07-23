function [cl2_3 cl3_3 cl4_3] = classify3(gr1)

cl2_3=0;
cl3_3=0;
cl4_3=0;
if (gr1>=0 && gr1<=8)
   cl2_3=1;
else
   cl2_3=0;
end

if (gr1>=-0.2 && gr1<=0.5)
   cl3_3=1;
else
   cl3_3=0;
end

if (gr1>=-0.6 && gr1<1)
   cl4_3=1;
else
   cl4_3=0;
end

end



