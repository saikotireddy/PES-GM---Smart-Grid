clear;


c = [0;5;10;30];

sharing_adl(1,:) = [13.995;0.570;-4.000;-4.980];
sharing_adl(2,:) = [15.045;4.380;5.220;4.785];
sharing_adl(3,:) = [21.455;8.895;6.290;5.740];

nonadl(1,:) = [13.690;-0.125;-6.365;-7.775];
nonadl(2,:) = [8.675;1.405;2.930;2.900];
nonadl(3,:) = [20.220;8.660;3.375;1.940];

nonsharing(1,:) = [0.160;-12.850;-18.275;-20.940];
nonsharing(2,:) = [0.335;-8.120;-10.765;-14.350];
nonsharing(3,:) = [2.555;-4.735;-6.675;-7.825];



for i = 1:3
   
subplot(1,3,i);
plot(c,sharing_adl(i,:),'--bo','LineWidth',2.5);
hold on;
plot(c,nonadl(i,:),'--r*','LineWidth',2.5);
hold on;
plot(c,nonsharing(i,:),'--g*','LineWidth',2.5);
xl = xlabel('c');
yl = ylabel('Average Profit obtained');
set(xl,'FontSize',32,'FontWeight','bold');
set(yl,'FontSize',32,'FontWeight','bold');
legend('ADL-sharing model','Non-ADL model','Greedy-ADL model')
ax = gca;
ax.FontSize = 20;
ax.Box = 'on';
if i==1
title('Microgrid-1');
elseif i == 2
    title('Microgrid-2');
else
    title('Microgrid-3');
end
hold off;
end


%figure;

% for i = 1:3
% subplot(1,3,i);
% xl = xlabel('c');
% yl = ylabel('Average Profit obtained');
% set(xl,'FontSize',12,'FontWeight','bold');
% set(yl,'FontSize',12,'FontWeight','bold');
% plot(c,nonsharing(i,:),'--r*');
% hold on;
% plot(c,sharing_adl(i,:),'--bo');
% xl = xlabel('c');
% yl = ylabel('Average Profit obtained');
% set(xl,'FontSize',12,'FontWeight','bold');
% set(yl,'FontSize',12,'FontWeight','bold');
% legend('Greedy-ADL model','ADL-sharing model')
% if i==1
% title('Microgrid-1');
% elseif i == 2
%     title('Microgrid-2');
% else
%     title('Microgrid-3');
% end
% hold off;
% end






