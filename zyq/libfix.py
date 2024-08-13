import numpy as np
from sklearn.neighbors import LocalOutlierFactor
from sklearn.cluster import DBSCAN
import sys
import os


def read_data(filename):
    """读取原始数据文件，并收集前33行的注释"""
    comments = ''  # 存储注释行
    data = []      # 存储数据行

    with open(filename, 'r') as file:
        # 收集注释行
        for i in range(33):
            comment_line = next(file)
            comments+=comment_line

        # 读取数据
        for line in file:
            parts = line.strip().split()
            # 假设数据格式为 Height, SNR1, Rv1, ..., SW5
            data.append([float(part) if part != '-99999' else np.nan for part in parts])

    return np.array(data), comments

def correct(data):
    data= correct_LOF(data,threshold=25)
    data= correct_based_on_second_derivative(data, threshold=2)
    
    return data
    

def correct_LOF(data,threshold=28):
    """校正数据并移除异常值"""
    # 假设速度列是第 3、6、9、12 和 15 列（从0开始计数）
    velocity_columns = [2, 5, 8, 11, 14]
    outlier_indices = {}
    
    # 移除包含三个及以上 NaN 值的行
    nan_count = np.sum(np.isnan(data), axis=1)
    cleaned_data = data[nan_count < 3]
    
    for col in velocity_columns:
        # 选择当前列并应用 LocalOutlierFactor
        X = cleaned_data[:, col].reshape(-1, 1)
        # 使用较小的 n_neighbors，以避免警告
        lof = LocalOutlierFactor(n_neighbors=min(len(X), threshold), contamination='auto')
        outlier_labels = lof.fit_predict(X)
        
        # 找出异常值的索引
        outlier_mask = outlier_labels == -1
        outlier_indices[col] = np.flatnonzero(outlier_mask)
    
    # 创建一个新数组用于存储处理后的数据
    processed_data = []
    removed_values = []

    for i, row in enumerate(cleaned_data):
        new_row = row.copy()
        for col in velocity_columns:
            if i in outlier_indices[col]:
                # 如果速度值被标记为异常，则将其设置为 NaN 并记录
                new_row[col] = np.nan
        processed_data.append(new_row)
    
    # 将列表转换为 NumPy 数组
    processed_data = np.array(processed_data)

    return processed_data

def correct_DBS(data):
    """校正数据并移除异常值"""
    # 假设速度列是第 3、6、9、12 和 15 列（从0开始计数）
    velocity_columns = [2, 5, 8, 11, 14]
    outlier_indices = {}

    # 移除包含 NaN 值的行
    cleaned_data = data[~np.isnan(data).any(axis=1)]

    for col in velocity_columns:
        # 选择当前列
        X = cleaned_data[:, col].reshape(-1, 1)
        
        # 使用 DBSCAN 检测异常值
        dbscan = DBSCAN(eps=0.9, min_samples=5)  # 需要调整 eps 和 min_samples
        outlier_labels = dbscan.fit_predict(X)
        
        # 找出异常值的索引
        # 对于 DBSCAN，-1 表示噪声点（即异常值）
        outlier_mask = outlier_labels == -1
        outlier_indices[col] = np.flatnonzero(outlier_mask)
    
    # 创建一个新数组用于存储处理后的数据
    processed_data = []
    removed_values = []

    for i, row in enumerate(cleaned_data):
        new_row = row.copy()
        for col in velocity_columns:
            if i in outlier_indices[col]:
                # 如果速度值被标记为异常，则将其设置为 NaN 并记录
                new_row[col] = np.nan
                removed_values.append((row[0], row[col]))
        processed_data.append(new_row)
    
    # 将列表转换为 NumPy 数组
    processed_data = np.array(processed_data)

    return processed_data, removed_values

