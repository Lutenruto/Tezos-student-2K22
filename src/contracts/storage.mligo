type index = nat
type user = string
type admin = bool

type mapping = (index, user, admin) map

type t = {
    last_index : index;
    user_map : mapping
}