#!./test/libs/bats/bin/bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'

setup() {
        cat << EOF > input
        mbtamuli_12
        mbtamuli@gmail.com
        EOF
}
teardown() {
 rm -f input
}

@test "Should fail when run as right input " {
   run bash t8uz.sh < input
   assert_failure
}
@test "Should pass when run as root" {
   run sudo bash t8uz.sh < input
   assert_success
}
@test "Should fail when same host name in present " {
   run sudo bash t8uz.sh < input
   assert_failure
}
