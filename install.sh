sudo pacman --noconfirm -Syu
sudo pacman --noconfirm  -S rustup cargo alacritty bspwm dunst i3 kitty mpd ncmpcpp neovim picom polybar qutebrowser ranger rofi zathura zsh  xorg xorg-xinit xorg-xinput unzip

wget https://github.com/elkowar/eww/archive/refs/tags/v0.1.0.zip
unzip v0.1.0.zip
cd eww-0.1.0/
cargo build --release
cd target/release
chmod +x ./eww
sudo cp eww ~/usr/bin
sudo cp eww ~/usr/sbin
cd -
git clone https://github.com/mlvzk/discocss
cp discocss/discocss /usr/bin

mv ~/.config ~/.config-bak
mv ~/.Xauthority ~/.Xauthority-bak
mv ~/.Xresources ~/.Xresources-bak
mv ~/.fehbg ~/.fehbg-bak
mv ~/.p10k.zsh ~/.p10k.zsh-bak
mv ~/.tmux.conf ~/.tmux.conf-bak
mv ~/.xprofile ~/.xprofile-bak
mv ~/.zshrc ~/.zshrc-bak
mv ~/Pictures ~/Pictures-bak
mv ~/.scripts ~/.scripts-bak
rm -rf ~/.config
cp -r ./config ~/.config
cp ./config/.Xauthority ~/
cp ./config/.Xresources ~/
cp ./config/.fehbg ~/
cp ./config/.p10k.zsh ~/
cp ./config/.tmux.conf ~/
cp ./config/.xprofile ~/
cp ./config/.zshrc ~/
cp -r ./config/.script ~/
cp -r ./config/.ascii ~/
cp -r ./config/.local/bin ~/
cp -r ./Pictures ~/
cp -r ./.scripts ~/
cp -r ./fonts/* /usr/share/fonts/
mkdir ~/screenshots
