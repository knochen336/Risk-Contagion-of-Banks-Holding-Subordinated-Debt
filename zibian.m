
load I;
load A;
load L1;
load V;
load Link;
load  Jlink;
 load W;
for t=Tao+1:1:TotalStep
     g(:,t)=g(:,t-1).*(1+normrnd(st,0.06,AssetNo,1));%%%%����Ϊ0.01����ֵΪst
%       g(find(g<0))=0;
%            if t==750
%               g(:,t)=0.6*g(:,t);
%           end
       %%%%�ʲ��۸����
    for i=1:1:BankNo
        %%%%���������Ϊ����״̬������������
        if BankFlag(i)==3
            continue;  %%%���������ΥԼ����
        end
         %%%����
%          if t>750
%               A(i,t)=0.3*AverageA*(1+SigmaA*randn(1,1));
%          else
            A(i,t)=AverageA*(1+SigmaA*randn(1,1));
%          end
%       if t>750
%           BankFlag(20)=3;
%           W(20,:)=0;
%           V1(20,t)=0;
%           L1(20,t)=0;
%           BankFlag(21)=3;
%           W(21,:)=0;
%           V1(21,t)=0;
%           L1(21,t)=0;
%       end
         
       
% A(i,t)=(AverageA);
          if A(i,t)<0
              A(i,t)=1;             
          end
     %%%Ͷ�ʻ���      
    Iopp(i,t)=(AverageI)*(1+SigmaW*randn(1,1));
        %Iopp(i,t)=(AverageI)*(1+Ro(i,t)*5);
        if Iopp(i,t)<0
             Iopp(i,t)=0;             
        end  
     
       
       
        I(i,t)=W(i,:)*g(:,t);  %%%%��i�����е�Ͷ�ʵ����ʲ�������û���ջز���Ͷ������ǰ�����ʲ���  
        %%%%%%ÿ���ջص�Ͷ�ʼ�����
        tempy1=W(i,:);
        tempy2=find(tempy1>0);
        temo=0;
       while  length(tempy2)>0
          tempy3=ceil(length(tempy2)*rand(1,1)); %%%���ѡȡͶ�ʽ����ջ�
          ttte=temo;
          temo=temo+tempy1(tempy2(tempy3))*g(tempy2(tempy3),t);
                
         if  temo>=I(i,t)*Yreturn
             W(i,tempy2(tempy3))= W(i,tempy2(tempy3))-(I(i,t)*Yreturn-ttte)/g(tempy2(tempy3),t);
             break;
         else
             W(i,tempy2(tempy3))=0;
             tempy1=W(i,:);
             tempy2=find(tempy1>0);
         end
       end
        Y1(i,t)=I(i,t)*Yreturn;
        I(i,t)=I(i,t)-I(i,t)*Yreturn;  %%%%��i�����е���ʣ�µ�Ͷ�ʵ����ʲ��� 
       %%%%%%%%%%%%%%%%%%%%%%%
     
      % ����ÿ�ڴμ����õ�����Ϣ
        temp1q = CJ(i)*SDL(i);
         % ����ÿ�ڴμ�����Ҫ��������Ϣ
        temp2q = sum(SD(i, :)*SDL);
       
      %%%��Ͷ�ʺͻ�ծǰ�������ʲ�
        L1(i,t)=L1(i,t-1)+A(i,t)-A(i,t-1)-Ra*A(i,t-1)+Y1(i,t)+temp1q-temp2q; 
        V1(i,t)=L1(i,t)-A(i,t)+I(i,t)-(Rb+1)*sum(B(i,:));%          %%%������Ȩ��
    end
     %%%%%%%%%%%%%%%%%%%%%%%%%    
      %%%%%%%%%%%%%%%%%%%  �������Ե��ж�
