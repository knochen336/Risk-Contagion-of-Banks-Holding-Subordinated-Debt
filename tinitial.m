%interbank����ṹ������
JlinkTemp=0;
for Jlinki=1:1:BankNo
    for Jlinkj=1:1:BankNo
        JlinkTemp=rand(1,1);
        if JlinkTemp<=C
            Jlink(Jlinki,Jlinkj)=1;
            Jlink(Jlinkj,Jlinki)=1;
        else
            Jlink(Jlinki,Jlinkj)=0;
            Jlink(Jlinkj,Jlinki)=0;
        end
    end
    Jlink(Jlinki,Jlinki)=0;
end
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
save  Jlink  Jlink
%Ͷ�ʳ�ʼ��
for i=1:1:BankNo
  for j=1:1:Tao
        I(i,j)=AverageA/3*(1+SigmaW*randn(1,1));
        if I(i,j)<=0
            I(i,j)=0;
        end
    end
end
%����Լ����ʲ���ʼ��
I(:,3)=I(:,1)+I(:,2)+I(:,3);
 A(:,Tao)=AverageA*(0.6+rand(BankNo,1));

V(:,Tao)=0.3*A(:,Tao).*(0.6+randn(BankNo,1));
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
%�������ʽ��ʼ��
for i=1:1:BankNo
    temp1=0;
%     for j=1:1:Tao
%         temp1=temp1+I(i,j);
%     end
%     L(i,Tao)=A(i,Tao)+V(i,Tao)-temp1;
     L(i,Tao)=A(i,Tao)+V(i,Tao)-I(i,Tao);
%     I(i,Tao)=temp1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
% ����ʼ��
temp2=zeros(1,BankNo);
% for i=1:1:BankNo
%     if L(i,Tao)<0       
%         for j=1:1:BankNo
%             if L(j,Tao)>-L(i,Tao) & temp2(j)<3;
%                 temp2(j)=temp2(j)+1;
%                 L(j,Tao)=L(j,Tao)+L(i,Tao);
%                  Jlink(i,j)=1;
%                  Jlink(j,i)=1;
%                  B(i,j)=-L(i,Tao);
%                   B(j,i)=L(i,Tao);
%                   break;
%             end
%         end
%          L(i,Tao)=0;
%     end
% end
L1=L;
%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
% %Ͷ�����ʳ�ʼ��
%         Ro=ones(BankNo,TotalStep)*0.01;
%         RoReturn=ones(BankNo,TotalStep);
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%�ʲ���ʼ��������ã������
for i = 1:1:BankNo
            for j = 1:1:AssetNo
                JlinkTemp = rand(1,1);
                if JlinkTemp <= p
                    Link(i,j) = 1;
                else
                    Link(i,j) = 0;
                end
            end
        end
        
 for i = 1:1:BankNo
     JlinkTemp = randperm(AssetNo,po);
      Link(i, JlinkTemp) = 1;
 end
 save Link Link
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
        % ����-�ʲ���������
 for i = 1:1:BankNo
     temp2=Link(i,:);
     temp3=length(find(temp2==1));
     temp4=I(i,Tao)/temp3;
     temp2(temp2==1)=temp4;
     W(i,:)=temp2;
 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ʼ�μ�ծ����
  CJ=zeros(BankNo,1); %ÿ�����з��еĴμ�ծ
 tem1=0.25*sum(V(:,3))/BankNo;
 V_bar=200;
  RiskPreference = rand(BankNo, 1); % ����������еķ���ƫ�ò���
beta1 = 12;%ѡ�����ж�
for pn=1:BankNo
    SDL(pn)=SDL_bar+(exp((V(pn,Tao)/V_bar)-1)-1)/1000;
end
for i = 1:1:BankNo
    CJ(i)=rand()*tem1; %ÿ�����з��еĴμ�ծ
    L1(i,3)=L1(i,3)+ CJ(i); %�μ�ծ������������
    % �ų�������ȡ��Ч��ѡ
    candidates = [1:i-1, i+1:BankNo];
    candidate_r = SDL(candidates);

    % ��̬Ȩ�ؼ���
    mean_r = mean(candidate_r);
    preference_effect = (2*RiskPreference(i) - 1); % [-1,1]
    rate_diff = (candidate_r - mean_r)/std(candidate_r); % ��׼�����ʲ���

    % Ȩ�ع�ʽ��ǿ������ƫ�������ʵĽ�������
    raw_weights = exp(beta1 * preference_effect * rate_diff);

    % ��ֵ�ȶ�����
    raw_weights = raw_weights + 1e-10; % ��ֹ��Ȩ��
    prob_weights = raw_weights / sum(raw_weights);

    % ��Ȩ�޷Żس�����˳����Ҫ�Բ�����
    selected = zeros(8,1);
    temp_weights = prob_weights;
    for k = 1:8
        cum_weights = cumsum(temp_weights);
        pick = find(cum_weights >= rand(), 1);
        selected(k) = candidates(pick);

        % �Ƴ���ѡ�����±�׼��
        candidates(pick) = [];
        temp_weights(pick) = [];
        temp_weights = temp_weights / sum(temp_weights);
    end

    % �μ�ծ����
    allocation = tf * CJ(i) / 8;
    SD(selected, i) = allocation;
    L1(selected) = L1(selected) - allocation;
end

  save CJ CJ
 save W W
 save A A
 save I I
 save V V
 save L1 L1
 save SD SD
 save SDL SDL