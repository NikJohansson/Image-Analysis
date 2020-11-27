function [S] = im2segment(im)
m = size(im,1);
n = size(im,2);
im=imgaussfilt(im,0.55);
k=10;
nr_segments=10;
for j =1:m % Filter all values less then 10% of maximum
    for i = 1:n
        if im(j,i)< 0.1*max(im)
            im(j,i)=0;
        end
    end
end
segment_cap=5;
while (nr_segments~=segment_cap) %Loop until we have found a nice threshhold
    if(k>=100)
        k=10;
        nr_segments=10;
        segment_cap=segment_cap+1;
    end
    I = zeros(m,n);    % i.e. bwlabel gives us 5 segments
    for j =1:m
        for i = 1:n
            if im(j,i)>k
                I(j,i)=1;
            end
        end
    end
    [segmentation, nr_segments] = bwlabel(I, 8);
    k=k+1;
end
nrofsegments = 5;
if nr_segments>nrofsegments
    for i =1:n
        v= segmentation(:,i);
        uniq=unique(v);
        if length(uniq)>2
            for j=3:length(uniq)
                segmentation(segmentation==uniq(j))=uniq(2);
                segmentation(segmentation>uniq(2))=segmentation(segmentation>uniq(2))-1;
            end
        end
    end
end
for kk = 1:nrofsegments % Divide all the segments into 5 diffenent matrices
    M = zeros(m,n);
    for j =1:m
        for i = 1:n
            if segmentation(j,i)==kk
                M(j,i)=1;
            end
        end
    end          
    S{kk}= M;
end