def correct_iqr(data):
    """校正数据并移除异常值"""
    # 假设速度列是第 3、6、9、12 和 15 列（从0开始计数）
    velocity_columns = [2, 5, 8, 11, 14]
    outlier_indices = {}

    # 移除包含 NaN 值的行
    cleaned_data = data[~np.isnan(data).any(axis=1)]

    for col in velocity_columns:
        # 选择当前列
        X = cleaned_data[:, col]

        # 计算第一和第三四分位数
        Q1 = np.percentile(X, 25)
        Q3 = np.percentile(X, 75)

        # 计算 IQR
        IQR = Q3 - Q1

        # 定义异常值的界限
        lower_bound = Q1 - 1.5 * IQR
        upper_bound = Q3 + 1.5 * IQR

        # 找出异常值的索引
        outlier_mask = (X < lower_bound) | (X > upper_bound)
        outlier_indices[col] = np.flatnonzero(outlier_mask)
    
    # 创建一个新数组用于存储处理后的数据
    processed_data = []
    removed_values = []

    for i, row in enumerate(cleaned_data):
        new_row = row.copy()
        for col in velocity_columns:
            if i in outlier_indices[col]:
                # 如果速度值被标记为异常，则将其设置为 NaN 并记录
                new_row[col] = np.nan
                removed_values.append((row[0], row[col]))
        processed_data.append(new_row)
    
    # 将列表转换为 NumPy 数组
    processed_data = np.array(processed_data)

    return processed_data, removed_values

def correct_exponential_smoothing(data, alpha=0.3, threshold=5):
    """
    使用指数平滑法检测并处理异常值。
    
    参数:
    - data: 输入的二维 NumPy 数组。
    - alpha: 指数平滑系数，默认为 0.5。
    - threshold: 标准差倍数阈值，默认为 3。
    
    返回:
    - processed_data: 处理后的数据。
    - removed_values: 被标记为异常值的数据点列表。
    """
    # 假设速度列是第 3、6、9、12 和 15 列（从0开始计数）
    velocity_columns = [2, 5, 8, 11, 14]
    outlier_indices = {}

    # 移除包含 NaN 值的行
    cleaned_data = data[~np.isnan(data).any(axis=1)]

    # 创建一个新数组用于存储处理后的数据
    processed_data = []
    removed_values = []

    for col in velocity_columns:
        # 选择当前列
        X = cleaned_data[:, col]

        # 初始化平滑序列
        smoothed_data = [X[0]]

        # 进行指数平滑
        for i in range(1, len(X)):
            smoothed_value = alpha * X[i] + (1 - alpha) * smoothed_data[-1]
            smoothed_data.append(smoothed_value)

        # 计算残差
        residuals = X - np.array(smoothed_data)

        # 计算残差的标准差
        std_dev = np.std(residuals)

        # 找出异常值的索引
        outlier_mask = np.abs(residuals) > threshold * std_dev
        outlier_indices[col] = np.flatnonzero(outlier_mask)

    for i, row in enumerate(cleaned_data):
        new_row = row.copy()
        for col in velocity_columns:
            if i in outlier_indices[col]:
                # 如果速度值被标记为异常，则将其设置为 NaN 并记录
                new_row[col] = np.nan
                removed_values.append((row[0], row[col]))
        processed_data.append(new_row)
    
    # 将列表转换为 NumPy 数组
    processed_data = np.array(processed_data)

    return processed_data, removed_values


def correct_based_on_change_rate(data, threshold=2.4):
    """
    使用基于变化率的方法检测连续性并进行异常值检测。
    
    参数:
    - data: 输入的二维 NumPy 数组。
    - threshold: 标准差倍数阈值，默认为 3。
    
    返回:
    - processed_data: 处理后的数据。
    - removed_values: 被标记为异常值的数据点列表。
    """
    # 假设速度列是第 3、6、9、12 和 15 列（从0开始计数）
    velocity_columns = [2, 5, 8, 11, 14]
    outlier_indices = {}

    # 移除包含 NaN 值的行
    cleaned_data = data[~np.isnan(data).any(axis=1)]

    # 创建一个新数组用于存储处理后的数据
    processed_data = []
    removed_values = []

    for col in velocity_columns:
        # 选择当前列
        X = cleaned_data[:, col]

        # 计算变化率
        change_rates = np.diff(X)

        # 计算变化率的标准差
        std_dev = np.std(change_rates)

        # 找出变化率异常的索引
        outlier_mask = np.abs(change_rates) > threshold * std_dev
        outlier_indices[col] = np.flatnonzero(outlier_mask) + 1  # 因为 diff 减少了长度

    for i, row in enumerate(cleaned_data):
        new_row = row.copy()
        for col in velocity_columns:
            if i in outlier_indices[col]:
                # 如果速度值被标记为异常，则将其设置为 NaN 并记录
                new_row[col] = np.nan
                removed_values.append((row[0], row[col]))
        processed_data.append(new_row)
    
    # 将列表转换为 NumPy 数组
    processed_data = np.array(processed_data)

    return processed_data, removed_values

