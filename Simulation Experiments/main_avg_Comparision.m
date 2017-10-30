clear;
clc;
global demand_values;
global price_vector;
global max_renewable;
global P;
global P2;

%Full_Demand = [6;8;10]

%ADL1 = [1 2]
%ADL2 = [1 3]
%ADL3 = [2 4]

demand_values = [2;4;6];

full_demand_values = [6;8;10];

ADL_levels = 3 + 1;

total_ADL_actions = 3 +1;

max_battery = 6;
max_renewable = 8;

min_state = max(demand_values);
max_state = max_battery + max_renewable - min(demand_values);

total_state_units = min_state + max_state+1;


max_givable = max_battery + max_renewable;
max_askable = max(full_demand_values) + max_battery;
%max_askable = 8;


total_decision_units = max_givable + max_askable + 1;

price_vector = [5;10;15];
time_stamp = 4;

Q = zeros(time_stamp,total_state_units,ADL_levels,size(price_vector,1),total_decision_units,total_ADL_actions);
count_Q = ones(time_stamp,total_state_units,ADL_levels,size(price_vector,1),total_decision_units,total_ADL_actions);

no_of_iterations = 10000100;

adl_units(1) = 1;
adl_units(2) = 1;
adl_units(3) = 2;
adl_units(4) = 0;



demand = 2;
adl = 1;
price = 5;
battery = 0;
time = 1;


ren = get_renewable(1,time);

%alpha = 1;
%alpha = 1;
initial_constant = 1000;
discount = 0.6;
c = max(price_vector) + 15;
total_reward = 0;

constant_time = 4;
constant_state = 2 + min_state +1;
constant_price = 3;
constant_adl = 4;
constant_adl_action = 4;

constant_action_set = (-4:2) + max_askable+1;


%**********************************************************************
d_size = size(demand_values,1);
p_size = size(price_vector,1);

%t_size = d_size * p_size;

P = zeros(d_size,d_size);
P2 = zeros(p_size,p_size);

for i = 1:d_size
    
   P(i,:) = rand(d_size,1);
   P(i,:) = P(i,:)/sum(P(i,:));
end

for i = 1:p_size
    
   P2(i,:) = rand(p_size,1);
   P2(i,:) = P2(i,:)/sum(P2(i,:));
end




% P = [    0.1579    0.3473    0.4948;
%     0.2092    0.5410    0.2498;
%     0.3741    0.4441    0.1818];
% 
% 
% 
% P2 =  [   0.3016    0.4100    0.2884;
%     0.6925    0.2470    0.0605;
%     0.4901    0.4241    0.0859];


%   P =  [ 0.6069    0.3484    0.0447;
%     0.1498    0.7879    0.0623;
%     0.1697    0.1027    0.7276;];
% 
% 
% 
%  P2 =  [  0.4632    0.2906    0.2462;
%     0.5376    0.2170    0.2454;
%     0.4762    0.0388    0.4850;];





%*************************************************************************



for main_iter = 1:no_of_iterations
    
    
%      demand = demand_values (randi(3));
%         battery = randi(4);
%         ren = randi(4);
%         time = randi(2);
%         price = price_vector(randi(3));
    
    
    
    
%     for j = adl:3
%     
%         adl_demand = adl_demand + adl_units(j);
%         
%     end
%     
 %   real_demand = demand + adl_demand;

    quasi_state = (battery + ren) - demand; % real_demand;
    
   
    
    state1 = quasi_state  + 1 + min_state;
    state2 = find(ismember(price_vector,price,'rows'),1);
    
    if quasi_state <= 0
    
         
        diff_power = max(-max_askable,quasi_state - max_battery);
        action_set = (diff_power : 0) + max_askable+1;
        
    else
        
        extra_power =  quasi_state - max_battery;
        
        if extra_power < 0 
        
        action_set = (extra_power : 0) + max_askable + 1;
        
        else
            action_set = extra_power + max_askable+1;
            
        end
        
        
        
    end
    
  %  action_set  = action_set - adl_action_demand;
    
    
 %   if main_iter < no_of_iterations - 100
    if rand() < 0.6 && main_iter < no_of_iterations - 100
        
        adl_action = randi([adl 4]);
        max_index = randi([min(action_set) max(action_set)]);
    else
        
        adl_set = [adl:4];
        
        if size(action_set,2) > 1
        [~,quasi_max_index] = max(Q(time,state1,adl,state2,action_set,adl_set));    
        
       [~, adl_action] = max(max(Q(time,state1,adl,state2,action_set,adl_set)));
        
        max_index = action_set(quasi_max_index(1));
        
        adl_action = adl_set(adl_action);
        else
        
            max_index = action_set;
            
             [~, adl_action] = max(Q(time,state1,adl,state2,action_set,adl_set));
             
            adl_action = adl_set(adl_action);
            
            
            
        end
    end
