import random

# Tạo ma trận ngẫu nhiên
def generate_matrix(rows, cols):
    return [[random.randint(1, 5) for _ in range(cols)] for _ in range(rows)]

# Nhân hai ma trận
def multiply_matrices(A, B):
    rows_A, cols_A = len(A), len(A[0])
    rows_B, cols_B = len(B), len(B[0])
    assert cols_A == rows_B, "Số cột của A phải bằng số dòng của B"
    C = [[0 for _ in range(cols_B)] for _ in range(rows_A)]
    for i in range(rows_A):
        for j in range(cols_B):
            for k in range(cols_A):
                C[i][j] += A[i][k] * B[k][j]
    return C

# Lưu ma trận vào file
def save_matrix(matrix, filename, mode='decimal'):
    with open(filename, 'w') as f:
        for row in matrix:
            if mode == 'decimal':
                f.write(' '.join(str(x) for x in row) + '\n')
            elif mode == 'binary':
                f.write(' '.join(format(x, '08b') for x in row) + '\n')

# Kích thước ma trận
rows_A, cols_A = 4, 16  # Kích thước ma trận A
rows_B, cols_B = 16, 4  # Kích thước ma trận B

# Tạo ma trận A và B
A = generate_matrix(rows_A, cols_A)
B = generate_matrix(rows_B, cols_B)

# Nhân ma trận A và B để tạo C
C = multiply_matrices(A, B)

# Lưu các ma trận vào các file riêng biệt
# Ma trận A
save_matrix(A, 'matrix_A_dec.txt', mode='decimal')  # Lưu hệ thập phân
save_matrix(A, 'matrix_A_bin.txt', mode='binary')   # Lưu hệ nhị phân

# Ma trận B
save_matrix(B, 'matrix_B_dec.txt', mode='decimal')  # Lưu hệ thập phân
save_matrix(B, 'matrix_B_bin.txt', mode='binary')   # Lưu hệ nhị phân

# Ma trận C
save_matrix(C, 'matrix_C_dec.txt', mode='decimal')  # Lưu hệ thập phân
save_matrix(C, 'matrix_C_bin.txt', mode='binary')   # Lưu hệ nhị phân

print("Đã lưu ma trận A, B, C vào các file hệ thập phân và nhị phân.")

