clear
clc
close all
load Res.mat
t = 1:24;

figure
grid on
hold on
box on
SOCPlot = plot(t, Res.SOC, 'linewidth', 2.5, 'Color', [0/255, 161/255, 241/255]);
PBPlot = plot(t, Res.PB, 'linewidth', 2.5, 'Color', [255/255, 187/255, 0/255]);
PBPlot.Marker = '.';
PBPlot.MarkerSize = 20;
legend('SOC', 'PB');
title('蓄电池电量情况');

figure
grid on
hold on
box on
plot(t, Res.PW, 'linewidth', 2.5, 'Color', [255/255, 187/255, 0/255]);
plot(t, PWFact, 'linewidth', 2.5, 'Color', [0/255, 161/255, 241/255]);

figure
grid on
hold on
box on
plot(t, PWFact - Res.PW, 'linewidth', 2.5, 'Color', [255/255, 187/255, 0/255]);
plot(t, Res.PMarket, 'linewidth', 2.5, 'Color', [0/255, 161/255, 241/255]);
% plot(t,Res.Psale,'linewidth', 2.5,'Color',[0/255,161/255,241/255]);
% plot(t,Res.Ppurchase,'linewidth', 2.5,'Color',[124/255,187/255,0/255]);
legend('弃风量', 'PMarket');

% figure
% grid on
% hold on
% box on
