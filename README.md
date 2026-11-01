# KFCMI

袁钟, 陈红梅, 王志红, 李天瑞. 利用混杂核模糊补互信息选择特征. 计算机研究与发展, 2023, 60(5): 1111–1120. DOI: 10.7544/issn1000-1239.202111272.

**Exploiting Hybrid Kernel-Based Fuzzy Complementary Mutual Information for Selecting Features**
Zhong Yuan, Hongmei Chen, Zhihong Wang, Tianrui Li. *Journal of Computer Research and Development*, 2023, 60(5): 1111–1120.

## 目录结构

```
KFCMI
├── Code/          核心 MATLAB 代码与示例数据
├── Datasets/      实验数据集（Categorical/Mixed/Numerical 三类，共 57 个）
└── Paper/         论文全文 PDF
```

## 摘要 Abstract

模糊粗糙集理论目前在数据挖掘和机器学习等领域受到了广泛的关注。该理论提供了一种能克服离散化问题的有效工具，并能直接应用于数值或混合属性数据。然而，大部分所提关于决策的模糊互信息都是非单调的，这可能导致一个不收敛的学习算法。为此，基于混杂核模糊补熵，定义了关于决策的模糊补互信息，证明了其随特征呈单调性变化；进而利用混杂核模糊补互信息探索特征选择方法并设计了相关算法。实验结果表明，在大多数情况下所提算法可以选取更少的特征且能保持或提高分类准确率。

Fuzzy rough set theory provides an effective tool to overcome the discretization problem and can be applied directly to numerical or mixed attribute data. However, most of the proposed fuzzy mutual information on decisions is non-monotonic, which may lead to a non-convergent learning algorithm. To this end, the fuzzy complementary mutual information on decisions is defined based on the hybrid kernel fuzzy complementary entropy, which is shown to vary monotonically with features. Then the feature selection method is explored by using the hybrid kernel-based fuzzy complementary mutual information and a corresponding algorithm (KFCMI) is designed. Experimental results show that the proposed algorithm can select fewer features and maintain or improve the classification accuracy in most cases.

## 用法 Usage

主算法为 `fs_KCMI.m`，其函数签名为：

```matlab
select_feature = fs_KCMI(data, varepsilon, delta)
```

- `data`：数据矩阵，行对应样本、列对应属性；数值属性需归一化到 [0,1]，决策属性放在最后一列。
- `varepsilon`：重要度阈值（如 0.01）。
- `delta`：数值特征的模糊半径（如 0.1）。

在 `Code/` 目录下运行以下示例：

```matlab
clc; clear;
load yeast;                       % 变量 trandata
data = trandata;
[n, m] = size(data);
% 数值列归一化到 [0,1]
for s = 1:m-1
    amin = min(data(:,s)); amax = max(data(:,s));
    if amax > amin
        data(:,s) = (data(:,s)-amin)./(amax-amin);
    end
end
varepsilon = 0.01;
delta = 0.1;
select_feature = fs_KCMI(data, varepsilon, delta)
```

也可直接运行 `Demo_KCMIFS.m` 查看在多组参数下的特征选择结果。`fs_KCMI.m` 依赖 `kersim_kcmifs.m`（核相似度）与 `fcentropy.m`（模糊补熵）。

## 引用 Citation

如果本工作对您的研究有帮助，请引用：

```bibtex
@article{yuan2023kfcmi,
  title   = {利用混杂核模糊补互信息选择特征},
  author  = {袁钟 and 陈红梅 and 王志红 and 李天瑞},
  journal = {计算机研究与发展},
  volume  = {60},
  number  = {5},
  pages   = {1111--1120},
  year    = {2023},
  doi     = {10.7544/issn1000-1239.202111272}
}
```

## 联系方式 Contact

如有问题，请联系 yuanzhong@scu.edu.cn。
