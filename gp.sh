#!/bin/bash
# 上面中的 #! 是一种约定标记, 它可以告诉系统这个脚本需要什么样的解释器来执行;

echo "开始push到hexo分支..."
git add .
git commit -m $1
echo "git提交注释:$1"
git push origin hexo
if [ $? != 0 ];then
	echo "push完成..."
fi