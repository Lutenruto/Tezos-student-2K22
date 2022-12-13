#import "storage.mligo" "Storage"
#import "parameter.mligo" "Parameter"
#import "errors.mligo" "Errors"

type action =
  AddUser of string
| Reset of unit

type return = operation list * Storage.t

let assert_admin (_assert_admin_parameter, store : Parameter.assert_admin_param * Storage.t) : unit =
    if (Tezos.get_sender() <> store.admin)
    then (failwith Errors.not_admin)
    else ()

let verify_admin (store : Storage.t) : bool =
    if Tezos.get_sender() = store.admin then true else false

let add_user (add_user_parameter, store : Parameter.add_user_param * Storage.t) : Storage.t =
    let () : unit = assert_admin((), store) in
    let returned_user_map : Storage.mapping = Map.add store.last_index add_user_parameter store.user_map in
    let new_index : Storage.index = store.last_index + 1n in
    {store with last_index = new_index; user_map = returned_user_map}

let main (action, store : action * Storage.t) : return =
 let new_store : Storage.t = match action with
        AddUser (p) -> add_user (p, store)
        | Reset -> { store with last_index = 0n; user_map = Map.empty }
        in
 (([] : operation list), new_store)
