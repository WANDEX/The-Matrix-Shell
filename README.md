# The-Matrix-Shell
The Matrix (1999) screen rain effect of falling green characters in a shell/terminal written with sh/bash/awk.
<p align="center">
    <img src="https://raw.githubusercontent.com/WANDEX/The-Matrix-Shell/media/media/demo_1.gif"/>
</p>

## Usage
```bash
Usage: matrix [OPTION...]
OPTIONS
    -h, --help          Display help
    -b, --binary        Use binary characters   [01]
    -d, --digits        Use digit characters    [0123456789]
    -l, --lower         Use lower case letters  [abcdefghijklmnopqrstuvwxyz]
    -u, --upper         Use upper case letters  [ABCDEFGHIJKLMNOPQRSTUVWXYZ]
    -s, --special       Use special characters  [()[]{}/\]
    -t, --testing       Activate character testing mode
    -c, --custom        Use custom characters specified 'inside single quotes'
    -m, --message       Provide a message to display in the center
    -i, --message_int   Provide an integer from 0-9 that modifies the message
    -k, --halfwidth     Use half-width characters of Japanese katakana
                        [ｱｲｳｴｵｶｷｸｹｺｻｽｾﾀﾁﾃﾄﾅﾆﾇﾈﾊﾋﾌﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦ]
    -K, --fullwidth     Use full-width Japanese katakana characters.
                        Will not work with fixed-width terminals!
[アイウエオカキクケコサスセタチテトナニヌネハヒフホマミムメモヤユヨラリルレロワヲ]
EXAMPLES
    matrix -du
    matrix -bi 5 -m 'TEST MESSAGE'
    matrix -b --custom='!?/\\' --testing
```

## Spawn full screen terminal and execute matrix shell
```bash
# example for st terminal emulator
st -f "NotoSansMono Nerd Font:pixelsize=27" -n opaque -t The-Matrix-Shell -e matrix -kd

# define rule in i3/config
for_window [title="The-Matrix-Shell"] fullscreen
```

## License
[MIT](https://choosealicense.com/licenses/mit/)

