type index = nat
type user = string

type mapping = (index, user) map

type t = {
    admin : address;
    last_index : index;
    user_map : mapping
}