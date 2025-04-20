% clear;
clc;
Tao=3; %投资期数
Ra=0.004; %储蓄利息0.004
Rb=0.008; %拆借利息0.008
% RoAverage=0.01;%投资收益利息
Kaxi=0.30; %资本储蓄比0.3
Beta=0.25;%储备金率0.25
TotalStep=2000;%仿真总步数
BankNo=200;
AssetNo = 150;%%%资产总数
L=zeros(BankNo,TotalStep);%每期结束后的流动性
L1=zeros(BankNo,TotalStep);%每期收到投资收益，投资收回，储蓄后，返还上期储蓄及利息后的流动性
L1temp=zeros(BankNo,TotalStep);%L1的暂时变量，银行间拆借时用
A=zeros(BankNo,TotalStep);%储蓄
V=zeros(BankNo,TotalStep);%净资产
V1=zeros(BankNo,TotalStep);%净资产
I=zeros(BankNo,TotalStep);%投资
Iopp=zeros(BankNo,TotalStep);%投资机会
E=zeros(BankNo,TotalStep);
R=zeros(BankNo,TotalStep);
D=zeros(BankNo,TotalStep);%分红
B=zeros(BankNo,BankNo);%拆借矩阵B(3,5)=6;B(5,3)=-6: 银行3向5借了6元。
Btemp=zeros(BankNo,BankNo);%B的暂时变量，拆借时要用
Benifit=zeros(BankNo,TotalStep);
InvestReturn=zeros(BankNo,TotalStep);
BankFlagTime=zeros(BankNo,TotalStep);
BankFlag=zeros(BankNo,1);%1:可以进行借款的银行(potential lender),2:资金不够的需要借款的或变卖资产的; 3:Default;4:Positive Cash but less than Beta*A or zero cash
AverageA=1000;
AverageI=500;
SigmaW=0.25;%投资波动参数0.25
SigmaA=0.15;% %储蓄波动参数0.15
C=0.03; %%%银行间连接概率
Jlink=zeros(BankNo,BankNo);
W = zeros(BankNo,AssetNo);%%%银行和资产间的矩阵
budget = 30.00;
g=zeros(AssetNo,TotalStep);%资产的初始价格
g(:,1:3)=1;
p=0.01;%%%银行和资产间连接概率
Y1=zeros(BankNo,TotalStep); %%%每期收回的投资及收益和
st=0.008; %%%投资的平均收益率
Yreturn=0.35; %%%%每步平均回收的资产占比0.35
alpha=1.0536; %%资产抛售时的贬值参数
%alpha=0;
SD=zeros(BankNo,BankNo); %次级债持有矩阵
tf=0.5; %次级债被银行间持有的比例0.5
SDL=zeros(BankNo,1); %次级债利率矩阵
SDL_bar=0.008;%次级债平均利率
po=8; %每个银行可投资6个资产
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
BG=zeros(BankNo,1);