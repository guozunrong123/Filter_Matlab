clear all;
close all;
clc;
addpath(genpath(pwd));

X =load('data1.txt');

L = size(X,1);   % Length of signal
T=0.0013; % Sampling period  (second)
t = (0:L-1)*T;        % Time vector

sample_freq=66.7;
cutoff_freq=5;
M_PI_F=3.14159265;

fr = sample_freq / cutoff_freq;
ohm = tan(M_PI_F / fr);
c = 1 + 2 * cos(M_PI_F / 4) * ohm + ohm * ohm;

b0 = ohm * ohm / c;
b1 = 2 * b0;
b2 = b0;
a1 = 2 * (ohm * ohm - 1) / c;
a2 = (1 - 2 * cos(M_PI_F / 4) * ohm + ohm * ohm) / c;

delay_element_2 = X(1,1) / (1 + a1 + a2);
delay_element_1 = delay_element_2;

X_Num=size(X(:,1));
output = X;
for i=1:X_Num
    sample=X(i,1);
    delay_element_0=sample - delay_element_1 * a1 - delay_element_2 * a2;
    output(i,1)=delay_element_0 * b0 + delay_element_1 * b1 + delay_element_2 * b2;
    delay_element_2 = delay_element_1;
    delay_element_1 = delay_element_0;
end
figure,
    plot(t,output(:,1));
    hold on;
    plot(t,X(:,1));

title('Signal')
xlabel('t (seconds)')
ylabel('X(t)')
legend('X fil','X','Location','northeastoutside','box','off');


Y = fft(X);
Y_fil = fft(output);
P2 = abs(Y/L);
P1 = P2(1:L/2+1,1);
P1(2:end-1,1) = 2*P1(2:end-1,1);

P2_fil = abs(Y_fil/L);
P1_fil = P2_fil(1:L/2+1,1);
P1_fil(2:end-1,1) = 2*P1_fil(2:end-1,1);


figure,
f = sample_freq*(0:(L/2))/L;
plot(f,P1(:,1));
hold on;
plot(f,P1_fil(:,1))
title('FFT of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
legend('Y fil','Y','Location','northeastoutside','box','off');

