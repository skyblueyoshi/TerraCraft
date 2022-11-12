---@class TC.UIDesign
local UIDesign = class("UIDesign")
local UIUtil = require("UIUtil")
local UIDefault = require("UIDefault")
local Locale = require("languages.Locale")
local UISpritePool = require("UISpritePool").getInstance()

function UIDesign.getStartUI()

    local UI_SIZE = Size.new(400, 400)

    local root = UIPanel.new("start_ui")
    root.size = GameWindow.displayResolution
    root:setMarginEnabled(true, true, true, true)
    root:setAutoStretch(true, true)
    local panel = UIUtil.createPanel("layer", 0, 0, UI_SIZE.width, UI_SIZE.height, {
        margins = { 0, 128, 0, 64, false, false }
    })
    root:addChild(panel)
    local sy = 32
    panel:addChild(UIUtil.createButton("btn_single", Locale.SINGLE_PLAYER, 0, sy, UI_SIZE.width, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        marginsLR = { 0, 0, false }
    }))
    sy = sy + UIDefault.ButtonOffset
    panel:addChild(UIUtil.createButton("btn_mul_player", Locale.MULTI_PLAYER, 0, sy, UI_SIZE.width, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        marginsLR = { 0, 0, false }
    }))
    sy = sy + UIDefault.ButtonOffset
    panel:addChild(UIUtil.createButton("btn_mod", Locale.MOD_LIST, 0, sy, UI_SIZE.width, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        marginsLR = { 0, 0, false }
    }))
    sy = sy + UIDefault.ButtonOffset
    panel:addChild(UIUtil.createButton("btn_community", Locale.COMMUNITY, 0, sy, UI_SIZE.width, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        marginsLR = { 0, 0, false }
    }))
    sy = sy + UIDefault.ButtonOffset + 16
    panel:addChild(UIUtil.createButtonWithImage("btn_lang", "tc:lang", 0, sy, UIDefault.ButtonHeight, UIDefault.ButtonHeight, {
        marginsLR = { -UIDefault.ButtonHeight - 16, nil }
    }))
    panel:addChild(UIUtil.createButton("btn_setting", Locale.SETTING, 0, sy, UI_SIZE.width / 2 - 8, UIDefault.ButtonHeight, {
        marginsLR = { 0, UI_SIZE.width / 2 + 8 }
    }))
    panel:addChild(UIUtil.createButton("btn_exit", Locale.EXIT_GAME,
            0, sy, UI_SIZE.width / 2 - 8, UIDefault.ButtonHeight, {
                marginsLR = { UI_SIZE.width / 2 + 8, 0 }
            }))
    root:addChild(UIUtil.createLabelNoPos("lb_copyright", Locale.COPYRIGHT,
            TextAlignment.Left, TextAlignment.Bottom, {
                margins = { 16, nil, nil, 0 }
            }))
    root:addChild(UIUtil.createLabelNoPos("lb_mod", Locale.MOD_LOADER_INFO,
            TextAlignment.Left, TextAlignment.Bottom, {
                margins = { 16, nil, nil, 32 }
            }))
    root:addChild(UIUtil.createLabelNoPos("lb_engine_ver", Locale.ENGINE_VERSION,
            TextAlignment.Right, TextAlignment.Bottom, {
                margins = { nil, nil, 16, 0 }
            }))
    root:addChild(UIUtil.createLabelNoPos("lb_game_ver", Locale.ENGINE_VERSION,
            TextAlignment.Right, TextAlignment.Bottom, {
                margins = { nil, nil, 16, 32 }
            }))
    return root
end

function UIDesign.getPendingUI()

    local UI_SIZE = Size.new(400, 400)

    local root = UIUtil.createBlackFullScreenLayer("pending_ui")
    root.size = GameWindow.displayResolution
    root:setMarginEnabled(true, true, true, true)
    root:setAutoStretch(true, true)
    local panel = UIUtil.createPanel("layer", 0, 0, UI_SIZE.width, UI_SIZE.height, {
        margins = { 0, 0, 0, 0, false, false }
    })
    root:addChild(panel)

    panel:addChild(UIUtil.createPanel("panel_animation", 0, 170, 32, 32, {
        marginsLR = { 0, 0 }
    }))
    panel:addChild(UIUtil.createLabel("lb_tip", Locale.LOADING,
            0, 250, UI_SIZE.width, 32, TextAlignment.HCenter, TextAlignment.VCenter, {

            }))

    panel:addChild(UIUtil.createButton("btn_back", Locale.BACK, 0, 0, UI_SIZE.width, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { 0, nil, 0, 50, false, false }
    }))

    return root
end

function UIDesign.getOptionUI()

    local UI_SIZE = Size.new(400, 400)

    local root = UIUtil.createBlackFullScreenLayer("option_ui")
    root.size = GameWindow.displayResolution
    root:setMarginEnabled(true, true, true, true)
    root:setAutoStretch(true, true)
    local panel = UIUtil.createPanel("layer", 0, 0, UI_SIZE.width, UI_SIZE.height, {
        margins = { 0, 128, 0, 64, false, false }
    })
    root:addChild(panel)
    local sy = 32
    panel:addChild(UIUtil.createButton("btn_back", Locale.BACK_TO_GAME, 0, sy, UI_SIZE.width, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        marginsLR = { 0, 0, false }
    }))
    sy = sy + UIDefault.ButtonOffset
    panel:addChild(UIUtil.createButton("btn_setting", Locale.SETTING, 0, sy, UI_SIZE.width, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        marginsLR = { 0, 0, false }
    }))
    sy = sy + UIDefault.ButtonOffset
    panel:addChild(UIUtil.createButton("btn_recipe", Locale.RECIPE_SEARCH .. "(R)", 0, sy, UI_SIZE.width, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        marginsLR = { 0, 0, false }
    }))
    sy = sy + UIDefault.ButtonOffset
    panel:addChild(UIUtil.createButton("btn_advancement", Locale.ADVANCEMENT .. "(F)", 0, sy, UI_SIZE.width, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        marginsLR = { 0, 0, false }
    }))
    sy = sy + UIDefault.ButtonOffset
    panel:addChild(UIUtil.createButton("btn_save_and_exit", Locale.SAVE_AND_EXIT, 0, sy, UI_SIZE.width, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        marginsLR = { 0, 0, false }
    }))

    panel:addChild(UIUtil.createLabelNoPos("lb_caption", Locale.GAME_MENU,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                margins = { 0, -20, 0, nil }
            }))
    return root
end

function UIDesign.getLanguageUI()

    local UI_SIZE = Size.new(600, 450)

    local root = UIPanel.new("language_ui")
    root.size = GameWindow.displayResolution
    root:setMarginEnabled(true, true, true, true)
    root:setAutoStretch(true, true)
    root.sprite = UISpritePool:get("tc:black")
    root.sprite.color = Color.new(255, 255, 255, 200)

    local panel = UIUtil.createPanel("layer", 0, 0, UI_SIZE.width, UI_SIZE.height, {
        margins = { 0, 0, 0, 0, false, false }
    })
    root:addChild(panel)
    panel:addChild(UIUtil.createImageNoPos("bg_frame", {
        margins = { 0, 0, 0, 0 },
        sprite = {
            name = "tc:window_frame_01",
            color = Color.new(255, 255, 255, 240)
        }
    }))
    panel:addChild(UIUtil.createImageNoPos("bg", {
        margins = { 2, 2, 2, 2 },
        sprite = {
            name = "tc:window_bg_01",
            color = Color.new(255, 255, 255, 30),
            style = UISpriteStyle.Filled
        }
    }))
    panel:addChild(UIUtil.createButton("btn_ok", Locale.OK, 0, 200, UI_SIZE.width, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { 16, nil, 16, 16 },
        targetSprite = {
            color = Color.new(110, 108, 132, 255)
        }
    }))
    panel:addChild(UIUtil.createLabelNoPos("lb_title", Locale.SELECT_LANGUAGE,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                positionY = 12,
                fontSize = UIDefault.FontSize + 8,
                marginsLR = { 0, 0 }
            }))
    panel:addChild(UIUtil.createLabelNoPos("lb_list_title", Locale.LANGUAGE_LIST,
            TextAlignment.Left, TextAlignment.Top, {
                margins = { 16, 64, 16, nil },
                color = Color.Gray
            }))
    panel:addChild(UIUtil.createImage("img_line", 0, 76, 128, 1, {
        marginsLR = { 100, 16 },
        sprite = {
            name = "tc:white",
            color = Color.Gray
        }
    }))
    panel:addChild(UIUtil.createLabelNoPos("lb_tips",
            Locale.LANGUAGE_MAY_WRONG,
            TextAlignment.HCenter, TextAlignment.Top, {
                margins = { 16, nil, 16, 80 },
                color = Color.new(128, 128, 0)
            }))
    local panelList = UIUtil.createScrollViewNoPos("panel_list", {
        margins = { 16, 96, 16, 128 },
    })
    panel:addChild(panelList)
    local panelItem = UIPanel.new("panel_item", 0, 0, panelList.size.width, 64)
    panelList:addChild(panelItem)

    panelItem:addChild(UIUtil.createImageNoPos("img_selected", {
        margins = { 0, 0, 0, 0 },
        touchable = false,
        visible = false,
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(48, 48, 60, 222)
        }
    }))
    panelItem:addChild(UIUtil.createLabelNoPos("lb_locale", "English",
            TextAlignment.HCenter, TextAlignment.VCenter, {
                margins = { 0, 0, 0, 0 }
            }))
    return root
end

