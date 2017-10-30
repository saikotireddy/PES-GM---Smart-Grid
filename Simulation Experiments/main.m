% This is smart grid code for paper to be submitted for PES Gm.

clear;
clc;
%***********************************************************************
% We setup the model first. These are the values that can be modified.

no_of_agents = 2;
max_price = 5;
battery_size = [4 ;4] ; %Maximum Battery storage capacity of agent 1,2.

time_slices = 4 ; %Decision taken in a day at 10 time points.

max_renewable_power = [4;4];

demand = [1;3;5];  % Demand is a markov process for both the agents.

max_transferable_units = battery_size + max_renewable_power;
max_askable_units = max(demand)*ones(2,1) + battery_size;



%Now the initial confiuration of the system.
c_time = 1;

c_demand = [demand(randi(3)); demand(randi(3))];
c_battery = [randi(battery_size(1));randi(battery_size(2))];
c_renewable = get_renewable(c_time);

state1 = [c_demand(1) c_battery(1) c_renewable(1)];
state2 = [c_demand(2) c_battery(2) c_renewable];
state_index_1 = 1;
state_index_2 = 1;

%***********************************************************************

%************************************************************************
%Setting up Q-Learning Parameters

units1 =  max_askable_units(1)+1;
units2 = max_askable_units(2)+1;

Q_1 = zeros(time_slices,size(demand,1)* (battery_size(1)+1)* (max_renewable_power(1)+1),max_askable_units(1)+max_transferable_units(1)+1,(max_price +1));
Q_2 = zeros(time_slices,size(demand,1)* (battery_size(2)+1)*(max_renewable_power(2)+1),max_askable_units(2)+max_transferable_units(2)+1, (max_price +1));

initial_action = [0;0];



residual = 1;
alpha = 0.1;
discount = 0.9;

no_of_iterations = 100100;

%************************************************************************

for main_iter = 1:no_of_iterations

    
    new_demand = get_demand(c_demand);
    
    next_time = c_time +1;
    if next_time > 4
        next_time = 1;
    end
    
    
    
    new_renewable = get_renewable(next_time);
    

    
    
    index = 1;
    
    for i = -(c_demand(1)+battery_size(1)-c_battery(1)-c_renewable(1)):(c_renewable(1)+c_battery(1))
        
        modified_index = units1 + i;
        if i > 0
            for j = max_price:-1:0
            action_space(index,:) = Q_1(c_time,state_index_1,modified_index,j+1);
            action1(index,:) = i;
            action1_index(index,:) = modified_index;
            action2(index,:) = j;
             index = index +1;
            end
        else
            action_space(index,:) = Q_1(c_time,state_index_1,modified_index,max_price+1);
            action1(index,:) = i;
            action1_index(index,:) = modified_index;
            action2(index,:) = max_price;
           
           index = index +1;
    
        end
       
    end
    
    if (rand < 0.45 || (sum(action_space > 0) == 0)) && (main_iter < no_of_iterations-100)
    
        max_index = randi(index-1);
        
    else
        [maxx,max_index] = max(action_space);
    
    end
    
 effective_power = (c_renewable(1)+c_battery(1)-action1(max_index)) - c_demand(1);
 
 new_battery = min(battery_size(1),max(0,effective_power));
 
 reward = action1(max_index)*action2(max_index) + C1(action1(max_index),action2(max_index))*(effective_power) + residual;
 
 if main_iter > no_of_iterations - 100
 fprintf('%d. %d,%d,%d  %d,%d  %f\n',c_time,c_demand(1),c_renewable(1),c_battery(1),action1(max_index),action2(max_index),reward);
 pause;
 end
 
 vector1 = [new_demand(1),new_battery, new_renewable(1)];
 
 ind1 = find(ismember(state1,vector1,'rows')); 
 
 if isempty(ind1) 
 
     state_index2 = size(state1,1)+ 1;
     state1(state_index2,:) = vector1;
     
 else
     
     state_index2 = ind1;
 
 end
 
 clear action_space;
 index = 1;
    
    for i = -(new_demand(1)+battery_size(1)-new_battery):(new_renewable(1)+new_battery)
        
        modified_index = units1 + i;
        if i > 0
            for j = 0:max_price
            action_space(index) = Q_1(next_time,state_index2,modified_index,j+1);
            index = index +1;
            end
        else
            action_space(index) = Q_1(next_time,state_index2,modified_index,max_price+1);
    index = index +1;
        end
        
    end
 
 
 next_reward = max(action_space);
 if isempty(next_reward)
     next_reward = 0;
 end
 
 
 
 Q_1(c_time,state_index_1,action1_index(max_index),action2(max_index)+1) = (1-alpha)*Q_1(c_time,state_index_1,action1_index(max_index),action2(max_index)+1)+alpha*(reward + discount*next_reward);
 
 
 
 
 
    
 
    
    




clear action1;
clear action2;
clear action_space;
clear action1_index;

state_index_1 = state_index2;
c_renewable = new_renewable;
c_demand = new_demand;
c_battery = [new_battery;0];
c_time = next_time;

end














