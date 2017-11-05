clear;
store(1) = load('multiagent_main.mat','store_reward');
store(2) = load('multiagent_comp1.mat','store_reward');
store(3) = load('multiagent_comp3.mat','store_reward');


no_of_agents = 3;
no_of_iterations = 10001000;

for main_index = 1:3
    
    store_reward = struct2array(store(1,main_index));
    
for index = 1:no_of_agents
beta = 100;
mgl = store_reward(2,index,:); % 2 inidcates cost = 10;
cum_mgl = cumsum(mgl);
for j = 1:size(mgl,3)
norm_mgl(main_index,index,j) = cum_mgl(1,1,j)/beta;
beta = beta + 100;
end
end

x_indices = [100:100:no_of_iterations];

end


for i = 1:no_of_agents
    
    subplot(1,3,i);

 
   plot(x_indices,reshape(norm_mgl(1,i,:),[1 no_of_iterations/100]),'-b');
   hold on;
   plot(x_indices,reshape(norm_mgl(2,i,:),[1 no_of_iterations/100]),'-r');
 %  hold on;
 %  plot(x_indices,reshape(norm_mgl(3,i,:),[1 no_of_iterations/100]),'-g');
   
    xl = xlabel('No\_of\_iterations');
    yl = ylabel('Average Profit obtained so far');
        
 %set(xl,'FontSize',12,'FontWeight','bold');
%set(yl,'FontSize',12,'FontWeight','bold');
legend('ADL-sharing model','Greedy-ADl model','Non-ADL model')
if i==1
title('Microgrid-1');
elseif i == 2
    title('Microgrid-2');
else
    title('Microgrid-3');
end
hold off;
   
end