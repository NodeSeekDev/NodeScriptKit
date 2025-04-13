#!/bin/bash
set +e

project_name="nskCore"
version="v0.0.1"
MENU_CONFIG_URL="https://raw.githubusercontent.com/NodeSeekDev/NskCore/refs/heads/main/menu.template.toml"
MAIN_CONFIG_URL="https://raw.githubusercontent.com/NodeSeekDev/NskCore/refs/heads/main/main.template.toml"
BIN_URL="https://github.com/NodeSeekDev/NskCore/releases/download/$version/"

# 获取当前操作系统和架构
goos=$(uname -s | tr '[:upper:]' '[:lower:]')  # 获取操作系统
goarch=$(uname -m)                            # 获取架构

echo "Current OS: $goos"
echo "Current Architecture: $goarch"

if [ "$goos" == "darwin" ]; then
    ext=""
elif [ "$goos" == "linux" ] || [ "$goos" == "freebsd" ]; then
    ext=""
else
    echo "Unsupported OS: $goos"
    exit 1
fi

if [ "$goarch" == "x86_64" ]; then
    arch="amd64"
elif [ "$goarch" == "i386" ]; then
    arch="386"
elif [ "$goarch" == "arm64" ]; then
    arch="arm64"
else
    echo "Unsupported Architecture: $goarch"
    exit 1
fi

BIN_FILENAME="$project_name-$goos-$arch$ext"
BIN_URL="$BIN_URL$BIN_FILENAME"

curl -Lso /usr/bin/nskCore $BIN_URL
chmod u+x /usr/bin/nskCore
mkdir -p /etc/nsk
curl -Lso /etc/nsk/config.toml $MAIN_CONFIG_URL
mkdir -p /etc/nsk/modules.d
curl -Lso /etc/nsk/modules.d/000-menu.toml $MENU_CONFIG_URL

cat > /usr/bin/nsk <<-EOF
#!/bin/bash
nskCore -config /etc/nsk/config.toml
EOF
chmod u+x /usr/bin/nsk
ln -s /usr/bin/nsk /usr/bin/n

echo 'nsk and n command is available'
