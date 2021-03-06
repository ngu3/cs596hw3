load('C:\data3-2.mat');
% disp(circles(:,1));
% disp(circles(:,2));
figure
hold on
plot(circles(:,1), circles(:,2),'.');
plot(stars(:,1), stars(:,2),'*');
lh = legend('circles', 'stars');
lh.Position(1) = 0.5 - lh.Position(3)/2;
lh.Position(2) = 0.8 - lh.Position(4)/2;
% hold off

% a = (circles(:,1)) * (circles(:,2))
K = zeros(42,42);

h = 5;
lambda = .1;
for i = 1:1:21
    for j = 1:1:21
        K(i,j) = exp((-1/h)*(abs(stars(i,1) - stars(j,1))^2 + abs(stars(i,2) - stars(j,2))^2));
    end
end

for i = 1:1:21
    for j = 1:1:21
        K(i,j + 21) = exp((-1/h)*(abs(stars(i,1) - circles(j,1))^2 + abs(stars(i,2) - circles(j,2))^2));
    end
end

for i = 1:1:21
    for j = 1:1:21
        K(i+21,j) = exp((-1/h)*(abs(circles(i,1) - stars(j,1))^2 + abs(circles(i,2) - stars(j,2))^2));
    end
end

for i = 1:1:21
    for j = 1:1:21
        K(i+21,j+21) = exp((-1/h)*(abs(circles(i,1) - circles(j,1))^2 + abs(circles(i,2) - circles(j,2))^2));
    end
end

I = eye(42);
b1 = ones(1,21);
b2 = ones(1,21)-2;
b = transpose(cat(2 ,b1, b2));
A = (inv(lambda*I + K))*b;

data = cat(1,stars,circles);



% for i = 1:1:42
%     g = g + A(i)*exp((-1/h)*((x-data(i,1)).^2 + (y - data(i,2)).^2));
% end

% figure
% hold on
X = zeros(250,2);
cnt = 0;
j = 1;
for x = -1:.001:1.1
%     disp(x);
    for y = -0.2:.001:1.2
        g = 0;
        for i = 1:1:42
            g = g + A(i)*exp((-1/h)*((x-data(i,1)).^2 + (y - data(i,2)).^2));
        end
        if abs(g) < 10^-3
            X(j, 1) = x;
            X(j, 2) = y;
            j = j + 1;
            cnt = cnt + 1;
%             disp('-----------');
%             disp(x);
%             disp(y);
%             plot(x,y);
            break
        end
    end
end
plot(X(:,1),X(:,2),'g','LineWidth',2,'DisplayName','boundary')

%%verify
% disp(stars(1,1));
% disp(stars(1,2));

acc_pred = 0;
for i= 1:1:21
    g = 0;
    for j = 1:1:42
        g = g + A(j)*exp((-1/h)*((stars(i,1)-data(j,1)).^2 + (stars(i,2) - data(j,2)).^2));
    end
    if g > 0
        acc_pred = acc_pred + 1;
    end
end

for i= 1:1:21
    g = 0;
    for j = 1:1:42
        g = g + A(j)*exp((-1/h)*((circles(i,1)-data(j,1)).^2 + (circles(i,2) - data(j,2)).^2));
    end
    if g < 0
        acc_pred = acc_pred + 1;
    end
end

acc = acc_pred/42;
acc_pct = acc * 100
title(sprintf('Boundary with Gaussian Kernel \n with h = %2.0f, \\lambda = %2.1f, accuracy = %2.2f%%', h, lambda, acc_pct))


