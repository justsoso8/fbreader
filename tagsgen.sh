#!/bin/sh

#Created by Zhuang Jianmin
filelist="cscope.files"

if [ ! -f ${filelist} ]; then
	find . -name "*.h" -o -name "*.hpp" -o -name "*.c" -o -name "*.cc" -o -name "*.cpp" > ${filelist}
fi

cscope -bkq -i cscope.files
ctags -R
