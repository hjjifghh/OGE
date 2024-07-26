%离散函数可视化
n=0:50;
y=100./abs((n-12).*(n+20));
plot(n,y,'.','MarkerSize',16)
grid

%连续函数可视化
x=linspace(0,2*pi,210);
y=sin(x);
plot(x,y,'-*')
grid

%绘制向量曲线、矩阵曲线、复数向量曲线
x=0:pi/5:4*pi;
y=2*cos(x);
plot(y)

y=[3 6 9;2 4 6;1 2 3];
plot(y)

x=[1:0.5:10];
y=[1:0.5:10];
z=x+sin(y).*i;
plot(z)

%绘制双向量曲线、曲线与矩阵曲线、双矩阵曲线
x=0:pi/10:4*pi;
y=2*cos(x);
plot(x,y)

x=0:pi/10:4*pi;
y=[sin(1.5*x);cos(x)+2];
plot(x,y)

x=[1 2 3;4 5 6;7 8 9];
y=[7 8 9;6 5 4;1 2 3];
plot(x,y)

%绘制不同线型
%s 方形  < 左三角 o 圆圈 d 菱形 p 五角形 + 加号    以此类推
x=0:pi/10:4*pi;
y=[sin(1.5*x);cos(x)+2];
plot(x,y,'r-')

t=(0:pi/100:2*pi)';
y1=sin(t).*[1,-1];
y2=sin(t).*cos(6*t);
t3=2*pi*(0:10)/10;
y3=sin(t3).*sin(10*t);
plot(t,y1,'r:',t,y2,'-bo',t3,y3,'m.')

%用双坐标图绘制plotyy
x=0:0.01:20;
y1=200*exp(-0.05*x).*sin(x);
y2=0.8*exp(-0.5*x).*sin(10*x);
plotyy(x,y1,x,y2)

%绘制双y轴图
x=linspace(0,10);
y=sin(3*x);
yyaxis left
plot(x,y)
z=sin(3*x).*exp(0.5*x);
yyaxis right
plot(x,z)
ylim([-150 150])

%绘制参数化曲线
ff=@tan;
fplot(ff,[-3 6]);
xt=@(t)cos(3*t);
yt=@(t)sin(2*t);
fplot(xt,yt)

%绘制隐函数
ezplot('x^4-y^6')

%利用hold命令绘制正弦与余弦曲线
x=linspace(0,4*pi,50);
y=sin(x);
z=cos(x);
plot(x,y,'b');
hold on;
plot(x,z,'k--');
lend('sin(x)','cos(x)');
hold off

%使用subplot命令对图形窗进行分割
x=linspace(0,4*pi,40);
y=sin(x);
z=cos(x);
t=sin(x)./(cos(x)+eps);
ct=cos(x)./(sin(x)+eps);

subplot(2,2,1);plot(x,y);
title('sin(x)');
subplot(2,2,2);plot(x,z);
title('cos(x)');
subplot(2,2,3);plot(x,t);
title('tangent(x)');
subplot(2,2,4);plot(x,ct);
title('contangent(x)');

%绘制三维图
%用plot3命令绘图
t=0:pi/50:10*pi;
plot3(sin(t),cos(t),t)    %螺旋线

t=0:pi/100:3*pi;
x=[t t];
y=[cos(t) cos(2*t)];
z=[(sin(t)).^2+(cos(t)).^2 (sin(t)).^2+(cos(t)).^2+1];
plot3(x,y,z);                %绘制矩阵向量曲线

t=0:pi/500:3*pi;
X=[sin(t).*cos(10*t);sin(t).*cos(12*t);sin(t).*cos(20*t)];
Y=[sin(t).*sin(10*t);sin(t).*sin(12*t);sin(t).*sin(20*t)];
Z=cos(t);
plot3(X,Y,Z)

t=(0:0.02:2)*pi;
x=sin(t);
y=sin(2*t);
z=2*cos(t);
plot3(x,y,z,'b-',x,y,z,'bd')
xlabel('x');ylabel('y');zlabel('z');

