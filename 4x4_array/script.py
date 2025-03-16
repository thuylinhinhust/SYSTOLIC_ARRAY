import random

def generate_matrix(k):
    return [[random.randint(1, 5) for _ in range(k)] for _ in range(k)]

def multiply_matrices(A, B):
    k = len(A)
    C = [[0 for _ in range(k)] for _ in range(k)]
    for i in range(k):
        for j in range(k):
            for l in range(k):
                C[i][j] += A[i][l] * B[l][j]
    return C

def save_matrix(matrix, filename, mode='decimal'):
    with open(filename, 'w') as f:
        for row in matrix:
            if mode == 'decimal':
                f.write(' '.join(str(x) for x in row) + '\n')
            elif mode == 'binary':
                f.write(' '.join(format(x, '08b') for x in row) + '\n')

def transpose_matrix(matrix):
    k = len(matrix)
    return [[matrix[j][i] for j in range(k)] for i in range(k)]

# Kích thước ma trận k
k = 4  # Thay đổi giá trị k theo nhu cầu

# Tạo ma trận A và B với giá trị từ 1 đến 5
A = generate_matrix(k)
B = generate_matrix(k)

# Nhân 2 ma trận để tạo ma trận C
C = multiply_matrices(A, B)

# Lưu ma trận ở hệ thập phân
save_matrix(A, 'matrix_dec_A.txt', mode='decimal')
save_matrix(B, 'matrix_dec_B.txt', mode='decimal')
save_matrix(C, 'matrix_dec_C.txt', mode='decimal')

# Hoán vị hàng và cột của ma trận B trước khi lưu nhị phân
B_transposed = transpose_matrix(B)

# Lưu ma trận ở hệ nhị phân 8-bit
save_matrix(A, 'matrix_bin_A.txt', mode='binary')
save_matrix(B_transposed, 'matrix_bin_B.txt', mode='binary')  # Lưu ma trận B đã hoán vị
save_matrix(C, 'matrix_bin_C.txt', mode='binary')

print("Đã tạo và lưu các ma trận A, B, C ở hệ thập phân và hệ nhị phân 8-bit.")

