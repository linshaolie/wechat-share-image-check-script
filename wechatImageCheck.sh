#!/bin/sh

log() {
    red="\033[31m"
    yellow="\033[33m"
    no_color='\033[0m'

    if [[ "$2" == "warning" ]]; then
        echo -e "${yellow}WARNING: $1$no_color"
    else
        echo -e "${red}ERROR: $1$no_color"
    fi
}

warn() {
  log $1 "warning"
}

error() {
  log $1 "error"
}

warn "test test test"
exit 1
fileNames=`exec git diff --cached --name-only| grep -E "shareToWechat\/.*\.jpg|shareToWechat\/.*\.png"`
diff=`git diff --name-status`
maxSize=32700
#要将$a分割开，先存储旧的分隔符
# OLD_IFS="$IFS"

#设置分隔符
IFS=$'\n'

#如下会自动分隔
arr=($fileNames)

#检测被修改文件大小
hasError=0
for line in $arr; do
  if [[ "${line}" ]]; then
    size=`ls -l ${line} | awk '{print $5}'`
    if [[ $size -gt $maxSize ]]; then
      tip="${line} 文件大小为: ${size}，大于微信图片最大限制要求: ${maxSize}";
      warn $tip;
      hasError=1
    fi
  fi
done
if [[ hasError =~ 0 ]]; then
  error "检测到图片大小不符合规则: 详情请见上面描述"
  exit 1
fi
