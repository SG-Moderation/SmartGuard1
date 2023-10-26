sfinv.register_page("automod:gui", {
    title = "AutoMod",
    get = function(self, player, context)
        local file = io.open(minetest.get_worldpath() .. "/AUTOMOD_LOGS.txt")
        local content = file:read("*all")
        file:close()
        local gui_elements = "textarea[0.3,0;8,10;fieldlogs;;" .. content .. "]" ..
                             "button[0,8.5;4,1;refresh;Refresh]" ..
                             "button[4,8.5;4,1;clear_field;Clear]"
        return sfinv.make_formspec(player, context, gui_elements, false)
    end
})