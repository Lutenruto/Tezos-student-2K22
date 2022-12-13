#import "storage.mligo" "Storage"
#import "parameter.mligo" "Parameter"
#import "errors.mligo" "Errors"

type action =
    SetText of Storage.text
    | NukeText of Storage.user
    | Reset of unit

type return = operation list * Storage.t

let assert_admin(_assert_admin_param, store: Parameter.assert_admin_param * Storage.t) : unit =
    if Tezos.get_sender() <> store.admin then failwith Errors.not_admin else ()

let set_text(set_text_param, store : Parameter.set_text_param * Storage.t) : Storage.user_mapping =
    Map.add (Tezos.get_sender()) set_text_param store.user_map

let nuke_text(nuke_text_param, store : Parameter.nuke_text_param * Storage.t) : Storage.user_mapping =
    let () : unit = assert_admin((), store) in 
    Map.remove nuke_text_param store.user_map

let main (action, store : action * Storage.t) : return =
    let new_store : Storage.t = match action with
        SetText (text) -> {store with user_map = set_text (text, store)}
        | NukeText (user) -> {store with user_map = nuke_text(user, store)}
        | Reset -> { store with user_map = Map.empty }
        in
    (([] : operation list), new_store)