%用mesh命令绘制三维网格
x=0:0.1:2*pi;
y=0:0.1:2*pi;
z=sin(x')*cos(2*y);
mesh(x,y,z)

[X,Y]=meshgrid(-5:.2:5);
Z=Y.*sin(X)-X.*cos(Y);
mesh(Z)

%用surf命令绘制着色的三维曲面
x=0:0.2:2*pi;
y=0:0.2:2*pi;
z=sin(x')*cos(2*y);
surf(x,y,z)

%用meshc、meshz命令绘制三维网格
x=0:0.2:2*pi;
y=0:0.2:2*pi;
z=sin(x')*cos(2*y);
meshc(z)         %先绘制平面，然后绘制三维，绘制等高线
meshz(z)         %增加绘制边界面功能

%绘制等高线以及光照效果三维曲面图，然后用三维曲面表现函数
x=0:0.2:2*pi;
y=0:0.2:2*pi;
z=sin(x')*cos(2*y);
surfc(x,y,z)            %绘制等高线三维曲面图
surfl(x,y,z)            %绘制光照效果三维曲面图

%饼状图pie 填充绘图area 彗星图comet 误差条图errorbar 矢量图feather
%多边形填充fill 拓扑图gplot 向量场quiver 等高线图contour
%水平条形图barth 垂直条形图bar 分散矩阵绘制plotmatrix
%二维条形直方图hist 散射图scatter 离散数据序列针状图stem
%阶梯图stairs 极坐标系下的柱状图rose

%用pie命令绘制饼状图
x=[0.43 .30 .68 .45 .8];
pie(x)
y=[0 0 0 1 0];     %有一片突出来了
pie(x,y)

%绘制阶梯图
X=linspace(0,4*pi,40);
Y=sin(X);
stairs(Y)
stairs(X,Y)

%用bar绘制条形图
x=-2.5:0.25:2.5;
y=2*exp(-x.*x);
bar(x,y,'black')

y=[2 2 3;2 5 6;2 8 9;2 11 12];
bar(y)

%绘制条形图示例
X=round(20*rand(3,4));
subplot(2,2,1);bar(X,'group');title('bargroup')
subplot(2,2,2);barh(X,'stack');title('barstack')
subplot(2,2,3);bar(X,'stack');title('barstack')
subplot(2,2,4);bar(X,1.2);title('barwidth=1.2')

%用hist/histogram绘制条形直方图
x=-2.5:0.25:2.5;
y=rand(5000,1);
hist(y,x)

x=randn(1000,1);
nbins=25;
histogram(x,nbins)   %根据等距分组的随机数绘制条形直方图

%用stem绘制离散数据序列
Y=linspace(-2*pi,2*pi,20);      %创建一个在区间内的20个离散数据值
stem(Y)     %绘制离散数据序列针状图

X=linspace(0,2*pi,20);
Y=cos(X);
stem(X,Y)           %绘制离散数据序列针状图

%用contour绘制等高线
[X,Y]=meshgrid(-2:.2:2,-2:.2:3);
Z=2*Y.*exp(-X.^2-Y.^2);
contour(X,Y,Z)
[X,Y,Z]=peaks;
contour(X,Y,Z,20)

%用quiver绘制矢量图
[X,Y]=meshgrid(-2:.2:2,-2:.2:3);
Z=2*Y.*exp(-X.^2-Y.^2);
[DX,DY]=gradient(Z,.2,.2);
contour(X,Y,Z)
hold on
quiver(X,Y,DX,DY)

%绘制含误差条的线图
x=[0:0.1:4*pi];
y=2*cos(2*x);
e=[0:1/(length(x)-1):1];
errorbar(x,y,e)             %绘制y对x的图，并在每个数据点处绘制一个垂直误差条

%绘制彗星图
t=0:.01:4*pi;
x=sin(t).*(cos(2*t).^2);
y=cos(t).*(sin(2*t).^2);
comet(x,y)     %显示向量y对向量X的彗星图

%绘制三维特殊图像
%bar3三维条形图 comet3三维彗星轨迹图 ezgragh3函数控制绘制三维图
%pie3三维饼状图 scatter3三维散射图 quiver3向量场
%stem3三维离散数据图 trisurf三角形表面图 trimesh三角形网格图
%sphere球面图 cylinder柱面图 contour3三维等高线

%用cylinder绘制圆柱圆形
cylinder(3)      %绘制圆柱图形，半径为3

t=0:pi/10:4*pi;
[X,Y,Z]=cylinder(sin(2*t)+3,50);
surfc(X,Y,Z)

%用sphere绘制球体
sphere         %绘制球体

[x,y,z]=sphere(40);
mesh(x,y,z)

%stem3绘制三维离散数据序列
x=0:1:4;
y=0:1:4;
z=3*rand(5);
stem3(x,y,z,'bo')
z=rand(4);
stem3(z,'ro','filled')    %绘制带填充的三维离散数据序列


%特殊坐标轴函数
%用semilogx绘制以x轴为对数的坐标图
x=0:0.01:2*pi;
y=abs(100*sin(4*x))+1;
semilogx(x,y)

%用semilogy绘制以轴为对数的坐标图
x=0:0.1:4*pi;
y=abs(100*sin(2*x))+1;
semilogy(x,y)

%用loglog绘制双对数的坐标图
x=0:0.1:2*pi;
y=abs(100*sin(3*x))+2;
loglog(x,y)

%用polar绘制极坐标图
theta=0:0.01:2*pi;
rho=sin(2*theta).*cos(2*theta);
polar(theta,rho)            %创建角theta对半径rho的极坐标图

%四维表现图（三维体切片平面）slice
[X,Y,Z]=meshgrid(-5:0.2:5);
V=X.*exp(-X.^2-Y.^2-Z.^2);
[xsurf,ysurf]=meshgrid(-2:0.2:2);
zsurf=xsurf.^2-ysurf.^2;
slice(X,Y,Z,V,xsurf,ysurf,zsurf)     %显示沿非平面切片的三维体数据