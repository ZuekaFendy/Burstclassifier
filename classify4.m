function [cl2_4 cl3_4 cl4_4] = classify4(gr2)

cl2_4=0;
cl3_4=0;
cl4_4=0;
if (gr2>=-0.1 && gr2<=4)
   cl2_4=1;
else
   cl2_4=0;
end

if (gr2>=-1.25 && gr2<1.0)
   cl3_4=1;
else
   cl3_4=0;
end

if (gr2>=-1.5 && gr2<1.0)
   cl4_4=1;
else
   cl4_4=0;
end

end



