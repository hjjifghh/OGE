 cellfun - 对元胞数组中的每个元胞应用函数
    此 MATLAB 函数将函数 func 应用于元胞数组 C 的每个元胞的内容，每次应用于一个元胞。然后 cellfun 将 func 的输出串联成输出数组 A，因此，对于 C 的第 i 个元素来说，A (i) =func (C{i})。输入参数 func 是一个函数的函数句柄，此函数接受一个输入参数并返回一个标量。func 的输出可以是任何数据类型，只要该类型的对象可以串联即可。数组 A 和元胞数组 C具有相同的大小。

    A = cellfun(func,C)
    A = cellfun(func,C1,...,Cn)
    A = cellfun(___,Name,Value)
    [A1,...,Am] = cellfun(___)