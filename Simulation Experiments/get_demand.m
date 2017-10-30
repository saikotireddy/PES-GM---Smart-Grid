function demand = get_demand(input)

consVec = [1;3;5];



prob = [0.1 0.6 0.3; 0.3 0.1 0.6; 0.6 0.3 0.1];

if input(1) == 1
    temp = 1;
else if input(1) == 3
        temp = 2;
    else if input(1) == 5
            temp = 3;
        end
    end
end

mat = prob(temp,:);

mat2 = cumsum(mat) ;
x = rand();
%fprintf('\n random is %f\n',x);
temp2 = find(mat2 > x , 1);

demand = [consVec(temp2);0];



end