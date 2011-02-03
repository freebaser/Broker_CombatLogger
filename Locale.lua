local _, ns = ...

ns.Locale = setmetatable(GetLocale() == 'frFR' and {
    ["Enabled"] = "Activ�",
    ["Disabled"] = "D�sactiv�",
} or GetLocale() == 'ruRU' and {
    ["Enabled"] = "Включено",
    ["Disabled"] = "Выключено",
} or GetLocale() == 'koKR' and {
    ["Enabled"] = "가능",
    ["Disabled"] = "불가능",
} or GetLocale() == 'zhCN' and {
    ["Enabled"] = "记录中",
    ["Disabled"] = "未记录",
} or GetLocale() == 'zhTW' and {
    ["Enabled"] = "記錄中",
    ["Disabled"] = "未記錄",
} or {}, {__index=function(t,i) return i end})

