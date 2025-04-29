# 1. 无序因子
# 无序因子是默认的因子类型，其水平（levels）按字母顺序排列或按显式指定的顺序排列。
# 
# 示例数据：澳大利亚各州的税务会计师来源
state <- c("tas", "sa",  "qld", "nsw", "nsw", "nt",  "wa",  "wa",
           "qld", "vic", "nsw", "vic", "qld", "qld", "sa",  "tas",
           "sa",  "nt",  "wa",  "vic", "qld", "nsw", "nsw", "wa",
           "sa",  "act", "nsw", "vic", "vic", "act")

# 创建无序因子
statef <- factor(state)

# 查看因子
print(statef)

# 查看因子的水平
levels(statef)
# 输出：
# 
# [1] tas sa  qld nsw nsw nt  wa  wa  qld vic nsw vic qld qld sa  tas sa  nt  wa  vic qld nsw nsw wa  sa  act nsw vic vic act
# Levels: act nsw nt qld sa tas vic wa
# 2. 使用 tapply() 计算分组均值
# tapply() 函数用于对分组数据应用函数（如均值、标准差等）。

# 示例数据：税务会计师的收入
incomes <- c(60, 49, 40, 61, 64, 60, 59, 54, 62, 69, 70, 42, 56,
             61, 61, 61, 58, 51, 48, 65, 49, 49, 41, 48, 52, 46,
             59, 46, 58, 43)

# 计算每个州的平均收入
incmeans <- tapply(incomes, statef, mean)
print(incmeans)
# 输出：
# 
# act    nsw     nt    qld     sa    tas    vic     wa
# 44.500 57.333 55.500 53.600 55.000 60.500 56.000 52.250
# 3. 计算标准误差
# 标准误差（Standard Error）是样本均值的标准差。我们可以定义一个函数来计算标准误差，并使用 tapply() 将其应用于分组数据。

# 定义标准误差函数
stdError <- function(x) sqrt(var(x) / length(x))

# 计算每个州收入的标准误差
incster <- tapply(incomes, statef, stdError)
print(incster)
# 输出：
# 
# act     nsw      nt     qld      sa     tas     vic      wa
# 1.5000 4.3102 4.5000 4.1061 2.7386 0.5000 5.2440 2.6575
# 4. 有序因子
# 有序因子用于表示具有自然顺序的分类数据。例如，教育水平（高中、本科、硕士、博士）或满意度评分（低、中、高）。

# 示例数据：满意度评分
satisfaction <- c("low", "medium", "high", "medium", "high", "low", "high")

# 创建有序因子
satisfaction_ordered <- ordered(satisfaction, levels = c("low", "medium", "high"))

# 查看有序因子
print(satisfaction_ordered)

# 查看因子的水平
levels(satisfaction_ordered)
# 输出：
# 
# [1] low    medium high   medium high   low    high  
# Levels: low < medium < high
# 5. 总结
# 无序因子：默认按字母顺序或显式指定顺序排列。
# 有序因子：用于表示具有自然顺序的分类数据。
# tapply()：用于对分组数据应用函数，如均值、标准差等。