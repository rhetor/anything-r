# http://127.0.0.1:15971/doc/manual/R-intro.html#Objects
# 创建一个数值向量
z <- 0:9
print(mode(z))  # 输出 "numeric"
print(length(z))  # 输出 10

# 将数值向量转换为字符向量
digits <- as.character(z)
print(mode(digits))  # 输出 "character"
print(length(digits))  # 输出 10

# 将字符向量转换回数值向量
d <- as.integer(digits)
print(mode(d))  # 输出 "numeric"
print(length(d))  # 输出 10

# 创建一个空的数值向量
e <- numeric()
print(mode(e))  # 输出 "numeric"
print(length(e))  # 输出 0

# 扩展向量长度
e[3] <- 17
print(e)  # 输出 [NA, NA, 17]
print(length(e))  # 输出 3

# 截断向量长度
alpha <- 1:10
alpha <- alpha[2 * 1:5]
print(alpha)  # 输出 [2, 4, 6, 8, 10]
length(alpha) <- 3
print(alpha)  # 输出 [2, 4, 6]

# 获取和设置属性
attributes(z)  # 返回 NULL，因为没有定义额外的属性
attr(z, "dim") <- c(5, 2)
print(attributes(z))  # 输出 $dim [1] 5 2


# TODO: 泛型函数和面向对象编程

