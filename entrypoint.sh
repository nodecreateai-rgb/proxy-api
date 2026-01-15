#!/bin/sh
set -e

if [ -f /CLIProxyAPI/config.example.yaml ]; then
    echo "正在替换环境变量..."
    
    # 使用 awk 进行替换
    awk '
    {
        line = $0
        while (match(line, /\$\{([^}]+)\}/)) {
            before = substr(line, 1, RSTART - 1)
            after = substr(line, RSTART + RLENGTH)
            var_expr = substr(line, RSTART + 2, RLENGTH - 3)
            
            if (match(var_expr, /^([^:]+):-(.*)$/)) {
                var_name = substr(var_expr, 1, RSTART - 1)
                default = substr(var_expr, RSTART + 2)
            } else {
                var_name = var_expr
                default = ""
            }
            
            var_value = ENVIRON[var_name]
            if (var_value == "") {
                var_value = default
            }
            
            line = before var_value after
        }
        print line
    }
    ' /CLIProxyAPI/config.example.yaml > /CLIProxyAPI/config.yaml
    
    echo "环境变量替换完成"
fi

# 执行原始命令（传递所有参数）
# 如果没有参数，使用默认命令
if [ $# -eq 0 ]; then
    exec ./CLIProxyAPI
else
    exec "$@"
fi
