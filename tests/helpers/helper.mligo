#import "../../src/contracts/main.mligo" "Main"
#import "assert.mligo" "Assert"

type taddr = (Main.action, Main.storage) typed_address
type contr = Main.action contract

let get_storage(taddr : taddr) =
    Test.get_storage taddr

let call (p, contr : Main.action * contr) =
    Test.transfer_to_contract contr (p) 0mute

//Set admin functions
let call_set_admin (p, contr : Main.action * contr) =
    call(Set_admin(p), contr)

let call_set_admin_success (p, contr : int * contr) =
    Assert.tx_success (call_set_admin(p, contr))

let call_set_admin_failure (p, contr, expected_error : int * contr * string) =
    Assert.tx_failure(call_set_admin(p, contr), expected_error)

//Remove admin functions
let call_remove_admin (p, contr : Main.action * contr) =
    call(Remove_admin(p), contr)

let call_remove_admin_success (p, contr : int * contr) =
    Assert.tx_success (call_remove_admin(p, contr))

let call_remove_admin_failure (p, contr, expected_error : int * contr * string) =
    Assert.tx_failure(call_remove_admin(p, contr), expected_error)

//Pay fees functions
let call_pay_contract_fees (p, contr : Main.action * contr) =
    call(Pay_contract_fees(p), contr)

let call_pay_contract_fees_success (p, contr : int * contr) =
    Assert.tx_success (call_pay_contract_fees(p, contr))

let call_pay_contract_fees_failure (p, contr, expected_error : int * contr * string) =
    Assert.tx_failure(call_pay_contract_fees(p, contr), expected_error)