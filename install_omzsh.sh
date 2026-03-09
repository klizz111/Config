# Refer https://sysin.org/blog/linux-zsh-all/
set -x

apt install zsh

git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git /etc/oh-my-zsh
# 从模板文件复制 .zshrc 创建默认配置文件（新用户将使用该配置文件）
cp /etc/oh-my-zsh/templates/zshrc.zsh-template /etc/skel/.zshrc 

# 修改 on-my-zsh 的安装目录 export ZSH=$HOME/.oh-my-zsh 为 export ZSH=/etc/oh-my-zsh
sed -i 's|$HOME/.oh-my-zsh|/etc/oh-my-zsh|g' /etc/skel/.zshrc

# 为每个用户配置独立的 cache 目录
# 在 source $ZSH/oh-my-zsh.sh 之前插入 export ZSH_CACHE_DIR
sed -i '/^source \$ZSH\/oh-my-zsh.sh/i export ZSH_CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh' /etc/skel/.zshrc

# 更改默认主题 ys
# xiong-chiamiov
sed -i '/^ZSH_THEME=.*/c ZSH_THEME="xiong-chiamiov"' /etc/skel/.zshrc

# 取消每周自动检查更新
sed -i "s/^# zstyle ':omz:update' mode disabled/zstyle ':omz:update' mode disabled/" /etc/skel/.zshrc

# 安装插件

# zsh-syntax-highlighting 语法高亮
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git /etc/oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# zsh-completions 命令补全
git clone --depth=1 https://github.com/zsh-users/zsh-completions /etc/oh-my-zsh/custom/plugins/zsh-completions
# 在source前添加
sed -i '/^source \$ZSH\/oh-my-zsh.sh/i fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src' /etc/skel/.zshrc

# zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git /etc/oh-my-zsh/custom/plugins/zsh-autosuggestions

# 启用
sed -i '/^plugins=.*/c plugins=(git zsh-syntax-highlighting zsh-completions zsh-autosuggestions)' /etc/skel/.zshrc

# 改变新用户的默认 shell
sed -i '/^SHELL=.*/c SHELL=/bin/zsh' /etc/default/useradd

# 修改当前用户
cp /etc/skel/.zshrc ~/.zshrc
chsh -s /bin/zsh
source ~/.zshrc
