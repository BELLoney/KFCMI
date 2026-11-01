%%%%% Calculate the fuzzy complementary entropy of fuzzy similarity matrix %%%%%
function [S]=fcentropy(M)
[a,b]=size(M);
K=0;
for i=1:a
    Si=(1/a)*(1-sum(M(i,:))/a);
    K=K+Si;
end
S=K;
