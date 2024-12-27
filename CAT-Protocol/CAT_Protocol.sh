#!/bin/bash

Crontab_file="/usr/bin/crontab"

# 检查是否为 root 用户
check_root() {
    [[ $EUID != 0 ]] && echo "错误: 当前非ROOT账号(或没有ROOT权限), 无法继续操作, 请更换ROOT账号或使用 sudo su 命令获取临时ROOT权限。" && exit 1
}

# 创建钱包
create_wallet() {
  echo -e "\n"
  cd ~/cat-token-box/packages/cli
  sudo yarn cli wallet create
  echo -e "\n"
  sudo yarn cli wallet address
  echo -e "请保存上面创建好的钱包地址、助记词"
}

# 启动 mint 并设置 gas 费用
start_mint_cat() {
  read -p "请输入想要mint的gas: " newMaxFeeRate
  sed -i "s/\"maxFeeRate\": [0-9]*/\"maxFeeRate\": $newMaxFeeRate/" ~/cat-token-box/packages/cli/config.json
  cd ~/cat-token-box/packages/cli
  bash ~/cat-token-box/packages/cli/mint_script.sh
}


# 查看钱包余额
check_wallet_balance() {
  cd ~/cat-token-box/packages/cli
  yarn cli wallet balances
}


# 查看FB区块最新区块信息
view_block_info() {
  curl http://192.168.3.71:3000/api -s | json
}

# 显示主菜单
echo -e "
1. 开始 mint cat
2. 查看钱包余额
3. 查看FB区块最新区块信息
"

# 获取用户选择并执行相应操作
read -e -p "请输入您的选择: " num
case "$num" in
1)
    start_mint_cat
    ;;
2)
    check_wallet_balance
    ;;
3)
    view_block_info
    ;;    
*)
    echo "错误: 请输入有效的数字。"
    ;;
esac