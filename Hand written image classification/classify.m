function y = classify(x, classification_data)
min_value =intmax;
for i=1:length(classification_data(1,:))
    prospect = norm(x-classification_data(1:end-1,i));
    if prospect<min_value
        min_value=prospect;
        y=classification_data(end,i);
    end
end
end

