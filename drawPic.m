T = 1:24;

% figure
% grid on
% hold on
% leg = {};

% for index = 1:NPeer
%     Pmarketplot(index) = plot(T, Res(index).PMarket);
%     leg(index) = {['MG' int2str(index)]};
%     Pmarketplot(index).LineStyle='-.';
%     Pmarketplot(index).LineWidth=1.5;
%     Pmarketplot(index).Marker='.';
%     Pmarketplot(index).MarkerSize=15;
% end
% ylim([-500 500]);
% legend(leg,'Location','North','Orientation','horizon');
% title('PMarket');
% set(get(gca, 'XLabel'), 'String', 't');
% set(get(gca, 'YLabel'), 'String', 'Power');

% figure
% grid on
% hold on
% leg = {};
% for index = 1:NPeer
%     PWERR(index)=plot(T, PWFact(index,:)-PWForecast(index,:));
%     leg(index) = {['MG' int2str(index)]};
%         PWERR(index).LineStyle='-.';
%     PWERR(index).LineWidth=1.5;
%     PWERR(index).Marker='.';
%     PWERR(index).MarkerSize=15;
% end
% legend(leg,'Location','North','Orientation','horizon');
% ylim([-120 150]);
% title('PW prediction errors');
% set(get(gca, 'XLabel'), 'String', 't');
% set(get(gca, 'YLabel'), 'String', 'PWERR');

% figure
% grid on
% hold on
% leg = {};
% % global PairRes
% for index = 1:NPeer
%     figure
%     grid on
%     hold on
%     buydata=[];
%     sellername={};
%     for t = T
%         % t
%         buydata(t)=FindData(t,['MG' int2str(index)],0,PairRes);
%     end
%     BarMarket(index)=bar(T,buydata,0.3,'FaceColor',[247/255,175/255,50/255]);
%     BarMarket(index).EdgeColor=[237/255,165/255,40/255];
%     % for t = T
%
%     %     text(t-0.3,buydata(t),'HorizontalAlignment','center','VerticalAlignment','bottom')
%     % end
%     Pmarketplot(index) = plot(T, Res(index).Ppurchase);
%     % leg(index) = {['MG' int2str(index)]};
%     Pmarketplot(index).LineStyle = '-.';
%     Pmarketplot(index).LineWidth = 1.5;
%     Pmarketplot(index).Marker = '.';
%     Pmarketplot(index).MarkerSize = 15;
%     Pmarketplot(index).Color=[0,160/255,233/255];
%     ylim([0 1.2*max(Res(index).Ppurchase)]);
%     legend('Pbought','PDemand','Location','North','Orientation','horizon');
%     title(['MG',int2str(index)])
%         set(get(gca, 'XLabel'), 'String', 't');
% set(get(gca, 'YLabel'), 'String', 'Power');
% end
% for index = 1:NPeer
%     figure
%     grid on
%     hold on
%     buydata = [];
%     sellername = {};

%     for t = T
%         % t
%         buydata(t) = FindData(t, ['MG' int2str(index)], 1, PairRes);
%     end

%     BarMarket(index) = bar(T, buydata, 0.3, 'FaceColor', [247/255, 175/255, 50/255]);
%     BarMarket(index).EdgeColor = [237/255, 165/255, 40/255];
%     % for t = T

%     %     text(t-0.3,buydata(t),'HorizontalAlignment','center','VerticalAlignment','bottom')
%     % end
%     Pmarketplot(index) = plot(T, Res(index).Psale);
%     % leg(index) = {['MG' int2str(index)]};
%     Pmarketplot(index).LineStyle = '-.';
%     Pmarketplot(index).LineWidth = 1.5;
%     Pmarketplot(index).Marker = '.';
%     Pmarketplot(index).MarkerSize = 15;
%     Pmarketplot(index).Color = [0, 160/255, 233/255];

%     if max(Res(index).Psale) ~= 0
%         ylim([0 1.22 * max(Res(index).Psale)]);
%     end

%     legend('Psold', 'PSale', 'Location', 'North', 'Orientation', 'horizon');
%     title(['MG', int2str(index)])
%     set(get(gca, 'XLabel'), 'String', 't');
%     set(get(gca, 'YLabel'), 'String', 'Power');
% end
