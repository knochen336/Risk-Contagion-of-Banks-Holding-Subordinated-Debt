 initial;
YT=10;
RT=zeros(TotalStep,1);
RTR=zeros(YT,TotalStep);
save RT RT
save RTR RTR
  
for u=1:1:YT
    u
    initial;
    load RT;
    load RTR;
    
    tinitial;
    zibian;
   RT=RT+SBank/YT;  
   RTR(u,:)=SBank';
   save RT RT
   save RTR RTR
end
%hold on
%plot(1:TotalStep,RT,'-r','LineWidth',1,'MarkerSize',2.5)
%xlabel('Step'),ylabel('Number of surviving banks')