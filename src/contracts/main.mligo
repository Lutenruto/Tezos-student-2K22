#import "storage.mligo" "Storage"
#import "parameter.mligo" "Parameter"
#import "errors.mligo" "Errors"

type action =
    | SetText of Parameter.set_text_param
    | SetAdmin of Parameter.set_admin_param
    | RemoveAdmin of Parameter.remove_admin_param
    | NukeText of Parameter.nuke_text_param
    | Reset of unit

let assert_admin (_assert_admin_parameter, store : Parameter.assert_admin_param * Storage.t) : unit =
    match Map.find_opt (Tezos.get_sender()) store.admin_map with 
        | Some _ -> () 
        | None -> (failwith Errors.not_admin)

let assert_blacklist (assert_blacklist_parameter, store : Parameter.assert_blacklist_param * Storage.t) : unit =
    let is_blacklisted = fun (i : address) -> 
        if (i = assert_blacklist_parameter) 
        then failwith Errors.blacklisted
        else ()
    in 
    List.iter is_blacklisted store.user_blacklist

let set_admin (set_admin_parameter, store : Parameter.set_admin_param * Storage.t) : Storage.t =
    let admin_map : Storage.admin_mapping =
        match Map.find_opt (Tezos.get_sender()) store.admin_map with
            Some _ -> Map.update (Tezos.get_sender()) (Some (true : Storage.invited)) store.admin_map
            | None -> Map.add (set_admin_parameter) (false : Storage.invited) store.admin_map 
        in
        { store with admin_map }    

let remove_admin (remove_admin_parameter, store : Parameter.remove_admin_param * Storage.t) : Storage.t =
    let admin_map : Storage.admin_mapping = Map.remove remove_admin_parameter store.admin_map in
    { store with admin_map }   

let pay_contract_fees(_pay_contract_fees_param, store : Parameter.pay_contract_fees_param * Storage.t) : Storage.t =
    let amount : tez = Tezos.get_amount() in
    let sender: address = Tezos.get_sender() in

    if(amount = 1tez) then
        match Map.find_opt sender store.haspaid with
            Some _ -> failwith Errors.fees_already_paid
            | None -> 
                let haspaid: Storage.has_paid = Map.add sender true store.haspaid in
            {store with haspaid}
    else failwith Errors.wrong_fees_amount
    
let set_string_register (set_string_register_parameter, store : Storage.string_register * Storage.t) : Storage.t =
    let string_register : Storage.string_register = set_string_register_parameter in
    { store with string_register }

let set_rank (set_rank_parameter, store : Parameter.set_rank_param * Storage.t) : Storage.t =
    let user_map : Storage.mapping =
        match Map.find_opt (Tezos.get_sender()) store.user_map with
            Some _ -> Map.update (Tezos.get_sender()) (Some (set_rank_parameter, (Moldu : Storage.rank))) store.user_map
            | None -> Map.add (Tezos.get_sender()) (set_rank_parameter, (Moldu : Storage.rank)) store.user_map 
        in
        { store with user_map }

let set_text (set_text_parameter, store : Parameter.set_text_param * Storage.t) : Storage.t =
    let user_map : Storage.mapping =
        match Map.find_opt (Tezos.get_sender()) store.user_map with
            Some _ -> Map.update (Tezos.get_sender()) (Some (set_text_parameter, (Moldu : Storage.rank))) store.user_map
            | None -> Map.add (Tezos.get_sender()) (set_text_parameter, (Moldu : Storage.rank)) store.user_map 
        in
        { store with user_map }

let nuke_text (nuke_text_parameter, store : Parameter.nuke_text_param * Storage.t) : Storage.t =
    match Map.find_opt nuke_text_parameter store.user_map with
        Some _ -> 
            let user_blacklist : Storage.blacklist = nuke_text_parameter :: store.user_blacklist in
            let user_map : Storage.mapping = Map.remove nuke_text_parameter store.user_map in
            { store with user_map; user_blacklist }
        | None -> failwith Errors.text_not_found

let main (action, store : action * Storage.t) : operation list * Storage.t =
    let () : unit = assert_blacklist ( Tezos.get_sender(), store) in
    let new_store : Storage.t = match action with
                            | SetText (p) -> 
                                let _ = pay_contract_fees((), store) in
                                // let temp_map : Storage.string_register = 
                                //     Map.literal [(Tezos.get_sender(), p)]
                                //     in
                                //let () = set_string_register(temp_map, set_text (p, store)) in
                                set_rank (p, store)
                            | SetAdmin (p) -> 
                                let () : unit = assert_admin ( (), store) in
                                set_admin (p, store)
                            | RemoveAdmin (p) ->
                                let () : unit = assert_admin ( (), store) in
                                remove_admin (p, store)
                            | NukeText (p) ->
                                let () : unit = assert_admin ( (), store) in
                                nuke_text(p, store)
                            | Reset -> { store with user_map = Map.empty }
                            in
    (([] : operation list), new_store)

[@view] 
let getUserText (user, store : address * Storage.t) : Storage.value * Storage.rank =
    match Map.find_opt user store.user_map with
        Some m -> m
        | None -> failwith Errors.no_entry