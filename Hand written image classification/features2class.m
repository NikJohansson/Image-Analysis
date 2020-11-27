function y = features2class(x,classification_data)
K=1;

nbr_of_classified=zeros(1,max(classification_data(end,:)));
distances=zeros(1,length(classification_data(1,:)));
for i=1:length(classification_data(1,:))
    distances(i)=norm(x-classification_data(1:end-1,i));
end
[B,I]=mink(distances,K);
for i=1:K
    nbr_of_classified(classification_data(end,I(i)))=nbr_of_classified(classification_data(end,I(i)))+1;
end
[Y,y]=max(nbr_of_classified);
end

