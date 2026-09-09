<h1 align="center">embervim</h1>

<!-- <div align="center">  -->
<!--    <a href="https://github.com/danlikestocode/embervim#Info"> -->
<!--    Info -->
<!--    </a>  -->
<!--    <span> • </span> -->
<!---->
<!--    <a href="https://github.com/danlikestocode/embervim#Install"> -->
<!--    Install -->
<!--    </a>  -->
<!--    <span> • </span> -->
<!---->
<!--    <a href="https://github.com/danlikestocode/embervim#Usage"> -->
<!--    Usage -->
<!--    </a>  -->
<!--    <span> • </span> -->
<!---->
<!--    <a href="https://dotfyle.com/danlikestocode/embervim-nvim"> -->
<!--    Plugin List -->
<!--    </a> -->
<!-- </div> -->
<!---->

<div align="center">

[![Neovim Minimum Version](https://img.shields.io/badge/Neovim-0.9.0-blueviolet.svg?style=flat-square&logo=Neovim&color=90E59A&logoColor=white)](https://github.com/neovim/neovim)
[![GitHub Issues](https://img.shields.io/github/issues/danlikestocode/embervim.svg?style=flat-square&label=Issues&color=d77982)](https://github.com/NvChad/NvChad/issues)

</div>

## :mag: Info
A completely GMO-free neovim configuration written with cross-compatability in mind.
Have you ever wanted an organic typing experience? Try out embervim! We always push
breaking changes and always reconfigure plugins. There is no better experience out there.

This is meant to be used as a baseline for your own configuration! All you have to do
is clone this repo, and smack that `nvim` folder into `~/.config`. Have a configuration
there already? Just go ahead and `rm -rf ~/.config` and you'll be good to go!

## Install on Ubuntu
Use the bootstrap script to install a current stable Neovim release, common CLI tools,
this config, and run a first-time headless setup:

```bash
git clone https://github.com/avvo-na/embervim.git
cd embervim
./scripts/install-ubuntu.sh --with-optional
```

The script installs Neovim from the official release `.deb`, not Ubuntu's older apt package.

**Features**
- LSP
- Autocomplete
- Treesitter/Telescope and other staples
- Lazygit in your editor 🤗
- Code screenshotting
- Doesn't break on WSL/Windows/Mac/Linux
- Much more!

> P.S. I honestly forgot everything this depends on. I know you will probably need `node`
for some LSPs and `silicon` for code screenshotting. Oh and probably install `lazygit`
if you want to use that. Other than that, if something breaks, my bad.

> P.S. P.S. Cloning this repo is over like 100MBs, so yeah... thats my bad. I may or
may not have stored some large image files here for a showcase once.


## License
```
DO WHATEVER YOU WANT TO PUBLIC LICENSE
                  Version 2, December 2004
Copyright (C) 2024 avvo-na
Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

           DO WHATEVER YOU WANT TO PUBLIC LICENSE
  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
  0. Literally nothing
```


