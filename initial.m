% clear;
clc;
Tao=3; %Ͷ������
Ra=0.004; %������Ϣ0.004
Rb=0.008; %�����Ϣ0.008
% RoAverage=0.01;%Ͷ��������Ϣ
Kaxi=0.30; %�ʱ������0.3
Beta=0.25;%��������0.25
TotalStep=2000;%�����ܲ���
BankNo=200;
AssetNo = 150;%%%�ʲ�����
L=zeros(BankNo,TotalStep);%ÿ�ڽ������������
L1=zeros(BankNo,TotalStep);%ÿ���յ�Ͷ�����棬Ͷ���ջأ�����󣬷������ڴ����Ϣ���������
L1temp=zeros(BankNo,TotalStep);%L1����ʱ���������м���ʱ��
A=zeros(BankNo,TotalStep);%����
V=zeros(BankNo,TotalStep);%���ʲ�
V1=zeros(BankNo,TotalStep);%���ʲ�
I=zeros(BankNo,TotalStep);%Ͷ��
Iopp=zeros(BankNo,TotalStep);%Ͷ�ʻ���
E=zeros(BankNo,TotalStep);
R=zeros(BankNo,TotalStep);
D=zeros(BankNo,TotalStep);%�ֺ�
B=zeros(BankNo,BankNo);%������B(3,5)=6;B(5,3)=-6: ����3��5����6Ԫ��
Btemp=zeros(BankNo,BankNo);%B����ʱ���������ʱҪ��
Benifit=zeros(BankNo,TotalStep);
InvestReturn=zeros(BankNo,TotalStep);
BankFlagTime=zeros(BankNo,TotalStep);
BankFlag=zeros(BankNo,1);%1:���Խ��н�������(potential lender),2:�ʽ𲻹�����Ҫ���Ļ�����ʲ���; 3:Default;4:Positive Cash but less than Beta*A or zero cash
AverageA=1000;
AverageI=500;
SigmaW=0.25;%Ͷ�ʲ�������0.25
SigmaA=0.15;% %���������0.15
C=0.03; %%%���м����Ӹ���
Jlink=zeros(BankNo,BankNo);
W = zeros(BankNo,AssetNo);%%%���к��ʲ���ľ���
budget = 30.00;
g=zeros(AssetNo,TotalStep);%�ʲ��ĳ�ʼ�۸�
g(:,1:3)=1;
p=0.01;%%%���к��ʲ������Ӹ���
Y1=zeros(BankNo,TotalStep); %%%ÿ���ջص�Ͷ�ʼ������
st=0.008; %%%Ͷ�ʵ�ƽ��������
Yreturn=0.35; %%%%ÿ��ƽ�����յ��ʲ�ռ��0.35
alpha=1.0536; %%�ʲ�����ʱ�ı�ֵ����
%alpha=0;
SD=zeros(BankNo,BankNo); %�μ�ծ���о���
tf=0.5; %�μ�ծ�����м���еı���0.5
SDL=zeros(BankNo,1); %�μ�ծ���ʾ���
SDL_bar=0.008;%�μ�ծƽ������
po=8; %ÿ�����п�Ͷ��6���ʲ�
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
BG=zeros(BankNo,1);