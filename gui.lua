sfinv.register_page("automod:gui", {
    title = "AutoMod",
    get = function(self, player, context)
        local file = io.open(minetest.get_worldpath() .. "/AUTOMOD.txt")
        local content = ""
        if file then
            content = file:read("*all")
            file:close()
        end
        local gui_elements = "textarea[0.3,0;8,10;fieldlogs;;" .. content .. "]" ..
                             "button[0,8.5;4,1;refresh;Refresh]" ..
                             "button[4,8.5;4,1;clear_field;Clear]"
        return sfinv.make_formspec(player, context, gui_elements, false)
    end,
    on_player_receive_fields = function(self, player, context, fields)
        if fields.refresh then
            sfinv.set_player_inventory_formspec(player)
        elseif fields.clear_field then
            local file = io.open(minetest.get_worldpath() .. "/AUTOMOD.txt", "w")
            if file then
                file:write("")
                file:close()
                sfinv.set_player_inventory_formspec(player)
            end
        end
    end
})