%      
     L1temp=L1; 
                Btemp=sum(B');
        Btemp1=Btemp'*(1+Rb);
        for ii=1:1:BankNo% Determinal potential lender 
            if BankFlag(ii)==3
                continue;
            end

           if ((Btemp1(ii)<=0) & (L1(ii,t)-Beta*A(ii,t)>=0))                
                 BankFlag(ii)=1; 
            end
            if (L1(ii,t)>0) & (Btemp1(ii)<0) & (L1(ii,t)-Beta*A(ii,t)<0)
                BankFlag(ii)=4;
            end
             if (L1(ii,t)-Btemp1(ii)>=0) & (L1(ii,t)>0) & (Btemp1(ii)>=0) & (L1(ii,t)-Btemp1(ii)-Beta*A(ii,t)<0) %%
                BankFlag(ii)=4;
                for jj=1:1:BankNo
                    if B(ii,jj)>0
                    L1temp(jj,t)= L1temp(jj,t)+(1+Rb)*B(ii,jj);
                     L1temp(ii,t)= L1temp(ii,t)-(1+Rb)*B(ii,jj);
                    B(ii,jj)=0;   
                    B(jj,ii)=0;
                    end
                end
                 
            end
            if ((L1(ii,t)-Btemp1(ii)-Beta*A(ii,t)>=0) & (L1(ii,t)>0) & (Btemp1(ii)>=0) )
                 BankFlag(ii)=1;                
                for jj=1:1:BankNo
                    if B(ii,jj)>0
                     L1temp(jj,t)= L1temp(jj,t)+(1+Rb)*B(ii,jj);
                      L1temp(ii,t)= L1temp(ii,t)-(1+Rb)*B(ii,jj);
                    B(ii,jj)=0;   
                    B(jj,ii)=0;
                    end
                end
                
            end
            L1=L1temp; 
           
         if  L1(ii,t)<0 | (L1(ii,t)-Btemp1(ii)<0)
                 BankFlag(ii)=2;
         end
           
        end
%         if t==10
%               BankFlag(10)=3;
%               BankFlag(20)=3;
%               BankFlag(30)=3;
%               BankFlag(31)=3;
%               BankFlag(32)=3;
%           end
   tt=1;    
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%%%%%%%%%%%%%���зֺ�      
      for ii=1:1:BankNo%invest
        if BankFlag(ii)~=1
            continue;
        end
        Dtemp1=I(ii,t);
        Dtemp2=I(ii,t)+Y1(ii,t)-I(ii,t-1);
%         V1(ii,t)=L1(ii,t)+Dtemp1-A(ii,t);
%         V1(i,t)=L1(ii,t)-A(ii,t)+I(ii,t)-(Rb+1)*sum(B(ii,:));
        E(ii,t)=V1(ii,t)/A(ii,t);
        R(ii,t)=Beta*A(ii,t);
        if (E(ii,t)>Kaxi)
            D(ii,t)=max(0,min(Dtemp2-Ra*A(ii,t-1), min(L1(ii,t)-R(ii,t),L1(ii,t)+Dtemp1-(1+Kaxi)*A(ii,t)) ));
        else 
            D(ii,t)=0;
        end
        Benifit(ii,t)=Dtemp2-Ra*A(ii,t-1);
        L1(ii,t)=L1(ii,t)-D(ii,t);
      end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%����Ͷ��
      Itemp1=0;       
        for ii=1:1:BankNo%invest
            if BankFlag(ii)~=1
                continue;
            end
            if Iopp(ii,t)>0
                Itemp1=min(Iopp(ii,t),max(0,L1(ii,t)-Beta*A(ii,t)));
                else
                Itemp1=0;
            end
            I(ii,t)=I(ii,t)+Itemp1;
%        Iopp(ii,t)=Iopp(ii,t)-Itemp1;
            L1(ii,t)=L1(ii,t)-Itemp1;
%             LL1(ii,t)=L1(ii,t);
               tempt2=find(Link(ii,:)>0);
               tempt3=length(tempt2);
                 tempt4=rand(1,1);
                  tempt5=ceil(tempt3*tempt4);
                 indx=randperm(tempt3, tempt5);
                   rv = tempt2(indx);  
                   Itr=Itemp1/tempt5;
                   for j=1:1:tempt5
                       W(ii,rv(j))=W(ii,rv(j))+Itr/g(rv(j),t);
                   end
        end
          
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%���н��
         %��迪ʼ
        EndFlag=0;
%         while EndFlag==0
            EndFlag=1;
            for i=1:1:BankNo%each borrower search for lender
                if ((BankFlag(i)==1) | (BankFlag(i)==3) | (BankFlag(i)==4))
                    continue;
                end
                %place all lenders in LenderSet Ѱ�ҿ��ܵĽ�����
              
                LenderSet=[];
                
                for j=1:1:BankNo
                    if (BankFlag(j)==1 & Jlink(i,j)==1)
                        if length(LenderSet)<1
                            LenderSet=j;
                        else
                            LenderSet=[LenderSet;j];
                        end
                    end
                end
                
                
                L1temp=L1;
                Btemp=B;

               Bnew=zeros(BankNo,BankNo);
                temp1=size(LenderSet);
                temp1=temp1(1,1);
                temp=sum(B(i,:));
                temp4=temp*(1+Rb);   
                if temp4>0
                    temp4=L1(i,t)-temp4;%temp4��ŵ���i���иý�Ǯ������
                   else
                    temp4=L1(i,t);                
                end
               
                temp5=0;
                temp6=0;
                temp7=0;
                while temp1>0                 
                    temp2=rand(1,1);
                    temp2=ceil(temp1*temp2);
                    temp6=temp2;
                    temp2=LenderSet(temp2); %%%%������
                    
                    if abs(temp4)<=L1temp(temp2,t)-Beta*A(temp2,t)%����ӵ�i�����н��Ǯ�㹻����
                        L1temp(temp2,t)=L1temp(temp2,t)-abs(temp4);%�����ծ��ծȨ���е������Ը���
                        L1temp(i,t)=0;
                        for jjj=1:1:BankNo                            
                            if B(i,jjj)>=0 
                                L1temp(jjj,t)=L1temp(jjj,t)+(1+Rb)*B(i,jjj);%������ծ��ծȨ���������Ը���
                                Btemp(i,jjj)=0;
                                Btemp(jjj,i)=0;                              
                            end
                        end 
                        
                        Btemp(temp2,i)= Btemp(temp2,i)-abs(temp4);
                        Btemp(i,temp2)=Btemp(i,temp2)+abs(temp4);
                        
                        temp4=0;
                        temp1=0;
                        EndFlag=0;
                        L1=L1temp;
                        B=Btemp;
                        BankFlag(i)=4;
                        flag(ii)=0;
                    else 
                         temp4=temp4+L1temp(temp2,t)-Beta*A(temp2,t);%��Ϊtemp4�Ǹ���                        
                         Btemp(temp2,i)=Btemp(temp2,i)- L1temp(temp2,t)+Beta*A(temp2,t);
                         Btemp(i,temp2)=Btemp(i,temp2)+ L1temp(temp2,t)-Beta*A(temp2,t);
                         
                         L1temp(i,t)=L1temp(i,t)+L1temp(temp2,t)-Beta*A(temp2,t);
                         L1temp(temp2,t)=Beta*A(temp2,t);
                        if temp1>1
                            temp3=LenderSet(1:temp6-1);
                            temp5=LenderSet(temp6+1:temp1);
                            temp3=[temp3;temp5];
                            LenderSet=temp3;
                            temp1=size(LenderSet);
                            temp1=temp1(1,1);
                        else
                            LenderSet=[];
                            temp1=0;
                            
                            %pause
                        end
                    end
                end
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%%%%%%%%%%%%%%%%
       %%�������������Ҫ�����ʲ�
    
        Wtemp=W;
        gtemp=g;
         if temp4<0
             tempw1=W(i,:);
             tempw2=find(tempw1>0);
             tempw3=length(tempw2);
               while tempw3>0
                    
                    tempw4=rand(1,1);
                    tempw5=ceil(tempw3*tempw4);
                    ttemp=tempw2(tempw5); %%%���ѡȡһ��Ͷ���ջ�
                    trt=tempw1(ttemp)/sum(Wtemp(:,ttemp));
                    gtemp(ttemp,t)=gtemp(ttemp,t)*exp(-trt*alpha);
                    tvalue=gtemp(ttemp,t)*tempw1(ttemp);
                   if abs(temp4)<=tvalue %%%������۸��ʲ����㹻��ծ
                        for jjj=1:1:BankNo                            
                            if B(i,jjj)>=0                                
                               L1temp(jjj,t)=L1temp(jjj,t)+(1+Rb)*B(i,jjj);%������ծ��ծȨ���������Ը���
                                Btemp(i,jjj)=0;
                                Btemp(jjj,i)=0;
                            end
                        end 
                        L1temp(i,t)=tvalue-abs(temp4);
                        EndFlag=0;
                        L1=L1temp;
                        B=Btemp;
                        BankFlag(i)=4;
                        tempw3=0;
%                         flag(ii)=0;
                        g=gtemp;
                        tempw1(ttemp)=0;
                       W(i,:)=tempw1;
                   else
                        temp4=temp4+tvalue;
                        L1temp(i,t)=L1temp(i,t)+tvalue;
                        if tempw3>1
                            tempq3=tempw2(1:tempw5-1);
                            tempq5=tempw2(tempw5+1:tempw3);
                            tempq=[tempq3,tempq5];
                            tempw2=tempq;
                            temp1=length(tempw2);
                            tempw3=length(tempw2);
                        else
                            tempw2=[];
                            temp1=0;
                            tempw3=length(tempw2);
%                             BankFlag(i)=3;
                        end
                   end
                 
              end
         end
         
         %%%%%��������ʲ�����������Ҫת�ôμ�ծ
           if temp4<0
               if abs(temp4)<= 0.98*sum(SD(i,:)) %%%0.98��ת�ôμ�ծ���ۿ�
                    for jjj=1:1:BankNo                            
                            if B(i,jjj)>=0                                
                               L1(jjj,t)=L1(jjj,t)+(1+Rb)*B(i,jjj);%������ծ��ծȨ���������Ը���
                                B(i,jjj)=0;
                                B(jjj,i)=0;
                            end
                    end 
                        L1(i,t)=0;
                       SD(i,:)=SD(i,:)*(1-abs(temp4)/0.98/sum(SD(i,:)));
               else
                   BankFlag(i)=3;
               end
           end
         
         
                %end of RiskInterBankDividendInvest.m;
        end
%         end%end of while EndFlag==0�������еĲ��   
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% �Ʋ����б���
 
for p=1:1:BankNo
     temp=0;
    if BankFlag(p)==3 & BG(p)==0
        BG(p)=1;
       tempa1=W(p,:);
       tempa2=find(tempa1>0);
       tempa3=length(tempa2);
       for j=1:1:tempa3
           tw=tempa1(tempa2(j))/sum(W(:,tempa2(j)));
           g(tempa2(j),t)=g(tempa2(j),t)*exp(-tw*alpha);
           temp=temp+g(tempa2(j),t)*W(p,tempa2(j));
           W(p,tempa2(j))=0;
       end
%        temp=W(p,:)*g(:,t);
%        W(p,:)=0;
%        temp
%        temp=temp+L1(p,t)%%%%%%%�������ڻ����Ǯ
%        p
       temp=temp+0.98*sum(SD(p,:));
       if temp>0 & temp>A(p,t) %%%�Ȼ���������Ǯ�ٻ���
%               A(p,t)=0;
              tempe1=B(p,:);
              tempe2=find(tempe1>0);
              if length(tempe2)>0
              tempe3=sum(tempe1(tempe2));
                if tempe3>temp-A(p,t)
                   L1(tempe2,t)=L1(tempe2,t)+(temp-A(p,t))/length(tempe2)*tempe1(tempe2)';
%                    B(tempe2,p)=B(tempe2,p)+(temp-A(p,t))/tempe3*tempe1(tempe2);
%                    B(p,tempe2)= B(p,tempe2)-(temp-A(p,t))/tempe3*tempe1(tempe2);
                   B(tempe2,p)=0;
                    B(p,tempe2)=0;
                   L1(p,t)=0;
                else
                    L1(tempe2,t)=L1(tempe2,t)+B(tempe2,p);
                    B(tempe2,p)=0;
                    B(p,tempe2)=0;
                    L1(p,t)=temp-tempe3-A(p,t);
                end
              else
                 L1(p,t)=temp-A(p,t);
              end
%        else
%            L1(p,t)=0;
       end
       if  L1(p,t)>0   %%%% �μ�ծ����
           ttep=sum(SD(:,p));
           for r=1:1:BankNo
               if SD(r,p)>0
                   L1(r,t)=L1(r,t)+L1(p,t)*SD(r,p)/ttep;
               end
           end
        end
       L1(p,t)=0;
    end
end 
   temp6=sum(B');
      BankFlagTime(:,t)=BankFlag;
        I(:,t)=W*g(:,t);
        for jjj=1:1:BankNo
           V(jjj,t)=L1(jjj,t)+I(jjj,t)-A(jjj,t)-temp6(jjj);
      end     
  % t
end

SBank=zeros(TotalStep,1);
for i=1:1:TotalStep
    for j=1:1:BankNo
        if BankFlagTime(j,i)~=3
           SBank(i)=SBank(i)+1; 
        end
    end
end
% hold on
% plot(1:TotalStep,SBank,'--r','LineWidth',2,'MarkerSize',2.5)
% xlabel('ʱ�䲽'),ylabel('���������')