function Data=Normalizedata(Data,k)
for s=1:k
    amin=min(Data(:,s));
    amax=max(Data(:,s));
    for t=1:size(Data,1)
        Data(t,s)=(Data(t,s)-amin)./(amax-amin);
    end
end
end