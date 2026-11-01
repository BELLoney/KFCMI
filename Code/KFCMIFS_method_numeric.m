 %%%%%%%%%%%%%%%%%%%%%%%%%%%%编写程序一定要仔细%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1计时等声明%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clf; %清除图片
clc;
clear;
close all
format long;

%clu_method=1 k-Means cluster from MatlabR2019b
%clu_method=2 Hierarchical cluster from MatlabR2019b
%clu_method=3 k-Medoids cluster from MatlabR2019b
%clu_method=4 FCM cluster from MatlabR2019b


% cla_method=1 A classification tree trained using fitctree 
% cla_method=2 A naive Bayes classifier trained using fitcnb
% cla_method=3 A nearest-neighbor classifier trained using fitcknn
% cla_method=4 A support vector machine classifier trained using fitcsvm
%% %加载路径
 currentFolder = pwd;
 addpath(genpath(currentFolder));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2导入数据%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  datalist{1}='dermatology';
  datalist{2}='diabetes';
  datalist{3}='ecoli';
  datalist{4}='glass';
  datalist{5}='ionosphere';
  datalist{6}='iris';
  datalist{7}='page_blocks';
  datalist{8}='parkinsons';
  datalist{9}='sonar';
  datalist{10}='waveform';
  datalist{11}='wbc';
  datalist{12}='wdbc';
  datalist{13}='wilt';
  datalist{14}='wine';
  datalist{15}='winequality_red';
  datalist{16}='winequality_white';
  datalist{17}='wpbc';
  datalist{18}='yeast';
  
% load ('wine.mat');

%Example(:,[1 2])=Example(:,[1 2])+1;
%data_array=Example;


%I=3;%第I个属性及以后为数值型属性
% I=0;%如果I==0，则为经典粗糙集检测方法
% if n<3 && m<3
%     disp('输入的决策系统行列个数不得小于3个！');
%     return
% end
% n为样本数 m为属性个数(不含决策属性)
% 
% if I~=0 %I~=0表示含有数值型属性
% for s=I:m-1
%     amin=min(data_array(:,s));
%     amax=max(data_array(:,s));
%     for t=1:n
%         data_array(t,s)=(data_array(t,s)-amin)./(amax-amin);
%     end
% end
% end
% 此时得到的条件属性为归一化后的数值属性数据

class_method={'fitctree','fitcnb','fitcknn','fitcsvm'};
%%
temp=2:4;
var=10.^(-temp); %调整参数var
del=0.01:0.02:0.4; %调整参数del
for i=1:18
    eval(['load ' datalist{i}]);
    sf_info_classifier={};%特征选择结果及分类信息
    select_feature_temp={};
    data_array=trandata;
    [n,m]=size(data_array); % n为样本数 m为属性个数(不含决策属性)
    for s=1:m-1
       if min(data_array(:,s))~=0&&max(data_array(:,s))~=1&&min(data_array(:,s))~=max(data_array(:,s))
          amin=min(data_array(:,s));
          amax=max(data_array(:,s));
       for t=1:n
        data_array(t,s)=(data_array(t,s)-amin)./(amax-amin);
       end
       end
    end% 此时得到的条件属性为归一化后的数值属性数据
for var_i=1:length(var) %邻域半径计算参数 delta=std（Data）/lammda
    for del_i=1:length(del)
 disp(['Dataset:',datalist{i}]);
 disp(['(var,del)=','(',num2str(var(var_i)), ',', num2str(del(del_i)), ')']);
   if var(var_i)~=var(end)
select_feature=fs_KCMI(trandata,var(var_i),del(del_i));
   elseif del_i==1
     select_feature=1:m-1;
       else
     break;
   end
if length(del)*(var_i-1)+del_i==1  
    
sf_info_classifier{1,1}='(var,del)';
sf_info_classifier{1,2}='select_feature';
sf_info_classifier{1,3}='select_feature_length';

end

sf_info_classifier{length(del)*(var_i-1)+del_i+1,1}=['(' num2str(var(var_i)) ',' num2str(del(del_i)) ')'];
sf_info_classifier{length(del)*(var_i-1)+del_i+1,2}=mat2str(select_feature);
sf_info_classifier{length(del)*(var_i-1)+del_i+1,3}=length(select_feature);%特征长度

if isempty(select_feature)
    sf_info_classifier(length(del)*(var_i-1)+del_i+1,[4 5 7 8 10 11 13 14])=num2cell(zeros(1,8));%分类选取特征   
    continue
end

cla_data=data_array(:,[select_feature,m]);%选取的特征序列

eq_loc=find(strcmp(select_feature_temp,mat2str(select_feature)),1);

if isempty(eq_loc)
    select_feature_temp=sf_info_classifier(:,2);
for meth_j=1:4  
for j=1:10
    cla_acc(j)=matlabclassifier(cla_data,meth_j);
end
cla_acc_mean=mean(cla_acc);
cla_acc_std=std(cla_acc);

for j=1:10
clu_acc(j)=matlabcluster(cla_data,meth_j);
end

clu_acc_mean=mean(clu_acc);
clu_acc_std=std(clu_acc);

if length(del)*(var_i-1)+del_i==1
sf_info_classifier{1,3*meth_j}=class_method{meth_j};%分类算法名称

sf_info_classifier{1,3*meth_j+1}='classfier_acc_mean';%分类精度名称
sf_info_classifier{1,3*meth_j+2}='classfier_acc_std';%分类标准差名称
end

sf_info_classifier{length(del)*(var_i-1)+del_i+1,3*meth_j+1}=cla_acc_mean;%分类精度
sf_info_classifier{length(del)*(var_i-1)+del_i+1,3*meth_j+2}=cla_acc_std;%分类精度标准差

end
else
sf_info_classifier(length(del)*(var_i-1)+del_i+1,4:end)=sf_info_classifier(eq_loc,4:end);%分类选取特征   
end
    end
end

save(['sf_info_classifier' datalist{i}],'sf_info_classifier')

xlswrite(['sf_info_classifier' datalist{i}],sf_info_classifier)
end


