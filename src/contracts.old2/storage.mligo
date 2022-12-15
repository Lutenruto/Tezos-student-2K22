type user = address
type value = string
type invited = bool

type rank = Platinum | Gold | Silver | Bronze | Moldu

type mapping = (user, (value * rank)) map
type admin_mapping = (user, invited) map
type haspaid = (user, bool) map
type blacklist = user list

type t = {
    admin_map: admin_mapping;
    user_map : mapping;
    user_blacklist : blacklist
}