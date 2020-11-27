im = imread('task1/honeycomb.jpg');
im= rgb2gray(im);
im=imgaussfilt(im,0.8);
F=[0 -1 0;
   -1 4 -1;
   0 -1 0];
im=conv2(im,F);
I= im>(0.02*max(im));
se = strel('disk',1);
B=imopen(~I,se);
[A, nr]=bwlabel(B);
M=zeros(size(A));

for kk = 1:nr
    if nnz(A==kk)>500
        M=M+(randi(500)+50)*(A==kk);
    end
end
se=strel('disk',1);
M=imclose(M,se);
imagesc(M)
colormap('jet')