
### sed按行执行， awk按列执行
有windows结束符，如把末尾的\r去掉, 等用sed 一次完成
sed -e 's/$/\r/' myunix.txt > mydos.txt
sed是一行一行的操作文件， 即按行操作文件，所以sed是流编辑器

而awk, 是按列操作文件， 被awk操作的文件必须是表格函式的字符串或文件

很多命令是表格式的输出， 所以一般用管道， 把结果交给awk处理。 