clear;
clc;
global demand_values;
global price_vector;
global max_renewable;
global P;
global P2;

%demand_values = [2;4;6];

max_battery = 4;
%max_renewable = 4;

min_state = max(demand_values);
max_state = max_battery + max_renewable - min(demand_values);

total_state_units = min_state + max_state+1;


max_givable = max_battery + max_renewable;
max_askable = max(demand_values) + max_battery;

total_decision_units = max_givable + max_askable + 1;

%price_vector = [5;10;15];
time_stamp = 4;

Q = zeros(time_stamp,total_state_units,size(price_vector,1),total_decision_units);

no_of_iterations = 100100;

demand = 2;
price = 5;
battery = 0;
time = 1;


ren = get_renewable(time);

alpha = 0.1;
discount = 0.6;
c = max(price_vector)+100;
total_reward = 0;

%**********************************************************************
% d_size = size(demand_values,1);
% p_size = size(price_vector,1);
% 
% %t_size = d_size * p_size;
% 
% P = zeros(d_size,d_size);
% P2 = zeros(p_size,p_size);
% 
% for i = 1:d_size
%     
%    P(i,:) = rand(d_size,1);
%    P(i,:) = P(i,:)/sum(P(i,:));
% end
% 
% for i = 1:p_size
%     
%    P2(i,:) = rand(p_size,1);
%    P2(i,:) = P2(i,:)/sum(P2(i,:));
% end




%P = [    0.1579    0.3473    0.4948;
 %   0.2092    0.5410    0.2498;
  %  0.3741    0.4441    0.1818];



%P2 =  [   0.3016    0.4100    0.2884;
   % 0.6925    0.2470    0.0605;
   % 0.4901    0.4241    0.0859];



%*************************************************************************



for main_iter = 1:no_of_iterations

    quasi_state = (battery + ren) - demand;
    state1 = quasi_state + 1 + min_state;
    state2 = find(ismember(price_vector,price,'rows'));
    
    if quasi_state <= 0
    
        %action_set = (quasi_state-max_battery : 0) + max_askable+1;
        diff_power = max(-4,quasi_state - max_battery);
        action_set = (diff_power : 0) + max_askable+1;
        
    else
        
        rem_battery = max_battery - battery;
        
        unfilled_units = quasi_state - rem_battery;
       
       if unfilled_units >= 0
       
             action_set = unfilled_units + max_askable + 1; 
           
           
            
       
       
       else
           
           action_set = (unfilled_units : 0) + max_askable + 1;
           
       end
       
        
      %  action_set = max(0,quasi_state - rem_battery)+ max_askable+1;
        
    end
    
    if rand() < 0.6 && main_iter < no_of_iterations - 100
        
        max_index = randi([min(action_set) max(action_set)]);
    else
        
        [~,quasi_max_index] = max(Q(time,state1,state2,action_set));    
        
        max_index = action_set(quasi_max_index);
        
    end
    
    action_taken = max_index - (max_askable+1);
    
    [next_demand,next_price] = get_next(demand,price);
    
    next_time = time +1 ;
    if next_time > 4
        next_time = 1;
    end
    
    next_ren = get_renewable(next_time);
    
    next_battery = max(battery+ren - action_taken - demand,0);
    
    if main_iter > no_of_iterations - 100
    fprintf('time : %d dem: %d ren: %d battery: %d state: %d Price: %d action_taken: %d nextbatt: %d \n', time,demand,ren,battery,quasi_state,price,action_taken,next_battery);
    pause;
    total_reward = total_reward + reward;
    end
    %*******************************************************************
    
    next_quasi_state = (next_battery + next_ren) - next_demand;
    next_state1 = next_quasi_state + 1 + min_state;
    next_state2 = find(ismember(price_vector,next_price,'rows'));
    
    if next_quasi_state <= 0
    
        next_action_set = (next_quasi_state-max_battery : next_quasi_state) + max_askable+1;
        
    else
        
        next_rem_battery = max_battery - next_battery;
        
        next_action_set = max(0,next_quasi_state - next_rem_battery) + max_askable+1;
        
    end
    
    next_max_reward =  max(Q(next_time,next_state1,next_state2,next_action_set));
    
    %*******************************************************************
    
    reward = action_taken*price + c*(min(0,(battery+ren-action_taken) - demand));
    
    %Write Q-Update
    
    Q(time,state1,state2,max_index) = (1-alpha)*Q(time,state1,state2,max_index) + alpha*(reward + discount*next_max_reward);
   
    
    demand = next_demand;
    battery = next_battery;
    ren = next_ren;
    time = next_time;
    price = next_price;
    
    
     if rem(main_iter,100) == 0
     
        demand = demand_values (randi(3));
        battery = randi(4);
        ren = randi(4);
        time = randi(4);
        price = price_vector(randi(3));
    
    end
    
    
    
  %  total_reward = total_reward + reward;
end

fprintf('Average Reward is %f\n',total_reward);%/no_of_iterations);

