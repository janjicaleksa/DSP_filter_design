%% a - iscrtavanje u vremenskom domenu
clear all
close all
clc

[x, Fs] = audioread('forrest_gump_zasumljen1.wav');
t = 0:1/Fs:(length(x)-1)/Fs;

figure(1)
plot(t,x);
xlabel('t[s]'); ylabel('x(t)');
title('Vremenski oblik prvog zasumljenog signala'); grid on;

%% b - iscrtavanje AFK

N = 2^nextpow2(length(x));
f1 = 0:Fs/N:Fs/2;
X = fft(x,N)/length(x);
X1 = abs(X(1:N/2+1));
X1(2:N/2+1) = 2*X1(2:N/2+1);

figure(2)
plot(f1,X1);
xlabel('f[Hz]'); ylabel('|X(jf)|');
title('AFK prvog zasumljenog signala'); grid on;

%% c - prvi filtar - uklanjanje sinusoidalnog suma na 3kHz

Rp = 2;
Rs = 40;
Wp1 = [2900 3100]/(Fs/2);
Ws1 = [2950 3050]/(Fs/2); 
[n1, Wn1] = cheb1ord(Wp1, Ws1, Rp, Rs);
[b1, a1] = cheby1(n1, Rp, Wp1, 'stop'); 
[h1, w1] = freqz(b1, a1, N/2+1); 

figure(3)
plot(w1, 20*log10(abs(h1)));
xlabel('\Omega [rad/odb]'); ylabel('Amplituda [dB]');
title('AFK prvog filtra'); grid on;

%filtriranje signala prvim filtrom

y1 = filter(b1, a1, x);
Y = fft(y1,N)/length(y1);
Y1 = abs(Y(1:N/2+1)); %abs funkcija ne radi
Y1(2:N/2+1) = 2*Y(2:N/2+1);

%% c - drugi filtar - uklanjanje sinusoidalnog suma na 5kHz

Wp2 = [4900 5100]/(Fs/2);
Ws2 = [4950 5050]/(Fs/2); 
[n2, Wn2] = cheb1ord(Wp2, Ws2, Rp, Rs);
[b2, a2] = cheby1(n2, Rp, Wp2, 'stop');
[h2, w2] = freqz(b2, a2, N/2+1); 

figure(4)
plot(w2, 20*log10(abs(h2)));
xlabel('\Omega [rad/odb]'); ylabel('Amplituda [dB]');
title('AFK drugog filtra'); grid on;

% filtriranje filtriranog signala drugim filtrom

y2 = filter(b2, a2, y1);
Y = fft(y2,N)/length(y2);
Y2 = abs(Y(1:N/2+1));
Y2(2:N/2+1) = 2*Y(2:N/2+1);

figure(5)
plot(t,x);
hold on;
plot(t,y2);
xlabel('t[s]'); ylabel('x(t)'); grid on;
title('Vremenski oblik prvog zasumljenog signala');
legend('pre filtriranja','posle filtriranja');

figure(6)
plot(f1,X1);
xlabel('f[Hz]'); ylabel('|X(jf)|');
title('AFK signala'); grid on;
hold on;
plot(f1,abs(Y1)); %prilikom odredjivanja vektora Y1, koji bi zbog
                  %abs() funkcije trebao biti nenegativan
                  %(sto nije tako)
                  %da bih postigao zeljenu apsolutnost prilikom iscrtavanja 
                  %grafika, u plot() naredbi dodatno "abs"-ujem vektor Y1
                  %ista stvar se desava i kasnije kod vektora Y2
legend('pre prvog filtra','posle prvog filtra');

figure(7)
plot(f1,abs(Y1));
xlabel('f[Hz]'); ylabel('|X(jf)|');
title('AFK signala'); grid on;
hold on;
plot(f1,abs(Y2));
legend('pre drugog filtra','posle drugog filtra');

audiowrite('isfiltriran1.wav', y2, Fs);
%% e - drugi zasumljeni signal

[x2,Fs2] = audioread('forrest_gump_zasumljen2.wav');

t2 = 0:1/Fs2:(length(x2)-1)/Fs2;
figure(8)
plot(t2,x2);
xlabel('t[s]'); ylabel('x(t)'); grid on;
title('Vremenski oblik drugog zasumljenog signala');
%hold on;

N2 = 2^nextpow2(length(x2));
f2 = 0:Fs2/N2:Fs2/2;
Xb = fft(x2,N2)/length(x2);
Xb1 = abs(Xb(1:N2/2+1));
Xb1(2:N2/2+1) = 2*Xb(2:N2/2+1);

figure(9)
plot(f2,abs(Xb1));
xlabel('f[Hz]'); ylabel('|X(jf)|');
title('AFK drugog zasumljenog signala'); grid on;
%hold on;

%analogni filtar
Wpb = 1500*2*pi;
Wsb = 2000*2*pi;
[nb, Wnb] = cheb1ord(Wpb, Wsb, Rp, Rs,'s');
[bb, ab] = cheby1(nb, Rp, Wpb, 's');
[hb, wb] = freqs(bb, ab, N2/2+1);

figure(10)
plot(wb/(2*pi),20*log10(abs(hb)));
grid on;
hold on;

[bz, az] = bilinear(bb, ab, Fs2);
[hz, fz] = freqz(bz, az, N2/2+1, Fs2); %digitalni

figure(10)
plot(fz, 20*log10(abs(hz)));
xlabel('f[Hz]'); ylabel('Amplituda [dB]');
title('AFK filtra'); grid on;
legend('analogni','digitalni');
grid on;

yb = filter(bz, az, x2);
Yb = fft(yb,N2)/length(yb);
Yb1 = abs(Yb(1:N2/2+1));
Yb1(2:N2/2+1) = 2*Yb1(2:N2/2+1);

figure(11)
plot(t2,x2);
hold on;
plot(t2,yb);
xlabel('t[s]'); ylabel('x(t)'); grid on;
title('Vremenski oblik signala');
legend('zasumljeni','isfiltrirani');

figure(12)
plot(f2,abs(Xb1));
hold on;
plot(f2,Yb1);
xlabel('f[Hz]'); ylabel('|X(jf)|'); grid on;
title('AFK signala');
legend('zasumljeni','isfiltrirani');

audiowrite('isfiltriran2.wav', yb, Fs2);