def correct_based_on_second_derivative(data, threshold=2.3):
    """
    使用基于变化率的变化率的方法检测连续性并进行异常值检测。
    
    参数:
    - data: 输入的二维 NumPy 数组。
    - threshold: 标准差倍数阈值，默认为 2.3。
    
    返回:
    - processed_data: 处理后的数据。
    - removed_values: 被标记为异常值的数据点列表。
    """
    # 假设速度列是第 3、6、9、12 和 15 列（从0开始计数）
    velocity_columns = [2, 5, 8, 11, 14]
    outlier_indices = {}

    # 移除包含三个及以上 NaN 值的行
    nan_count = np.sum(np.isnan(data), axis=1)
    cleaned_data = data[nan_count < 3]


    # 创建一个新数组用于存储处理后的数据
    processed_data = []
    removed_values = []

    for col in velocity_columns:
        # 选择当前列
        X = cleaned_data[:, col]

        # 计算变化率
        first_derivative = np.diff(X)

        # 计算变化率的变化率（二阶导数）
        second_derivative = np.diff(first_derivative)

        # 计算二阶导数的标准差
        std_dev = np.std(second_derivative)

        # 找出二阶导数异常的索引
        outlier_mask = np.abs(second_derivative) > threshold * std_dev
        outlier_indices[col] = np.flatnonzero(outlier_mask) + 2  # 因为两次 diff 减少了长度

    for i, row in enumerate(cleaned_data):
        new_row = row.copy()
        for col in velocity_columns:
            if i in outlier_indices[col]:
                # 如果速度值被标记为异常，则将其设置为 NaN 并记录
                new_row[col] = np.nan
        processed_data.append(new_row)
    
    # 将列表转换为 NumPy 数组
    processed_data = np.array(processed_data)

    return processed_data


def write_data_with_format(data, new_filename,comments):
    """将处理后的数据写入新文件，保持原格式，速度数据保留两位小数"""
    with open(new_filename, 'w') as file:
        # 重新写入注释行
        file.write(comments)
      
        # 遍历数据行
        for row in data:
            formatted_row = [
                "\t" +str(round(value, 2) if idx in {2, 5, 8, 11, 14} else str(value))  # 速度数据保留两位小数
                for idx, value in enumerate(row)
            ]
            file.write(' '.join(formatted_row) + '\n')

if __name__=="__main__":
    #filename = 'L1B ST.txt'
    #new_filename = 'L1B_ST_Processed.txt'
    
    filepath = sys.argv[1]
    filename = sys.argv[2]
    formatted_datetime = sys.argv[3]

    
    new_filepath = filepath[:-len(filename)]+"Processed_"+formatted_datetime+"\\"+filename[:-4]+"_Processed.txt"
    
    folder_path=filepath[:-len(filename)]+"Processed_"+formatted_datetime+"\\"
    if os.path.exists(folder_path) and os.path.isdir(folder_path):
        print("The folder already here")
    else:
        os.mkdir(folder_path)
    
    # 读取数据
    original_data,comments= read_data(filepath)
    
    # 校正和处理数据
    processed_data=correct(original_data)
    
    
    # 写入新文件
    write_data_with_format(processed_data, new_filepath,comments)
    
    print(f"Data processing completed.\n New file saved as '{new_filepath}'")