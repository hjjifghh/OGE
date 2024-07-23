import numpy as np

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

def correct_and_smooth(data):
    """校正速度数据并进行平滑处理"""
    heights = data[:, 0]
    rv_cols = data[:, 2::3]  # 提取Rv1至Rv5列
    corrected_rvs = rv_cols.copy()
    
    # 校正Beam间的关系
    corrected_rvs[1::2, :] = -corrected_rvs[::2, :]  # Beam1/2, Beam3/4 对调正负号
    
    # 简单的平滑处理（这里使用前后项平均作为示例）
    for col in range(corrected_rvs.shape[1]):
        for i in range(1, len(heights) - 1):
            if not np.isnan(corrected_rvs[i, col]):  # 跳过NaN值
                corrected_rvs[i, col] = np.mean(corrected_rvs[i-1:i+2, col])
    
    # 将修正后的速度数据放回原数据结构
    data[:, 2::3] = corrected_rvs
    return data

def write_data_with_format(data, new_filename):
    """将处理后的数据写入新文件，保持原格式，速度数据保留两位小数"""
    with open(new_filename, 'w') as file:
        # 重新写入注释行
        file.write("Original Comment Line 1\n")
        file.write("Original Comment Line 2\n")  # 假设的注释行
        # 写入列名
        file.write("Height\tSNR1\tRv1\t...\tSW5\n")
        
        # 遍历数据行
        for row in data:
            formatted_row = [
                "\t" +str(round(value, 2) if idx in {2, 5, 8, 11, 14} else str(value))  # 速度数据保留两位小数
                for idx, value in enumerate(row)
            ]
            file.write('\t'.join(formatted_row) + '\n')

# 主程序
filename = 'L1B ST.txt'
new_filename = 'L1B_ST_Processed.txt'

# 读取数据
original_data = read_data(filename)

# 校正和处理数据
processed_data = correct_and_smooth(original_data)

# 写入新文件
write_data_with_format(processed_data, new_filename)

print(f"Data processing completed. New file saved as '{new_filename}'")