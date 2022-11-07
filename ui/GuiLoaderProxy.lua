local GuiID = require("GuiID")

local serverProxies = {
    [GuiID.Backpack] = function(player, _, _)
        return require("backpack.BackpackContainerServer").new(player)
    end,
    [GuiID.Smelt] = function(player, xi, yi)
        return require("smelt.SmeltContainerServer").new(player, xi, yi)
    end,
    [GuiID.Brewing] = function(player, xi, yi)
        return require("brewing.BrewingContainerServer").new(player, xi, yi)
    end,
    [GuiID.Chest30] = function(player, xi, yi)
        return require("chest.Chest30ContainerServer").new(player, xi, yi)
    end,
    [GuiID.Shooter9] = function(player, xi, yi)
        return require("shooter.Shooter9ContainerServer").new(player, xi, yi)
    end,
    [GuiID.Enchantment] = function(player, xi, yi)
        return require("enchant.EnchantContainerServer").new(player, xi, yi)
    end,
    [GuiID.EnderChest30] = function(player, xi, yi)
        return require("chest.EnderChest30ContainerServer").new(player, xi, yi)
    end,
    [GuiID.Craft3x] = function(player, xi, yi)
        return require("craft3x.Craft3xContainerServer").new(player, xi, yi)
    end,
    [GuiID.Repair] = function(player, xi, yi)
        return require("repair.RepairContainerServer").new(player, xi, yi)
    end,
}

local clientProxies = {
    [GuiID.Backpack] = function(player, _, _)
        local BackpackContainerClient = require("backpack.BackpackContainerClient")
        local BackpackUI = require("backpack.BackpackUI")
        return BackpackUI.new(BackpackContainerClient.new(player))
    end,
    [GuiID.Smelt] = function(player, xi, yi)
        local SmeltContainerClient = require("smelt.SmeltContainerClient")
        local SmeltUI = require("smelt.SmeltUI")
        return SmeltUI.new(SmeltContainerClient.new(player, xi, yi))
    end,
    [GuiID.Brewing] = function(player, xi, yi)
        local BrewingContainerClient = require("brewing.BrewingContainerClient")
        local BrewingUI = require("brewing.BrewingUI")
        return BrewingUI.new(BrewingContainerClient.new(player, xi, yi))
    end,
    [GuiID.Chest30] = function(player, xi, yi)
        local Chest30ContainerClient = require("chest.Chest30ContainerClient")
        local Chest30UI = require("chest.Chest30UI")
        return Chest30UI.new(Chest30ContainerClient.new(player, xi, yi))
    end,
    [GuiID.Shooter9] = function(player, xi, yi)
        local Shooter9ContainerClient = require("shooter.Shooter9ContainerClient")
        local Shooter9UI = require("shooter.Shooter9UI")
        return Shooter9UI.new(Shooter9ContainerClient.new(player, xi, yi))
    end,
    [GuiID.Advancement] = function(player, xi, yi)
        local AdvancementContainerClient = require("advancement.AdvancementContainerClient")
        local AdvancementUI = require("advancement.AdvancementUI")
        return AdvancementUI.new(AdvancementContainerClient.new(player))
    end,
    [GuiID.Enchantment] = function(player, xi, yi)
        local EnchantContainerClient = require("enchant.EnchantContainerClient")
        local EnchantUI = require("enchant.EnchantUI")
        return EnchantUI.new(EnchantContainerClient.new(player, xi, yi))
    end,
    [GuiID.EnderChest30] = function(player, _, _)
        local Chest30ContainerClient = require("chest.Chest30ContainerClient")
        local EnderChest30UI = require("chest.EnderChest30UI")
        return EnderChest30UI.new(Chest30ContainerClient.new(player))
    end,
    [GuiID.Craft3x] = function(player, _, _)
        local Craft3xContainerClient = require("craft3x.Craft3xContainerClient")
        local Craft3xUI = require("craft3x.Craft3xUI")
        return Craft3xUI.new(Craft3xContainerClient.new(player))
    end,
    [GuiID.Repair] = function(player, xi, yi)
        local RepairContainerClient = require("repair.RepairContainerClient")
        local RepairUI = require("repair.RepairUI")
        return RepairUI.new(RepairContainerClient.new(player, xi, yi))
    end,
}

return { serverProxies, clientProxies }