clear all;
close all; 
clc;

%% prikazivanje u vremenskom domenu

[x1, Fs1] = audioread('truba_4.wav');
t1 = 0:(1/Fs1):((length(x1)-1)/Fs1);
figure(1)
subplot(4,1,1);
plot(t1,x1);
xlabel('t [s]'); ylabel('x(t)'); title('Signal note na trubi'); grid on;

[x2, Fs2] = audioread('klavir_4.wav');
t2 = 0:(1/Fs2):((length(x2)-1)/Fs2);
figure(1)
subplot(4,1,2);
plot(t2,x2);
xlabel('t [s]'); ylabel('x(t)'); title('Signal note na klaviru'); grid on;

[x3, Fs3] = audioread('flauta_4.wav');
t3 = 0:(1/Fs3):((length(x3)-1)/Fs3);
figure(1)
subplot(4,1,3);
plot(t3,x3);
xlabel('t [s]'); ylabel('x(t)'); title('Signal note na flauti'); grid on;

[x4, Fs4] = audioread('violina_4.wav');
t4 = 0:(1/Fs4):((length(x4)-1)/Fs4);
figure(1)
subplot(4,1,4);
plot(t4,x4);
xlabel('t [s]'); ylabel('x(t)'); title('Signal note na violini'); grid on;

%% amplitudske i fazne karakteristike

N1 = 2^nextpow2(length(x1));
X = fft(x1,N1)/length(x1);
f1 = 0:(Fs1/N1):(Fs1/2);
X1 = abs(X(1:(N1/2)+1));
X1(2:(N1/2)+1) = 2*X1(2:(N1/2)+1);
Xphase1 =unwrap(angle(X(1:(N1/2)+1)));
figure(2)
subplot(4,1,1)
plot(f1,X1);
title('AFK signala tona na trubi');
xlabel('f[Hz]'); ylabel('|X(jf)|'); grid on;
figure(3)
subplot(4,1,1);
plot(f1,Xphase1);
title('FFK signala tona na trubi');
xlabel('f[Hz]'); ylabel('arg{X(jf)}'); grid on;

N2 = 2^nextpow2(length(x2));
X = fft(x2,N2)/length(x2);
f2 = 0:(Fs2/N2):(Fs2/2);
X2 = abs(X(1:(N2/2)+1));
X2(2:(N2/2)+1) = 2*X2(2:(N2/2)+1); 
Xphase2 =unwrap(angle(X(1:(N2/2)+1)));
figure(2)
subplot(4,1,2)
plot(f2,X2);
title('AFK signala tona na klaviru');
xlabel('f[Hz]'); ylabel('|X(jf)|'); grid on;
figure(3)
subplot(4,1,2);
plot(f2,Xphase2);
title('FFK signala tona na klaviru');
xlabel('f[Hz]'); ylabel('arg{X(jf)}'); grid on;

N3 = 2^nextpow2(length(x3));
X = fft(x3,N3)/length(x3);
f3 = 0:(Fs3/N3):(Fs3/2);
X3 = abs(X(1:(N3/2)+1));
X3(2:(N3/2)+1) = 2*X3(2:(N3/2)+1); % X1(f) = X2(-f) + X2(f)
Xphase3 =unwrap(angle(X(1:(N3/2)+1)));
figure(2)
subplot(4,1,3)
plot(f3,X3);
title('AFK signala tona na flauti');
xlabel('f[Hz]'); ylabel('|X(jf)|'); grid on;
figure(3)
subplot(4,1,3);
plot(f3,Xphase3);
title('FFK signala tona na flauti');
xlabel('f[Hz]'); ylabel('arg{X(jf)}'); grid on;

N4 = 2^nextpow2(length(x4));
X = fft(x4,N4)/length(x4);
f4 = 0:(Fs4/N4):(Fs4/2);
X4 = abs(X(1:(N4/2)+1));
X4(2:(N4/2)+1) = 2*X4(2:(N4/2)+1); 
Xphase4 =unwrap(angle(X(1:(N4/2)+1)));
figure(2)
subplot(4,1,4)
plot(f4,X4);
title('AFK signala tona na violini');
xlabel('f[Hz]'); ylabel('|X(jf)|'); grid on;
figure(3)
subplot(4,1,4);
plot(f4,Xphase4);
title('FFK signala tona na violini');
xlabel('f[Hz]'); ylabel('arg{X(jf)}'); grid on;

%% odredjivanje frekvencija prvih pikova

pom1 = pikovi(X1,Fs1,N1);
truba_freq_first_pick = round(pom1(1));
truba_average_freq = pom1(2);

pom2 = pikovi(X2,Fs2,N2);
klavir_freq_first_pick = round(pom2(1));
klavir_average_freq = pom2(2);

pom3 = pikovi(X3,Fs3,N3);
flauta_freq_first_pick = round(pom3(1));
flauta_average_freq = pom3(2);

pom4 = pikovi(X4,Fs4,N4);
violina_freq_first_pick = round(pom4(1));
violina_average_freq = pom4(2);

table(truba_freq_first_pick ,klavir_freq_first_pick,...
    flauta_freq_first_pick, violina_freq_first_pick)

table(truba_average_freq,klavir_average_freq,...
    flauta_average_freq, violina_average_freq)