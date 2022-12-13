type user = address
type text = string

type user_mapping = (user, text) map

type t = {
    user_map : user_mapping;
    admin: address
}