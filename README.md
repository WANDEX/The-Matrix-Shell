# The-Matrix-Shell
The Matrix (1999) screen rain effect of falling green characters in a shell/terminal written in POSIX sh.
<p align="center">
    <img src="https://user-images.githubusercontent.com/15724752/181203605-18912e4a-5657-4e61-a830-7d8fe5b85f2e.gif"/>
</p>

## Usage
```sh
Usage: matrix [OPTION...]
OPTIONS
    -h, --help          Display help
    -b, --binary        Use binary characters  [01]
    -d, --digits        Use digit characters   [0123456789]
    -l, --lower         Use lower case letters [abcdefghijklmnopqrstuvwxyz]
    -u, --upper         Use upper case letters [ABCDEFGHIJKLMNOPQRSTUVWXYZ]
    -s, --special       Use special characters [()[]{}/\]
    -t, --testing       Activate character testing mode
    -c, --custom        Use custom characters specified 'inside single quotes'
    -m, --message       Provide a message to display in the center
    -i, --message_int   Provide an integer from 0-9 that modifies the message
    -k, --halfwidth     Use half-width characters of Japanese katakana
                        [ｱｲｳｴｵｶｷｸｹｺｻｽｾﾀﾁﾃﾄﾅﾆﾇﾈﾊﾋﾌﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦ]
    -K, --fullwidth     Use full-width Japanese katakana characters.
                        Will not work, provided as a reference!
[アイウエオカキクケコサスセタチテトナニヌネハヒフホマミムメモヤユヨラリルレロワヲ]
EXAMPLES
    matrix -du
    matrix -bi 5 -m 'TEST MESSAGE'
    matrix -b --custom='!?/\' --testing
```

## Spawn full screen terminal and execute matrix shell
```sh
# example for st terminal emulator
st -f "NotoSansMono Nerd Font:pixelsize=27" -n opaque -t The-Matrix-Shell -e matrix -du

# define rule in i3/config
for_window [title="The-Matrix-Shell"] fullscreen
```

## Screensaver & Lock screen
For using this script as a screensaver, you can use [slock](https://tools.suckless.org/slock/) with [unlock screen](https://tools.suckless.org/slock/patches/unlock_screen/) patch.

You can build & patch it from sources yourself, or build & use my already [patched slock version](https://github.com/WANDEX/slock).

#### Create and modify this script to fit your system, terminal emulator, available font, etc.
###### matrixlock
```sh
#!/bin/sh
# specifically for using in command: 'slock "$bname"' (this script base name)
# executes matrix shell in new spawned terminals for each monitor output
# then kills all process-group when 'slock "$bname"' process is finished

bname=$(basename "$0") # get this script base name

spawn_term() {
    # add (.0) in title - wm should use this substring as rule to match monitor output
    title="The-Matrix-Shell (.$1)"
    st -f "NotoSansMono Nerd Font:pixelsize=27" -n opaque -t "$title" -e matrix -du
}

# whole command line runs in the background
# if process exist and then finished -> killall process group | else return 1 (does nothing)
pwait -u "$USER" -f "slock $bname" && killall -g "$bname" &

nummons=$(xrandr --listactivemonitors | sed "1d" | wc -l)
i=0
while [ "$i" -lt "$nummons" ]; do
    spawn_term "$i" &
    i=$((i + 1))
done
```
#### Do not forget to add to your WM - match substring rules:
###### `window title="The-Matrix-Shell"`
to make it fullscreen/floating/etc. as you like or need.

###### `window title="(.N)"`
where `N` is number from `0` to the `total Number of monitor outputs`.

To place windows with such titles on predefined monitors.

## After installing of patched slock & creating matrixlock:
Make sure that **slock, matrix, matrixlock** files are added to your `$PATH`. And can be used independently.

##### Now you can lock your screen using this simple command:
```console
$ slock matrixlock
```

## License
[MIT](https://choosealicense.com/licenses/mit/)

