function kersim=kersim_kcmifs(a,x,e)
if e==0
   if (a==x)
            kersim=1;
        else
            kersim=0;
   end
else
      kersim=exp(-(a-x)^2/(2*e^2));    
end