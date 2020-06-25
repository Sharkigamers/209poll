#/usr/bin/bash
test_exit_status () {
    command ./209poll $2 $3 $4 &> /dev/null
    if [ $? == $1 ] ; then
        echo -e "\e[1m\e[92m"OK"\e[0m": $2 = $1
    else
        echo -e "\e[1m\e[91m"KO"\e[0m": $2 = $1
    fi
}
test_output () {
    EXPECT=mktemp
    OUTPUT=`command ./209poll $2 $3 $4 2>&1 | sed "$1q;d"`
    echo -e $5 > $EXPECT
    echo $OUTPUT | diff - $EXPECT > /dev/null
    if [ $? == 0 ] ; then
        echo -e "\e[1m\e[95mLine: "$1": \e[1m\e[92m"OK"\e[0m": $5
    else
        echo -e "\e[1m\e[95mLine: "$1": \e[1m\e[91m"KO"\e[0m": $5 "<" $(<$EXPECT) "\n\t>" $OUTPUT
    fi
    rm -rf $EXPECT
}
echo -e "\e[1m\e[95m> Testing status...\e[0m"
echo -e "\e[1m\e[33mTesting not numerical args ...\e[0m"
test_exit_status 84 10000a 100 45
test_exit_status 84 10000 100a 45
test_exit_status 84 10000 100 45a
echo -e "\e[1m\e[33m> Testing missing args ...\e[0m"
test_exit_status 84 10000 100
echo -e "\e[1m\e[33m> Testing wrong values ...\e[0m"
test_exit_status 84 1 100 45
test_exit_status 84 10000 0 45
test_exit_status 84 10000 100 -1
test_exit_status 84 10000 100 101
test_exit_status 84 10000 10001 10
echo -e "\e[1m\e[33m> Testing return value from functionnal ...\e[0m"
test_exit_status 0 10000 100 45
test_exit_status 0 10000 100 42.24
echo -e "\e[1m\e[33m> Testing functionnal output...\e[0m"
test_output "1" "10000" "500" "42.24" "Population size: 10000"
test_output "1" "10000" "100" "45" "Population size: 10000"
test_output "2" "10000" "500" "42.24" "Sample size: 500"
test_output "2" "10000" "100" "45" "Sample size: 100"
test_output "3" "10000" "500" "42.24" "Voting intentions: 42.24%"
test_output "3" "10000" "100" "45" "Voting intentions: 45.00%"
test_output "4" "10000" "500" "42.24" "Variance: 0.000464"
test_output "4" "10000" "100" "45" "Variance: 0.002450"
test_output "5" "10000" "500" "42.24" "95% confidence interval: [38.02%; 46.46%]"
test_output "5" "10000" "100" "45" "95% confidence interval: [35.30%; 54.70%]"
test_output "6" "10000" "500" "42.24" "99% confidence interval: [36.68%; 47.80%]"
test_output "6" "10000" "100" "45" "99% confidence interval: [32.23%; 57.77%]"