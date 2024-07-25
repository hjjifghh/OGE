# 7.22

基本跑通画图流程

# 7.23

初步理解数据读入操作

# 7.24

完成绘图代码的阅读和整理

# 7.25

- 优化了l1b_draw
- 基于L2的绘图

可能的优化方法：

##  **Local Outlier Factor (LOF)**：
   LOF 是一种基于密度的方法，它计算每个数据点相对于其邻居的局部密度。LOF 值越低，说明数据点越可能是异常值。Python 中可以使用 sklearn 库实现 LOF 算法。

   ```python
   om sklearn.neighbors import LocalOutlierFactor
   lof = LocalOutlierFactor()
   scores = lof.fit_predict(data)
   outliers = np.where(scores == -1)[0]
   ```
1. n_neighbors
含义：指定用于计算局部密度的邻居数量。
调整思路：
较小的值：较小的 n_neighbors 值会使算法更加敏感于局部异常值，适合于识别非常规的模式或非常局域的变化。
较大的值：较大的 n_neighbors 值会使算法更倾向于检测整体数据分布中的异常值，适合于识别那些在全局视角下显得异常的数据点。
建议：如果数据集中包含多个不同规模的异常模式，可以尝试使用不同的 n_neighbors 值来捕捉不同尺度上的异常情况。例如，您可以先使用一个较小的值来捕捉非常局域的异常，然后使用较大的值来捕捉更大范围内的异常。
2. contamination
含义：预期的异常值比例，可以是一个浮点数或 'auto'。
调整思路：
固定比例：如果您对数据集有一定的了解，并且知道异常值的大致比例，可以设置一个固定的值。例如，如果预计异常值大约占总数据的 5%，则可以设置 contamination=0.05。
自动估算：如果不确定异常值的比例，可以设置 contamination='auto'，让算法根据数据自动估算比例。
建议：对于大多数情况，使用 'auto' 是一个不错的选择。然而，如果数据集非常大或者异常值的比例明显，则手动设置一个合适的值可能会更好。
3. metric
含义：用于计算距离的度量标准，默认是欧几里得距离。
调整思路：
不同度量标准：根据数据的特性选择合适的距离度量标准。例如，对于高维稀疏数据，可以考虑使用余弦相似度作为度量。
建议：对于大多数数值型数据，欧几里得距离通常是一个好的起点。对于文本或类别数据，可以考虑使用其他度量标准。
4. algorithm
含义：用于计算最近邻的算法。
调整思路：
不同算法：不同的算法有不同的性能特点。例如，'auto' 会根据数据集的大小和维度自动选择最佳算法。
建议：对于大型数据集，可以考虑使用 'ball_tree' 或 'kd_tree'，它们在高维空间中表现较好。


## **DBSCAN**：
   DBSCAN 是另一种基于密度的聚类算法，它可以自动检测异常值。在 Python 中，可以使用 sklearn 库中的 DBSCAN 实现。

```python
   from sklearn.cluster import DBSCAN
   db = DBSCAN(eps=0.3, min_samples=10)
   clusters = db.fit_predict(data)
   outliers = np.unique(clusters)
```
