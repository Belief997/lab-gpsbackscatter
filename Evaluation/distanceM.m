function [distM] = distanceM(allLlaDegDegM,llaTrueDegDegM)
%DISTANCE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

nedM = Lla2Ned(allLlaDegDegM,llaTrueDegDegM);
iFi = isfinite(allLlaDegDegM(:,1));
distM = sqrt(sum(nedM(iFi,1:2).^2,2));

end