%     else
%         
%         [~,quasi_max_index] = max(count_Q(time,state1,state2,action_set));    
%         
%         max_index = action_set(quasi_max_index);
%     end
    


    
    
    adl_action_demand = 0;
    
    if adl_action < 4
    for j = adl:adl_action
    
    
        adl_action_demand = adl_action_demand +  adl_units(j);
        
    end
    end
    
    real_demand = demand + adl_action_demand;












    action_taken = max_index - (max_askable+1);
    
    [next_demand,next_price] = get_next(demand,price);
    
    
    
    
    
    
    
   % nd = (battery + ren - action_taken) - demand;
    
    
    % Update this. 
    
%     if nd > 0
%         
%         rem_adl = max(0,adl_demand - nd);
%         nd = max(0,nd - adl_demand);
%         
%     else
%         rem_adl = adl_demand;
%   
%     end
%     
%     if rem_adl == 3
%     
%         next_adl = 1;
%     elseif rem_adl == 2 
%             next_adl = 2;
%     
%     elseif rem_adl == 0
%                 next_adl = 4;
%             else
%                 next_adl = adl;
%     end
%     
%     penalty = 0;

if adl == 4
    next_adl = 4;
elseif adl_action == 4
  
    next_adl = adl;
else
    next_adl = adl_action + 1;
end


    penalty = 0;

    if time == 2 && next_adl == 1
        penalty = 1;
       % next_adl = 2;
    elseif time ==3 && next_adl == 1
        penalty = 2;
        %next_adl = 3;
    elseif time == 3 && next_adl == 2
        penalty = 1;
        %next_adl = 3;
    elseif time == 4 && next_adl == 1
        penalty = 4;
        %next_adl = 1;
    elseif time == 4 && next_adl == 2
        penalty = 3;
        %next_adl = 1;
    elseif time == 4 && next_adl == 3
        penalty = 2;
        %next_adl = 1;
    end
%     
%          
%     next_adl_demand = 0;    
%         
%     for j = next_adl:3
%     
%         next_adl_demand = next_adl_demand + adl_units(j);
%         
%     end 
        
        
    
    
    
    next_time = time +1 ;
    if next_time > 4
        next_adl = 1;
        next_time = 1;
    end
    
    next_ren = get_renewable(1,next_time);
    

    real_action = action_taken - adl_action_demand;
    
    
    next_battery = max(battery+ren - real_action - real_demand,0);
   
    reward = (real_action)*price + c*(min(0,(battery+ren-action_taken) - demand) - penalty);
    
    if main_iter > no_of_iterations - 100
    fprintf('time : %d dem: %d ren: %d battery: %d state: %d  ADL : %d Price: %d action_taken: %d nextbatt: %d adl_action: %d \n', time,demand,ren,battery,quasi_state,adl,price,action_taken,next_battery,adl_action);
    pause;
    total_reward = total_reward + reward;
    end
    %*******************************************************************
    
%    next_real_demand = next_demand + next_adl_demand;
    
    next_quasi_state = (next_battery + next_ren) - next_demand; % next_real_demand;
    next_state1 = next_quasi_state + 1 + min_state;
    next_state2 = find(ismember(price_vector,next_price,'rows'),1);
    
    if next_quasi_state <= 0
    
        next_diff_power =  max(-max_askable,next_quasi_state-max_battery);
        next_action_set = (next_diff_power : 0) + max_askable+1;
        
    else
        
      %  next_rem_battery = max_battery - next_battery;
        
       % next_action_set = (next_quasi_state - next_rem_battery : next_quasi_state) + max_askable+1;
        
       next_extra_power =  next_quasi_state - max_battery;
        
        if next_extra_power < 0 
        
        next_action_set = (next_extra_power : 0) + max_askable + 1;
        
        else
            next_action_set = next_extra_power + max_askable+1;
            
        end        
   
       
    end
    
    next_max_reward =  max(max(Q(next_time,next_state1,next_adl,next_state2,next_action_set,[next_adl :4])));
    
    %*******************************************************************
    
    %+ penalty);
    
    %Write Q-Update
    
    alpha = 1/(count_Q(time,state1,adl,state2,max_index,adl_action));
    
    Q(time,state1,adl,state2,max_index,adl_action) = (1-alpha)*Q(time,state1,adl,state2,max_index,adl_action) + alpha*(reward + next_max_reward - max(Q(constant_time,constant_state,constant_adl,constant_price,constant_action_set,constant_adl_action)));
    count_Q(time,state1,adl,state2,max_index,adl_action) = count_Q(time,state1,adl,state2,max_index,adl_action) + 1; 
    
    demand = next_demand;
    battery = next_battery;
    ren = next_ren;
    time = next_time;
    price = next_price;
    adl = next_adl;
%     
    if rem(main_iter,100) == 0
     
        demand = 6; %demand_values (randi(3));
        battery = 4;%randi(4);
        ren = 4;%randi(4);
        time = 4;%randi(4);
        price = 15;%price_vector(randi(3));
        adl = 4;
    end
    
   % alpha = initial_constant/main_iter;
    
    
   % total_reward = total_reward + reward;
end

fprintf('Average Reward is %f\n',total_reward);%/no_of_iterations);

