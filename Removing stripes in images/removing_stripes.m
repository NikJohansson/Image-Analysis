im = imread('longbeach.png');
im_copy=im;
I= rgb2gray(im);
I= I==min(I);
[M, N] = size (I);
for i = 1:M
    for j = 1:N
        if I(i,j)
            red=0;
            green=0;
            blue=0;
            c=0;
            for k=-15:15
                for l=-1:1
                    if (i+k>0 && i+k<=M && j+l>0 && j+l<=N)
                        if ~I(i+k, j+l) 
                            red = red + uint64(im_copy(i+k,j+l,1));
                            green = green + uint64(im_copy(i+k,j+l,2));
                            blue = blue + uint64(im_copy(i+k,j+l,3));
                            c=c+1;
                        end
                    end
                end
            end
            im(i,j,1)=red/c;
            im(i,j,2)=green/c;
            im(i,j,3)=blue/c;
        end
    end
end