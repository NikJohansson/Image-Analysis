function features = segment2features(I)
features = zeros(7,1);

xmin=intmax;
xmax=0;
ymin=intmax;
ymax=0;

[M,N]=size(I);
for j=1:N
    for i=1:M
        if I(i,j)==1&&j<xmin
            xmin=j;
        end
        if I(i,j)==1&&j>xmax
            xmax=j;
        end
    end
end
for i=1:M
    for j=1:N
        if I(i,j)==1&&i<ymin
            ymin=i;
        end
        if I(i,j)==1&&i>ymax
            ymax=i;
        end
    end
end
I= [zeros(1,xmax-xmin+3);
    zeros(ymax-ymin+1,1), I(ymin:ymax,xmin:xmax), zeros(ymax-ymin+1,1);
    zeros(1,xmax-xmin+3)];
[M,N]=size(I);

% Pertcentage of filled elements
features(1) = sum(I,'all')/(M*N);

%Centre of mass
xmass=0;
ymass=0;
for i=1:M
    for j=1:N
        xmass=xmass+I(i,j)*j;
        ymass=ymass+I(i,j)*i;
    end
end
x_centre=xmass/sum(I,'all')/N;
y_centre=ymass/sum(I,'all')/M;

%Horisontal centre of mass
features(2)=x_centre;

%Vertical centre of mass
features(3)=y_centre;

l=floor(M/3);
I1=I(1:l,:);
I2=I(l:2*l,:);
I3=I(2*l:end,:);

% Pertcentage of filled elements in evey vertical third
features(4) = sum(I1,'all')/(l*N);
features(5) = sum(I2,'all')/(l*N);
features(6) = sum(I3,'all')/((M-2*l)*N);

%Number of holes
[B, nr_segments] = bwlabel(~I, 8);
if nr_segments==3
    features(7)=1;
elseif nr_segments==2
    features(7)=0;
else
    features(7)=0.5;
end
end

