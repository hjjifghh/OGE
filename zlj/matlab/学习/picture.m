%图形标注
%xlabel(txt)
x=0:0.1*pi:3*pi;
y=2*cos(x);
plot(x,y)
xlabel({'x','0 \leq x \leq 2\pi'});
ylabel('y');
title('y=2cos(x)','fontsize',12,'FontWeight','bold','FontName','仿宋');

clf
subplot(1,2,1),plot((1:10).^2)
year=2014;
xlabel(['Population for Year',num2str(year)])

t=linspace(0,1);
y=exp(t);
subplot(1,2,2),plot(t,y);
xlabel('t_{seconds}')
ylabel('e^t',"FontSize",12,'FontWeight','bold','Color','r')

%图形的文字标注
clf
x-0:0.1*pi:3*pi;
y=2*cos(x);
subplot(1,2,1),plot(x,y)
text(pi/2,2*cos(pi/2),'\lefttarrow 2cos(x)=0','FontSize',10)
text(5*pi/4,2*cos(5*pi/4),'\rightarrow 2cos(x)=-1.414','FontSize',10)

subplot(1,2,2),plot(x,y)
gtext('y=2cos(x)','fontsize',10)

%利用legend命令进行图例标注
clf
x=linspace(0,pi);
y1=cos(x);
y2=cos(2*x);
y3=cos(3*x);
plot(x,y1,x,y2,x,y3)
legend({'cos(x)','cos(2x)','coa(3x)'},'Location','northwest','NumColumns',2)

%利用ginpuut命令绘图，选取图像中的n个点
clf
x=0:0.05*pi:2*pi;
y=2*cos(x).*sin(x);
plot(x,y)
[m n]=ginput(2)
plot(m,n,'or')
text(m(1),n(1),['(',num2str(m(1)),num2str(n(1)),'}'])

%使用axis命令设定坐标轴示例
clf
x=0:0.2:6;
subplot(1,2,1),plot(x,exp(x),'-bo')

subplot(1,2,2),plot(x,exp(x),'-bo')
axis([0 4 0 80])

%使用grid添加删除网格线
x=0:0.1*pi:3*pi;
y=2*cos(x);
plot(x,y)
grid on
grid off

%坐标轴封闭控制示例
x=0:0.1*pi:3*pi;
y=2*cos(x);
plot(x,y)
box on
box off

%利用view命令设置视点,从不同的角度观察图像
clf
X=0:0.1*pi:3*pi;
Z=2*cos(X);
Y=zeros(size(X));
subplot(2,2,1)
plot3(X,Y,Z,'r');grid;
xlabel('X-axis');ylabel('Y-axis');zlabel('Z-axis');
title('Az=-37.5,E1=30');
view([-37.5,5,30]);
subplot(2,2,2)
plot3(X,Y,Z,'r');grid;
xlabel('X-axis');ylabel('Y-axis');zlabel('Z-axis');
title('Az=-37.5,E1=60');
view([-37.5,5,60]);
subplot(2,2,3)
plot3(X,Y,Z,'r');grid;
xlabel('X-axis');ylabel('Y-axis');zlabel('Z-axis');
title('Az=60,E1=30');
view([60,30]);
subplot(2,2,4)
plot3(X,Y,Z,'r');grid;
xlabel('X-axis');ylabel('Y-axis');zlabel('Z-axis');
title('Az=90,E1=0');
view([90,0]);

%使用ratate3d视角控制命令显示
a=peaks(30);
mesh(a);
rotate3d on

%使用hidden绘制图像
a=peaks(30);
mesh(a);
hidden off

%使用bone绘制图像
[x,y,z]=peaks(30);
surf(x,y,z);
colormap(hsv(128))        %定义图形为u饱和色图，有128种颜色

%使用shading命令控制图形的着色方式
x=-8:8;y=x;
[X,Y]=meshgrid(x,y);
Z=2*X.^2+2*Y.^2;
subplot(1,3,1),surf(Z),shading flat    %平滑
title('FlatShading')
subplot(1,3,2),surf(Z),shading faceted  %平面形式
title('FacetedShading')
subplot(1,3,3),surf(Z),shading interp   %差值形式
title('InterpolateShading')

%使用caxis绘制图像
a=peaks(40);
surf(a)
caxis([-4 4])   %控制颜色范围

%使用brighten改变图色
a=peaks(40);
surf(a)
brighten(-0.2);

%使用colorbar增加颜色标尺
subplot(1,2,1),surf(peaks)
colorbar('vert')    %增加一个垂直的垂直的颜色标尺
subplot(1,2,2),contourf(peaks)
colorbar('southoutside')     %在特定位置显示颜色标尺

%利用colordef命令设置图形背景颜色
subplot(1,2,1),colordef white
a=peaks(30);
surf(a)
subplot(1,2,2),colordef black
surf(a)

%利用light命令为图形设置光源
surf(peaks)
light('Position',[-1 0 0],'Style','infinite')；

%利用lighting命令来设置曲面光源模式
surf(peaks)
light('Position',[-1 0 0],'Style','infinite');
lighting gouraud;   %点模式，以像素为光照的基本单元    phong以像素为基本单元，并计算考虑每一点的反射
lighting none;      %关闭光源
