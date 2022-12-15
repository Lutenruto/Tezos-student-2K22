type user = address
type value = string
type invited = bool

type rank = Platinum | Gold | Silver | Bronze | Moldu

type mapping = (user, (value * rank)) map
type admin_mapping = (user, invited) map
type has_paid = (user, bool) map
type string_register = (address, string) map
type blacklist = user list

type t = {
    admin_map: admin_mapping;
    user_map : mapping;
    haspaid : has_paid;
    string_register : string_register;
    user_blacklist : blacklist
}