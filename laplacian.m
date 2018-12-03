% real = rand(1000,1);

hname = {'h = 0.005' 'h =   0.05' 'h =   0.25' 'h =        1'};
colors = {'r' 'b' 'g' 'm'};
lines = {'-','-.','--',':'};

hold on
hset = [.005,.05,.25,1];
% h = 5;
for j = 1:1:4
    h = hset(j);
    disp(h);
    y = 0;
for i = 1:1:1000
    a = real(i);
    x = -1:.05:2;
    y = y + ((1/(2*h))*exp(-(1/h)*abs(x-a)))/1000;
end
plot(x,y, 'Color',colors{j},'LineStyle',lines{j},'LineWidth',1);
end
legend(hname)
title('Construct PDF using Laplacian kernel with different h')
hold off