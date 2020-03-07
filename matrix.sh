#!/bin/sh
# "The Matrix" effect

BINARY_G='01'
DIGITS_G='0123456789'
LOWER_G='abcdefghijklmnopqrstuvwxyz'
UPPER_G='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
SPECIAL_G='()[]{}/\\'
KATAKANA_H_G='ｱｲｳｴｵｶｷｸｹｺｻｽｾﾀﾁﾃﾄﾅﾆﾇﾈﾊﾋﾌﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦ'
KATAKANA_F_G='アイウエオカキクケコサスセタチテトナニヌネハヒフホマミムメモヤユヨラリルレロワヲ'

usage() {
    # Help message
    printf "Usage: $(basename $BASH_SOURCE) [OPTION...]\n"
    printf "OPTIONS\n"
    printf "\t-h, --help \t\t\tDisplay help\n"
    printf "\t-b, --binary \t\tUse binary characters \t[$BINARY_G]\n"
    printf "\t-d, --digits \t\tUse digit characters  \t[$DIGITS_G]\n"
    printf "\t-l, --lower\t\t\tUse lower case letters\t[$LOWER_G]\n"
    printf "\t-u, --upper\t\t\tUse upper case letters\t[$UPPER_G]\n"
    printf "\t-s, --special\t\tUse special characters\t[$SPECIAL_G]\n"
    printf "\t-t, --testing\t\tActivate character testing mode\n"
    printf "\t-c, --custom \t\tUse custom characters specified \'inside single quotes\'\n"
    printf "\t-m, --message\t\tProvide a message to display in the center\n"
    printf "\t-i, --message_int\tProvide an integer from 0-9 that modifies the message\n"
    printf "\t-k, --halfwidth\t\tUse half-width characters of Japanese katakana\n\t\t\t\t\t\t[$KATAKANA_H_G]\n"
    printf "\t-K, --fullwidth\t\tUse full-width Japanese katakana characters.\n"
    printf "\t\t\t\t\t\tWill not work with fixed-width terminals!\t\n[$KATAKANA_F_G]\n"
    printf "EXAMPLES\n"
    printf "\t$(basename $BASH_SOURCE) -du\n"
    printf "\t$(basename $BASH_SOURCE) -bi 5 -m 'TEST MESSAGE'\n"
    printf "\t$(basename $BASH_SOURCE) -b --custom='"
    printf '!?/\\\'
    printf "' --testing\n"
    exit 0
}

input_validation() {
    # show usage if command not supplied
    if [ $? != 0 ]; then
        printf "Failed to parse options. Exiting...\n"
        exit 1
    elif [[ -z "$1" ]]; then
        usage
    elif [[ "$1" != -* || "$1" == - ]]; then
        printf "Options should start with '-'.\n"
        usage
    fi
}

get_opt() {
    # Parse and read OPTIONS command-line options
    SHORT=bc:dhi:kKlm:stu
    LONG=binary,custom:,digits,help,message_int:,fullwidth,lower,message:,halfwidth,special,testing,upper
    OPTIONS=$(getopt --options $SHORT --long $LONG --name "$0" -- "$@")
    input_validation "$@"
    # PLACE FOR OPTION DEFAULTS
    message='NEO THE MATRIX HAS YOU'
    message_int=0 # int from 0 to 9 including
    eval set -- "$OPTIONS"
    while true; do
        case "$1" in
        -b|--binary)
            binary_v="$BINARY_G"
            ;;
        -c|--custom)
            shift
            custom_v=$1
            ;;
        -d|--digits)
            digits_v="$DIGITS_G"
            ;;
        -h|--help)
            usage
            ;;
        -i|--message_int)
            shift
            message_int="$1"
            ;;
        -k|--halfwidth)
            katakana_h_v="$KATAKANA_H_G"
            ;;
        -K|--fullwidth)
            katakana_f_v="$KATAKANA_F_G"
            ;;
        -l|--lower)
            lower_v="$LOWER_G"
            ;;
        -m|--message)
            shift
            message="$1"
            ;;
        -s|--special)
            special_v="$SPECIAL_G"
            ;;
        -t|--testing)
            testing_f=1
            ;;
        -u|--upper)
            upper_v="$UPPER_G"
            ;;
        --)
            shift
            break
            ;;
        esac
        shift
    done
}

testing_mode() {
    if [[ $testing_f ]]; then
        printf "Character Testing Mode.\n\n"
        printf "characters:\t[$letters]\n"
        printf "charlength:\t($letters_len) = characters length + 1\n"
        printf "exiting...\n"
        exit 0
    fi
}

get_chars() {
    letters="$binary_v$digits_v$lower_v$upper_v$special_v$katakana_f_v$katakana_h_v$custom_v"
    letters_len="$((${#letters} + 1))"
    testing_mode
}

main() {
    lines=$(tput lines)
    cols=$(tput cols)
    message_len="$((${#message} - 2))"
    cent_v=$((lines / 2)) # find vertical center
    cent_h=$(((cols / 2) - (message_len / 2))) # find horizontal center

    awkscript='
    {
        lines=$1;
        random_col=$3;
        c=$4;
        letter=substr(letters,c,1);
        cols[random_col]=0;

        for (col in cols) {
            rnum = int(20*rand());
            if (cols[col] < 0) {
                line=-cols[col];
                cols[col]=cols[col]-1;
                subline = -cols[col] + 1;
                printf "\033[%s;%sH%s", line, col, " ";
                printf "\033[%s;%sH%s\033[0;0H", newline, col, " ";
                if (actcol >= lines) {
                    cols[col]=0;
                } else if (rnum < 1) {
                    cols[col]=0;
                }
            } else {
                line=cols[col]+1;
                cols[col]=cols[col]+1;
                if (rnum < 3) {
                    printf "\033[%s;%sH\033[0;32m%s\033[0m", line, col, letter;
                } else {
                    printf "\033[%s;%sH\033[2;32m%s\033[0m", line, col, letter;
                }
                #printf "\033[%s;%sH\033[2;32m%s\033[0;0H\033[0m", cols[col], col, letter;
                printf "\033[%s;%sH\033[%s;32m%s\033[0;0H\033[0m", cent_v, cent_h, message_int, message;
                if (cols[col] >= lines) {
                    if (rnum < 2) {
                        cols[col]=0;
                    } else {
                        cols[col]=-1;
                    }
                }
            }
        }
    }
    '

    echo -e "\e[1;40m"
    clear

    if [[ -t 0 ]]; then
        stty -echo -icanon -icrnl time 0 min 0;
    fi

    keypress=''
    while [ "x$keypress" = "x" ]; do
        echo $lines $cols $(( $RANDOM % $cols)) $(( $RANDOM % letters_len ))
        sleep 0.04
        keypress="`cat -v`"
    done | awk -v letters="$letters" -v cent_v="$cent_v" -v cent_h="$cent_h" -v message="$message" -v message_int="$message_int" "$awkscript"

    if [[ -t 0 ]]; then
        stty sane;
    fi

    clear
    exit 0
}

get_opt "$@"
get_chars
main
