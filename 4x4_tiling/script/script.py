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

# Ghi ma trận vào file thập phân
def save_matrix_decimal(matrix, filename):
    with open(filename, 'w') as f:
        for row in matrix:
            f.write(' '.join(str(x) for x in row) + '\n')

# Ghi ma trận A vào file nhị phân với tiling 4x4
def save_tiled_matrix_binary_A(matrix, filename, tile_size=4):
    with open(filename, 'w') as f:
        rows, cols = len(matrix), len(matrix[0])
        for start_row in range(0, rows, tile_size):
            for start_col in range(0, cols, tile_size):
                tile = [row[start_col:start_col + tile_size] for row in matrix[start_row:start_row + tile_size]]
                for row in tile:
                    f.write(' '.join(format(x, '08b') for x in row) + '\n')

# Chuyển vị ma trận
def transpose_matrix(matrix):
    return [list(row) for row in zip(*matrix)]

# Ghi ma trận B vào file nhị phân sau khi chuyển vị và thực hiện tiling 4x4
def save_tiled_matrix_binary_B_transposed(matrix, filename, tile_size=4):
    transposed = transpose_matrix(matrix)
    with open(filename, 'w') as f:
        rows, cols = len(transposed), len(transposed[0])
        for start_row in range(0, rows, tile_size):
            for start_col in range(0, cols, tile_size):
                tile = [row[start_col:start_col + tile_size] for row in transposed[start_row:start_row + tile_size]]
                for row in tile:
                    f.write(' '.join(format(x, '08b') for x in row) + '\n')

# Kích thước ma trận
rows_A, cols_A = 12, 16
rows_B, cols_B = 16, 12

# Tạo ma trận A và B
A = generate_matrix(rows_A, cols_A)
B = generate_matrix(rows_B, cols_B)

# Nhân ma trận A và B để tạo C
C = multiply_matrices(A, B)

# Lưu ma trận ở hệ thập phân
save_matrix_decimal(A, 'matrix_A_dec.txt')
save_matrix_decimal(B, 'matrix_B_dec.txt')
save_matrix_decimal(C, 'matrix_C_dec.txt')

# Lưu ma trận ở hệ nhị phân với tiling
save_tiled_matrix_binary_A(A, 'matrix_A_bin.txt')
save_tiled_matrix_binary_B_transposed(B, 'matrix_B_bin.txt')
save_tiled_matrix_binary_A(C, 'matrix_C_bin.txt')

print("Đã lưu ma trận A, B và C đồng bộ ở hệ thập phân và nhị phân với yêu cầu tiling.")

