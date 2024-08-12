import numpy as np
from sklearn.neighbors import LocalOutlierFactor
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
    """校正数据并移除异常值"""
    # 假设速度列是第 3、6、9、12 和 15 列（从0开始计数）
    velocity_columns = [2, 5, 8, 11, 14]
    outlier_indices = {}
    
    # 移除包含 NaN 值的行
    cleaned_data = data[~np.isnan(data).any(axis=1)]
    
    for col in velocity_columns:
        # 选择当前列并应用 LocalOutlierFactor
        X = cleaned_data[:, col].reshape(-1, 1)
        # 使用较小的 n_neighbors，以避免警告
        lof = LocalOutlierFactor(n_neighbors=min(len(X), 28), contamination='auto')
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
                removed_values.append((row[0], row[col]))
        processed_data.append(new_row)
    
    # 将列表转换为 NumPy 数组
    processed_data = np.array(processed_data)

    return processed_data, removed_values



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
    os.mkdir(filepath[:-len(filename)]+"Processed_"+formatted_datetime+"\\")
    
    # 读取数据
    original_data,comments= read_data(filepath)
    
    # 校正和处理数据
    processed_data, removed_values = correct(original_data)
    
    # 输出被删除的速度值及其对应的高度
    print("Removed Values and Corresponding Heights:")
    for height, speed in removed_values:
        print(f"Height: {height}, Speed: {speed}")
    
    # 写入新文件
    write_data_with_format(processed_data, new_filepath,comments)
    
    print(f"Data processing completed.\n New file saved as '{new_filepath}'")