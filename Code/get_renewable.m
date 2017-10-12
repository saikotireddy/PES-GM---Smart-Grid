function ren = get_renewable(input)


if input == 1 || input == 2 
    lambda = 2;
end
 if input ==3 || input == 4 
    lambda = 4;
 end
 
 if input ==5 || input == 6 
    lambda = 1;
 end
 
    if input == 7 || input == 8
    lambda = 1;
    end
    
    if input == 9 || input == 10
    lambda = 0;
    end
   
    ren = 0;
while(ren == 0)    
ren = poissrnd(lambda) ;
end
if ren > 4
    ren =4;
end


end