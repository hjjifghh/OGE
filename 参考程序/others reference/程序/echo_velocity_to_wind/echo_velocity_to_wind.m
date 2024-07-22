clear all;clc;close all;
E=xlsread('midmode_20121227_20130110_east_echo_velocity.xlsx');
W=xlsread('midmode_20121227_20130110_west_echo_velocity.xlsx');
N=xlsread('midmode_20121227_20130110_north_echo_velocity.xlsx');
S=xlsread('midmode_20121227_20130110_south_echo_velocity.xlsx');
H=E(1:end,1);
% U=xlsread('midmode_20121227_20130110_after_secondary_order_fitting_zonal_fluctuation.xlsx');
% V=xlsread('midmode_20121227_20130110_after_secondary_order_fitting_meridional_fluctuation.xlsx');
% W=xlsread('midmode_20121227_20130110_after_secondary_order_fitting_vertical_fluctuation.xlsx');
alpha=15*2*pi/360;
U=(W(1:end,2:end)-E(1:end,2:end))/(2*cos(alpha));
V=(S(1:end,2:end)-N(1:end,2:end))/(2*cos(alpha));
Z=(E(1:end,2:end)+W(1:end,2:end))/(2*sin(alpha));
xlswrite('midmode_20121227_20130110_zonal_wind.xlsx',[H,U]);
xlswrite('midmode_20121227_20130110_meridional_wind.xlsx',[H,V]);
xlswrite('midmode_20121227_20130110_vertical_wind.xlsx',[H,Z]);

[n,date]=xlsread('TimeAxis20121227_20130110.xlsx');
TimeAxis = datenum(date(1:end));
HightAxis=H;  
% xlswrite('midmode_20121226_20130106_zonal_wind.xlsx',[H,U]');
% xlswrite('midmode_20121226_20130106_meridional_wind.xlsx',[H,V]');
% xlswrite('midmode_20121226_20130106_vertical_wind.xlsx',[H,Z]');

%%
[row,column]=size(Z);
for i=1:row;
    for j=2:(column-1);
         Z(i,j)=(Z(i,j-1)+Z(i,j)+Z(i,j+1))/3;
        U(i,j)=(U(i,j-1)+U(i,j)+U(i,j+1))/3;
        V(i,j)=(V(i,j-1)+V(i,j)+V(i,j+1))/3;
    end
end

for j=1:column
    for i=2:(row-1)
       Z(i,j)=(Z(i-1,j)+Z(i,j)+Z(i+1,j))/3;
       U(i,j)=(U(i-1,j)+U(i,j)+U(i+1,j))/3;
       V(i,j)=(V(i-1,j)+V(i,j)+V(i+1,j))/3;
    end
end

for j=1:column
     Zx=Z(:,j);
p = polyfit(H,Zx,2);     %%%%%%%%%%二次多项式拟合
Zx_fluc= polyval(p,H);    %%%%%%%%拟合后值
 Z_fluc(:,j)=Zx-Zx_fluc;  
end
for j=1:column
     Ux=U(:,j);
p = polyfit(H,Ux,2);     %%%%%%%%%%二次多项式拟合
Ux_fluc= polyval(p,H);    %%%%%%%%拟合后值
 U_fluc(:,j)=Ux-Ux_fluc;  
end
for j=1:column
     Vx=V(:,j);
p = polyfit(H,Vx,2);     %%%%%%%%%%二次多项式拟合
Vx_fluc= polyval(p,H);    %%%%%%%%拟合后值
 V_fluc(:,j)=Vx-Vx_fluc;  
end
%%
VerticalWind=Z_fluc;
ZonalWind=U_fluc;
MeridionalWind=V_fluc;

%%
figure;
set(gcf,'position',[ 1  49  1920 947]); 
% contourf(TimeAxis,HightAxis, VerticalWind');
wind20km=MeridionalWind(17,:);
wind16km=ZonalWind(11,:);
wind14km=ZonalWind(7,:);
smooth(wind20km,3,'moving');
TimeAxisX = TimeAxis(1):1/24:TimeAxis(end);  % 插值1hour
Windi=wind20km;
WindInt = interp1(TimeAxis, Windi , TimeAxisX,'spline'); 

plot(TimeAxisX,WindInt );

% colorbar;
datetick('x', 'DD','keeplimits');
% set(gca,'XTick',[0:24:ll-1]);
% set(gca,'XTickLabel',{'24',' ','25',' ','26',' ','27',' ','28',' ','29',' ','30',' ','31',' ','1',' ','2'});
% xlabel('day(Local Time)','fontweight','bold','fontsize',15); 
xlabel('UT (Day)'); 
ylabel('zonalwind(m/s)'); 
% title('Vertical Wind');
title('Zonal Wind at km');