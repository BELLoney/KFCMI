
clear all
clc

load yeast

tem=2:4;
var=10.^(-tem);
del=0.01:0.02:0.4;
select_feature_all={};
select_feature_all{1,1}='(var,del)';
select_feature_all{1,2}='select_feature';
select_feature_all{1,3}='select_feature_length';

select_feature_all_num=[];
% tic;
for var_i=1:length(var) %邻域半径计算参数 delta=std（Data）/lammda
    for del_i=1:length(del)
select_feature=fs_KCMI(trandata,var(var_i),del(del_i));
select_feature_all{length(del)*(var_i-1)+del_i+1,1}=['(' num2str(var(var_i)) ',' num2str(del(del_i)) ')'];
select_feature_all{length(del)*(var_i-1)+del_i+1,2}=mat2str(select_feature);
select_feature_all{length(del)*(var_i-1)+del_i+1,3}=length(select_feature);

select_feature_all_num(del_i,var_i)=length(select_feature);%特征长度
%select_feature1=fs_KCMI_v1(trandata,delta,varepsilon)
    end
end