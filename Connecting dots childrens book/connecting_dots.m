im = imread('dots.jpg');
im= rgb2gray(im);
im=mat2gray(im);

I=im<0.5*max(im);
[B,nr]=bwlabel(I);
nr_components=zeros(nr,1);
for i=1:nr
    nr_components(i)=nnz(B==i);
end
for i=1:4
    [M,I]=max(nr_components);
    B(B==I)=0;
    nr_components(I)=0;
end
x_coords=zeros(nr,2);
y_coords=zeros(nr,2);
[M,N]=size(im);
for k=1:nr
    if nr_components(k)~=0
        xmin=intmax;
        xmax=0;
        ymin=intmax;
        ymax=0;
        for j=1:N
            for i=1:M
                if B(i,j)==k&&j<xmin
                    xmin=j;
                end
                if B(i,j)==k&&j>xmax
                    xmax=j;
                end
            end
        end
        x_coords(k,1)=xmin;
        x_coords(k,2)=xmax;
        for i=1:M
            for j=1:N
                if B(i,j)==k&&i<ymin
                    ymin=i;
                end
                if B(i,j)==k&&i>ymax
                    ymax=i;
                end
            end
        end
        y_coords(k,1)=ymin;
        y_coords(k,2)=ymax;
    end
end

p = imread('template.jpg');
p= rgb2gray(p);
p=mat2gray(p);
e=ones(size(p));
pr=fliplr(flipud(p));
r= conv2(im.^2, e, 'same')-2*conv2(im,pr,'same')+ sum(sum(pr.^2));
[y,x]=find(r==min(min(r)));

start=0;
min_dist=intmax;
for i=1:nr
    if nr_components(i)~=0
        dist=(x-(x_coords(i,1)+x_coords(i,2))/2)^2+(y-(y_coords(i,1)+y_coords(i,2))/2)^2;
        % no need for sqrt in this case
        if dist<min_dist
            min_dist=dist;
            start=i;
        end
    end
end
nr_components_copy=nr_components;
nr_components_copy(start)=0;

first_dot=0;
min_dist=intmax;

for i=1:nr
    if nr_components_copy(i)~=0
        x_dist = (x_coords(start,1) + x_coords(start,2))/2 - (x_coords(i,1) + x_coords(i,2))/2;
        y_dist = (y_coords(start,1) + y_coords(start,2))/2 - (y_coords(i,1) + y_coords(i,2))/2;
        dist=x_dist^2+y_dist^2; % no need for sqrt in this case
        if dist<min_dist
            min_dist=dist;
            first_dot=i;
        end
    end
end
nr_components_copy(first_dot)=0;

if nnz(nr_components)>18
    nr_dots = 9 +(nnz(nr_components)-18)/3;
else
    nr_dots =nnz(nr_components)/2;
end

current=zeros(3,1);
previous=first_dot;
imagesc(im);
hold on;
for k=1:nr_dots-1
    min_dist=intmax;
    if k<9
        for i=1:nr
            if nr_components_copy(i)~=0
                x_dist = (x_coords(previous,1) + x_coords(previous,2))/2 - (x_coords(i,1) + x_coords(i,2))/2;
                y_dist = (y_coords(previous,1) + y_coords(previous,2))/2 - (y_coords(i,1) + y_coords(i,2))/2;
                dist=x_dist^2+y_dist^2; % no need for sqrt in this case
                if dist<min_dist
                    min_dist=dist;
                    current(1)=i;
                end
            end
        end
        nr_components_copy(current(1))=0;
        min_dist=intmax;
        for i=1:nr
            if nr_components_copy(i)~=0
                x_dist = (x_coords(current(1),1) + x_coords(current(1),2))/2 - (x_coords(i,1) + x_coords(i,2))/2;
                y_dist = (y_coords(current(1),1) + y_coords(current(1),2))/2 - (y_coords(i,1) + y_coords(i,2))/2;
                dist=x_dist^2+y_dist^2; % no need for sqrt in this case
                if dist<min_dist
                    min_dist=dist;
                    current(2)=i;
                end
            end
        end
        nr_components_copy(current(2))=0;
        
        if abs(nr_components(current(1))-nr_components(first_dot))<=abs(nr_components(current(2))-nr_components(first_dot))
            next = current(1);
        else
            next = current(2);
        end
    else
        for i=1:nr
            if nr_components_copy(i)~=0
                x_dist = (x_coords(previous,1) + x_coords(previous,2))/2 - (x_coords(i,1) + x_coords(i,2))/2;
                y_dist = (y_coords(previous,1) + y_coords(previous,2))/2 - (y_coords(i,1) + y_coords(i,2))/2;
                dist=x_dist^2+y_dist^2; % no need for sqrt in this case
                if dist<min_dist
                    min_dist=dist;
                    current(1)=i;
                end
            end
        end
        nr_components_copy(current(1))=0;
        min_dist=intmax;
        for i=1:nr
            if nr_components_copy(i)~=0
                x_dist = (x_coords(current(1),1) + x_coords(current(1),2))/2 - (x_coords(i,1) + x_coords(i,2))/2;
                y_dist = (y_coords(current(1),1) + y_coords(current(1),2))/2 - (y_coords(i,1) + y_coords(i,2))/2;
                dist=x_dist^2+y_dist^2; % no need for sqrt in this case
                if dist<min_dist
                    min_dist=dist;
                    current(2)=i;
                end
            end
        end
        nr_components_copy(current(2))=0;
        min_dist=intmax;
        for i=1:nr
            if nr_components_copy(i)~=0
                x_dist = (x_coords(current(2),1) + x_coords(current(2),2))/2 - (x_coords(i,1) + x_coords(i,2))/2;
                y_dist = (y_coords(current(2),1) + y_coords(current(2),2))/2 - (y_coords(i,1) + y_coords(i,2))/2;
                dist=x_dist^2+y_dist^2; % no need for sqrt in this case
                if dist<min_dist
                    min_dist=dist;
                    current(3)=i;
                end
            end
        end
        nr_components_copy(current(3))=0;
        
        nr_comp_diff1=abs(nr_components(current(1))-nr_components(first_dot));
        nr_comp_diff2=abs(nr_components(current(2))-nr_components(first_dot));
        nr_comp_diff3=abs(nr_components(current(3))-nr_components(first_dot));
        
        if nr_comp_diff1<=nr_comp_diff2 && nr_comp_diff1<=nr_comp_diff3
            next = current(1);
        elseif nr_comp_diff2<nr_comp_diff3
            next = current(2);
        else
            next = current(3);
        end
    end
    x1=(x_coords(previous,1) + x_coords(previous,2))/2;
    y1=(y_coords(previous,1) + y_coords(previous,2))/2;
    x2=(x_coords(next,1) + x_coords(next,2))/2;
    y2=(y_coords(next,1) + y_coords(next,2))/2;
    line([x1 x2],[y1 y2],'Color','k','LineWidth',3);
    previous=next;
end
colormap('gray')