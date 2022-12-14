// #import "../src/contracts/main.mligo" "Main"
// #import "./helpers/bootstrap.mligo" "Bootstrap"
// #import "./helpers/helper.mligo" "Helper"

// let test_successful_originate =
//     let account = Bootstrap.boot_accounts(Tezos.get_now()) in
//     let (addr, taddr, contr) = Bootstrap.originate_contract(Bootstrap.base_storage) in
//     let init_store = Helper.get_storage(taddr) in
//     let () = Test.println(init_store) in
//     assert(Bootstrap.base_storage = init_store)
