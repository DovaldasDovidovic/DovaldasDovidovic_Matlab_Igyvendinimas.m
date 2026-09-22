clc
clear all
x = 0.1:1/22:1;
d = ((1+0.6*sin(2*pi*x/0.7))+0.3*sin(2*pi*x))/2;

% 1 sluoksnio svoriai
w11_1 = rand(1);
w12_1 = rand(1);
w21_1 = rand(1);
w22_1 = rand(1);

b1_1 = rand(1);
b2_1 = rand(1);

% 2 sluoksnio svoriai
w11_2 = rand(1);
w12_2 = rand(1);
w21_2 = rand(1);
w22_2 = rand(1);
w31_2 = rand(1);
w32_2 = rand(1);

b1_2 = rand(1);
b2_2 = rand(1);
b3_2 = rand(1);

% 3 sluoksnio svoriai
w11_3 = rand(1);
w12_3 = rand(1);
w13_3 = rand(1);

b1_3 = rand(1);

% mokymosi greitis
eta = 0.1;

% MOKYMAS

for iter = 1:50000
    y_prev = 0;

    for n = 1:length(x)

% įėjimai
x1 = x(n);
x2 = y_prev;

% 1 sluoksnio 
v1_1 = x1*w11_1+x2*w12_1+b1_1;
v2_1 = x1*w21_1+x2*w22_1+b2_1;

y1_1 = 1/(1+exp(-v1_1));
y2_1 = 1/(1+exp(-v2_1));

% 2 sluoksnio
v1_2 = y1_1*w11_2 + y2_1*w12_2 + b1_2;
v2_2 = y1_1*w21_2 + y2_1*w22_2 + b2_2;
v3_2 = y1_1*w31_2 + y2_1*w32_2 + b3_2;

y1_2 = 1/(1+exp(-v1_2));
y2_2 = 1/(1+exp(-v2_2));
y3_2 = 1/(1+exp(-v3_2));

% Išėjimo
v1_3 = y1_2*w11_3+y2_2*w12_3+y3_2*w13_3+b1_3;
y = 1/(1+exp(-v1_3));

% Klaida
e = d(n)-y;

% Išėjimo sluoksnio
delta1_3 = e*y*(1-y);

% 2 sluoksnio 
delta1_2 = y1_2*(1-y1_2)*delta1_3*w11_3;
delta2_2 = y2_2*(1-y2_2)*delta1_3*w12_3;
delta3_2 = y3_2*(1-y3_2)*delta1_3*w13_3;

% 1 sluoksnio
delta1_1 = y1_1*(1-y1_1)*(delta1_2*w11_2 + delta2_2*w21_2 + delta3_2*w31_2);
delta2_1 = y2_1*(1-y2_1)*(delta1_2*w12_2 + delta2_2*w22_2 + delta3_2*w32_2);

% 3 sluoksnio svorių atnaujinimas
w11_3 = w11_3 + eta*delta1_3*y1_2;
w12_3 = w12_3 + eta*delta1_3*y2_2;
w13_3 = w13_3 + eta*delta1_3*y3_2;

b1_3 = b1_3+eta*delta1_3;

% 2 sluoksnio svorių atnaujinimas
w11_2 = w11_2+eta*delta1_2*y1_1;
w12_2 = w12_2+eta*delta1_2*y2_1;
w21_2 = w21_2+eta*delta2_2*y1_1;
w22_2 = w22_2+eta*delta2_2*y2_1;
w31_2 = w31_2+eta*delta3_2*y1_1;
w32_2 = w32_2+eta*delta3_2*y2_1;

b1_2 = b1_2+eta*delta1_2;
b2_2 = b2_2+eta*delta2_2;
b3_2 = b3_2+eta*delta3_2;

% 1 sluoksnio svoriu atnaujinimas
w11_1 = w11_1+eta*delta1_1*x1;
w12_1 = w12_1+eta*delta1_1*x2;
w21_1 = w21_1+eta*delta2_1*x1;
w22_1 = w22_1+eta*delta2_1*x2;

b1_1 = b1_1+eta*delta1_1;
b2_1 = b2_1+eta*delta2_1;

y_prev = y;

end
end

y_model = zeros(size(x));
y_prev = 0;

for n = 1:length(x)
    x1=x(n);
    x2=y_prev;

    % 1 sluoksnis
    v1_1 = x1*w11_1 + x2*w12_1 + b1_1;
    v2_1 = x1*w21_1 + x2*w22_1 + b2_1;
    y1_1 = 1/(1 + exp(-v1_1));
    y2_1 = 1/(1 + exp(-v2_1));
    
    % 2 sluoksnis
    v1_2 = y1_1*w11_2 + y2_1*w12_2 + b1_2;
    v2_2 = y1_1*w21_2 + y2_1*w22_2 + b2_2;
    v3_2 = y1_1*w31_2 + y2_1*w32_2 + b3_2;
    y1_2 = 1/(1 + exp(-v1_2));
    y2_2 = 1/(1 + exp(-v2_2));
    y3_2 = 1/(1 + exp(-v3_2));

    % 3 sluoksnis 
    v1_3 = y1_2*w11_3 + y2_2*w12_3 + y3_2*w13_3 + b1_3;
    y = 1/(1 + exp(-v1_3));


    y_model(n) = y;
    y_prev = y;
end

% grafikas

figure
plot(x, d, 'bo-', 'LineWidth', 1.5)
hold on
plot(x, y_model, 'r*-', 'LineWidth', 1.5)

grid on
xlabel('x')
ylabel('y')
title('Norimo ir neuroninio tinklo atsako palyginimas')
legend('Norimas atsakas d', 'Tinklo atsakas y')
