function  [gnssMeasBackscattered]=Seprate(gnssMeas,prFileName)
figure;
[colors] = PlotPseudoranges(gnssMeas,prFileName);
figure;
PlotCno(gnssMeas,prFileName,colors);

% pick out the strongest sat signal as stander
[strongestSig,SigIndex]=max(gnssMeas.Cn0DbHz);
[MaxCn0DbHz,Index]=max(strongestSig);
StongestSvid=gnssMeas.Svid(Index);


Index = 8;
gnssCnoMax=gnssMeas.Cn0DbHz(:,Index);

% set the nan as 0
for i=1:length(gnssCnoMax)
    if isnan(gnssCnoMax(i)) 
       gnssCnoMax(i)=0; 
    end
    
end
% plot for scale view
figure;
plot(gnssCnoMax);

% window length 4
% split data into two parts
LenGnss = length(gnssCnoMax);
pickUp = zeros(1, LenGnss);
pickDn = zeros(1, LenGnss);
midThre = 0;
cntPick = ones(1,2);
for i=1:LenGnss
    if i+3 <= LenGnss
        if mod(i,4) == 1
           dataBuf = gnssCnoMax(i:i+3); 
           midThre = median(dataBuf); 
        end
    end
    
    if gnssCnoMax(i) >= midThre - 1
        pickUp(i) = 1;
%         cntPick(1) = cntPick(1) + 1;
    else
        pickDn(i) = 1;
%         cntPick(2) = cntPick(2) + 1;
    end
    
end

% pickUp -> backscattered sat signal
% pickDn -> original sat signal
save('pickUp.mat','pickUp');
DataUp = pickUp .* gnssCnoMax';
DataDn = pickDn .* gnssCnoMax';

figure
plot(gnssCnoMax);
hold on
plot(DataUp);
plot(DataDn);
hold off

% chose data for later processing
LocsCnoIndex= find(pickUp==1);
% LocsCnoIndex= find(pickDn==1);
% gnssMeasBackscattered=gnssMeas(LocsCnoIndex);
% gnssMeasBackscattered=gnssMeas(LocsCnoIndex);
%
gnssMeasBackscattered.Svid=gnssMeas.Svid;
gnssMeasBackscattered.AzDeg=gnssMeas.AzDeg;
gnssMeasBackscattered.ElDeg=gnssMeas.ElDeg;
gnssMeasBackscattered.FctSeconds=gnssMeas.FctSeconds(LocsCnoIndex,:);
gnssMeasBackscattered.ClkDCount=gnssMeas.ClkDCount(LocsCnoIndex,:);
gnssMeasBackscattered.HwDscDelS=gnssMeas.HwDscDelS(LocsCnoIndex,:);
gnssMeasBackscattered.tRxSeconds=gnssMeas.tRxSeconds(LocsCnoIndex,:);
gnssMeasBackscattered.tTxSeconds=gnssMeas.tTxSeconds(LocsCnoIndex,:);
gnssMeasBackscattered.PrM=gnssMeas.PrM(LocsCnoIndex,:);
gnssMeasBackscattered.PrSigmaM=gnssMeas.PrSigmaM(LocsCnoIndex,:);
gnssMeasBackscattered.DelPrM=gnssMeas.DelPrM(LocsCnoIndex,:);
gnssMeasBackscattered.PrrMps=gnssMeas.PrrMps(LocsCnoIndex,:);
gnssMeasBackscattered.PrrSigmaMps=gnssMeas.PrrSigmaMps(LocsCnoIndex,:);
gnssMeasBackscattered.AdrM=gnssMeas.AdrM(LocsCnoIndex,:);
gnssMeasBackscattered.AdrSigmaM=gnssMeas.AdrSigmaM(LocsCnoIndex,:);
gnssMeasBackscattered.AdrState=gnssMeas.AdrState(LocsCnoIndex,:);
gnssMeasBackscattered.Cn0DbHz=gnssMeas.Cn0DbHz(LocsCnoIndex,:);
gnssBksCnoMax=gnssMeasBackscattered.Cn0DbHz(:,Index);
figure;
plot(gnssBksCnoMax);

end