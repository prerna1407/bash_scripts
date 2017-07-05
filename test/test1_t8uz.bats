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
}

teardown() {
  rm -f input input2
  sudo rm -rf /var/www/* \
  /etc/apache2/sites-available/*
  sudo rm -rf 35 35.conf
}

@test "Should fail when run as non-root user." {
  run bash t8uz.sh < input
  assert_failure
}

@test "Should pass when run as root" {
  run sudo bash t8uz.sh < input
  assert_success
}

@test "Should fail when same host name is present" {
  run sudo bash t8uz.sh < input
  run sudo bash t8uz.sh < input
  assert_failure
}

@test "Should fail when domain consists of space" {
  run sudo bash t8uz.sh < input2
  refute [ -d '/var/www/12' ]
  echo "The script is accepting `12 35` as domain name.
  It should not as the input string has space in it."
}
