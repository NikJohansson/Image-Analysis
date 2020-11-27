im = imread('blood.png');
I=im<(0.8*max(im));
se = strel('disk',2);
B=imopen(I,se);
    [A, nr]=bwlabel(B,4);
M=zeros(size(A));
segment_sizes=zeros(1,nr);
for kk = 1:nr
    segment_sizes(kk)=nnz(A==kk);
    if segment_sizes(kk)>50
        M=M+(randi(500)+50)*(A==kk);
    end
end;

imagesc(M)
colormap('jet')
nr_of_blood_cells=nnz(segment_sizes>50);