function UIDesign.getPlayerListUI()
    local UI_SIZE = Size.new(800, 450)
    local root = UIUtil.createBlackFullScreenLayer("player_list_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, nil)
    panel:addChild(UIUtil.createLabelNoPos("lb_title", Locale.SELECT_PLAYER,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                positionY = 12,
                marginsLR = { 0, 0 },
                fontSize = UIDefault.FontSize + 8
            }))
    local panelList = UIUtil.createScrollViewNoPos("panel_list", {
        margins = { 16, 64, 16, 80 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(30, 30, 45)
        }
    })
    panel:addChild(panelList)
    local panelItem = UIPanel.new("panel_item", 0, 0, panelList.size.width, 96)
    panelList:addChild(panelItem)
    panelItem:addChild(UIUtil.createImageNoPos("img_selected", {
        margins = { 0, 0, 0, 0 },
        touchable = false,
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(60, 60, 80, 222)
        }
    }))
    panelItem:addChild(UIUtil.createImage("img_line", 0, 96, 100, 2, {
        marginsLR = { 16, 16 },
        sprite = {
            name = "tc:white",
            color = Color.new(60, 60, 80, 100)
        }
    }))
    local playerIconHolder = UIUtil.createImage("img_player_icon_holder", 16, 16, 64, 64, {
        touchable = false
    })
    panelItem:addChild(playerIconHolder)
    playerIconHolder:addChild(UIUtil.createImageNoPos("bg", {
        margins = { 0, 0, 0, 0 },
        touchable = false,
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(10, 10, 25)
        }
    }))
    panelItem:addChild(UIUtil.createLabel("lb_player_name", "BlueYoshiSuperLazyJuju",
            96, 32, 128, 24,
            TextAlignment.Left, TextAlignment.VCenter))
    --panelItem:addChild(UIUtil.createImage("img_hp", 96, 48, 32, 32, {
    --    touchable = false,
    --    sprite = { name = "tc:health" }
    --}))
    --panelItem:addChild(UIUtil.createLabel("lb_hp", "200/200",
    --        130, 48, 96, 32,
    --        TextAlignment.Left, TextAlignment.VCenter, {
    --            color = Color.new(200, 100, 100)
    --        }))
    --panelItem:addChild(UIUtil.createImage("img_mana", 226, 48, 32, 32, {
    --    touchable = false,
    --    sprite = { name = "tc:mana" }
    --}))
    --panelItem:addChild(UIUtil.createLabel("lb_mana", "100/100",
    --        260, 48, 96, 32,
    --        TextAlignment.Left, TextAlignment.VCenter, {
    --            color = Color.new(100, 100, 200)
    --        }))
    --panelItem:addChild(UIUtil.createImage("img_exp", 356, 48, 32, 32, {
    --    touchable = false,
    --    sprite = { name = "tc:exp" }
    --}))
    --panelItem:addChild(UIUtil.createLabel("lb_exp", "Lv.12",
    --        384, 48, 96, 32,
    --        TextAlignment.Left, TextAlignment.VCenter, {
    --            color = Color.new(150, 150, 75)
    --        }))
    --panelItem:addChild(UIUtil.createLabel("lb_tips", "背包共享",
    --        460, 48, 96, 32,
    --        TextAlignment.Left, TextAlignment.VCenter, {
    --            color = Color.FrenchGray
    --        }))
    panelItem:addChild(UIUtil.createButtonWithImage("btn_remove", "tc:delete",
            700, 0, 48, 48, {
                marginsTB = { 16, 16, false },
                targetSprite = { color = Color.new(110, 108, 132, 255) }
            }, {
                sprite = { color = Color.new(180, 168, 232, 255) }
            }))
    panelItem:addChild(UIUtil.createButtonWithImage("btn_cfg", "tc:conf",
            640, 0, 48, 48, {
                marginsTB = { 16, 16, false },
                targetSprite = { color = Color.new(110, 108, 132, 255) }
            }, {
                sprite = { color = Color.new(180, 168, 232, 255) }
            }))
    panel:addChild(UIUtil.createButton("btn_back", Locale.BACK, 0, 200, 220, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { 0, nil, UI_SIZE.width * 0.66, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panel:addChild(UIUtil.createButton("btn_create", Locale.NEW_PLAYER_B, 0, 200, 220, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { 0, nil, 0, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panel:addChild(UIUtil.createButton("btn_ok", Locale.SELECT_PLAYER, 0, 200, 220, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { UI_SIZE.width * 0.66, nil, 0, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    return root
end

function UIDesign.getNewPlayerUI()
    local UI_SIZE = Size.new(800, 450)
    local root = UIUtil.createBlackFullScreenLayer("new_player_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, nil)
    panel:getChild("bg_frame"):setRightMargin(200, true)
    root:addChild(panel)
    panel:addChild(UIUtil.createLabelNoPos("lb_title", Locale.CREATE_PLAYER,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                positionY = 12,
                marginsLR = { 0, 200 },
                fontSize = UIDefault.FontSize + 8
            }))
    panel:addChild(UIUtil.createButton("btn_back", Locale.BACK, 32, 200, 250, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { nil, nil, nil, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panel:addChild(UIUtil.createButton("btn_ok", Locale.CREATE_PLAYER, 320, 200, 250, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { nil, nil, nil, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))

    local panelList = UIUtil.createScrollView("panel_list", 0, 0, 240, 100, {
        margins = { 16, 64, nil, 150 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(30, 30, 45)
        }
    })
    panel:addChild(panelList)
    local panelItem = UIPanel.new("panel_item", 0, 0, panelList.size.width, 80)
    panelList:addChild(panelItem)
    panelItem:addChild(UIUtil.createImageNoPos("img_selected", {
        margins = { 0, 0, 0, 0 },
        touchable = false,
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(60, 60, 80, 222)
        },
        visible = false
    }))
    panelItem:addChild(UIUtil.createImage("img_line", 0, 80, 100, 2, {
        marginsLR = { 16, 16 },
        sprite = {
            name = "tc:white",
            color = Color.new(60, 60, 80, 100)
        }
    }))
    local playerIconHolder = UIUtil.createImage("img_player_icon_holder", 8, 8, 64, 64, {
        touchable = false
    })
    panelItem:addChild(playerIconHolder)
    playerIconHolder:addChild(UIUtil.createImageNoPos("bg", {
        margins = { 0, 0, 0, 0 },
        touchable = false,
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(10, 10, 25)
        }
    }))
    panelItem:addChild(UIUtil.createLabel("lb_name", "xqz",
            80, 8, 128, 24,
            TextAlignment.Left, TextAlignment.VCenter))
    panelItem:addChild(UIUtil.createLabel("lb_author", "by Blueyoshi, xxx, zzz",
            80, 32, 128, 24,
            TextAlignment.Left, TextAlignment.VCenter, {
                fontSize = 18,
                color = Color.FrenchGray
            }))
    panelItem:addChild(UIUtil.createLabel("lb_mod", "Mod: Terraria",
            80, 52, 128, 24,
            TextAlignment.Left, TextAlignment.VCenter, {
                fontSize = 18,
                color = Color.Gray
            }))

    panel:addChild(UIUtil.createLabel("lb_gender", "性别:",
            280, 176, 100, 32,
            TextAlignment.Left, TextAlignment.VCenter))
    panel:addChild(UIUtil.createButtonWithImage("btn_male", "tc:male",
            360, 160, 56, 56, {
                targetSprite = { color = Color.new(80, 88, 102, 255) },
            }))
    panel:addChild(UIUtil.createButtonWithImage("btn_female", "tc:female",
            480, 160, 56, 56, {
                targetSprite = { color = Color.new(80, 88, 102, 255) },
            }))
    panel:getChild("lb_gender").visible = false
    panel:getChild("btn_male").visible = false
    panel:getChild("btn_female").visible = false

    panel:addChild(UIUtil.createLabel("lb_name", Locale.NAME_Q,
            280, 100, 100, 32,
            TextAlignment.Left, TextAlignment.VCenter))

    local panelName = UIUtil.createPanel("panel_name", 340, 90, 200, 48, {
        marginsLR = { 340, 216 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(60, 60, 85)
        }
    })
    panel:addChild(panelName)
    panelName:addChild(UIUtil.createPanelNoPos("bg", {
        margins = { 2, 2, 2, 2 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(30, 30, 45)
        }
    }))
    local editName = UIInputField.new("edit")
    UIUtil.setMargins(editName, 8, 8, 8, 8)
    panelName:addChild(editName)

    panel:addChild(UIUtil.createButton("btn_move", Locale.MORE_SETTINGS, 0, 250, 276, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        marginsLR = { 272, 216 },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
        visible = false
    }))

    panel:addChild(UIUtil.createPanel("pos_panel", 640, 125, 200, 200))

    local panelInfo = UIUtil.createPanelNoPos("panel_info", {
        margins = { 16, 310, 216, 80 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(28, 28, 40, 222)
        },
    })
    panel:addChild(panelInfo)
    panelInfo:addChild(UIUtil.createPanelNoPos("bg", {
        margins = { 4, 4, 4, 4 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(10, 10, 20, 222)
        }
    }))
    panelInfo:addChild(UIUtil.createLabelNoPos("lb_info", "名字不能超过1000个字符!",
            TextAlignment.HCenter, TextAlignment.VCenter, {
                margins = { 0, 0, 0, 0 },
                color = Color.Yellow
            }))

    panel:addChild(UIUtil.createButton("btn_animator", Locale.CHANGE_POSTURE, 660, 350, 160, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        targetSprite = { color = Color.new(80, 88, 102, 255) },
    }))

    return root
end

function UIDesign.getWorldListUI()

    local UI_SIZE = Size.new(800, 450)
    local root = UIUtil.createBlackFullScreenLayer("world_list_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, nil)
    panel:addChild(UIUtil.createLabelNoPos("lb_title", Locale.SELECT_WORLD,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                positionY = 12,
                marginsLR = { 0, 0 },
                fontSize = UIDefault.FontSize + 8
            }))
    local panelList = UIUtil.createScrollViewNoPos("panel_list", {
        margins = { 16, 64, 16, 80 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(30, 30, 45)
        }
    })
    panel:addChild(panelList)
    local panelItem = UIPanel.new("panel_item", 0, 0, panelList.size.width, 128)
    panelList:addChild(panelItem)
    panelItem:addChild(UIUtil.createImageNoPos("img_selected", {
        margins = { 0, 0, 0, 0 },
        touchable = false,
        visible = false,
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(60, 60, 80, 222)
        }
    }))
    panelItem:addChild(UIUtil.createImage("img_line", 0, 128, 100, 2, {
        marginsLR = { 16, 16 },
        sprite = {
            name = "tc:white",
            color = Color.new(60, 60, 80, 100)
        }
    }))
    local imgWorldPic = UIUtil.createImage("img_world_pic", 16, 16, 96, 96, {
        touchable = false,
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(10, 10, 25)
        }
    })
    panelItem:addChild(imgWorldPic)
    imgWorldPic:addChild(UIUtil.createImageNoPos("img", {
        margins = { 0, 0, 0, 0 },
        touchable = false,
        sprite = {
            name = "tc:world_icon",
        }
    }))
    panelItem:addChild(UIUtil.createLabel("lb_world_name", "SuperJujuWorld",
            128, 16, 128, 24,
            TextAlignment.Left, TextAlignment.VCenter))
    panelItem:addChild(UIUtil.createLabel("lb_time", "2/22/2022 2:22 PM",
            128, 48, 96, 32,
            TextAlignment.Left, TextAlignment.VCenter, {
                color = Color.Gray
            }))
    panelItem:addChild(UIUtil.createLabel("lb_tips", "Hardcore Mode, Version 2022",
            128, 80, 96, 32,
            TextAlignment.Left, TextAlignment.VCenter, {
                color = Color.FrenchGray
            }))
    panelItem:addChild(UIUtil.createButtonWithImage("btn_remove", "tc:delete",
            700, 0, 48, 48, {
                marginsTB = { 16, 16, false },
                targetSprite = { color = Color.new(110, 108, 132, 255) }
            }, {
                sprite = { color = Color.new(180, 168, 232, 255) }
            }))
    panel:addChild(UIUtil.createButton("btn_back", Locale.BACK, 0, 200, 220, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { 0, nil, UI_SIZE.width * 0.66, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panel:addChild(UIUtil.createButton("btn_create", Locale.NEW_WORLD_B, 0, 200, 220, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { 0, nil, 0, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panel:addChild(UIUtil.createButton("btn_ok", Locale.ENTER_WORLD, 0, 200, 220, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { UI_SIZE.width * 0.66, nil, 0, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    return root
end

function UIDesign.getNewWorldUI()
    local UI_SIZE = Size.new(600, 450)
    local root = UIUtil.createBlackFullScreenLayer("new_list_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, nil)
    panel:addChild(UIUtil.createLabelNoPos("lb_title", Locale.CREATE_NEW_WORLD,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                positionY = 12,
                marginsLR = { 0, 0 },
                fontSize = UIDefault.FontSize + 8
            }))
    panel:addChild(UIUtil.createLabel("lb_name", Locale.WORLD_NAME_Q,
            0, 60, 180, 48,
            TextAlignment.HCenter, TextAlignment.VCenter, {}))
    local panelName = UIUtil.createPanel("panel_name", 0, 60, 200, 48, {
        marginsLR = { 180, 16 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(60, 60, 85)
        }
    })
    panel:addChild(panelName)
    panelName:addChild(UIUtil.createPanelNoPos("bg", {
        margins = { 2, 2, 2, 2 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(30, 30, 45)
        }
    }))
    local editName = UIInputField.new("edit")
    UIUtil.setMargins(editName, 8, 8, 8, 8)
    panelName:addChild(editName)
    panel:addChild(UIUtil.createLabel("lb_seed", Locale.WORLD_SEED_Q,
            0, 120, 180, 48,
            TextAlignment.HCenter, TextAlignment.VCenter, {}))
    local panelSeed = UIUtil.createPanel("panel_seed", 0, 120, 200, 48, {
        marginsLR = { 180, 16 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(60, 60, 85)
        }
    })
    panel:addChild(panelSeed)
    panelSeed:addChild(UIUtil.createPanelNoPos("bg", {
        margins = { 2, 2, 2, 2 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(30, 30, 45)
        }
    }))
    local editSeed = UIInputField.new("edit")
    UIUtil.setMargins(editSeed, 8, 8, 8, 8)
    panelSeed:addChild(editSeed)
    panel:addChild(UIUtil.createButton("btn_gm", Locale.SURVIVAL_MODE, 0, 190, 276, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        marginsLR = { 16, UI_SIZE.width * 0.5 + 8, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panel:addChild(UIUtil.createButton("btn_bp", Locale.BP_SHARED_MODE, 0, 190, 276, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        marginsLR = { UI_SIZE.width * 0.5 + 8, 16, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panel:addChild(UIUtil.createButton("btn_move", Locale.MORE_SETTINGS, 0, 250, 276, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        marginsLR = { 16, 16 },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panel:getChild("btn_move").visible = false
    local panelInfo = UIUtil.createPanelNoPos("panel_info", {
        margins = { 16, 316, 16, 80 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(28, 28, 40, 222)
        }
    })
    panel:addChild(panelInfo)
    panelInfo:addChild(UIUtil.createPanelNoPos("bg", {
        margins = { 4, 4, 4, 4 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(10, 10, 20, 222)
        }
    }))
    panelInfo:addChild(UIUtil.createLabelNoPos("lb_info", "Hello world! This is a Tip! 名字不能超过1000个字符!",
            TextAlignment.HCenter, TextAlignment.VCenter, {
                margins = { 0, 0, 0, 0 },
                color = Color.Yellow
            }))
    panel:addChild(UIUtil.createButton("btn_back", Locale.BACK, 0, 200, 250, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { 0, nil, UI_SIZE.width * 0.5, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panel:addChild(UIUtil.createButton("btn_ok", Locale.CREATE_WORLD, 0, 200, 250, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { UI_SIZE.width * 0.5, nil, 0, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    return root
end

function UIDesign.getServerListUI()

    local UI_SIZE = Size.new(800, 450)
    local root = UIUtil.createBlackFullScreenLayer("server_list_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, nil)
    panel:addChild(UIUtil.createLabelNoPos("lb_title", "选择服务器",
            TextAlignment.HCenter, TextAlignment.VCenter, {
                positionY = 12,
                marginsLR = { 0, 0 },
                fontSize = UIDefault.FontSize + 8
            }))
    local panelList = UIUtil.createScrollViewNoPos("panel_list", {
        margins = { 16, 64, 16, 80 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(30, 30, 45)
        }
    })
    panel:addChild(panelList)
    local panelItem = UIPanel.new("panel_item", 0, 0, panelList.size.width, 96)
    panelList:addChild(panelItem)
    panelItem:addChild(UIUtil.createImageNoPos("img_selected", {
        margins = { 0, 0, 0, 0 },
        touchable = false,
        visible = false,
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(60, 60, 80, 222)
        }
    }))
    panelItem:addChild(UIUtil.createImage("img_line", 0, 96, 100, 2, {
        marginsLR = { 16, 16 },
        sprite = {
            name = "tc:white",
            color = Color.new(60, 60, 80, 100)
        }
    }))
    panelItem:addChild(UIUtil.createImage("img_server_pic", 16, 16, 64, 64, {
        touchable = false,
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(10, 10, 25)
        }
    }))
    panelItem:addChild(UIUtil.createLabel("lb_server_name", "Blueyoshi Test Server",
            96, 16, 128, 24,
            TextAlignment.Left, TextAlignment.VCenter))
    panelItem:addChild(UIUtil.createLabel("lb_tips", "这是一个服务器首页文本！",
            96, 48, 96, 32,
            TextAlignment.Left, TextAlignment.VCenter, {
                color = Color.FrenchGray
            }))
    panelItem:addChild(UIUtil.createImage("img_ping_bg", 0, 0, 30, 22, {
        margins = { nil, 16, 16, nil },
        sprite = {
            name = "tc:ping_bg"
        }
    }))
    panelItem:addChild(UIUtil.createImage("img_ping_green", 0, 0, 30, 22, {
        margins = { nil, 16, 16, nil },
        sprite = {
            name = "tc:ping_green"
        }
    }))
    panelItem:addChild(UIUtil.createLabel("lb_players", "114/1000",
            96, 16, 30, 24,
            TextAlignment.Right, TextAlignment.VCenter, {
                margins = { nil, 16, 60, nil },
                color = Color.FrenchGray
            }))

    panelItem:addChild(UIUtil.createButtonWithImage("btn_remove", "tc:delete",
            700, 0, 48, 48, {
                margins = { nil, nil, 16, 8 },
                targetSprite = { color = Color.new(110, 108, 132, 255) }
            }, {
                sprite = { color = Color.new(180, 168, 232, 255) }
            }))
    panelItem:addChild(UIUtil.createButtonWithImage("btn_cfg", "tc:conf",
            700, 0, 48, 48, {
                margins = { nil, nil, 80, 8 },
                targetSprite = { color = Color.new(110, 108, 132, 255) }
            }, {
                sprite = { color = Color.new(180, 168, 232, 255) }
            }))
    panel:addChild(UIUtil.createButton("btn_back", Locale.BACK, 0, 200, 220, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { 0, nil, UI_SIZE.width * 0.66, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panel:addChild(UIUtil.createButton("btn_create", "添加服务器..", 0, 200, 220, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { 0, nil, 0, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panel:addChild(UIUtil.createButton("btn_ok", "进入服务器", 0, 200, 220, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { UI_SIZE.width * 0.66, nil, 0, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    return root
end

function UIDesign.getNewServerUI()
    local UI_SIZE = Size.new(600, 250)
    local root = UIUtil.createBlackFullScreenLayer("new_list_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, nil)
    panel:addChild(UIUtil.createLabelNoPos("lb_title", "编辑服务器信息",
            TextAlignment.HCenter, TextAlignment.VCenter, {
                positionY = 12,
                marginsLR = { 0, 0 },
                fontSize = UIDefault.FontSize + 8
            }))
    panel:addChild(UIUtil.createLabel("lb_name", "Server Name:",
            0, 60, 180, 48,
            TextAlignment.HCenter, TextAlignment.VCenter, {}))
    local panelName = UIUtil.createPanel("panel_name", 0, 60, 200, 48, {
        marginsLR = { 180, 16 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(60, 60, 85)
        }
    })
    panel:addChild(panelName)
    panelName:addChild(UIUtil.createPanelNoPos("bg", {
        margins = { 2, 2, 2, 2 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(30, 30, 45)
        }
    }))
    local editName = UIInputField.new("edit")
    UIUtil.setMargins(editName, 8, 8, 8, 8)
    panelName:addChild(editName)
    panel:addChild(UIUtil.createLabel("lb_addr", "Server Address:",
            0, 120, 180, 48,
            TextAlignment.HCenter, TextAlignment.VCenter, {}))
    local panelAddr = UIUtil.createPanel("lb_addr", 0, 120, 200, 48, {
        marginsLR = { 180, 16 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(60, 60, 85)
        }
    })
    panel:addChild(panelAddr)
    panelAddr:addChild(UIUtil.createPanelNoPos("bg", {
        margins = { 2, 2, 2, 2 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(30, 30, 45)
        }
    }))
    local editAddr = UIInputField.new("edit")
    UIUtil.setMargins(editAddr, 8, 8, 8, 8)
    panelAddr:addChild(editAddr)

    panel:addChild(UIUtil.createButton("btn_back", "Cancel", 0, 200, 250, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { 0, nil, UI_SIZE.width * 0.5, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panel:addChild(UIUtil.createButton("btn_ok", "Done", 0, 200, 250, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { UI_SIZE.width * 0.5, nil, 0, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    return root
end

function UIDesign.getSettingUI()
    local UI_SIZE = Size.new(800, 450)
    local root = UIUtil.createBlackFullScreenLayer("setting_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, nil)
    panel:addChild(UIUtil.createLabelNoPos("lb_title", Locale.SETTING_PANEL,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                positionY = 12,
                marginsLR = { 32, 60 },
                fontSize = UIDefault.FontSize + 8
            }
    ))
    local panelList = UIUtil.createScrollView("panel_list", 0, 0, 200, 32, {
        margins = { 16, 64, nil, 80 }
    })
    panel:addChild(panelList)

    local panelItem = UIPanel.new("panel_item", 0, 0, panelList.size.width, 48)
    panelList:addChild(panelItem)

    panelItem:addChild(UIUtil.createImageNoPos("img_selected", {
        margins = { 0, 0, 0, 0 },
        touchable = false,
        visible = true,
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(48, 48, 60, 222)
        }
    }))
    panelItem:addChild(UIUtil.createImage("lb_group_pic", 8, 8, 32, 32, {
        sprite = { name = "tc:conf" }
    }))
    panelItem:addChild(UIUtil.createLabel("lb_group_name", Locale.SOUND,
            48, 16, 128, 24,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                marginsTB = { 0, 0, false }
            })
    )
    local infoList = UIUtil.createScrollView("info_list", 0, 0, 300, 32, {
        margins = { 232, 64, 16, 80 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(48, 48, 60, 160)
        }
    })
    panel:addChild(infoList)

    local panelHold = UIUtil.createPanel("panel_hold", 0, 0, 32, 300, {
        marginsLR = { 0, 0 }
    })
    infoList:addChild(panelHold)

    local panelSlider = UIUtil.createPanel("panel_slider", 0, 0, 32, 100, {
        marginsLR = { 0, 0 }
    })
    infoList:addChild(panelSlider)
    panelSlider:addChild(UIUtil.createLabel("lb_title", "Value - 50%", 16, 16, 32, 32,
            TextAlignment.Left, TextAlignment.VCenter))
    panelSlider:addChild(UIUtil.createSlider("slider", 0, 56, 100, 32, {
        marginsLR = { 10, 10 }
    }))
    panelSlider:addChild(UIUtil.createImage("img_line", 0, 0, 32, 2, {
        margins = { 16, nil, 16, 2, true, false },
        sprite = {
            name = "tc:white",
            color = Color.new(20, 20, 30)
        }
    }))

    local panelBool = UIUtil.createPanel("panel_bool", 0, 0, 32, 64, {
        marginsLR = { 0, 0 }
    })
    infoList:addChild(panelBool)
    panelBool:addChild(UIUtil.createLabel("lb_title", "Boolean Value", 16, 16, 32, 32,
            TextAlignment.Left, TextAlignment.VCenter))
    panelBool:addChild(UIUtil.createSwitch("sw", 20, 16, 64, 32, {
        marginsLR = { nil, 16 },
        selected = true
    }))
    panelBool:addChild(UIUtil.createImage("img_line", 0, 0, 32, 2, {
        margins = { 16, nil, 16, 2, true, false },
        sprite = {
            name = "tc:white",
            color = Color.new(20, 20, 30)
        }
    }))

    panel:addChild(UIUtil.createButton("btn_ok", Locale.OK, 0, 200, 300, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        targetSprite = {
            color = Color.new(110, 108, 132, 255)
        },
        margins = { 0, nil, 0, 16, false }
    }))
    return root
end

function UIDesign.getInfoPopupUI()
    local UI_SIZE = Size.new(500, 300)
    local root = UIUtil.createBlackFullScreenLayer("info_popup_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, nil)
    panel:addChild(UIUtil.createLabelNoPos("lb_title", Locale.TIPS,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                positionY = 12,
                marginsLR = { 0, 0 },
                fontSize = UIDefault.FontSize + 8
            }))
    local panelInfo = UIUtil.createPanelNoPos("panel_info", {
        margins = { 16, 54, 16, 80 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(28, 28, 40, 222)
        }
    })
    panel:addChild(panelInfo)
    panelInfo:addChild(UIUtil.createPanelNoPos("bg", {
        margins = { 4, 4, 4, 4 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(10, 10, 20, 222)
        }
    }))
    panelInfo:addChild(UIUtil.createLabelNoPos("lb_info", "gGui->OnMapDeleteEvent(event, controlID, pControl, pUserContext); mapDeleteUI->GetLabel(IDC_LABEL_INFO)->SetAlignment(AL_VCENTER | AL_HCENTER);",
            TextAlignment.HCenter, TextAlignment.VCenter, {
                horizontalOverflow = TextHorizontalOverflow.Wrap,
                margins = { 16, 16, 16, 16 },
                color = Color.Yellow
            }))
    panel:addChild(UIUtil.createButton("btn_back", Locale.BACK, 0, 200, 200, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { 0, nil, UI_SIZE.width * 0.5, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panel:addChild(UIUtil.createButton("btn_ok", Locale.OK, 0, 200, 200, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { UI_SIZE.width * 0.5, nil, 0, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    return root
end

function UIDesign.getModListUI()
    local UI_SIZE = Size.new(800, 450)
    local root = UIUtil.createBlackFullScreenLayer("mod_list_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, nil)
    panel:addChild(UIUtil.createLabelNoPos("lb_title", Locale.MOD_LIST,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                positionY = 12,
                marginsLR = { 0, 0 },
                fontSize = UIDefault.FontSize + 8
            }))
    panel:addChild(UIUtil.createButton("btn_back", Locale.BACK, 0, 200, 220, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { 0, nil, UI_SIZE.width * 0.66, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panel:addChild(UIUtil.createButton("btn_mod_folder", Locale.OPEN_MOD_FOLDER, 0, 200, 220, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { 0, nil, 0, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panel:addChild(UIUtil.createButton("btn_mod_sources", Locale.MANAGER_SOURCES, 0, 200, 220, UIDefault.ButtonHeight, {
        anchorPoint = { 0.5, 0 },
        margins = { UI_SIZE.width * 0.66, nil, 0, 16, false, false },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panel:addChild(UIUtil.createLabel("lb_list_title", string.format(Locale.ALL_MOD_LOADED, 0),
            16, 64, 300, 24,
            TextAlignment.Left, TextAlignment.Top, {
                color = Color.Gray
            }))
    local panelList = UIUtil.createScrollView("panel_list", 0, 0, 300, 32, {
        margins = { 16, 96, nil, 80 },
    })
    panel:addChild(panelList)
    local panelItem = UIPanel.new("panel_item", 0, 0, panelList.size.width, 96)
    panelList:addChild(panelItem)
    panelItem:addChild(UIUtil.createImageNoPos("img_selected", {
        margins = { 0, 0, 0, 0 },
        touchable = false,
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(48, 48, 60, 222)
        },
        visible = false
    }))
    panelItem:addChild(UIUtil.createLabel("lb_mod_name", "ModNameHere",
            96, 16, 128, 24,
            TextAlignment.Left, TextAlignment.VCenter))

    panelItem:addChild(UIUtil.createLabel("lb_mod_tip", "the mod tip.. test for auto wrap",
            96, 40, 128, 24,
            TextAlignment.Left, TextAlignment.Top, {
                marginsLR = { 96, 16 },
                fontSize = UIDefault.SmallFontSize,
                color = Color.FrenchGray,
                horizontalOverflow = TextHorizontalOverflow.Wrap
            }))
    panelItem:addChild(UIUtil.createImage("img_mod_pic", 16, 16, 64, 64, {
        sprite = { name = "tc:round_rect_white" }
    }))
    local infoPanelList = UIUtil.createScrollViewNoPos("info_list", {
        margins = { 332, 64, 16, 80 },
    })
    panel:addChild(infoPanelList)
    local panelInfo1 = UIUtil.createPanel("panel_info_1", 0, 0, 32, 96, {
        marginsLR = { 0, 0 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(48, 48, 60, 160)
        }
    })
    infoPanelList:addChild(panelInfo1)
    local panelVersion = UIPanel.new("panel_version", 0, 0, 200, 96)
    panelInfo1:addChild(panelVersion)
    panelVersion:addChild(UIUtil.createLabel("lb_version_title", Locale.MOD_VERSION,
            0, 16, 128, 24,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                marginsLR = { 0, 0 },
                color = Color.Gray
            }))
    panelVersion:addChild(UIUtil.createLabel("lb_version", "1.1.1.1",
            0, 48, 128, 24,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                marginsLR = { 0, 0 },
            }))
    local panelAuthor = UIPanel.new("panel_author", 200, 0, 200, 96)
    panelInfo1:addChild(panelAuthor)
    panelAuthor:addChild(UIUtil.createLabel("lb_author_title", Locale.MOD_AUTHORS,
            0, 16, 128, 24,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                marginsLR = { 0, 0 },
                color = Color.Gray
            }))
    panelAuthor:addChild(UIUtil.createLabel("lb_author", "Super Lazy BlueYoshi",
            0, 48, 128, 24,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                marginsLR = { 0, 0 }
            }))
    local panelInfoWeb = UIUtil.createPanel("panel_info_web", 0, 112, 32, 112, {
        marginsLR = { 0, 0 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(48, 48, 60, 160)
        }
    })
    infoPanelList:addChild(panelInfoWeb)
    panelInfoWeb:addChild(UIUtil.createLabel("lb_web", Locale.WEB,
            16, 16, 300, 24))
    panelInfoWeb:addChild(UIUtil.createButton("btn_web_1", Locale.WEB, 8, 56, 200, UIDefault.ButtonHeight, {
        marginsLR = { 16, nil },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))
    panelInfoWeb:addChild(UIUtil.createButton("btn_web_2", Locale.WEB, 200, 56, 200, UIDefault.ButtonHeight, {
        marginsLR = { nil, 16 },
        targetSprite = { color = Color.new(110, 108, 132, 255) },
    }))

    local panelInfo2 = UIUtil.createPanel("panel_info_2", 0, 188 + 64, 32, 400, {
        marginsLR = { 0, 0 },
        sprite = {
            name = "tc:round_rect_white",
            color = Color.new(48, 48, 60, 160)
        }
    })
    infoPanelList:addChild(panelInfo2)
    panelInfo2:addChild(UIUtil.createLabel("lb_des_caption", Locale.DESC,
            16, 16, 300, 24))

    panelInfo2:addChild(UIUtil.createLabel("lb_des", "Test Desc",
            16, 48, 300, 24,
            TextAlignment.Left, TextAlignment.Top, {
                marginsLR = { 16, 16 },
                color = Color.FrenchGray,
                horizontalOverflow = TextHorizontalOverflow.Wrap
            }))
    return root
end

function UIDesign.getTipUI()
    local UI_SIZE = Size.new(100, 100)

    local root = UIUtil.createPanel("tip_ui", 0, 0, UI_SIZE.width, UI_SIZE.height, {
        sprite = {
            name = "tc:window_frame_01",
            color = Color.new(255, 255, 255, 200)
        },
        touchable = false
    })

    root:addChild(UIUtil.createLabel("lb_tip", "This is a tip",
            8, 8, 32, 32,
            TextAlignment.Left, TextAlignment.Top, {
                fontSize = UIDefault.SmallFontSize,
                color = Color.new(224, 224, 224, 255),
                isRichText = true,
                autoAdaptSize = true,
            }))

    return root
end

function UIDesign.getHudUI()
    local root = UIUtil.createPanel("hud_ui", 0, 0,
            GameWindow.displayResolution.width, GameWindow.displayResolution.height, {
                margins = { 0, 0, 0, 0, true, true },
                touchable = false
            })

    local panelElementBase = UIUtil.createPanel("panel_element_base", 0, 0, 32, 32)
    root:addChild(panelElementBase)

    root:addChild(UIUtil.createLabel("lb_music_name", "Music:Name", 0, 0, 32, 32,
            TextAlignment.Right, TextAlignment.Top, {
                margins = { nil, nil, 16, 32 },
                fontSize = UIDefault.SmallFontSize,
                color = Color.new(155, 155, 155)
            }
    ))

    root:addChild(UIUtil.createLabel("lb_music_author", "MusicAuthor", 0, 0, 32, 32,
            TextAlignment.Right, TextAlignment.Top, {
                margins = { nil, nil, 16, 8 },
                fontSize = UIDefault.SmallFontSize,
                color = Color.new(100, 100, 100)
            }
    ))

    local joystickCenter = UIJoystick.new("joystick_center")
    joystickCenter:setSize(300, 300)
    --joystickCenter.backSprite = UISpritePool:get("tc:joystick_base")
    --joystickCenter.frontSprite = UISpritePool:get("tc:joystick_controlled_aim")
    UIUtil.setMargins(joystickCenter, 0, 0, 0, 0, false, false)
    joystickCenter.controlRadius = 96
    root:addChild(joystickCenter)

    local joystickLeft = UIJoystick.new("joystick_left")
    joystickLeft:setSize(250, 250)
    joystickLeft.backSprite = UISpritePool:get("tc:joystick_base")
    joystickLeft.frontSprite = UISpritePool:get("tc:joystick_controlled")
    joystickLeft.leftMarginEnabled = true
    joystickLeft.bottomMarginEnabled = true
    joystickLeft.controlRadius = 64
    joystickLeft.backSprite.color = Color.new(255, 255, 255, 128)
    joystickLeft.frontSprite.color = Color.new(255, 255, 255, 128)
    root:addChild(joystickLeft)

    local joystickRight = UIJoystick.new("joystick_right")
    joystickRight:setSize(250, 250)
    joystickRight.backSprite = UISpritePool:get("tc:joystick_base")
    joystickRight.frontSprite = UISpritePool:get("tc:joystick_controlled_aim")
    joystickRight.rightMarginEnabled = true
    joystickRight.bottomMarginEnabled = true
    joystickRight.controlRadius = 96
    joystickRight.backSprite.color = Color.new(255, 255, 255, 128)
    joystickRight.frontSprite.color = Color.new(255, 255, 255, 128)
    root:addChild(joystickRight)

    local panelBtn = UIUtil.createPanel("panel_btn", 0, 0, 54 * 6, 48, {
        margins = { 0, 8, 0, nil, false, false },
        anchorPoint = { 0.5, 0 },
    })
    root:addChild(panelBtn)

    ---_setBtn
    ---@param btn UIButton
    local function _setBtn(btn, spriteName)
        local sprite = UISpritePool:get(spriteName)
        local color = Color.new(255, 255, 255, 200)
        btn.targetSprite = sprite
        btn.targetSprite.color = color
        btn.selectedSprite = sprite
        btn.selectedSprite.color = color
        btn.pressedSprite = sprite
        btn.pressedSprite.color = color
        btn.highlightedSprite = sprite
        btn.highlightedSprite.color = color
    end

    local check_box_front_or_wall = UIUtil.createButton("check_box_front_or_wall", "", 0, 0, 48, 48)
    _setBtn(check_box_front_or_wall, "tc:check_box_front_or_wall")
    panelBtn:addChild(check_box_front_or_wall)

    local check_box_smart = UIUtil.createButton("check_box_smart", "", 54 * 1, 0, 48, 48)
    _setBtn(check_box_smart, "tc:check_box_smart")
    panelBtn:addChild(check_box_smart)

    local button_recipe = UIUtil.createButton("button_recipe", "", 54 * 2, 0, 48, 48)
    _setBtn(button_recipe, "tc:button_recipe")
    panelBtn:addChild(button_recipe)

    local button_task = UIUtil.createButton("button_task", "", 54 * 3, 0, 48, 48)
    _setBtn(button_task, "tc:button_task")
    panelBtn:addChild(button_task)

    local btnBackpack = UIUtil.createButton("button_backpack", "", 54 * 4, 0, 48, 48)
    _setBtn(btnBackpack, "tc:button_backpack")
    panelBtn:addChild(btnBackpack)

    local btnOption = UIUtil.createButton("button_option", "", 54 * 5, 0, 48, 48)
    _setBtn(btnOption, "tc:button_option")
    panelBtn:addChild(btnOption)

    root:addChild(UIUtil.createLabel("lb_debug", "<c=#9c9c9cFF>FPS</c>", 32, 200, 32, 32))
    root:addChild(UIUtil.createLabel("lb_hp", "<c=#9c9c9cFF>114/514</c>", 32, 128, 32, 32))
    root:addChild(UIUtil.createLabel("lb_mana", "<c=#9c9c9cFF>114/514</c>", 32, 128, 32, 32))

    local panelShortcut = UIUtil.createPanel("panel_shortcut", 0, 0, 56 * 10, 56, {
        margins = { 0, nil, 0, 0, false, false },
        anchorPoint = { 0.5, 0 },
    })
    root:addChild(panelShortcut)

    -- 0-9: shortcut slots
    for i = 0, 9 do
        panelShortcut:addChild(UIUtil.createSlotStyle("slot",
                i * 56, 0, 56, 56, 2), i)
    end
    panelShortcut:addChild(UIUtil.createLabel("lb_exp", "<c=#FFFF00FF>114514</c>",
            0, -38, 32, 32,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                margins = { 0, nil, 0, nil, false, false },
                isRichText = true,
                fontSize = UIDefault.SmallFontSize,
            }
    ))
    panelShortcut:addChild(UIUtil.createLabel("lb_item_name", "Test Item Name",
            0, -68, 32, 32,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                margins = { 0, nil, 0, nil, false, false },
            }
    ))

    -- advancement tips
    local panelAdvancements = UIUtil.createPanel("panel_advancements", 0, 0, 32, 32, {
        margins = { nil, 0, 0, nil },
        touchable = false
    })
    root:addChild(panelAdvancements)

    local ADVANCEMENT_TIP_SIZE = Size.new(400, 80)

    local panelAdvancementTip = UIUtil.createPanel("panel_advancement_tip", 0, 0,
            ADVANCEMENT_TIP_SIZE.width, ADVANCEMENT_TIP_SIZE.height, {
                margins = { nil, 0, 0, nil },
                sprite = {
                    name = "tc:advance_tip",
                    color = Color.new(200, 200, 200, 255)
                },
                touchable = false,
                visible = false,
            })
    panelAdvancements:addChild(panelAdvancementTip)

    panelAdvancementTip:addChild(UIUtil.createPanel("panel_icon",
            8, 8, 64, 64))

    panelAdvancementTip:addChild(UIUtil.createLabel("lb_caption", Locale.GET_ADVANCEMENT,
            72, 8, 32, 32,
            TextAlignment.Left, TextAlignment.VCenter, {
                fontSize = UIDefault.FontSize,
                color = Color.new(240, 240, 0, 255),
                isRichText = true,
            }))

    panelAdvancementTip:addChild(UIUtil.createLabel("lb_sub_caption", "",
            72, 40, 32, 32,
            TextAlignment.Left, TextAlignment.VCenter, {
                fontSize = UIDefault.FontSize,
                color = Color.new(224, 224, 224, 255),
                isRichText = true,
            }))

    return root
end

function UIDesign.getItemListUI()
end

function UIDesign.getAdvancementUI()
    local root = UIUtil.createBlackFullScreenLayer("advancement_ui")

    local panelScroll = UIUtil.createScrollViewNoPos("scroll", {
        margins = { 0, 0, 0, 0, true, true }
    })
    root:addChild(panelScroll)
    local panel = UIUtil.createPanel("panel", 0, 0, 300, 300)
    panelScroll:addChild(panel)

    root:addChild(UIUtil.createButton("btn_ok", Locale.BACK, 0, 0, 200, UIDefault.ButtonHeight, {
        margins = { 0, nil, 0, 32, false, false }
    }))

    return root
end

function UIDesign.getBackpackUI()

    local UI_SIZE = Size.new(512, 468)
    local root = UIUtil.createBlackFullScreenLayer("backpack_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, {
        style = "Gray",
    })
    -- Equipment
    panel:addChild(UIUtil.createLabel("lb_equipment", Locale.EQUIPMENT,
            16, 8, 32, 32,
            TextAlignment.Left, TextAlignment.VCenter, {
                fontSize = UIDefault.SmallFontSize,
                color = Color.Gray
            }))
    -- Appearance
    panel:addChild(UIUtil.createLabel("lb_appearance", Locale.APPEAR_ACCESSORY,
            236, 8, 32, 32,
            TextAlignment.Right, TextAlignment.VCenter, {
                fontSize = UIDefault.SmallFontSize,
                color = Color.Gray
            }))
    -- Crafting
    panel:addChild(UIUtil.createLabel("lb_crafting", Locale.CRAFT,
            286, 32, 32, 32,
            TextAlignment.Left, TextAlignment.VCenter, {
                fontSize = UIDefault.SmallFontSize,
                color = Color.Gray
            }))

    local inventoryStartY = UI_SIZE.height - 268
    local statusStartY = 42

    panel:addChild(UIUtil.createPanel("panel_status", 68, statusStartY,
            100, 142, {
                sprite = {
                    name = "tc:base2",
                    color = Color.new(188, 188, 188, 200)
                }
            }))

    panel:addChild(UIUtil.createImage("img_craft_arrow", 393, 103, 32, 24, {
        sprite = {
            name = "tc:arrow3",
            color = Color.new(100, 100, 100, 188)
        }
    }))

    -- 0-9: shortcut slots
    for i = 0, 9 do
        panel:addChild(UIUtil.createSlot("slot",
                16 + i * UIDefault.CellOffset, inventoryStartY + 204), i)
    end

    -- 10-49: inner backpack slots
    for i = 0, 39 do
        panel:addChild(UIUtil.createSlot("slot",
                16 + math.fmod(i, 10) * UIDefault.CellOffset,
                inventoryStartY + math.floor(i / 10) * UIDefault.CellOffset), 10 + i)
    end

    local dressIconNames = { "tc:helmet", "tc:chestplate", "tc:leggings" }

    -- 50-52: equipment slots
    for i = 0, 2 do
        panel:addChild(UIUtil.createSlot("slot",
                16, statusStartY + i * UIDefault.CellOffset,
                UIDefault.CellSize, UIDefault.CellSize, dressIconNames[i + 1]
        ), 50 + i)
    end

    -- 53-55: appearance slots
    for i = 0, 2 do
        panel:addChild(UIUtil.createSlot("slot",
                174, statusStartY + i * UIDefault.CellOffset,
                UIDefault.CellSize, UIDefault.CellSize, dressIconNames[i + 1]
        ), 53 + i)
    end

    -- 56-64: crafting input slots, only display 4 slots
    local displays = { [0] = true, [1] = true, [3] = true, [4] = true }
    for i = 0, 8 do
        local c = UIUtil.createSlot("slot",
                286 + math.fmod(i, 3) * UIDefault.CellOffset,
                statusStartY + UIDefault.CellOffset / 3 + math.floor(i / 3) * UIDefault.CellOffset)
        c.visible = displays[i] ~= nil and true or false
        panel:addChild(c, 56 + i)
    end

    -- 65: crafting result slots
    panel:addChild(UIUtil.createSlot("slot",
            436, statusStartY + UIDefault.CellOffset,
            UIDefault.CellSize, UIDefault.CellSize, "tc:hammer"), 65)

    -- 66-68: accessory slots
    for i = 0, 2 do
        panel:addChild(UIUtil.createSlot("slot",
                222, statusStartY + i * UIDefault.CellOffset,
                UIDefault.CellSize, UIDefault.CellSize
        ), 66 + i)
    end

    -- 69: drop slots
    panel:addChild(UIUtil.createSlot("slot",
            UI_SIZE.width + 16, UI_SIZE.height - 154,
            UIDefault.CellSize, UIDefault.CellSize, "tc:trash"), 69)

    panel:addChild(UIUtil.createButtonWithImage("btn_recipe", "tc:recipe_book",
            UI_SIZE.width + 16, UI_SIZE.height - UIDefault.ButtonHeight, UIDefault.ButtonHeight, UIDefault.ButtonHeight, {
                targetSprite = {
                    color = Color.new(128, 128, 128)
                }
            }))

    panel:addChild(UIUtil.createButtonWithImage("btn_sort", "tc:sort",
            UI_SIZE.width + 16, UI_SIZE.height - UIDefault.ButtonHeight - 54, UIDefault.ButtonHeight, UIDefault.ButtonHeight, {
                targetSprite = {
                    color = Color.new(128, 128, 128)
                }
            }))

    return root
end

function UIDesign.getRecipeBookUI()
    local UI_SIZE = Size.new(372, 468)
    local panel = UIUtil.createWindowPattern(nil, UI_SIZE, {
        style = "Gray",
    })

    local panelList = UIUtil.createScrollView("panel_list", 0, 0, 336, 32, {
        margins = { 0, 16, 0, 16, false, true },
    })
    panelList.isScrollHorizontal = false
    panelList.isScrollVertical = true
    panel:addChild(panelList)

    local panelItem = UIUtil.createSlotStyle("panel_item", 0, 0,
            UIDefault.CellHugeSize, UIDefault.CellHugeSize, 4)
    panelList:addChild(panelItem)

    return panel
end

function UIDesign.getNeiUI()

    local UI_SIZE = Size.new(622, 380)
    local UI_LIST_WIDTH = UIDefault.CellSize * 6
    local TAB_SIZE = 54
    local root = UIUtil.createBlackFullScreenLayer("nei_ui")
    local infoPanel = UIUtil.createWindowPattern(root, UI_SIZE, {
        style = "Gray",
    })
    UIUtil.setMargins(infoPanel, 0, 0, UI_LIST_WIDTH, 0, false, false)

    local panelSearch = UIUtil.createPanel("panel_search", 0, 0, UI_LIST_WIDTH, 32, {
        margins = { nil, 8, 8, 8, false, true }
    })
    root:addChild(panelSearch)

    local panelCells = UIUtil.createPanel("panel_cells", 0, 0, 32, 32, {
        margins = { 0, 64, 0, 32, true, true }
    })
    panelSearch:addChild(panelCells)

    panelSearch:addChild(UIUtil.createLabel("lb_page", "114/514",
            0, 0, UI_LIST_WIDTH, 48,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                fontSize = UIDefault.FontSize,
            }))

    panelSearch:addChild(UIUtil.createButtonWithImage("btn_prev", "tc:arrow1",
            0, 0, 48, 48, {
                targetSprite = {
                    color = Color.new(128, 128, 128)
                }
            }))

    panelSearch:addChild(UIUtil.createButtonWithImage("btn_next", "tc:arrow2",
            UI_LIST_WIDTH - 48, 0, 48, 48, {
                targetSprite = {
                    color = Color.new(128, 128, 128)
                }
            }))

    root:addChild(UIUtil.createButton("btn_search_mode", Locale.SEARCH_FROM_OUTPUT,
            8, 8, 160, 48, {
                margins = { nil, nil, UI_LIST_WIDTH + 32, 8 },
                targetSprite = {
                    color = Color.new(128, 128, 128)
                }
            }))

    root:addChild(UIUtil.createButton("btn_back_history", Locale.PRE_ITEM,
            8, 8, 160, 48, {
                margins = { nil, nil, UI_LIST_WIDTH + 32, nil },
                targetSprite = {
                    color = Color.new(128, 128, 128)
                }
            }))

    local panelCell = UIUtil.createPanel("panel_cell", 0, 0, UIDefault.CellSize, UIDefault.CellSize, {
        sprite = {
            name = "tc:white",
            color = Color.new(100, 100, 100, 100)
        }
    })
    panelSearch:addChild(panelCell)

    local panelTabs = UIUtil.createPanel("panel_tabs", 16, -TAB_SIZE + 7, TAB_SIZE, TAB_SIZE)
    infoPanel:addChild(panelTabs)

    local panelTab = UIUtil.createPanel("panel_tab", 16, -TAB_SIZE + 7, TAB_SIZE, TAB_SIZE, {
        sprite = {
            name = "tc:tab_clicked",
        }
    })
    infoPanel:addChild(panelTab)

    local panelPositionDetail = UIUtil.createPanel("panel_position_detail", 0, 0, 360 - 16, 32, {
        margins = { nil, 16, 8, 16, false, true }
    })
    infoPanel:addChild(panelPositionDetail)

    panelPositionDetail:addChild(UIUtil.createPanel("panel_detail", 0, 0, 344, 300, {
        margins = { 0, 0, 0, 0, false, false }
    }))

    infoPanel:addChild(UIUtil.createLabel("lb_recipe_name", "",
            0, 0, 32, 32, TextAlignment.HCenter, TextAlignment.VCenter, {
                margins = { 0, 8, 360, nil, true, false }
            }))

    local panelList = UIUtil.createScrollView("panel_list", 0, 0, 32, 32, {
        margins = { 16, 40, 360, 16, true, true },
        sprite = {
            name = "tc:base_list_cell",
        }
    })
    infoPanel:addChild(panelList)

    local panelItem = UIUtil.createPanel("panel_item", 0, 0, 32, 32, {
        sprite = {
            name = "tc:base_list_cell",
        }
    })
    panelList:addChild(panelItem)

    local panelPreviewCell = UIUtil.createPanel("panel_preview_cell", 0, 0, UIDefault.CellSize, UIDefault.CellSize, {
        sprite = {
            name = "tc:white",
            color = Color.new(100, 100, 100, 0)
        }
    })
    panelItem:addChild(panelPreviewCell)
    panelItem:addChild(UIUtil.createPanel("img_arrow", 0, 0, 32, 24, {
        sprite = {
            name = "tc:arrow3",
            color = Color.Gray
        },
        touchable = false,
    }))

    return root
end

function UIDesign.generateBackpackPattern(panel, UI_SIZE)
    panel:addChild(UIUtil.createLabel("lb_inventory", Locale.INVENTORY,
            16, 170, 32, 32,
            TextAlignment.Left, TextAlignment.VCenter, {
                fontSize = UIDefault.SmallFontSize,
                color = Color.Gray
            }))

    local inventoryStartY = UI_SIZE.height - 268

    -- 0-9: shortcut slots
    for i = 0, 9 do
        panel:addChild(UIUtil.createSlot("slot",
                16 + i * UIDefault.CellOffset, inventoryStartY + 204), i)
    end

    -- 10-49: inner backpack slots
    for i = 0, 39 do
        panel:addChild(UIUtil.createSlot("slot",
                16 + math.fmod(i, 10) * UIDefault.CellOffset,
                inventoryStartY + math.floor(i / 10) * UIDefault.CellOffset), 10 + i)
    end
end

function UIDesign.getCraft3xUI()

    local UI_SIZE = Size.new(512, 468)
    local root = UIUtil.createBlackFullScreenLayer("craft3x_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, {
        style = "Gray",
    })
    panel:addChild(UIUtil.createLabel("lb_title", Locale.CRAFT,
            100, 8, 32, 32,
            TextAlignment.Left, TextAlignment.VCenter, {
                fontSize = UIDefault.SmallFontSize,
                color = Color.Gray
            }))

    UIDesign.generateBackpackPattern(panel, UI_SIZE)

    local offsetX = 100
    local offsetY = 38

    -- 50-58: input
    for i = 0, 8 do
        panel:addChild(UIUtil.createSlot("slot_input",
                offsetX + UIDefault.CellSize * (i % 3),
                offsetY + UIDefault.CellSize * math.floor(i / 3),
                UIDefault.CellSize, UIDefault.CellSize), 50 + i)
    end

    -- 59: output
    panel:addChild(UIUtil.createSlot("slot_output",
            offsetX + 240,
            offsetY + UIDefault.CellSize * 1.5 - UIDefault.CellLargeSize * 0.5,
            UIDefault.CellLargeSize, UIDefault.CellLargeSize), 50 + 9)

    panel:addChild(UIUtil.createImage("img_arrow", offsetX + 170, offsetY + 56, 40, 32, {
        sprite = {
            name = "tc:arrow4",
            color = Color.new(100, 100, 100),
        }
    }))

    panel:addChild(UIUtil.createButtonWithImage("btn_recipe", "tc:recipe_book",
            UI_SIZE.width + 16, UI_SIZE.height - UIDefault.ButtonHeight, UIDefault.ButtonHeight, UIDefault.ButtonHeight, {
                targetSprite = {
                    color = Color.new(128, 128, 128)
                }
            }))

    return root
end

function UIDesign.getSmeltUI()

    local UI_SIZE = Size.new(512, 468)
    local root = UIUtil.createBlackFullScreenLayer("smelt_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, {
        style = "Gray",
    })
    panel:addChild(UIUtil.createLabel("lb_title", Locale.FURNACE,
            240, 8, 32, 32,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                fontSize = UIDefault.SmallFontSize,
                color = Color.Gray
            }))

    UIDesign.generateBackpackPattern(panel, UI_SIZE)

    local offsetX = 160
    local offsetY = 38

    -- 50: input  51: fuel  52: output  53: back
    panel:addChild(UIUtil.createSlot("slot_input",
            offsetX, offsetY, UIDefault.CellSize, UIDefault.CellSize), 50)

    panel:addChild(UIUtil.createSlot("slot_fuel",
            offsetX, offsetY + 88, UIDefault.CellSize, UIDefault.CellSize, "tc:fire"), 51)

    panel:addChild(UIUtil.createSlot("slot_output",
            offsetX + 150, offsetY + 40, UIDefault.CellLargeSize, UIDefault.CellLargeSize), 52)

    panel:addChild(UIUtil.createSlot("slot_back",
            offsetX - 60, offsetY + 88, UIDefault.CellSize, UIDefault.CellSize, "tc:fuel_return"), 53)

    panel:addChild(UIUtil.createImage("img_cook",
            offsetX + 80, offsetY + 52, 40, 32, {
                sprite = {
                    name = "tc:process_00",
                }
            }))

    panel:addChild(UIUtil.createImage("img_burn",
            offsetX + 8, offsetY + 52, 30, 30, {
                sprite = {
                    name = "tc:burn_00"
                }
            }))

    panel:addChild(UIUtil.createButtonWithImage("btn_recipe", "tc:recipe_book",
            UI_SIZE.width + 16, UI_SIZE.height - UIDefault.ButtonHeight, UIDefault.ButtonHeight, UIDefault.ButtonHeight, {
                targetSprite = {
                    color = Color.new(128, 128, 128)
                }
            }))

    return root
end

function UIDesign.getEnchantmentUI()
    local UI_SIZE = Size.new(512, 468)
    local root = UIUtil.createBlackFullScreenLayer("enchantment_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, {
        style = "Gray",
    })
    panel:addChild(UIUtil.createLabel("lb_title", Locale.ENCHANT,
            60, 8, 32, 32,
            TextAlignment.Left, TextAlignment.VCenter, {
                fontSize = UIDefault.SmallFontSize,
                color = Color.Gray
            }))

    UIDesign.generateBackpackPattern(panel, UI_SIZE)

    -- 50-51: tool, lapis
    panel:addChild(UIUtil.createSlot("slot_tool",
            60,
            42,
            UIDefault.CellLargeSize, UIDefault.CellLargeSize, "tc:hammer"), 50)

    panel:addChild(UIUtil.createSlot("slot_lapis",
            65,
            120,
            UIDefault.CellSize, UIDefault.CellSize, "tc:lapis_lazuli_gray"), 51)

    local BTN_X, BTN_Y = 160, 30
    local BTN_WIDTH, BTN_HEIGHT = 336, 48

    for i = 1, 3 do
        local panelBtn = UIUtil.createPanel(string.format("panel_btn_%d", i),
                BTN_X, BTN_Y + (i - 1) * BTN_HEIGHT, BTN_WIDTH, BTN_HEIGHT, {
                    sprite = {
                        name = "tc:base_list_cell_highlight_2",
                    }
                })
        panel:addChild(panelBtn)

        panelBtn:addChild(UIUtil.createImage("img_exp",
                12, 8, 32, 32, {
                    sprite = {
                        name = string.format("tc:enchantment_exp_%d", i),
                    },
                    touchable = false
                }))

        panelBtn:addChild(UIUtil.createLabel("lb_cost", "3",
                40, 8, 32, 32, TextAlignment.Left, TextAlignment.VCenter, {
                    color = Color.Yellow
                }
        ))

        panelBtn:addChild(UIUtil.createLabel("lb_exp", "30",
                290, 8, 32, 32, TextAlignment.Right, TextAlignment.VCenter, {
                    color = Color.Yellow
                }
        ))

        panelBtn:addChild(UIUtil.createLabel("lb_preview", "精准采集IV ...",
                160, 8, 32, 32, TextAlignment.HCenter, TextAlignment.VCenter, {
                    color = Color.Gray
                }
        ))

    end

    return root
end

function UIDesign.getRepairUI()
    local UI_SIZE = Size.new(512, 468)
    local root = UIUtil.createBlackFullScreenLayer("repair_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, {
        style = "Gray",
    })
    panel:addChild(UIUtil.createLabel("lb_title", Locale.REPAIR,
            240, 8, 32, 32,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                fontSize = UIDefault.FontSize,
                color = Color.Gray
            }))

    UIDesign.generateBackpackPattern(panel, UI_SIZE)

    local offsetX, offsetY = 100, 90

    -- 50-52: tool, source, output
    panel:addChild(UIUtil.createSlot("slot_tool",
            offsetX + 0,
            offsetY + 0,
            UIDefault.CellSize, UIDefault.CellSize, "tc:hammer"), 50)

    panel:addChild(UIUtil.createSlot("slot_source",
            offsetX + 120,
            offsetY + 0,
            UIDefault.CellSize, UIDefault.CellSize, "tc:ingot_gray"), 51)

    panel:addChild(UIUtil.createSlot("slot_output",
            offsetX + 250,
            offsetY - 5,
            UIDefault.CellLargeSize, UIDefault.CellLargeSize, "tc:hammer"), 52)

    panel:addChild(UIUtil.createLabel("lb_exp", "附魔消耗:22",
            offsetX + 130, offsetY + 54, 32, 32, TextAlignment.HCenter, TextAlignment.VCenter, {
                color = Color.Yellow,
                visible = false,
            }
    ))

    panel:addChild(UIUtil.createImage("img_add", offsetX + 68, offsetY + 8, 32, 32, {
        sprite = {
            name = "tc:adding",
        }
    }))

    panel:addChild(UIUtil.createImage("img_process", offsetX + 190, offsetY + 8, 40, 32, {
        sprite = {
            name = "tc:process_00",
        }
    }))

    panel:addChild(UIUtil.createButtonWithImage("btn_recipe", "tc:recipe_book",
            UI_SIZE.width + 16, UI_SIZE.height - UIDefault.ButtonHeight, UIDefault.ButtonHeight, UIDefault.ButtonHeight, {
                targetSprite = {
                    color = Color.new(128, 128, 128)
                }
            }))

    return root
end

function UIDesign.getBrewingUI()

    local UI_SIZE = Size.new(512, 468)
    local root = UIUtil.createBlackFullScreenLayer("brewing_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, {
        style = "Gray",
    })
    panel:addChild(UIUtil.createLabel("lb_title", Locale.BREWING_STAND,
            240, 8, 32, 32,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                fontSize = UIDefault.SmallFontSize,
                color = Color.Gray
            }))

    UIDesign.generateBackpackPattern(panel, UI_SIZE)

    local offsetX = 240
    local offsetY = 38

    panel:addChild(UIUtil.createImage("img_tube", offsetX, offsetY + 52, 30, 30, {
        sprite = {
            name = "tc:tube"
        }
    }))

    panel:addChild(UIUtil.createImage("img_process", offsetX + 38, offsetY + 12, 24, 80, {
        sprite = {
            name = "tc:brewing_process_00",
        }
    }))

    panel:addChild(UIUtil.createImage("img_bubble", offsetX - 48, offsetY + 4, 40, 64, {
        sprite = {
            name = "tc:brewing_bubble_00"
        }
    }))

    panel:addChild(UIUtil.createImage("img_fuel", offsetX - 48, offsetY + 70, 40, 12, {
        sprite = {
            name = "tc:brewing_fuel_00"
        }
    }))

    -- 50: potion  51: source  52: output  53: fuel
    panel:addChild(UIUtil.createSlot("slot_potion",
            offsetX - 82, offsetY + 88, UIDefault.CellSize, UIDefault.CellSize, "tc:glass_bottle"), 50)

    panel:addChild(UIUtil.createSlot("slot_input",
            offsetX - 8, offsetY, UIDefault.CellSize, UIDefault.CellSize), 51)

    panel:addChild(UIUtil.createSlot("slot_output",
            offsetX + 66, offsetY + 80, UIDefault.CellLargeSize, UIDefault.CellLargeSize, "tc:glass_bottle"), 52)

    panel:addChild(UIUtil.createSlot("slot_fuel",
            offsetX - 100, offsetY, UIDefault.CellSize, UIDefault.CellSize, "tc:blaze_powder"), 53)

    panel:addChild(UIUtil.createButtonWithImage("btn_recipe", "tc:recipe_book",
            UI_SIZE.width + 16, UI_SIZE.height - UIDefault.ButtonHeight, UIDefault.ButtonHeight, UIDefault.ButtonHeight, {
                targetSprite = {
                    color = Color.new(128, 128, 128)
                }
            }))

    return root
end

function UIDesign.getChest30UI()

    local UI_SIZE = Size.new(512, 468)
    local root = UIUtil.createBlackFullScreenLayer("chest30_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, {
        style = "Gray",
    })
    panel:addChild(UIUtil.createLabel("lb_title", Locale.STORAGE,
            16, 4, 32, 32,
            TextAlignment.Left, TextAlignment.VCenter, {
                fontSize = UIDefault.SmallFontSize,
                color = Color.Gray
            }))

    UIDesign.generateBackpackPattern(panel, UI_SIZE)

    local offsetX = 240
    local offsetY = 34

    for i = 0, 29 do
        panel:addChild(UIUtil.createSlot("slot",
                16 + math.fmod(i, 10) * UIDefault.CellOffset,
                offsetY + math.floor(i / 10) * UIDefault.CellOffset), 50 + i)
    end

    local btnOffsetY = 76
    panel:addChild(UIUtil.createButton("btn_sort", Locale.ARRANGE,
            528, btnOffsetY, 160, UIDefault.ButtonHeight))
    panel:addChild(UIUtil.createButton("btn_quick_pick", Locale.QUICK_PICK,
            528, btnOffsetY + UIDefault.ButtonOffset, 160, UIDefault.ButtonHeight))
    panel:addChild(UIUtil.createButton("btn_quick_push", Locale.QUICK_PUSH,
            528, btnOffsetY + UIDefault.ButtonOffset * 2, 160, UIDefault.ButtonHeight))
    panel:addChild(UIUtil.createButton("btn_quick_stack", Locale.QUICK_STACK,
            528, btnOffsetY + UIDefault.ButtonOffset * 3, 160, UIDefault.ButtonHeight))

    return root
end

function UIDesign.getShooter9UI()

    local UI_SIZE = Size.new(512, 468)
    local root = UIUtil.createBlackFullScreenLayer("shooter9_ui")
    local panel = UIUtil.createWindowPattern(root, UI_SIZE, {
        style = "Gray",
    })
    panel:addChild(UIUtil.createLabel("lb_title", Locale.STORAGE,
            16, 4, 32, 32,
            TextAlignment.Left, TextAlignment.VCenter, {
                fontSize = UIDefault.SmallFontSize,
                color = Color.Gray
            }))

    UIDesign.generateBackpackPattern(panel, UI_SIZE)

    local offsetX = 240
    local offsetY = 34

    for i = 0, 8 do
        panel:addChild(UIUtil.createSlot("slot",
                16 + math.fmod(i, 3) * UIDefault.CellOffset,
                offsetY + math.floor(i / 3) * UIDefault.CellOffset), 50 + i)
    end

    return root
end

function UIDesign.getDeathUI()
    local root = UIUtil.createBlackFullScreenLayer("death_ui")
    local panel = UIUtil.createPanel("panel", 0, 0, 100, 200, {
        margins = { 0, 0, 0, 0, false, false }
    })
    root:addChild(panel)

    panel:addChild(UIUtil.createLabel("lb_title", Locale.YOU_DIED,
            0, 0, 100, 32,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                fontSize = 60,
                color = Color.Red,
            }))

    panel:addChild(UIUtil.createLabel("lb_title_2", "重生中... 3",
            0, 100, 100, 32,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                fontSize = 40,
                color = Color.Red,
            }))

    return root
end

return UIDesign