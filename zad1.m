clear all
close all 
clc

P = mod(0021,4) + 4;
Q = mod(0+0+2+1,4); 
R = mod(0021+2019,3);
S = mod(0021,3);

%% odredjivanje diskretnih signala x i y

x = zeros(1,P);
y = zeros(1,P);

for i=0:(P-1)
    if (i < floor(P/2))
        x(i+1) = sin(i) + 2*cos(2*i) + P/2;
        y(i+1) = (-1)^i + mod(i,2);
    else
        x(i+1) = 2^i;
        y(i+1) = i - P/2;
    end
end

%% iscrtavanje diskretnih signala x i y u P tacaka

n = 0:(P-1);
figure(1)
subplot(2,1,1);
stem(n,x);
xlabel('n [odb]'); ylabel('x[n]'); title('Signal x[n]'); grid on;
subplot(2,1,2);
stem(n,y);
xlabel('n [odb]'); ylabel('y[n]'); title('Signal y[n]'); grid on;

%% ciklicna konvolucija u P+2 (5+2=7) tacaka

x1 = [x zeros(1,(P+2)-length(x))]; %dopunjavanje nulama
y1 = [y zeros(1,(P+2)-length(y))];

z = zeros(1,(P+2));

for k = 0:((P+2)-1)
    z(k+1) = x1*transpose(y1(mod(k:-1:k-((P+2)-1),(P+2))+1));
end

z_cconv = cconv(x1,y1,(P+2));

n1 = 0:(P+1);
figure(2)
stem(n1,z);
xlabel('n [odb]'); ylabel('z[n]'); title...
    ('Cirkularna konvolucija signala x[n] i y[n] u P+2 tacaka'); grid on;

%% linearna konvolucija
N = length(x)+length(y)-1;

y2 = [y zeros(1,N-length(y))];

z_lin = zeros(1,N);

for i=1:N
    for j=1:length(x)
        if(i-j+1>0)
            z_lin(i)=z_lin(i)+x(j)*y2(i-j+1);
        end
    end
end

z_lin_conv = conv(y,x);

n_lin = 0:(N-1);
figure(3)
subplot(2,1,1)
stem(n_lin,z_lin);
xlabel('n [odb]'); ylabel('z\_lin[n]'); title...
    ('Linearna konvolucija signala x[n] i y[n]'); grid on;

%% cirkularna konvolucija koja odgovara linearnoj

x2 = [x zeros(1,N-length(x))];

z_lin2 = zeros(1,N);

for k = 0:(N-1)
z_lin2(k+1) = sum(x2.*y2(mod(k:-1:k-(N-1) ,N)+1)); 
end

z_lin_cconv = cconv(x2, y2, N);

figure(3)
subplot(2,1,2)
stem(n_lin,z_lin2);
xlabel('n [odb]'); ylabel('z\_lin2[n]'); title...
    ('Cirkularna konvolucija signala x[n] i y[n] u P+P-1 tacaka'); grid on;

%% provera
figure(4)
subplot(2,1,1)
stem(n1,z);
xlabel('n [odb]'); ylabel('z[n]'); title...
('Cirkularna konvolucija signala x[n] i y[n] u P+2 tacaka'); grid on;
subplot(2,1,2)
stem(n1,z_cconv);
xlabel('n [odb]'); ylabel('z\_cconv[n]'); title...
('Cirkularna konvolucija signala x[n] i y[n] u P+2 tacaka dobijena pomocu funkcije cconv()'); grid on;

figure(5)
subplot(3,1,1)
stem(n_lin,z_lin);
xlabel('n [odb]'); ylabel('z\_lin[n]'); title...
('Linearna konvolucija signala x[n] i y[n]'); grid on;
subplot(3,1,2)
stem(n_lin,z_lin2);
xlabel('n [odb]'); ylabel('z\_lin2[n]'); title...
('Cirkularna konvolucija signala x[n] i y[n] koja odgovara linearnoj'); grid on;
subplot(3,1,3)
stem(n_lin,z_lin_cconv);
xlabel('n [odb]'); ylabel('z\_conv[n]'); title...
('Linearna konvolucija signala x[n] i y[n] dobijena pomocu funkcije conv()'); grid on;
