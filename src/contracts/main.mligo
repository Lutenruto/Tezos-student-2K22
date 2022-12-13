#import "storage.mligo" "Storage"
#import "parameter.mligo" "Parameter"
#import "errors.mligo" "Errors"

type action =
    | SetText of Parameter.set_text_param
    | NukeText of Parameter.nuke_text_param
    | Reset of unit

let assert_admin (_assert_admin_parameter, store : Parameter.assert_admin_param * Storage.t) : unit =
    if (Tezos.get_sender() <> store.admin )
    then (failwith Errors.not_admin)
    else ()
  
let set_text (set_text_parameter, store : Parameter.set_text_param * Storage.t) : Storage.t =
    let user_map : Storage.mapping =
        match Map.find_opt (Tezos.get_sender()) store.user_map with
            Some _ -> Map.update (Tezos.get_sender()) (Some (set_text_parameter)) store.user_map
            | None -> Map.add (Tezos.get_sender()) (set_text_parameter) store.user_map 
        in
        { store with user_map }

let nuke_text (nuke_text_parameter, store : Parameter.nuke_text_param * Storage.t) : Storage.t =
    let user_map : Storage.mapping =
        match Map.find_opt nuke_text_parameter store.user_map with
            Some _ -> Map.remove nuke_text_parameter store.user_map
            | None -> store.user_map
        in
        { store with user_map }

let main (action, store : action * Storage.t) : operation list * Storage.t =
    let new_store : Storage.t = match action with
                            SetText (p) -> set_text (p, store)
                            | NukeText (p) ->
                                    let () : unit = assert_admin ( (), store) in
                                    nuke_text(p, store)
                            | Reset -> { store with user_map = Map.empty }
                            in
 (([] : operation list), new_store)
