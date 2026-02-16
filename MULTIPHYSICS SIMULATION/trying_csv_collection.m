tef = "total_eff.csv";
A = readmatrix(tef);

vef = "vol_eff.csv";
B = readmatrix(vef);

x1 = A(:,1);
y1 = A(:,2);


x2 = B(:,1);
y2 = B(:,2);


y2_adjusted = interp1(x2,y2,x1);

plot(x1, y2_adjusted, x1, y1)