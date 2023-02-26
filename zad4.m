clear all
close all
clc
%% a - AFK signala tona
[x, Fs] = audioread('truba_4.wav');
N = 2^nextpow2(length(x));
X = fft(x,N)/length(x);
f = 0:(Fs/N):(Fs/2);
X1 = abs(X(1:(N/2)+1));
X1(2:(N/2)+1) = 2*X(2:(N/2)+1); % X1(f) = X2(-f) + X2(f)

figure(1)
plot(f,abs(X1));
title('AFK signala tona na trubi');
xlabel('f[Hz]'); ylabel('|X(jf)|'); grid on;

%% projektovanje FIR filtra
n = 49;
window = blackman(n+1);
Wn = [500 1000]/(Fs/2);
b = fir1(n, Wn, window);
a = 1;
[hz, fz] = freqz(b, a, N/2+1, Fs);

figure(2)
stem(window);
xlabel('n[odb]');
title('Blackman prozorska funkcija'); grid on;

figure(3)
plot(fz, 20*log10(abs(hz)));
xlabel('f[Hz]');
title('AFK FIR filtra'); grid on;

%% filtriranje signala

y = filter(b, a, x);
Y = fft(y,N)/length(y);
Y1 = abs(Y(1:N/2+1));
Y1(2:N/2+1) = 2*Y1(2:N/2+1);

figure(4)
plot(f,abs(X1));
hold on;
plot(f,abs(Y1));
title('AFK signala tona na trubi');
xlabel('f[Hz]'); ylabel('|X(jf)|'); grid on;
legend('pre filtriranja','posle filtriranja');

audiowrite('isfiltriran3.wav', y, Fs);
%% b
y1 = [];
for i=1:length(y)
   if (mod(i,9) == 0)
       y1 = [y1 y(i)];
   end
end

% fft novoodabranog signala y1
Fs_new = Fs/9;
N1 = 2^nextpow2(length(y1));
Y_new = fft(y1,N1)/length(y1);
Y1_new = abs(Y_new(1:(N1/2)+1));
Y1_new(2:(N1/2)+1) = 2*Y_new(2:(N1/2)+1);

f1 = 0:(Fs_new/N1):(Fs_new/2); %nova frekvencijska osa

figure(5)
plot(f1,abs(Y1_new));
title('AFK isfiltriranog signala tona na trubi nakon zamene ucestanosti');
xlabel('f[Hz]'); ylabel('|X(jf)|'); grid on;
grid on;

audiowrite('isfiltriran4.wav', y1, Fs_new);