clear all;
close all;
%��·���
[PolyValue,U_mV] = IV_CurvePolyFit()
disp(char(['I_mV=',poly2str(PolyValue,'*U_mV')]))
Fitted_IV_curve =polyval(PolyValue,U_mV);
R_s=U_mV./Fitted_IV_curve;


% U_mV=150;
% Y = (1.3422*10^-12)*(U_mV^5) - (1.4261*10^-09)*(U_mV^4) + (5.8629*10^-07)*(U_mV^3) - (0.00010974)*(U_mV^2)+ (0.0080545)*U_mV + 0.0010613
% Y = (1.3422*10^-12)*(_v1^5) - (1.4261*10^-09)*(_v1^4) + (5.8629*10^-07)*(_v1^3) - (0.00010974)*(_v1^2)+ (0.0080545)*_v1 + 0.0010613
%���IVͼ��
% 1.3422*((10)^-2))*((_v1)^5) -1.4261*((10)^-09)*((_v1)^4)+5.8629*((10)^-07)*((_v1)^3)-(0.00010974)*((_v1)^2)+ (0.0080545)*(_v1) + 0.0010613
% % figure;
% % plot(U_mV,Fitted_IV_curve);
%% ����迹��ȡ
Diff_res=1./diff(Fitted_IV_curve);
PolyValueDiffR = polyfit(U_mV(2:end),Diff_res,5);
Diff_R = polyval(PolyValueDiffR,U_mV);

figure;
plot(U_mV(2:end),Diff_res);
%% ��������ȡ
[Negative_Area]=find(Diff_res<0);
Negative_Value=Diff_res(Negative_Area);
figure;
plot(Negative_Area,Negative_Value);
%% ����ϵ��Ӱ��
%% ����ϵ������
% �ྦྷ���
% ��ɢ����
Cj=0.3e-12; Cp=0.1e-12; Ls=1e-9; Rs=6; %�������ߵ���
% Rj=-692;
pi=3.1416;
f=1.57542e9;%����Ƶ��
%   f=5.80e9;%����Ƶ��
Rm=max(Negative_Value)
f_r0=1/(2*pi*(-Rm)*Cj)*sqrt(-Rm/Rs - 1 ) %���Խ�ֹƵ�ʼ���
Ka=1.2;


% figure;
% plot(Negative_Area,Negative_Value);
% F=(1+Ka)/((1-Rs/(-Rj))*(1-(f/f_r0)^2))
F=(1+Ka)./((1-Rs./(-Negative_Value)).*(1-(f/f_r0)^2));

% plot(NegativeRes);
% �쳣ֵȥ��
TF = isoutlier(F,'movmedian',2);
ind = find(TF);
Aoutlier = F(ind);
F(ind)=F(ind);
F_fill = filloutliers(F,'next');
F_fill = smoothdata(F_fill,'movmean');
figure;
title('Noise Figure')
plot(Negative_Area,F,Negative_Area,F_fill);
axis tight
legend('Noisy Figure with Outlier','Noisy Figure with Filled Outlier')
%% ��Ч��·����
[Z,Z_normalized] = Circuit_Normaliztion(Cj,Cp,Ls,Rs,Rm,f,Negative_Value);
Abs_Z=abs(Z);
%% 5%����������
%  Z0=abs(real(Z));
% ErrorRate=0.05.*Z; %5ŷķ
%  ZL=abs(real(Z))+real(ErrorRate)-(1i)*(imag(Z)+imag(ErrorRate));
ZL=abs(real(Z))+1-(1i)*(imag(Z)+1);
 DeGain=abs((1-ZL./Z)./(1+ZL./Z));
 
 figure;
 title('Noise Figure and Gain')
 hold on;
 plot(Negative_Area,abs(real(Z)),Negative_Area,DeGain,Negative_Area,abs(Z));
 axis tight
 legend('Realpart of tunnel diode impedance','Amplifier gain with 1 ohm','Z_abs')
%%
  abs((1+1i*3+1.1+1i*3.385)./(1+1i*3-1.1-1i*3.385)).*78.6
  %% �迹�ֲ�
  figure;
  title('Impendance distribute');
  scatter3(Negative_Area,real(Z),imag(Z));
  xlabel('Bias (mV)');
  ylabel('Impendance Real part (ohm)');
  zlabel('Impendance Imag part (ohm)');

%% ��·��ƣ��迹ƥ��
 %�����迹 
 Z_ex=-78.6-(1i)*224;
%  Z_out=Z_ex+1./(1i*2*pi*f*1.5e-9)
Z_norm=Z_ex/50;
Zmatch=1/(1./(-1-1i*0)-1./Z_norm)
%  Z=Z_norm.*Zmatch/(Z_norm+Zmatch)