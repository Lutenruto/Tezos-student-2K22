#import "../src/contracts.old2/main.mligo" "Main"
#import "./helpers/bootstrap.mligo" "Bootstrap"
#import "./helpers/helper.mligo" "Helper"

let test_successful_pay_contract_fees =
    let accounts = Bootstrap.boot_accounts(Tezos.get_now()) in
    let (_, taddr, contr) = Bootstrap.originate_contract(Bootstrap.base_storage) in
    let () = Test.set_source(accounts.0) in
    let () = assert(Bootstrap.base_storage = Helper.get_storage(taddr)) in
    let () = Helper.call_pay_contract_fees_success(3, contr) in
    let modified_store = Helper.get_storage(taddr) in
    let () = Test.println(Test.to_string(modified_store)) in
    assert(modified_store = Bootstrap.base_storage + 3)