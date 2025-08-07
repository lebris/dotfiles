Prerequisites
 - Ubuntu : enable universe repository (for powerline)

```console
apt-get update && apt-get install -y git make powerline fonts-powerline powerline-gitstatus

$ git clone git@github.com:lebris/dotfiles.git ~/.dotfiles
$ cd ~/.dotfiles
$ ./setup.sh
```


## `fonts-powerline` Patch for Ubuntu 24.04

see https://askubuntu.com/a/1553845

```console
sudo cp /etc/fonts/conf.d/10-powerline-symbols.conf{,.orig}
sudo vi /etc/fonts/conf.d/10-powerline-symbols.conf
```

Add the following
```diff
    <fontconfig>
+            <alias>
+                    <family>Ubuntu Sans Mono</family>
+                    <prefer><family>PowerlineSymbols</family></prefer>
+            </alias>
```
