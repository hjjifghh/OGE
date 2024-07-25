import numpy as np
from sklearn.neighbors import LocalOutlierFactor

def read_data(filename):
    """读取原始数据文件"""
    with open(filename, 'r') as file:
        # 跳过注释行
        for i in range (33):
            next(file)
        # 假设前两行为注释
        data = []
        for line in file:
            parts = line.strip().split()
            # 假设数据格式为 Height, SNR1, Rv1, ..., SW5
            data.append([float(part) if part != '-99999' else np.nan for part in parts])
    return np.array(data)

def correct(data):
    """Correct the data by removing outliers."""
    # Assuming the velocity columns are 3, 6, 9, 12, 15
    velocity_columns = [2, 5, 8, 11, 14]  # Python indexing starts at 0
    outlier_indices = set()

    # Remove NaN values before applying LOF
    cleaned_data = data[~np.isnan(data).any(axis=1)]
    
    for col in velocity_columns:
        # Select the column and apply LocalOutlierFactor
        X = cleaned_data[:, col].reshape(-1, 1)
        lof = LocalOutlierFactor(n_neighbors=min(len(X), 30), contamination='auto')
        outlier_labels = lof.fit_predict(X)
        
        # Find the indices of the outliers in the original dataset
        outlier_mask = outlier_labels == -1
        outlier_indices.update(np.flatnonzero(outlier_mask))
    
    # Remove outliers
    processed_data = np.delete(cleaned_data, list(outlier_indices), axis=0)
    removed_values = [(data[i, 0], data[i, col]) for col in velocity_columns for i in outlier_indices]

    return processed_data, removed_values



def write_data_with_format(data, new_filename):
    """将处理后的数据写入新文件，保持原格式，速度数据保留两位小数"""
    with open(new_filename, 'w') as file:
        # 重新写入注释行
        file.write("#Original Comment Line 1\n")
        file.write("#Original Comment Line 2\n")  # 假设的注释行
        # 写入列名
        file.write("Height\tSNR1\tRv1\t...\tSW5\n")
        
        # 遍历数据行
        for row in data:
            formatted_row = [
                "\t" +str(round(value, 2) if idx in {2, 5, 8, 11, 14} else str(value))  # 速度数据保留两位小数
                for idx, value in enumerate(row)
            ]
            file.write(' '.join(formatted_row) + '\n')

# 主程序
filename = 'L1B ST.txt'
new_filename = 'L1B_ST_Processed.txt'

# 读取数据
original_data = read_data(filename)

# 校正和处理数据
processed_data, removed_values = correct(original_data)

# 输出被删除的速度值及其对应的高度
print("Removed Values and Corresponding Heights:")
for height, speed in removed_values:
    print(f"Height: {height}, Speed: {speed}")

# 写入新文件
write_data_with_format(processed_data, new_filename)

print(f"Data processing completed. New file saved as '{new_filename}'")