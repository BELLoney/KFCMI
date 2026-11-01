%% Compute reduct from numerical data, categorical data and their 
%% mixtures with fuzzy complementary mutual information. 
function select_feature=fs_KCMI(data,varepsilon,delta)
%%%input:
% data is data matrix, where rows for samples and columns for attributes. 
% Numerical attributes should be normalized into [0,1] and decision attribute is put in the last column 
% fuzzyneighbor means the fuzzy radius , usually takes value std(data(:,j),1)/lammda
%%%output
% a reduct--- the set of selected attributes.
[row,column]=size(data);
fuzzyradius=zeros(1,column);%初始化模糊半径  
for j=1:column
    if min(data(:,j))==0&&max(data(:,j))==1%判断第j个属性是否为数值属性
     fuzzyradius(j)=delta; %Find the radius of the numeric feature
    end
end
% fuzzyradius=[1 1 1 1 0]; %自己赋值fuzzyradius
%%%%%%%%%%%%%compute the fuzzy relation matrix %%%%%%%%%
    for i=1:column
        col=i;
        r=[];
        eval(['ssr' num2str(col) '=[];']);
        for j=1:row      
            a=data(j,col);
            x=data(:,col);       
            for m=1:length(x)
                r(j,m)=kersim_kcmifs(a,x(m),fuzzyradius(i));
            end
        end
        eval(['ssr' num2str(col) '=r;']);
    end      
%%%%%%%%%%%Compute inner significance of each attribute%%%%%%%%%%%%%%%%%%%%%
attrinu=column-1;
red=[];
AllC=1:attrinu;%Set of all conditional attributes
r_D=eval(['ssr' num2str(column)]);
r_C=ones(row);
CMI_C_c_D=[];
for i=1:length(AllC)
    r1=eval(['ssr' num2str(AllC(i))]);
    r_C=r_C.*r1;
    AllC_c=setdiff(AllC,AllC(i));
    r_C_c=ones(row);
    for j=1:length(AllC_c)
        r1=eval(['ssr' num2str(AllC_c(j))]);
        r_C_c=r_C_c.*r1;
    end
    CMI_C_c_D(i)=fcentropy(r_D)+fcentropy(r_C_c)-fcentropy(r_D.*r_C_c);
end
CMI_C_D=fcentropy(r_D)+fcentropy(r_C)-fcentropy(r_D.*r_C);

for i=1:attrinu
    sig_c=CMI_C_D-CMI_C_c_D(i);
    if sig_c>varepsilon
        red=[red AllC(i)];
    end
end
%%%%%%%%%%%Compute outer significance of each attribute%%%%%%%%%%%%%%%%%%%%%
 label=1;
 r_red=ones(row);
 for i=1:length(red)
     r1=eval(['ssr' num2str(red(i))]);
     r_red=r_red.*r1;
 end
while (label)
       CMI_red_D=fcentropy(r_D)+fcentropy(r_red)-fcentropy(r_D.*r_red);
    if CMI_C_D-CMI_red_D>varepsilon
       C_red=setdiff(AllC,red);
       sig_c=[];
%        r_C_red_c=ones(row);
       for i=1:length(C_red)
           r1=eval(['ssr' num2str(C_red(i))]);
           r_red_ci=r_red.*r1;
           sig_c(i)=fcentropy(r_D)+fcentropy(r_red_ci)-fcentropy(r_D.*r_red_ci);
       end
    [~,n1]=max(sig_c);
    red=[red C_red(n1)];
    r1=eval(['ssr' num2str(C_red(n1))]);
    r_red=r_red.*r1;
    else 
        label=0;
    end
end
if length(red)==attrinu
select_feature=red(1:end-1);
else
    select_feature=red;
end
