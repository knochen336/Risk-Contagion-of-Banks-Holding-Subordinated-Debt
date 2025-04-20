load RTR;

ris=zeros(1,TotalStep);
for i=2:1:TotalStep
    for j=1:1:YT
        ris(i)=ris(i)+(-RTR(j,i)+RTR(j,i-1))/RTR(j,i-1)/YT;
    end
end
rist=zeros(1,TotalStep-199);
for i=1:1:1801
    rist(i)= sum(ris(i:i+199));
end
hold on
ttt=[rist,zeros(1,199)];
figure;
RT1=RT(1:1801);
yyaxis left;
plot(1:1801, RT1, 'k'); % 存活银行数目
yyaxis right;
plot(1:1801, rist, 'r'); % 系统性风险
% 添加图例
legend('存活银行数目', '系统性风险');

%figure;
%plot(1:1801, rist, 'r'); % 系统性风险
% 添加图例
%legend('存活银行数目', '系统性风险');
%legend('r_{a}=0.002','r_{a}=0.004','r_{a}=0.006')
