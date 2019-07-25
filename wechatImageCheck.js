const fs = require('fs');
const exec = require('child_process').exec

const maxSize = 32700;

function warn(...args) {
    console.log(`\x1b[40m \x1b[33m ${args} \x1b[0m`)
}

function error(...args) {
    console.log(`\x1b[40m \x1b[31m ${args} \x1b[0m`)
}

exec('git diff --cached --name-only| grep -E "shareToWechat\/.*\.jpg|shareToWechat\/.*\.png"', (err, stdout) => {
    let hasError = false;
    if (stdout.length) {
        const fileNames = stdout.split('\n');
        fileNames.pop();
        for (let i = 0; i < fileNames.length; i++) {
            const fileName = fileNames[i];
            console.log('check', fileName);
            let states = {size: 0};
            try {
                states = fs.statSync(fileName);
            } catch (err) {
            }

            let fileSize = states.size;
            if (fileSize >= maxSize) {
                let tip = `${fileName} 文件大小为: ${fileSize}，大于微信图片最大限制要求: ${maxSize}`;
                warn(tip);
                hasError = true;
            }
        }
    }
    if (hasError) {
        error('检测到图片大小不符合规则: 详情请见上面描述');
        process.exit(1)
    }
});
