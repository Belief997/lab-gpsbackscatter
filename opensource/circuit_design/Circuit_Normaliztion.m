function [Z,Z_normalized] = Circuit_Normaliztion(Cj,Cp,Ls,Rs,Rm,f,Rj)
%% �������룬�ٷ������Ʋ� MBD2057-E28
% Cj=0.3e-12; Cp=0.1e-12; Ls=0.8e-9; Rs=6;
% Rj=-692; Rm=-80; f=1.57542e9;
 pi=3.1416;
% ��һ�׶� Cj Rj����ת��
Z1=(Rj.*1/((1i)*2*pi*f*Cj))./(Rj+1/((1i)*2*pi*f*Cj));
Z1_R=real(Z1);
Z1_X=imag(Z1);
Z1_C=1./((1i).*Z1_X*2*pi*f);
% disp(['����ݲ�����Ч�任��R= ',num2str(Z1_R),' ,C=',num2str(Z1_C)]);
% �ڶ��׶δ�����·��Ч�任
Z2=Z1+Rs+(1i)*Ls*2*pi*f;
Z2_R=real(Z2);
Z2_X=imag(Z2);
Z2_C=1./((1i).*Z2_X*2*pi*f);
% disp(['�����򻯵�Ч�任��R= ',num2str(Z2_R),' ,C=',num2str(Z2_C)]);
% �����׶� Z2�����䲢��ת��
Z3_1=1./Z2;
Z3_R=1./real(Z3_1);
Z3_X=1./imag(Z3_1);
Z3_C=1./(Z3_X*2*pi*f);
% ���Ľ׶Σ���Ч�迹����
Z4_R=Z3_R;
Z4_C=Z3_C+Cp;

Z =(Z4_R*1./((1i)*2*pi*f.*Z4_C))./(Z4_R+1./((1i)*2*pi*f.*Z4_C));
C=1./((1i).*(imag(Z))*2*pi*f);
Z0=abs(real(Z));
Z_normalized = Z./Z0;
Z_abs=abs(Z);
% disp(['�����򻯵�Ч�任��R= ',num2str(Z4_R(i)),' ,C=',num2str(C),' ,�迹Z=',num2str(Z),' ,��Чֵ��',num2str(Z_abs),' ��һ���迹Z0=',num2str(Z_normalized),]);
end