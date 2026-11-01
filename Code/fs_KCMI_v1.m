%% Compute reduct from numerical data, categorical data and their 
%% mixtures with fuzzy complementary mutual information. 
function select_feature=fs_KCMI_v1(data,delta,varepsilon)
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
%%%%%%%%%%%%%%%%%data reduct based on complement mutual information%%%%%%%%%%%%%%%%%%%
attrinu=column-1;
red=[];
x=0;
base=ones(row);
AllC=1:attrinu;%所有条件属性集
r_d=eval(['ssr' num2str(column)]);
for j=attrinu:-1:1
    sig=[];
    for i=1:length(AllC)
       r1=eval(['ssr' num2str(AllC(i))]);
       sig(i)=fcentropy(r_d)+fcentropy(min(r1,base))-fcentropy(min(min(r1,r_d),base)); 
    end
    [x1,n1]=max(sig);
    x=[x;x1];
    len=length(x);
    if abs(x(len)-x(len-1))>varepsilon
        base1=eval(['ssr' num2str(AllC(n1))]);
        base=min(base,base1);
        red=[red;AllC(n1)];
        AllC=setdiff(AllC,AllC(n1));
    else
        break
    end
end
select_feature=red';
