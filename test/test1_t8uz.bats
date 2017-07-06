#!./test/libs/bats/bin/bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'

setup() {
  cat << EOF > input
mytest.com
new@mytest.com
EOF

  cat << EOF > input2
12 35
new1@mytest.com
EOF

  cat << EOF > input3
www.mytest.com
new2@mytest.com
EOF
}

teardown() {
  rm -f input input2 input3
  sudo rm -rf /var/www/* \
  /etc/apache2/sites-available/*
  sudo rm -rf 35 35.conf
}

@test "TEST1: Should fail when run as non-root user." {
  run bash t8uz.sh < input
  assert_failure
}

@test "TEST1: Should pass when run as root" {
  run sudo bash t8uz.sh < input
  assert_success
}

@test "TEST1: Should fail when same host name is present" {
  run sudo bash t8uz.sh < input
  run sudo bash t8uz.sh < input
  assert_failure
}

@test "TEST1: Should fail when domain consists of space" {
  run sudo bash t8uz.sh < input2
  refute [ -d '/var/www/12' ]
  echo "The script is accepting `12 35` as domain name.
  It should not as the input string has space in it."
}

@test "TEST1: Server alias shouldn't add unnecessary .com at end" {
  run sudo bash t8uz.sh < input
  duplicate_suffix=$(grep ServerAlias /etc/apache2/sites-available/mytest.com.conf | sed 's/^\(.*\)www.mytest.com\(.*\)/\2 /')
  [ "$duplicate_suffix" == ".com" ]
  assert_failure
}

@test "TEST1: Server alias shouldn't add unnecessary www. at beginning" {
  run sudo bash t8uz.sh < input3
  duplicate_prexix=$(grep ServerAlias /etc/apache2/sites-available/www.mytest.com.conf | sed 's/^\(.*\)www.mytest.com\(.*\)/\1 /')
  [ "$duplicate_prefix=" == "www." ]
  assert_failure
}
