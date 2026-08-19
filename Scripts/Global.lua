activeGitCommit = "5beb4211d66821f33a4de588e84005d875ac07fb"
setUninteractables = true

-- UTILITY FUNCTIONS
-- Used throughout the various scripts as a general-purpose function.
function gitLink(fileDirectory)
    return "https://raw.githubusercontent.com/Artemis-of-Dust/Princess_and_Knight_TTS/" .. activeGitCommit .. "/" .. fileDirectory
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- Creates a list of all Card objects with all given tags (optional).
-- If a card is inside a Deck, it will first remove it from the Deck (note this removal happens immediately).
function getCardsByTagsGlobal(tagList, excludeTagList)
    local tagList = tagList or {}
    local excludeTagList = excludeTagList or {}
    local foundCards = {}
    for _, obj in ipairs(getObjects()) do
        -- Individual cards
        if obj.type == "Card" then
            local cardValid = true
            for _, tag in pairs(tagList) do
                if obj.hasTag(tag) == false then
                    cardValid = false
                end
            end
            for _, tag in pairs(excludeTagList) do
                if obj.hasTag(tag) then
                    cardValid = false
                end
            end
            if cardValid then
                table.insert(foundCards, obj)
            end
        
        -- Search decks for valid cards contained within
        elseif obj.type == "Deck" then
            for _, card in pairs(obj.getObjects()) do
                local searchValid = true
                
                for _, tag in pairs(tagList) do
                    local foundTag = false
                    for _, cardTag in pairs(card.tags) do
                        if cardTag == tag then
                            foundTag = true
                        end
                    end
                    if foundTag == false then
                        searchValid = false
                    end
                end
                
                for _, tag in pairs(excludeTagList) do
                    for _, cardTag in pairs(card.tags) do
                        if cardTag == tag then
                            searchValid = false
                        end
                    end
                end
                
                if searchValid then
                    local cardObj = obj.remainder
                    if cardObj == nil then
                        cardObj = obj.takeObject({position=obj.getPosition(), guid=card.guid})
                    end
                    
                    table.insert(foundCards, cardObj)
                end
            end
        end
    end
    
    return foundCards
end


-- PREDEFINED DATA
local factionData = {
    {
        name        = "Castione Ducal",
        colour      = {r=237, g=53, b=53},
        playerBoard = gitLink("Boards/Personal_Board_1.webp"),
        deckRow     = 1,
        princessCardTooltipA = [[INSTANT: Choose one of either Socialise, Trade, or Audience and develop the leftmost marker of this track at no cost.]],
        princessCardTooltipB = [[INSTANT: Perform Development.
----------
END GAME: Gain 1 VP for each developed space Level 3 or above. (Maximum 9 points.)]],
        knightCardTooltipA = [[INSTANT: Gain 6 of any resources.]],
        knightCardTooltipB = [[CONTINUOUS: At the start of each turn, you may gain one of the following:
▶ Gain 1 of any resource.
▶ Gain 3 Gold.
▶ Perform Alliance 1.]],
        actionMarkerPrincess   = gitLink("Tokens/LightPrincess_Ticked.png"),
        actionMarkerKnight     = gitLink("Tokens/LightKnight_Ticked.png"),
        relationMarkerPrincess = gitLink("Tokens/Princess1.png"),
        relationMarkerKnight   = gitLink("Tokens/Knight1.png"),
        scoreTile              = gitLink("Tiles/VP_Tiles/VPTile1.png"),
        scoreTileBack          = gitLink("Tiles/VP_Tiles/VPTile1Back.png"),
        affectionTile          = gitLink("Tiles/Affection_Tiles/Affection_Tile_1.webp"),
        affectionTileBack      = gitLink("Tiles/Affection_Tiles/Affection_Tile_1_Back.webp"),
        factionToken           = gitLink("Tokens/FactionMarker_1.png"),
        },
    {
        name        = "Visconti Ducal",
        colour      = {r=48, g=149, b=28},
        deckRow     = 2,
        playerBoard = gitLink("Boards/Personal_Board_2.webp"),
        princessCardTooltipA = [[INSTANT: Increase the Grand Duke's Evaluation by 2.
----------
CONTINUOUS: You are treated as having an additional ☆ in the Grand Duke's Evaluation Track.]],
        princessCardTooltipB = [[CONTINUOUS: When performing Development to develop a space at a Level equal to or lower than the number of ☆ you have in "Grand Duke's Evaluation" plus 1, reduce the cost by 1 of any resource.]],
        knightCardTooltipA = [[INSTANT: Perform Alliance 1 three times.]],
        knightCardTooltipB = [[INSTANT: Perform Workshop and Trading House once each in any order. At this time, you may choose to perform actions of the space where the Wood Pawn is currently placed without moving the Wood Pawn.]],
        actionMarkerPrincess   = gitLink("Tokens/LightPrincess_Ticked.png"),
        actionMarkerKnight     = gitLink("Tokens/LightKnight_Ticked.png"),
        relationMarkerPrincess = gitLink("Tokens/Princess2.png"),
        relationMarkerKnight   = gitLink("Tokens/Knight2.png"),
        scoreTile              = gitLink("Tiles/VP_Tiles/VPTile2.png"),
        scoreTileBack          = gitLink("Tiles/VP_Tiles/VPTile2Back.png"),
        affectionTile          = gitLink("Tiles/Affection_Tiles/Affection_Tile_2.webp"),
        affectionTileBack      = gitLink("Tiles/Affection_Tiles/Affection_Tile_2_Back.webp"),
        factionToken           = gitLink("Tokens/FactionMarker_2.png"),
        },
    {
        name        = "Draug Earl",
        colour      = {r=220, g=220, b=33},
        deckRow     = 3,
        playerBoard = gitLink("Boards/Personal_Board_3.webp"),
        princessCardTooltipA = [[END GAME: From the two Action Cards visible on your Personal Board, among actions that are shown on both cards, choose 1 action from Socialise, Trade, Audience, and 1 action from Workshop, Carriage, and Trading House. Perform these actions in any order.]],
        princessCardTooltipB = [[END GAME: You may spend 5 Gold to perform the Development action. You may repeat this to a maximum of 5 times.]],
        knightCardTooltipA = [[CONTINUOUS: When you gain Princess Affection, also gain 2 Gold. When you gain Knight Affection, also gain 2 Gold.]],
        knightCardTooltipB = [[CONTINUOUS: At the start of each turn, you may replace 1 Action Card on top of your Personal Board with 1 Action Card from your hand.]],
        actionMarkerPrincess   = gitLink("Tokens/LightPrincess_Ticked.png"),
        actionMarkerKnight     = gitLink("Tokens/LightKnight_Ticked.png"),
        relationMarkerPrincess = gitLink("Tokens/Princess3.png"),
        relationMarkerKnight   = gitLink("Tokens/Knight3.png"),
        scoreTile              = gitLink("Tiles/VP_Tiles/VPTile3.png"),
        scoreTileBack          = gitLink("Tiles/VP_Tiles/VPTile3Back.png"),
        affectionTile          = gitLink("Tiles/Affection_Tiles/Affection_Tile_3.webp"),
        affectionTileBack      = gitLink("Tiles/Affection_Tiles/Affection_Tile_3_Back.webp"),
        factionToken           = gitLink("Tokens/FactionMarker_3.png"),
        },
    {
        name        = "Berserk Marquis",
        colour      = {r=228, g=125, b=5},
        deckRow     = 4,
        playerBoard = gitLink("Boards/Personal_Board_4.webp"),
        princessCardTooltipA = [[INSTANT: Perform Supply 5 or perform Supply 2 two times.]],
        princessCardTooltipB = [[CONTINUOUS: When performing the Trade action and choosing spaces for the Supply bonuses, you may choose the bonus of spaces where a wood cube is placed on it.]],
        knightCardTooltipA = [[INSTANT: Look through the Tier 3 Action Deck. Choose any card and add it to your hand (your hand will now have 4 cards). Then, shuffle the deck.]],
        knightCardTooltipB = [[INSTANT: Play an Action Card from your hand onto the Knight Area, performing the Affection Check and executing the action. (From this point on, your hand size will be reduced by one card.)]],
        actionMarkerPrincess   = gitLink("Tokens/LightPrincess_Ticked.png"),
        actionMarkerKnight     = gitLink("Tokens/LightKnight_Ticked.png"),
        relationMarkerPrincess = gitLink("Tokens/Princess4.png"),
        relationMarkerKnight   = gitLink("Tokens/Knight4.png"),
        scoreTile              = gitLink("Tiles/VP_Tiles/VPTile4.png"),
        scoreTileBack          = gitLink("Tiles/VP_Tiles/VPTile4Back.png"),
        affectionTile          = gitLink("Tiles/Affection_Tiles/Affection_Tile_4.webp"),
        affectionTileBack      = gitLink("Tiles/Affection_Tiles/Affection_Tile_4_Back.webp"),
        factionToken           = gitLink("Tokens/FactionMarker_4.png"),
        },
    {
        name        = "Einherjar Viscount",
        colour      = {r=29, g=72, b=174},
        deckRow     = 5,
        playerBoard = gitLink("Boards/Personal_Board_5.webp"),
        princessCardTooltipA = [[INSTANT: Perform the Socialise or Audience action.]],
        princessCardTooltipB = [[CONTINUOUS: When performing the Supply action, add +1 to your supply value.
----------
CONTINUOUS: When performing the Supply action, you may treat this as an additional space with the effect "Increase the Grand Duke's Evaluation by 1."]],
        knightCardTooltipA = [[CONTINUOUS: Allied White Cities are counted as Green Cities for all scoring and effects.]],
        knightCardTooltipB = [[CONTINUOUS: Treat this as having a Wood Cube placed at an additional 1 Red City and 1 Blue City.]],
        actionMarkerPrincess   = gitLink("Tokens/LightPrincess_Ticked.png"),
        actionMarkerKnight     = gitLink("Tokens/LightKnight_Ticked.png"),
        relationMarkerPrincess = gitLink("Tokens/Princess5.png"),
        relationMarkerKnight   = gitLink("Tokens/Knight5.png"),
        scoreTile              = gitLink("Tiles/VP_Tiles/VPTile5.png"),
        scoreTileBack          = gitLink("Tiles/VP_Tiles/VPTile5Back.png"),
        affectionTile          = gitLink("Tiles/Affection_Tiles/Affection_Tile_5.webp"),
        affectionTileBack      = gitLink("Tiles/Affection_Tiles/Affection_Tile_5_Back.webp"),
        factionToken           = gitLink("Tokens/FactionMarker_5.png"),
        },
    {
        name        = "Sforza Archducal",
        colour      = {r=236, g=232, b=210},
        deckRow     = 6,
        playerBoard = gitLink("Boards/Personal_Board_6.webp"),
        princessCardTooltipA = [[CONTINUOUS: When executing Socialise, immediately gain 1 of any resource. If all Socialise spaces have been unlocked, you may choose to advance the "Grand Duke's Evaluation" by 1 instead.]],
        princessCardTooltipB = [[CONTINUOUS: When gaining a bonus from the "Grand Duke's Evaluation Track," gain double the bonus, excluding Victory Points.
----------
CONTINUOUS: When advancing Grand Duke's Evaluation by 1, if the Wood Cube is already placed on the leftmost space of the Grand Duke's Evaluation Track, you may instead gain 1 Popular Support Chip up to once per turn.]],
        knightCardTooltipA = [[INSTANT: Pay 1 of any resource to perform Development. You may repeat this up to a number of times equal to the number of ☆ in "Grand Duke's Evaluation" minus 1.]],
        knightCardTooltipB = [[INSTANT: Look at the Episode Cards not being used in the game, select 1 from among them, and play it at no cost. Return the remaining Episode Cards to the box. (They are not used during the game.)
----------
CONTINUOUS: Your play limit for Episode Cards increases by the number of ☆ you have in the Grand Duke's Evaluation. (Increases by up to 4.)]],
        actionMarkerPrincess   = gitLink("Tokens/LightPrincess_Ticked.png"),
        actionMarkerKnight     = gitLink("Tokens/LightKnight_Ticked.png"),
        relationMarkerPrincess = gitLink("Tokens/Princess6.png"),
        relationMarkerKnight   = gitLink("Tokens/Knight6.png"),
        scoreTile              = gitLink("Tiles/VP_Tiles/VPTile6.png"),
        scoreTileBack          = gitLink("Tiles/VP_Tiles/VPTile6Back.png"),
        affectionTile          = gitLink("Tiles/Affection_Tiles/Affection_Tile_6.webp"),
        affectionTileBack      = gitLink("Tiles/Affection_Tiles/Affection_Tile_6_Back.webp"),
        factionToken           = gitLink("Tokens/Faction_Marker_6.png"),
        },
    {
        name        = "Spartacus Baronet",
        colour      = {r=45, g=45, b=45},
        deckRow     = 7,
        playerBoard = gitLink("Boards/Personal_Board_7.webp"),
        princessCardTooltipA = [[INSTANT: Choose 1 from Socialise, Trade, or Audience and and develop the leftmost marker of this track. During this, you may reduce the cost by any resource for each space you choose to reduce your Grand Duke's Evaluation.]],
        princessCardTooltipB = [[INSTANT: Look at the Personal Manifest Cards not being used in the game, select up to 3 cards to additionally declare, placing them face-up next to your Personal Board. Return the remaining Personal Manifest Cards to the box. (They are not used during the game.)]],
        knightCardTooltipA = [[INSTANT: Choose any 2 different actions from Workshop, Carriage, and Trading House, and perform the actions in any order.]],
        knightCardTooltipB = [[INSTANT: Gain Popular Support Chips equal to double the number of your Wood Cubes placed on the Popular Support Board. (Maximum of 14.)]],
        actionMarkerPrincess   = gitLink("Tokens/DarkPrincess_Ticked.png"),
        actionMarkerKnight     = gitLink("Tokens/DarkKnight_Ticked.png"),
        relationMarkerPrincess = gitLink("Tokens/Princess7.png"),
        relationMarkerKnight   = gitLink("Tokens/Knight7.png"),
        scoreTile              = gitLink("Tiles/VP_Tiles/VPTile7.png"),
        scoreTileBack          = gitLink("Tiles/VP_Tiles/VPTile7Back.png"),
        affectionTile          = gitLink("Tiles/Affection_Tiles/Affection_Tile_7.webp"),
        affectionTileBack      = gitLink("Tiles/Affection_Tiles/Affection_Tile_7_Back.webp"),
        factionToken           = gitLink("Tokens/Faction_Marker_7.png"),
        }
}
local playerData = {
    Red = {
        faction = 1,
        position = {x = -60,   y = 6.48, z = -24},
        mode = 1,
        playerType = "inactive",
        resources = {
            money = 0,
            red = 0,
            green = 0,
            blue = 2,
            },
        cities = {
            white = 0,
            blue = 0,
            green = 0,
            red = 0,
            },
        },
    Green = {
        faction = 2,
        position = {x = -30,   y = 6.48, z = -24},
        mode = 1,
        playerType = "inactive",
        resources = {
            money = 0,
            red = 0,
            green = 0,
            blue = 2,
            },
        cities = {
            white = 0,
            blue = 0,
            green = 0,
            red = 0,
            },
        },
    Yellow = {
        faction = 3,
        position = {x = -0,    y = 6.48, z = -24},
        mode = 1,
        playerType = "inactive",
        resources = {
            money = 0,
            red = 0,
            green = 0,
            blue = 2,
            },
        cities = {
            white = 0,
            blue = 0,
            green = 0,
            red = 0,
            },
        },
    Orange = {
        faction = 4,
        position = {x =  30,   y = 6.48, z = -24},
        mode = 1,
        playerType = "inactive",
        resources = {
            money = 0,
            red = 0,
            green = 0,
            blue = 2,
            },
        cities = {
            white = 0,
            blue = 0,
            green = 0,
            red = 0,
            },
        },
    Blue = {
        faction = 5,
        position = {x =  60,   y = 6.48, z = -24},
        mode = 1,
        playerType = "inactive",
        resources = {
            money = 0,
            red = 0,
            green = 0,
            blue = 2,
            },
        cities = {
            white = 0,
            blue = 0,
            green = 0,
            red = 0,
            },
        },
}
local setupData = {
    auto = true,
    expansion = true,
    character_cards = true,
}
local playerPositions = {
    Red    = {x = -60,   y = 6.48, z = -24},
    Green  = {x = -30,   y = 6.48, z = -24},
    Yellow = {x = -0,    y = 6.48, z = -24},
    Orange = {x =  30,   y = 6.48, z = -24},
    Blue   = {x =  60,   y = 6.48, z = -24},
}
local templateObjects = {
    Deck = {
    GUID = nil,
    Name = "Deck",
    Transform = {
        posX = 0,
        posY = 0,
        posZ = 0,
        rotX = 0,
        rotY = 0,
        rotZ = 0,
        scaleX = 1.65,
        scaleY = 1.65,
        scaleZ = 1.65,
      },
    Nickname     = "",
    Description  = "",
    GMNotes      = "",
    Tags         = {},
    AltLookAngle = {
        x = 0.0,
        y = 0.0,
        z = 0.0
    },
    ColorDiffuse = {
        r = 0.0,
        g = 0.0,
        b = 0.0
    },
    LayoutGroupSortIndex = 0,
    Value        = 0,
    Locked       = false,
    Grid         = true,
    Snap         = true,
    IgnoreFoW    = false,
    MeasureMovement = false,
    DragSelectable = true,
    Autoraise    = true,
    Sticky       = true,
    Tooltip      = true,
    GridProjection = false,
    HideWhenFaceDown = true,
    Hands        = false,
    SidewaysCard = false,
    DeckIDs      = {},
    CustomDeck   = {},
    LuaScript    = "",
    LuaScriptState = "",
    XmlUI        = "",
    ContainedObjects = {},
    AttachedSnapPoints = {},
    },
    Board = {
        GUID           = nil,
        Name           = "Custom_Tile",
        Transform      = {
            posX   = 0,
            posY   = 0,
            posZ   = 0,
            rotX   = 0,
            rotY   = 0,
            rotZ   = 0,
            scaleX = 8.4196,
            scaleY = 1.0,
            scaleZ = 6,
          },
        Nickname       = "",
        Description    = "",
        GMNotes        = "",
        Tags           = {},
        AltLookAngle   = {
            x = 0.0,
            y = 0.0,
            z = 0.0
        },
        ColorDiffuse   = {
            r = 1.0,
            g = 1.0,
            b = 1.0
        },
        LayoutGroupSortIndex = 0,
        Value          = 0,
        Locked         = false,
        Grid           = true,
        Snap           = true,
        IgnoreFoW      = false,
        MeasureMovement  = false,
        DragSelectable = true,
        Autoraise      = true,
        Sticky         = true,
        Tooltip        = true,
        GridProjection = false,
        HideWhenFaceDown  = false,
        Hands          = false,
        CustomImage    = {
            ImageURL          = "",
            ImageSecondaryURL = "",
            ImageScalar       = 1.0,
            WidthScale        = 0.0,
            CustomTile        = {
                Type      = 0,
                Thickness = 0.3,
                Stackable = false,
                Stretch   = false
            }
        },
        LuaScript      = "",
        LuaScriptState = "",
        XmlUI          = "",
        AttachedSnapPoints = {},
        },
    Token = {
        GUID           = nil,
        Name           = "Custom_Model",
        Transform      = {
            posX   = 0,
            posY   = 0,
            posZ   = 0,
            rotX   = 0,
            rotY   = 0,
            rotZ   = 0,
            scaleX = 0.23,
            scaleY = 0.23,
            scaleZ = 0.23,
          },
        Nickname       = "",
        Description    = "",
        GMNotes        = "",
        Tags           = {},
        AltLookAngle   = {
            x = 0.0,
            y = 0.0,
            z = 0.0
        },
        ColorDiffuse   = {
            r = 0.0,
            g = 0.0,
            b = 0.0
        },
        LayoutGroupSortIndex = 0,
        Value          = 0,
        Locked         = false,
        Grid           = true,
        Snap           = true,
        IgnoreFoW      = false,
        MeasureMovement  = false,
        DragSelectable = true,
        Autoraise      = true,
        Sticky         = false,
        Tooltip        = true,
        GridProjection = false,
        HideWhenFaceDown  = false,
        Hands          = false,
        CustomMesh     = {
            MeshURL       = gitLink("Other/marker_rounded_cube.obj"),
            DiffuseURL    = "",
            NormalURL     = "",
            ColliderURL   = gitLink("Other/marker_rounded_cube.obj"),
            Convex        = true,
            MaterialIndex = 0,
            TypeIndex     = 0,
            CastShadows   = true
            },
        LuaScript      = "",
        LuaScriptState = "",
        XmlUI          = "",
        AttachedSnapPoints = {},
        },
    Disc = {
        GUID           = nil,
        Name           = "Custom_Model",
        Transform      = {
            posX   = 0,
            posY   = 0,
            posZ   = 0,
            rotX   = 0,
            rotY   = 0,
            rotZ   = 0,
            scaleX = 0.6,
            scaleY = 0.6,
            scaleZ = 0.6,
          },
        Nickname       = "",
        Description    = "",
        GMNotes        = "",
        Tags           = {},
        AltLookAngle   = {
            x = 0.0,
            y = 0.0,
            z = 0.0
        },
        ColorDiffuse   = {
            r = 0.0,
            g = 0.0,
            b = 0.0
        },
        LayoutGroupSortIndex = 0,
        Value          = 0,
        Locked         = false,
        Grid           = true,
        Snap           = true,
        IgnoreFoW      = false,
        MeasureMovement  = false,
        DragSelectable = true,
        Autoraise      = true,
        Sticky         = false,
        Tooltip        = true,
        GridProjection = false,
        HideWhenFaceDown  = false,
        Hands          = false,
        CustomMesh     = {
            MeshURL       = gitLink("Other/marker_disc.obj"),
            DiffuseURL    = "",
            NormalURL     = "",
            ColliderURL   = gitLink("Other/marker_disc.obj"),
            Convex        = true,
            MaterialIndex = 3,
            TypeIndex     = 0,
            CastShadows   = true
            },
        LuaScript      = "",
        LuaScriptState = "",
        XmlUI          = "",
        AttachedSnapPoints = {},
        },
    Pawn = {
        GUID           = nil,
        Name           = "PlayerPawn",
        Transform      = {
            posX   = 0,
            posY   = 0,
            posZ   = 0,
            rotX   = 0,
            rotY   = 0,
            rotZ   = 0,
            scaleX = 0.8,
            scaleY = 0.8,
            scaleZ = 0.8,
          },
        Nickname       = "",
        Description    = "",
        GMNotes        = "",
        Tags           = {},
        AltLookAngle   = {
            x = 0.0,
            y = 0.0,
            z = 0.0
        },
        ColorDiffuse   = {
            r = 0.0,
            g = 0.0,
            b = 0.0
        },
        LayoutGroupSortIndex = 0,
        Value          = 0,
        Locked         = false,
        Grid           = true,
        Snap           = false,
        IgnoreFoW      = false,
        MeasureMovement  = false,
        DragSelectable = true,
        Autoraise      = true,
        Sticky         = false,
        Tooltip        = true,
        GridProjection = false,
        HideWhenFaceDown  = false,
        Hands          = false,
        LuaScript      = "",
        LuaScriptState = "",
        XmlUI          = "",
        AttachedSnapPoints = {},
        },
    CustomDisc = {
    GUID           = nil,
    Name           = "Custom_Tile",
    Transform      = {
        posX   = 0,
        posY   = 0,
        posZ   = 0,
        rotX   = 0,
        rotY   = 0,
        rotZ   = 0,
        scaleX = 0.42,
        scaleY = 0.42,
        scaleZ = 0.42,
      },
    Nickname       = "",
    Description    = "",
    GMNotes        = "",
    Tags           = {},
    AltLookAngle   = {
        x = 0.0,
        y = 0.0,
        z = 0.0
    },
    ColorDiffuse   = {
        r = 1,
        g = 1,
        b = 1
    },
    LayoutGroupSortIndex = 0,
    Value          = 0,
    Locked         = false,
    Grid           = true,
    Snap           = true,
    IgnoreFoW      = false,
    MeasureMovement  = false,
    DragSelectable = true,
    Autoraise      = true,
    Sticky         = false,
    Tooltip        = true,
    GridProjection = false,
    HideWhenFaceDown  = false,
    Hands          = false,
    CustomImage    = {
        ImageURL          = "",
        ImageSecondaryURL = "",
        ImageScalar       = 1.0,
        WidthScale        = 0.0,
        CustomTile        = {
            Type      = 2,
            Thickness = 0.2,
            Stackable = false,
            Stretch   = true
        }
    },
    LuaScript      = "",
    LuaScriptState = "",
    XmlUI          = "",
    AttachedSnapPoints = {}
    },
    CustomTile = {
    GUID           = nil,
    Name           = "Custom_Tile",
    Transform      = {
        posX   = 0,
        posY   = 0,
        posZ   = 0,
        rotX   = 0,
        rotY   = 0,
        rotZ   = 0,
        scaleX = 1.35,
        scaleY = 1.00,
        scaleZ = 1.35,
      },
    Nickname       = "",
    Description    = "",
    GMNotes        = "",
    Tags           = {},
    AltLookAngle   = {
        x = 0.0,
        y = 0.0,
        z = 0.0
    },
    ColorDiffuse   = {
        r = 1,
        g = 1,
        b = 1
    },
    LayoutGroupSortIndex = 0,
    Value          = 0,
    Locked         = false,
    Grid           = true,
    Snap           = true,
    IgnoreFoW      = false,
    MeasureMovement  = false,
    DragSelectable = true,
    Autoraise      = true,
    Sticky         = true,
    Tooltip        = true,
    GridProjection = false,
    HideWhenFaceDown  = false,
    Hands          = false,
    CustomImage    = {
        ImageURL          = "",
        ImageSecondaryURL = "",
        ImageScalar       = 1.0,
        WidthScale        = 0.0,
        CustomTile        = {
            Type      = 3,
            Thickness = 0.2,
            Stackable = false,
            Stretch   = true
        }
    },
    LuaScript      = "",
    LuaScriptState = "",
    XmlUI          = "",
    AttachedSnapPoints = {}
    },
    Card = {
    GUID = nil,
    Name = "CardCustom",
    Transform = {
        posX = 0,
        posY = 0,
        posZ = 0,
        rotX = 0,
        rotY = 0,
        rotZ = 0,
        scaleX = 1.65,
        scaleY = 1.65,
        scaleZ = 1.65,
      },
    Nickname     = "",
    Description  = "",
    GMNotes      = "",
    Tags         = {},
    AltLookAngle = {
        x = 0.0,
        y = 0.0,
        z = 0.0
    },
    ColorDiffuse = {
        r = 0.0,
        g = 0.0,
        b = 0.0
    },
    LayoutGroupSortIndex = 0,
    Value        = 0,
    Locked       = false,
    Grid         = true,
    Snap         = true,
    IgnoreFoW    = false,
    MeasureMovement = false,
    DragSelectable = true,
    Autoraise    = true,
    Sticky       = true,
    Tooltip      = true,
    GridProjection = false,
    HideWhenFaceDown = true,
    Hands        = false,
    SidewaysCard = false,
    CardID       = 100,
    CustomDeck   = {},
    LuaScript    = "",
    LuaScriptState = "",
    XmlUI        = "",
    ContainedObjects = {},
    AttachedSnapPoints = {},
    },
    
}
local boardSnapPoints = {
    -- Action Card slots
    Act1 = {x=-0.235, z=-0.39, rotation=0, tags={}},
    Act2 = {x= 0.235, z=-0.39, rotation=0, tags={}},
    -- Action and Bond Chip Markers 
    Chi1 = {x=-0.125, z=-0.90, rotation=0, tags={}},
    Chi2 = {x= 0.000, z=-0.90, rotation=0, tags={}},
    Chi3 = {x= 0.125, z=-0.90, rotation=0, tags={}},
    -- Character Card slots
    Cha1 = {x=-0.763, z=-0.385, rotation=0, tags={"Piece_CharCard"}},
    Cha2 = {x= 0.763, z=-0.385, rotation=0, tags={"Piece_CharCard"}},
    -- Bond Action chip slots (to sit above the Character cards)
    Bon1 = {x=-0.763, z=-0.275, rotation=0, tags={"Piece_BondChip"}},
    Bon2 = {x= 0.763, z=-0.275, rotation=0, tags={"Piece_BondChip"}},
    -- Relationship Track
    Rel1  = {x=-0.930, z=0.15, rotation=0, tags={}},
    Rel2  = {x=-0.775, z=0.15, rotation=0, tags={}},
    Rel3  = {x=-0.620, z=0.15, rotation=0, tags={}},
    Rel4  = {x=-0.465, z=0.15, rotation=0, tags={}},
    Rel5  = {x=-0.310, z=0.15, rotation=0, tags={}},
    Rel6  = {x=-0.155, z=0.15, rotation=0, tags={}},
    Rel7  = {x= 0.000, z=0.15, rotation=0, tags={}},
    Rel8  = {x= 0.155, z=0.15, rotation=0, tags={}},
    Rel9  = {x= 0.310, z=0.15, rotation=0, tags={}},
    Rel10 = {x= 0.465, z=0.15, rotation=0, tags={}},
    Rel11 = {x= 0.620, z=0.15, rotation=0, tags={}},
    Rel12 = {x= 0.775, z=0.15, rotation=0, tags={}},
    Rel13 = {x= 0.930, z=0.15, rotation=0, tags={}},
    -- Cargo Track
    Car1  = {x=-0.762,  z=0.325, tags={}},
    Car2  = {x=-0.623,  z=0.325, tags={}},
    Car3  = {x=-0.483,  z=0.325, tags={}},
    Car4  = {x=-0.344,  z=0.325, tags={}},
    Car5  = {x=-0.205,  z=0.325, tags={}},
    Car6  = {x=-0.066,  z=0.325, tags={}},
    Car7  = {x= 0.074,  z=0.325, tags={}},
    Car8  = {x= 0.213,  z=0.325, tags={}},
    Car9  = {x= 0.352,  z=0.325, tags={}},
    Car10 = {x= 0.492,  z=0.325, tags={}},
    -- Development Track: Socialise
    Soc1 = {x=-0.591,   z=0.53, tags={"Piece_Disc"}},
    Soc2 = {x=-0.288,   z=0.53, tags={"Piece_Disc"}},
    Soc3 = {x= 0.015,   z=0.53, tags={"Piece_Disc"}},
    Soc4 = {x= 0.318,   z=0.53, tags={"Piece_Disc"}},
    Soc5 = {x= 0.621,   z=0.53, tags={"Piece_Disc"}},
    -- Development Track: Trade
    Tra1 = {x=-0.591,   z=0.71, tags={"Piece_Disc"}},
    Tra2 = {x=-0.288,   z=0.71, tags={"Piece_Disc"}},
    Tra3 = {x= 0.015,   z=0.71, tags={"Piece_Disc"}},
    Tra4 = {x= 0.318,   z=0.71, tags={"Piece_Disc"}},
    Tra5 = {x= 0.621,   z=0.71, tags={"Piece_Disc"}},
    -- Development Track: Audience
    Aud1 = {x=-0.591,   z=0.89, tags={"Piece_Disc"}},
    Aud2 = {x=-0.288,   z=0.89, tags={"Piece_Disc"}},
    Aud3 = {x= 0.015,   z=0.89, tags={"Piece_Disc"}},
    Aud4 = {x= 0.318,   z=0.89, tags={"Piece_Disc"}},
    Aud5 = {x= 0.621,   z=0.89, tags={"Piece_Disc"}},
    -- Active card spaces, for played Manifest and Episode cards.
    Pla1  = {x=-1.100,  z=-1.475, rotation=0, tags={}},
    Pla2  = {x=-0.660,  z=-1.475, rotation=0, tags={}},
    Pla3  = {x=-0.220,  z=-1.475, rotation=0, tags={}},
    Pla4  = {x= 0.220,  z=-1.475, rotation=0, tags={}},
    Pla5  = {x= 0.660,  z=-1.475, rotation=0, tags={}},
    Pla6  = {x= 1.100,  z=-1.475, rotation=0, tags={}},
    Pla7  = {x=-1.100,  z=-2.350, rotation=0, tags={}},
    Pla8  = {x=-0.660,  z=-2.350, rotation=0, tags={}},
    Pla9  = {x=-0.220,  z=-2.350, rotation=0, tags={}},
    Pla10 = {x= 0.220,  z=-2.350, rotation=0, tags={}},
    Pla11 = {x= 0.660,  z=-2.350, rotation=0, tags={}},
    Pla12 = {x= 1.100,  z=-2.350, rotation=0, tags={}},
    -- Additional unusable snapPoints for spawning purposes.
      -- Action Decks
    Ext1 = {x= 1.280,   z= -0.56, tags={"~tag"}},
    --Ext2 = {x= 1.400,   z= -0.10, rotation=0, tags={"~tag"}},
    --Ext3 = {x= 1.400,   z=  0.80, rotation=0, tags={"~tag"}},
    Ext4 = {x= 0.000,   z=  1.50, tags={"~tag"}},
      -- VP Scoring Tiles
    Ext5 = {x=-1.200,   z= -0.75, tags={"~tag"}},
    Ext6 = {x=-1.550,   z= -0.75, tags={"~tag"}},
      -- Faction Markers
    Ext7  = {x=-1.100,   z= -1.10, tags={"~tag"}},
    Ext8  = {x=-1.225,   z= -1.10, tags={"~tag"}},
    Ext9  = {x=-1.350,   z= -1.10, tags={"~tag"}},
    Ext10 = {x=-1.475,   z= -1.10, tags={"~tag"}},
      -- Knight Pawns
    Ext11 = {x=-1.100,   z= -1.25, tags={"~tag"}},
    Ext12 = {x=-1.225,   z= -1.25, tags={"~tag"}},
    Ext13 = {x=-1.350,   z= -1.25, tags={"~tag"}},
}
local templateDeckData = {
   Character = {
        front      = gitLink("Cards/Character_Cards.webp"),
        back       = gitLink("Cards/Character_Cards_Back.webp"),
        gridWidth  = 4,
        gridHeight = 7,
        uniqueBack = true,
    },
    Action0 = {
        front      = gitLink("Cards/Action_Cards_0.webp"),
        back       = gitLink("Cards/Action_Cards_0_Back.webp"),
        gridWidth  = 3,
        gridHeight = 7,
        uniqueBack = true,
    },
    Action1 = {
        front      = gitLink("Cards/Action_Cards_1.webp"),
        back       = gitLink("Cards/Action_Cards_1_Back.jpg"),
        gridWidth  = 5,
        gridHeight = 7,
        uniqueBack = false,
    },
    Action2 = {
        front      = gitLink("Cards/Action_Cards_2.webp"),
        back       = gitLink("Cards/Action_Cards_2_Back.jpg"),
        gridWidth  = 5,
        gridHeight = 7,
        uniqueBack = false,
    },
    Action3 = {
        front      = gitLink("Cards/Action_Cards_3.webp"),
        back       = gitLink("Cards/Action_Cards_3_Back.jpg"),
        gridWidth  = 5,
        gridHeight = 7,
        uniqueBack = false,
    },
    RoyalOrder = {
        front      = gitLink("Cards/Royal_Order_Cards.jpg"),
        back       = gitLink("Cards/Royal_Order_Cards_Back.jpg"),
        gridWidth  = 5,
        gridHeight = 2,
        uniqueBack = false,
    },
    Manifest = {
        front      = gitLink("Cards/Manifest_Cards.webp"),
        back       = gitLink("Cards/Manifest_Cards_Back.webp"),
        gridWidth  = 5,
        gridHeight = 5,
        uniqueBack = false,
    },
    GrandManifest = {
        front      = gitLink("Cards/Grand_Manifest_Cards.webp"),
        back       = gitLink("Cards/Grand_Manifest_Cards_Back.webp"),
        gridWidth  = 4,
        gridHeight = 1,
        uniqueBack = false,
    },
}
local cardSnapPoints = {
    RoyalOrder = {
        {x=-0.576, z=0.34, tags={"Piece_FactionMarker"}},
        {x= 0.000, z=0.34, tags={"Piece_FactionMarker"}},
        {x= 0.576, z=0.34, tags={"Piece_FactionMarker"}},
        {x=-0.288, z=0.92, tags={"Piece_FactionMarker"}},
        {x= 0.288, z=0.92, tags={"Piece_FactionMarker"}},
    },
    GrandManifest = {
        {x=-0.57, z=-0.650, tags={"Piece_PopularSupportChip"}},
        {x=-0.57, z= 0.115, tags={"Piece_PopularSupportChip"}},
        {x=-0.57, z= 0.880, tags={"Piece_PopularSupportChip"}},
    },
    Manifest = {
        {x=-0.57, z=-0.200, tags={"Piece_PopularSupportChip"}},
        {x=-0.57, z= 0.385, tags={"Piece_PopularSupportChip"}},
        {x=-0.57, z= 0.970, tags={"Piece_PopularSupportChip"}},
    },
}
local tableObjects = {
    -- These start out instantiated as GUID strings but get replaced after onLoad() with the object reference.
    -- This is done due to a limitation of TTS unable to reference objects until after they are first loaded.
    ExpeditionBoard = "8a3f76"
}


-- CORE FUNCTIONS
function onLoad(saved_state)
    -- Restore player data
    if saved_state ~= "" then
        local restoredData = JSON.decode(saved_state)
        for player, data in pairs(restoredData[1]) do
            for metric, value in pairs(data) do
                playerData[player][metric] = value
            end
        end
        for setting, data in pairs(restoredData[2]) do
            setupData[setting] = data
        end
    end

    -- Find major objects for functions
    for key, GUID in pairs(tableObjects) do
        tableObjects[key] = getObjectFromGUID(GUID)
    end

    -- Generate scripted objects (usually based on tags assigned to objects to reduce duplicate scripting!)
    generateButtons()
    generateCounters()
    generateAllyCityCounters()
    
    -- Reset the snappoints on cards.
    setCardSnapPoints()
    
    -- Set marked objects to be uninteractable
    if setUninteractables then
        for _, object in ipairs(getObjectsWithTag("Uninteractable")) do
            object.interactable = false
        end
    end
end

function onObjectCollisionEnter(registered_object, collision_info)
    updateCollisionPlayerAllies(registered_object, collision_info)
end

function onObjectCollisionExit(registered_object, collision_info)
    -- We add a short delay just make sure the object has time to actually leave the detection range when being removed.
    Wait.time(
        function()
            updateCollisionPlayerAllies(registered_object, collision_info)
        end,
        0.1)
end

function onSave()
    return JSON.encode({playerData, setupData})
end



-- FACTION SELECT FUNCTIONS
-- Functions to handle the player's faction selection operation
-- [→onLoad()]: Generates the clickable buttons.
function generateButtons()

    -- FACTION SELECTION MENUES
    -- Look through all objects for objects with both a "Func_FactionSelect" and "PlayerAssigned_..." tag.
    -- The tags indicate the object is intended to receive these functions, and which player it is used for.
    for _, obj in ipairs(getObjects()) do
        local validType    = false
        local targetPlayer = nil
        
        for _, tag in ipairs(obj.getTags()) do
            if tag == "Func_FactionSelect" then
                validType = true end
            if string.find(tag, "PlayerAssigned_") then
                targetPlayer =  string.sub(tag, 16) end
        end
        
        if validType and targetPlayer then
            createFactionSelectButton(obj, targetPlayer) 
        end
    end
    
    -- START GAME BUTTONS
    for _, obj in ipairs(getObjects()) do
        
        for _, tag in ipairs(obj.getTags()) do
            if tag == "Func_GameSetup_Manual" then
                createButtonGameSetup(obj, false) 
            end
        end
        
        for _, tag in ipairs(obj.getTags()) do
            if tag == "Func_GameSetup_Auto" then
                createButtonGameSetup(obj, true) 
            end
        end
    end
end

function createFactionSelectButton(obj, targetPlayer)

    local factionLabel = factionData[playerData[targetPlayer].faction].name

    -- Faction Display
    obj.createButton({
      click_function = "none",
      function_owner = self,
      label = factionLabel,
      position   = { 0, 1.6, 1},
      rotation   = { 0, 0, 0},
      font_color = {r=1, g=1, b=1, a=1},
      width = 0,
      height = 0,
      font_size = 600
    })

    -- Select Left
    obj.createButton({
      click_function = "none",
      function_owner = self,
      label = "➤",
      position   = {-6, 1.6, 1},
      rotation   = { 0, 0, 180},
      width = 0,
      height = 0,
      font_size = 1000,
      font_color = {r=100, g=100, b=100, a=100},
    })
    obj.createButton({
      click_function = "onClick_factionSelect_Down_"  .. obj.getGUID(),
      function_owner = self,
      position = {-6, 1.6, 1},
      rotation = { 0, 0, 0},
      color    = {r=0, g=0, b=0, a=0},
      width = 800,
      height = 600,
    })
   
    -- Select Right
    obj.createButton({
      click_function = "onClick_factionSelect_Up_"  .. obj.getGUID(),
      function_owner = self,
      label = "➤",
      position   = { 6, 1.6, 1},
      rotation   = { 0, 0, 0},
      font_color = {r=1, g=1, b=1, a=1},
      width = 800,
      height = 600,
      font_size = 1000,
      font_color = {r=100, g=100, b=100, a=100},
      color      = {r=0, g=0, b=0, a=0},
    })
    
    -- Wrapper function to allow buttons to pass arguments
    local btnFunction_Up = function(obj, player, alt_click)
        updateFactionSelect(targetPlayer, true)
    end
    local btnFunction_Down = function(obj, player, alt_click)
        updateFactionSelect(targetPlayer, false)
    end
    
    _G["onClick_factionSelect_Up_"   .. obj.getGUID()] = btnFunction_Up
    _G["onClick_factionSelect_Down_" .. obj.getGUID()] = btnFunction_Down
end

function createButtonGameSetup(obj, autoType)
    
    if autoType then
        obj.createButton({
          click_function = "onClick_gameSetup" .. obj.getGUID(),
          function_owner = self,
          label = "BEGIN\nSETUP",
          position   = { 0, 0.7, 0},
          rotation   = { 0, 0, 0},
          font_color = {r=100, g=100, b=100, a=100},
          width = 1400,
          height = 1400,
          color = {r=0, g=1, b=1, a=0},
          font_size = 450
        })
        obj.createButton({
          click_function = "onClick_setting1" .. obj.getGUID(),
          function_owner = self,
          label = setupData["auto"] and "AUTO" or "MANUAL",
          position   = { 5, 0, -14},
          rotation   = { 0, 0, 0},
          font_color = {r=1, g=1, b=1, a=100},
          width = 2800,
          height = 1000,
          color = setupData["auto"] and {r=25/255, g=80/255, b=25/255, a=100}
            or {r=100/255, g=25/255, b=25/255, a=100},
          font_size = 600
        })
        obj.createButton({
          click_function = "onClick_setting2" .. obj.getGUID(),
          function_owner = self,
          label = setupData["expansion"] and "ENABLED" or "DISABLED",
          position   = { 5, 0, -10},
          rotation   = { 0, 0, 0},
          font_color = {r=1, g=1, b=1, a=100},
          width = 2800,
          height = 1000,
          color = setupData["expansion"] and {r=25/255, g=80/255, b=25/255, a=100}
            or {r=100/255, g=25/255, b=25/255, a=100},
          font_size = 600
        })
        obj.createButton({
          click_function = "onClick_setting3" .. obj.getGUID(),
          function_owner = self,
          label = setupData["character_cards"] and "ENABLED" or "DISABLED",
          position   = { 5, 0, -6},
          rotation   = { 0, 0, 0},
          font_color = {r=1, g=1, b=1, a=100},
          width = 2800,
          height = 1000,
          color = setupData["character_cards"] and {r=25/255, g=80/255, b=25/255, a=100}
            or {r=100/255, g=25/255, b=25/255, a=100},
          font_size = 600
        })
        obj.createButton({
          click_function = "none",
          function_owner = self,
          label = "Setup Method:",
          position   = { -4, 0, -14},
          rotation   = { 0, 0, 0},
          font_color = {r=100, g=100, b=100, a=100},
          width = 0,
          height = 0,
          font_size = 600
        })
        obj.createButton({
          click_function = "none",
          function_owner = self,
          label = "Maiden's Oath:",
          position   = { -4, 0, -10},
          rotation   = { 0, 0, 0},
          font_color = {r=100, g=100, b=100, a=100},
          width = 0,
          height = 0,
          font_size = 600
        })
        obj.createButton({
          click_function = "none",
          function_owner = self,
          label = "Additional\nCharacter Cards:",
          position   = { -4, 0, -6},
          rotation   = { 0, 0, 0},
          font_color = {r=100, g=100, b=100, a=100},
          width = 0,
          height = 0,
          font_size = 600
        })
    else
        obj.createButton({
          click_function = "none",
          function_owner = self,
          label = "MANUAL\nSETUP",
          position   = { 0, 0.7, 0},
          rotation   = { 0, 0, 0},
          font_color = {r=1, g=1, b=1, a=1},
          width = 0,
          height = 0,
          font_size = 380
        })
        obj.createButton({
          click_function = "onClick_gameSetup" .. obj.getGUID(),
          function_owner = self,
          label = "",
          position   = { 0, 0.25, 0},
          rotation   = { 0, 0, 0},
          font_color = {r=1, g=1, b=1, a=1},
          width = 1400,
          height = 1400,
          font_size = 0
        })
    end
    
    -- Wrapper function to allow buttons to pass arguments
    local btnFunction_Auto = function(obj, player, alt_click)
        gameSetup(obj, true)
    end
    local btnFunction_Manual = function(obj, player, alt_click)
        gameSetup(obj, false)
    end
    local btnUpdate1 = function(obj, player, alt_click)
        updateSetup(obj, 1)
    end
    local btnUpdate2 = function(obj, player, alt_click)
        updateSetup(obj, 2)
    end
    local btnUpdate3 = function(obj, player, alt_click)
        updateSetup(obj, 3)
    end
    
    if autoType then
        _G["onClick_gameSetup" .. obj.getGUID()] = btnFunction_Auto
        _G["onClick_setting1" .. obj.getGUID()] = btnUpdate1
        _G["onClick_setting2" .. obj.getGUID()] = btnUpdate2
        _G["onClick_setting3" .. obj.getGUID()] = btnUpdate3
    else
        _G["onClick_gameSetup" .. obj.getGUID()] = btnFunction_Manual
    end
end

function updateFactionSelect(player, selectDirection)
    currentFaction = playerData[player].faction
    if selectDirection then
        newFaction = currentFaction+1
    else
        newFaction = currentFaction-1
    end
    
    -- Resolve under/overflow
    if newFaction > #factionData then
        currentFaction = 1
    elseif newFaction < 1 then
        currentFaction = #factionData
    else
        currentFaction = newFaction
    end
    
    -- Update settings with the new selection
    playerData[player].faction = currentFaction
    
    -- Update Button Display
    for _, obj in ipairs(getObjects()) do
        local validType    = false
        local validPlayer  = false
        
        for _, tag in ipairs(obj.getTags()) do
            if tag == "Func_FactionSelect" then
                validType = true
            elseif tag == ("PlayerAssigned_" .. player) then
                validPlayer = true
            end
        end
        
        if validType and validPlayer then
            obj.editButton({
                index = 0,
                label = factionData[currentFaction].name
                })
        end
    end
    
    -- Spawn in player components for the new Faction selected
    setFaction(player, currentFaction)
end

-- General purpose function to create object data by taking template data and modifying it with input parameter.
-- Able to handle most object types needed for this.
function generateObject(arg)
    --[=[ The data structure MUST abide by the following:
    *objType =
    player   =
    objData  = {
        frontURL   = Front facing image for CustomImage data.
        backURL    = Back facing image for CustomImage data.
        colour     = Colour of object.
        tags       = table of additional tags to add to object.
        scale      = resizing of object. All axes are optional.
        name       = name of the object. Shows up in hover-overs.
        description   =
        tileType      =
        tileThickness =
        customDeck    =
        snappoints    =
        }
    ]=]
    local objType = arg.objType
    local objData = arg.objData or {}
    local player  = arg.player
    if objType == nil then error("No valid objType given for generateObject.") return end
    
    local outputObject = deepcopy(templateObjects[objType])
    
    -- CustomImage properties, if able.
    if outputObject.CustomImage then
        outputObject.CustomImage.ImageURL          = objData.frontURL or ""
        outputObject.CustomImage.ImageSecondaryURL = objData.backURL  or ""
        
        -- CustomTile properties, if able
        if outputObject.CustomImage.CustomTile then
            outputObject.CustomImage.CustomTile.Type      = objData.tileType or outputObject.CustomImage.CustomTile.Type    
            outputObject.CustomImage.CustomTile.Thickness = objData.tileThickness or outputObject.CustomImage.CustomTile.Thickness
            
        end
    end

    -- CardID properties, if able.
    if outputObject.CardID then
        outputObject.CardID = objData.cardID or outputObject.CardID
    end
    
    -- CustomDeck properties, if able.
    if outputObject.CustomDeck then
        outputObject.CustomDeck = objData.customDeck or outputObject.CustomDeck
    end

    -- Colouring for tokens or edges of tiles
    if objData.colour then
        outputObject.ColorDiffuse = {
            r = (objData.colour.r or 0) / 255,
            g = (objData.colour.g or 0) / 255,
            b = (objData.colour.b or 0) / 255,
            a = (objData.colour.a or 255) / 255
            }
    end
    
    -- Resizing object
    if objData.scale then
        outputObject.Transform.scaleX = objData.scale.x or outputObject.Transform.scaleX
        outputObject.Transform.scaleY = objData.scale.y or outputObject.Transform.scaleY
        outputObject.Transform.scaleZ = objData.scale.z or outputObject.Transform.scaleZ
    end

    -- Additional tags
    if objData.tags then
        for _, tag in ipairs(objData.tags) do
            table.insert(outputObject.Tags, tag)
        end
    end
    
    if objData.snappoints then
        for _, snappoint in pairs(objData.snappoints) do
            local snapPointData = {
                Position = {
                    x = snappoint.position and snappoint.position.x or 0,
                    y = snappoint.position and snappoint.position.y or 0,
                    z = snappoint.position and snappoint.position.z or 0,
                    },
                Rotation = snappoint.rotiation and {
                    snappoint.rotation.x or 0,
                    snappoint.rotation.y or 0,
                    snappoint.rotation.z or 0} or nil,
                Tags = snappoint.tags or {}
            }
            table.insert(outputObject.AttachedSnapPoints, snapPointData)
        end
    end
    
    -- Name
    if objData.name then
        outputObject.Nickname = objData.name
    end
    
    -- Description
    if objData.description then
        outputObject.Description = objData.description
    end
    
    -- Assign object to be owned by the player, and thus removable when character is deselected.
    if player ~= nil then
        table.insert(outputObject.Tags, "PlayerOwned_" .. player)
    end
    
    -- Output the final object.
    return outputObject
end

-- Spawns in a defined object for a player relative to the player board, from named positions.
function spawnComponent(arg)
    --[=[ The data structure MUST abide by the following:
        *objData     =
        *playerBoard =
        snapPoint    =
        offset       =
        flipped      =
        registered   =
        interactable =
    ]=]
    
    -- Define values
    local objData           = arg.objData
    local playerBoard       = arg.playerBoard
    local snapPoint         = arg.snapPoint and boardSnapPoints[arg.snapPoint]
                              or {x=0, z=0, rotation=0}
    local offset            = {x        = arg.offset and arg.offset.x   or 0,
                               y        = arg.offset and arg.offset.y   or 0,
                               z        = arg.offset and arg.offset.z   or 0,
                               rotation = arg.offset and arg.offset.rot or 0}
    local flipped           = arg.flipped      or false
    local registered        = arg.registered   or false
    local interactable      = arg.interactable or true
    local handDeal          = arg.handDeal or false
    if objData == nil or playerBoard == nil then error("Invalid spawnComponent command.") return end
    
    local boardRotation = playerBoard.getRotation()

    local spawnPosition = playerBoard.positionToWorld({
        x = snapPoint.x + offset.x,
        y = offset.y + 0.35,
        z = snapPoint.z + offset.z
    })
    
    local spawnRotation = {
        x = boardRotation.x + 0,
        y = boardRotation.y + (snapPoint.rotation or 0) + offset.rotation,
        z = boardRotation.z + (flipped and 180 or 0)
    }
    
    local spawnedObject = spawnObjectData({
        data = objData,
        position = spawnPosition,
        rotation = spawnRotation,
        callback_function = function(spawnedObj)
            -- Set registered (Optional).
            if registered then
                spawnedObj.registerCollisions()
            end
            -- Set uninteractable (Optional).
            if interactable == false then
                spawnedObj.interactable = false
            end
            -- Deals to hand (Optional)
            if handDeal  then
                spawnedObj.deal(99, handDeal)
            end
        end
    })
    
    return spawnedObject
end

-- Due to a rather large of unique requirements to construct, player boards are generated in an abstracting function.
function generateBoard(player, factionNum)
    local outputObject = generateObject({
            objType = "Board",
            player  = player,
            objData = {
                frontURL = factionData[factionNum].playerBoard,
                backURL  = factionData[factionNum].playerBoard,
                colour   = {r=213, g=160, b=92},
                tags     = {}
                }
            })
    
    outputObject.Locked   = true
    
    -- Add all Snap Points
    for key, snapPoint in pairs(boardSnapPoints) do
        table.insert(outputObject.AttachedSnapPoints, {
            Position = {
                x = snapPoint.x,
                y = 0.40,
                z = snapPoint.z
                },
            Rotation = snapPoint.rotation and {
                x = 0,
                y = snapPoint.rotation,
                z = 0
                } or nil,
            Tags = deepcopy(snapPoint.tags)
            })
    end
    
    return outputObject
end

function generateActionDeck(deckTypes, player, factionRow)
    
    local outputObject = generateObject({
            objType = "Deck",
            player  = player,
            objData = {
                tags = {},
                }
            })
    
    outputObject.CustomDeck = {}
    for i, deckType in ipairs(deckTypes) do
        deckData = {
            FaceURL      = templateDeckData[deckType].front,
            BackURL      = templateDeckData[deckType].back,
            NumWidth     = templateDeckData[deckType].gridWidth,
            NumHeight    = templateDeckData[deckType].gridHeight,
            BackIsHidden = true,
            UniqueBack   = templateDeckData[deckType].uniqueBack,
            Type = 0
            }
            
        outputObject.CustomDeck[i] = deckData
            
        -- Iterate over all cards from the given rows and add it to the deck
        for n = 0, (deckData.NumWidth - 1), 1 do
            -- TTS REQUIRES the number be formatted as a 2 digit ID concatenated to the CustomDeck ID number.
            -- i.e. The first card must be X00, followed by X01. We probably skip some here so we need to count
            --   where our desired index is using the faction's row number.
            
            local baseIndex = (factionRow - 1) * deckData.NumWidth
            local GeneratedID = i .. string.format("%02d" , (baseIndex + i))
            
            table.insert(outputObject.ContainedObjects, {
                Name = "Card",
                Nickname = "",
                CardID   = GeneratedID,
                CustomDeck = {
                    [i]  = deckData
                    },
                Tags     = {"Piece_" .. deckType .. "Card"}
            })
            
            table.insert(outputObject.DeckIDs, GeneratedID)
        end
    end
    
    -- Tag ownership to the player
    if player ~= nil then
        for i, card in ipairs(outputObject.ContainedObjects) do
            table.insert(card.Tags, "PlayerOwned_" .. player)
        end
    end
    
    return outputObject
end

function generateCharacterCard(player, princessCard, factionNum, variantMode)
    local deckData = {
            FaceURL      = templateDeckData["Character"].front,
            BackURL      = templateDeckData["Character"].back,
            NumWidth     = templateDeckData["Character"].gridWidth,
            NumHeight    = templateDeckData["Character"].gridHeight,
            BackIsHidden = true,
            UniqueBack   = true,
            Type = 0
            }
    
    local cardIndex = 0
    cardIndex = cardIndex + (deckData.NumWidth * (factionData[factionNum].deckRow - 1)) -- Accounts for the offset of the faction's row.
    cardIndex = cardIndex + (variantMode and 2 or 0) -- Offset by 2 for variant cards.
    cardIndex = cardIndex + (princessCard and 0 or 1) -- Offset by 1 if you need the Knight's card.

    local outputObject =generateObject({
        objType = "Card",
        player  = player,
        objData = {
            cardID = "1" .. string.format("%02d" , cardIndex),
            customDeck = {
                ["1"] = deckData
                },
            description = princessCard and (not variantMode) and factionData[factionNum].princessCardTooltipA
                or princessCard and (variantMode) and factionData[factionNum].princessCardTooltipB
                or (not princessCard) and (not variantMode) and factionData[factionNum].knightCardTooltipA
                or (not princessCard) and (variantMode) and factionData[factionNum].knightCardTooltipB
                or "",
            colour   = {r=255, g=255, b=255},
            tags     = variantMode and {"Module_CharCards", "Piece_CharCard"} or {"Piece_CharCard"},
            }
        })
    
    return outputObject
end

function setFaction(player, factionNum)
    playerPosition = playerPositions[player]

    -- Clear old objects for replacement
    for _, object in ipairs(getObjectsWithTag("PlayerOwned_" .. player)) do
        object.Destruct()
    end
    
    -- Spawn new board
    objToSpawn = generateBoard(player, factionNum)
    local playerBoard = spawnObjectData({
        data = objToSpawn,
        position = {x=playerPosition.x, y=playerPosition.y, z=playerPosition.z},
        rotation = {x=0, y=180, z=0},
        })
    
    -- Relationship markers
    spawnComponent({
            objData      = generateObject({
                objType = "CustomDisc",
                player  = player,
                objData = {
                    frontURL = factionData[factionNum].relationMarkerPrincess,
                    colour   = {r=243, g=111, b=162},
                    tags     = {}
                    }
                }),
            playerBoard  = playerBoard,
            snapPoint    = "Rel13",
            offset   = {x = 0, y = -0.06, x = 0},
            })
    spawnComponent({
            objData      = generateObject({
                objType = "CustomDisc",
                player  = player,
                objData = {
                    frontURL = factionData[factionNum].relationMarkerKnight,
                    colour   = {r=243, g=111, b=162},
                    tags     = {}
                    }
                }),
            playerBoard  = playerBoard,
            snapPoint    = "Rel1",
            offset   = {x = 0, y = -0.06, x = 0},
            })
    
    -- Action markers
    spawnComponent({
            objData      = generateObject({
                objType = "CustomDisc",
                player  = player,
                objData = {
                    frontURL = factionData[factionNum].actionMarkerPrincess,
                    backURL  = factionData[factionNum].actionMarkerKnight,
                    colour   = factionData[factionNum].colour,
                    tags     = {}
                    }
                }),
            playerBoard  = playerBoard,
            snapPoint    = "Chi3",
            offset   = {x = 0, y = -0.05, x = 0},
            })
    spawnComponent({
            objData      = generateObject({
                objType = "CustomDisc",
                player  = player,
                objData = {
                    frontURL = factionData[factionNum].actionMarkerKnight,
                    backURL  = factionData[factionNum].actionMarkerPrincess,
                    colour   = factionData[factionNum].colour,
                    tags     = {}
                    }
                }),
            playerBoard  = playerBoard,
            snapPoint    = "Chi1",
            offset   = {x = 0, y = -0.05, x = 0},
            })
    
    -- Bond Chips
    spawnComponent({
            objData      = generateObject({
                objType = "CustomDisc",
                player  = player,
                objData = {
                    name = "Bond Chip",
                    frontURL = factionData[factionNum].relationMarkerKnight,
                    backURL = factionData[factionNum].relationMarkerPrincess,
                    colour   = {r=243, g=111, b=162},
                    tags     = {"Piece_BondChip"}
                    }
                }),
            playerBoard  = playerBoard,
            snapPoint    = "Chi2",
            offset   = {x = 0, y = -0.05, x = 0},
            })
    spawnComponent({
            objData      = generateObject({
                objType = "CustomDisc",
                player  = player,
                objData = {
                    name = "Bond Chip",
                    frontURL = factionData[factionNum].relationMarkerPrincess,
                    backURL = factionData[factionNum].relationMarkerKnight,
                    colour   = {r=243, g=111, b=162},
                    tags     = {"Piece_BondChip"}
                    }
                }),
            playerBoard  = playerBoard,
            offset   = {x = 0, y = 0.15, x = 0},
            snapPoint    = "Chi2"
            })
    
    -- Character cards
    spawnComponent({
            objData      = generateCharacterCard(player, true, factionNum, false),
            playerBoard  = playerBoard,
            snapPoint    = "Cha2"
            })
    spawnComponent({
            objData      = generateCharacterCard(player, false, factionNum, false),
            playerBoard  = playerBoard,
            snapPoint    = "Cha1"
            })
    spawnComponent({
            objData      = generateCharacterCard(player, true, factionNum, true),
            playerBoard  = playerBoard,
            snapPoint    = "Cha2"
            })
    spawnComponent({
            objData      = generateCharacterCard(player, false, factionNum, true),
            playerBoard  = playerBoard,
            snapPoint    = "Cha1"
            })
    
    -- Trade markers
    objToSpawn = generateObject({
                objType = "Token",
                player  = player,
                objData = {
                    colour   = {
                        r = factionData[factionNum].colour.r,
                        g = factionData[factionNum].colour.g,
                        b = factionData[factionNum].colour.b,
                        a = 235
                        },
                    tags     = {}
                    }
                })
    for i=1,10,1 do
        spawnComponent({
                objData      = objToSpawn,
                playerBoard  = playerBoard,
                offset = {x = 0, y = 0.15, x = 0},
                snapPoint    = "Car" .. i
                })
    end
    
    -- Development markers
    objToSpawn = generateObject({
                objType = "Disc",
                player  = player,
                objData = {
                    colour   = {
                        r = factionData[factionNum].colour.r,
                        g = factionData[factionNum].colour.g,
                        b = factionData[factionNum].colour.b,
                        a = 255
                        },
                    tags     = {"Piece_Disc"}
                    }
                })
    for i=1,5,1 do
        spawnComponent({
                objData      = objToSpawn,
                playerBoard  = playerBoard,
                snapPoint    = "Soc" .. i
                })
        spawnComponent({
                objData      = objToSpawn,
                playerBoard  = playerBoard,
                snapPoint    = "Tra" .. i
                })
        spawnComponent({
                objData      = objToSpawn,
                playerBoard  = playerBoard,
                snapPoint    = "Aud" .. i
                })
    end
    
    -- Action Decks
    local ActionDeck123 = spawnComponent({
            objData      = generateActionDeck({"Action1", "Action2", "Action3"}, player, factionData[factionNum].deckRow),
            playerBoard  = playerBoard,
            offset   = {x = 0, y = -0.26, z = 0},
            snapPoint    = "Ext1",
            flipped      = true,
            })
    ActionDeck123.setName(factionData[factionNum].name ..  " Action Deck")        
    local ActionDeck0 = spawnComponent({
            objData      = generateActionDeck({"Action0"}, player, factionData[factionNum].deckRow),
            playerBoard  = playerBoard,
            offset   = {x = 0, y = 0, z = 0},
            snapPoint    = "Ext4",
            handDeal = player,
            })
    
    -- 70 Point Tile
    spawnComponent({
            objData      = generateObject({
                objType = "CustomTile",
                player  = player,
                objData = {
                    frontURL = factionData[factionNum].scoreTile ,
                    backURL  = factionData[factionNum].scoreTileBack,
                    colour   = {r=228, g=222, b=191},
                    description = [[Flip this over when your score tracker crosses the starting position.

(This indicates you have achieved an additional 70 VP at the end of the game.)]],
                    tags     = {}
                    }
                }),
            offset   = {x=0, y=-0.36, z=0},
            playerBoard  = playerBoard,
            snapPoint    = "Ext5"
            })
    
    -- Affection Bonus Tile
    spawnComponent({
            objData      = generateObject({
                objType = "CustomTile",
                player  = player,
                objData = {
                    frontURL = factionData[factionNum].affectionTile ,
                    backURL  = factionData[factionNum].affectionTileBack,
                    colour   = {r=228, g=222, b=191},
                    description = [[If you do not have all four colours (red, blue, yellow, and green) during an Affection Check, flip this tile over.

(You will not receive the 3 VP at the end of the game.)]],
                    tags     = {"Module_Expansion"}
                    }
                }),
            offset   = {x=0, y=-0.36, z=0},
            playerBoard  = playerBoard,
            snapPoint    = "Ext6"
            })
            
    -- Faction indicator discs
    spawnComponent({
            objData      = generateObject({
                objType = "CustomDisc",
                player  = player,
                objData = {
                    frontURL = factionData[factionNum].factionToken,
                    colour   = factionData[factionNum].colour,
                    offset   = {x=0, y=-0.3, z=0},
                    tags     = {"Piece_FactionMarker"}
                    }
                }),
            playerBoard  = playerBoard,
            snapPoint    = "Ext7",
            offset   = {x = 0, y = -0.36, x = 0},
            })
    spawnComponent({
            objData      = generateObject({
                objType = "CustomDisc",
                player  = player,
                objData = {
                    frontURL = factionData[factionNum].factionToken,
                    colour   = factionData[factionNum].colour,
                    offset   = {x=0, y=-0.1, z=0},
                    tags     = {"Piece_FactionMarker"}
                    }
                }),
            playerBoard  = playerBoard,
            snapPoint    = "Ext8",
            offset   = {x = 0, y = -0.36, x = 0},
            })
    spawnComponent({
            objData      = generateObject({
                objType = "CustomDisc",
                player  = player,
                objData = {
                    frontURL = factionData[factionNum].factionToken,
                    colour   = factionData[factionNum].colour,
                    offset   = {x=0, y=-0.1, z=0},
                    tags     = {"Piece_FactionMarker"}
                    }
                }),
            playerBoard  = playerBoard,
            snapPoint    = "Ext9",
            offset   = {x = 0, y = -0.36, x = 0},
            })
            
    -- Grand Duke's Eval Marker
    spawnComponent({
            objData = generateObject({
                objType = "Token",
                player  = player,
                objData = {
                    colour   = {
                        r = factionData[factionNum].colour.r,
                        g = factionData[factionNum].colour.g,
                        b = factionData[factionNum].colour.b,
                        a = 255
                        },
                    tags     = {"Piece_CubeMarker"}
                    }
                }),
            playerBoard  = playerBoard,
            snapPoint    = "Ext10",
            offset   = {x = 0, y = -0.30, x = 0},
            })

    -- Knight's Pawns
    spawnComponent({
            objData = generateObject({
                objType = "Pawn",
                player  = player,
                objData = {
                    colour   = {
                        r = factionData[factionNum].colour.r,
                        g = factionData[factionNum].colour.g,
                        b = factionData[factionNum].colour.b,
                        a = 255
                        },
                    tags     = {"Piece_Pawn"}
                    }
                }),
            playerBoard  = playerBoard,
            snapPoint    = "Ext11",
            offset   = {x = 0, y = -0.36, x = 0},
            })
    spawnComponent({
            objData = generateObject({
                objType = "Pawn",
                player  = player,
                objData = {
                    colour   = {
                        r = factionData[factionNum].colour.r,
                        g = factionData[factionNum].colour.g,
                        b = factionData[factionNum].colour.b,
                        a = 255
                        },
                    tags     = {"Piece_Pawn"}
                    }
                }),
            playerBoard  = playerBoard,
            snapPoint    = "Ext12",
            offset   = {x = 0, y = -0.36, x = 0},
            })
    spawnComponent({
            objData = generateObject({
                objType = "Pawn",
                player  = player,
                objData = {
                    colour   = {
                        r = factionData[factionNum].colour.r,
                        g = factionData[factionNum].colour.g,
                        b = factionData[factionNum].colour.b,
                        a = 255
                        },
                    tags     = {"Piece_Pawn"}
                    }
                }),
            playerBoard  = playerBoard,
            snapPoint    = "Ext13",
            offset   = {x = 0, y = -0.36, x = 0},
            })


    -- Reset Ally City counters
    updatePlayerAllies(player)
end



-- GAME SETUP FUNCTIONS
function updateSetup(buttonObj, settingID)
    local settingName = ""
    
    if settingID == 1 then
        settingName = "auto"
    elseif settingID == 2 then
        settingName = "expansion"
    elseif settingID == 3 then
        settingName = "character_cards"
    end
    
    if setupData[settingName] then
        setupData[settingName] = false
    else
        setupData[settingName] = true
    end
    
    local buttonLabel = "ENABLED"
    local buttonColour = {r=25/255, g=80/255, b=25/255, a=100}
    if setupData[settingName] == false then
        buttonLabel = "DISABLED"
        buttonColour = {r=100/255, g=25/255, b=25/255, a=100}
    end
    
    if settingID == 1 then
        if setupData[settingName] then
            buttonLabel = "AUTO"
        else
            buttonLabel = "MANUAL"
        end
    end
    
    buttonObj.editButton({
        index=settingID,
        label=buttonLabel,
        color=buttonColour,
        })
    
    onSave()    
end

function gameSetup(buttonObj, autoSetup)
    buttonObj.AssetBundle.playTriggerEffect(0) -- Plays the button press animation of the object
    print("Starting game!")
            
    -- Destroy on a delay to give the button time to animate.
    Wait.time(
        function()
            -- Find all faction selection objects and setup buttons and destroy them (including itself).
            for _, selectionObj in ipairs(getObjects()) do
                for _, tag in ipairs(selectionObj.getTags()) do
                    if tag == "Func_FactionSelect" or
                       tag == "Func_GameSetup_Manual" or
                       tag == "Func_GameSetup_Auto" or
                       tag == "Setup_ToRemove" then
                        selectionObj.destruct()
                    end
                end
            end
            
            -- Find active players
            local activePlayerCount = 0
            local assignedNPC = false
            for _, player in ipairs(Player.getPlayers()) do
                if playerData[player.color] ~= nil then
                    if player.seated then
                        playerData[player.color].playerType = "active"
                        activePlayerCount = activePlayerCount + 1
                    end
                end
            end
            
            -- Assign an NPC (or 2 if you're playing solo!)
            if activePlayerCount <= 2 then
                local assignedNPCs = 0
                for color, data in pairs(playerData) do
                    if data.playerType == "inactive" then
                        data.playerType = "bot"
                        assignedNPCs = assignedNPCs + 1
                    end
                    if activePlayerCount == 2 and assignedNPCs == 1 then
                        break
                    elseif  assignedNPCs == 2 then
                        break
                    end
                end
            end
            
            
            local NPCDiscs = {}
            local discLimit = activePlayerCount == 2 and 9 or 15
            for color, data in pairs(playerData) do
                -- Selectively destroy NPC pieces
                if data.playerType == "bot" then
                    local destroyCards = getCardsByTagsGlobal({"PlayerOwned_" .. color}, {"Piece_Action1Card", "Piece_Action2Card", "Piece_Action3Card"})
                    for _, obj in pairs(destroyCards) do
                        obj.Destruct()
                    end
                
                    for _, object in ipairs(getObjectsWithTag("PlayerOwned_" .. color)) do
                        if object.hasTag("Piece_Disc") and #NPCDiscs < discLimit then
                            table.insert(NPCDiscs, object)
                        elseif object.type == "Deck" then
                        
                        else
                            object.Destruct()
                        end
                    end
                    for _, object in ipairs(getObjectsWithTag("PlayerAssigned_" .. color)) do
                        object.Destruct()
                    end
                    
                elseif data.playerType == "inactive" then
                    for _, object in ipairs(getObjectsWithTag("PlayerOwned_" .. color)) do
                        object.Destruct()
                    end
                    for _, object in ipairs(getObjectsWithTag("PlayerAssigned_" .. color)) do
                        object.Destruct()
                    end
                end
            end
            
            -- Remove the space blockades based on the number of players active. Lock the remainder.
            for _, obj in ipairs(getObjectsWithTag("Piece_Block4")) do
                if activePlayerCount >= 4 then
                    obj.Destruct()
                else
                    obj.setLock(true)
                end
            end
            
            for _, obj in ipairs(getObjectsWithTag("Piece_Block5")) do
                if activePlayerCount >= 5 then
                    obj.Destruct()
                else
                    obj.setLock(true)
                end
            end
            
            
            -- SETTING: EXPANSION DISABLED:
            -- If the Maiden's Oath expansion is disabled, delete everything that requires it.
            if setupData.expansion == false then
                for _, obj in ipairs(getObjectsWithTag("Module_Expansion")) do
                    obj.destruct()
                end
            end   
            
            -- SETTING: ADDITIONAL CHARACTER CARDS DISABLED
            -- If the Additional Character Cards setting is disabled, delete the extra character cards
            if setupData.character_cards == false then
                for _, obj in ipairs(getObjectsWithTag("Module_CharCards")) do
                    obj.destruct()
                end
                for _, obj in ipairs(getObjects()) do
                    if obj.type == "Deck" then
                        for _, card in ipairs(obj.getObjects()) do
                            for _, tag in ipairs(card.tags) do
                                if tag == "Module_CharCards" then
                                    local foundCard = obj.takeObject({guid=card.guid})
                                    foundCard.destruct()
                                end
                            end
                        end
                    end
                end
            end
            
        end,
        0.4)
    
    if setupData["auto"] then
        autoGameSetup()
    end
end

function autoGameSetup()
    -- Position player pieces
    Wait.time(
        function() 
            -- local activePlayers = {"Red", "Green", "Yellow", "Orange", "Blue"}        
            local activePlayers = {}
            local botPlayers = {}
            local playerOrder = {}
            -- Find players who are seated (playing)
            for color, data in pairs(playerData) do
                if data.playerType == "active" then
                    table.insert(activePlayers, color)
                elseif data.playerType == "bot" then
                    table.insert(botPlayers, color)
                end
            end
            -- Randomise player order
            for i = #activePlayers, 1, -1 do
                local j = math.random(i)
                activePlayers[i], activePlayers[j] = activePlayers[j], activePlayers[i]
                table.insert(playerOrder, activePlayers[i])
            end
            
            -- Set up bot pieces
            if botPlayers ~= nil then
                local offsetCount = 0
                for _, botColor in ipairs(botPlayers) do
                    for _, obj in ipairs(getObjectsWithTag("PlayerOwned_" .. botColor)) do 
                        offsetCount = offsetCount + 1
                        if obj.hasTag("Piece_Disc") then
                            moveToSlot(obj, "NPCDisc", {
                                x=(1.0 + -1.0*(offsetCount)),
                                y=0,
                                z=0,
                                })
                        end
                    end
                end
            end
            
            -- Set up for each order
            for turnOrder, playerColor in ipairs(playerOrder) do
                local startMoney = 0
                if turnOrder >= 2 then
                    startMoney = 1
                elseif turnOrder >= 4 then
                    startMoney = 2
                end
                
                -- Reset resource values.
                 playerData[playerColor].resources = {
                    money = startMoney,
                    red = 0,
                    green = 0,
                    blue = 2,
                    }
                updateResourceCounter(playerColor, "Money", startMoney)
                updateResourceCounter(playerColor, "Red", 0)
                updateResourceCounter(playerColor, "Green", 0)
                updateResourceCounter(playerColor, "Blue", 2)
                
                -- Set up their pieces onto the public boards    
                local piecePawns = {}
                local factionDiscs = {}
                local evalCube =  nil
                
                for _, obj in ipairs(getObjects()) do
                    local playerOwned = false
                    for _, tag in ipairs(obj.getTags()) do
                        if tag == "PlayerOwned_" .. playerColor then
                            playerOwned = true
                        end
                    end
                    if playerOwned then
                        for _, tag in ipairs(obj.getTags()) do
                            if tag == "Piece_Pawn" then
                                table.insert(piecePawns, obj)
                            elseif tag == "Piece_FactionMarker" then
                                table.insert(factionDiscs, obj)
                            elseif tag == "Piece_CubeMarker" then
                                evalCube = obj
                            end
                        end
                    end
                end
                
                moveToSlot(piecePawns[1], "KnightWorkshop", {x=(-1.8 + 0.6*(turnOrder)), y=0, z=0})
                moveToSlot(piecePawns[2], "KnightCarriage", {x=(-1.8 + 0.6*(turnOrder)), y=0, z=0})
                moveToSlot(piecePawns[3], "KnightTrading",  {x=(-1.8 + 0.6*(turnOrder)), y=0, z=0})
                
                moveToSlot(factionDiscs[1], "TurnOrder_" .. turnOrder)
                moveToSlot(factionDiscs[2], "Score0", {x=0, y=(0.2*(turnOrder-1)), z=0})
                
                moveToSlot(evalCube, "DukeEval_" .. turnOrder)
                
            end
        end,
        0.5)

    -- Shuffle decks
    Wait.time(
        function()  
            -- Shuffle decks
            for _, obj in ipairs(getObjects()) do
                for _, tag in ipairs(obj.getTags()) do
                    if tag == "Deck_Episode" or
                        tag == "Deck_Manifest" or
                        tag == "Deck_RoyalOrder" or
                        tag == "Deck_GrandManifest" or
                        tag == "Bag_Tile_A" or
                        tag == "Bag_Tile_B" then
                        obj.shuffle()
                    end
                end
            end
        end,
        0.8)

    -- Lay out public cards
    Wait.time(
        function()  
            -- Place Royal Order cards
            dealToSlot("Deck_RoyalOrder", "RoyalOrder")
            dealToSlot("Deck_RoyalOrder", "Forecast_2_RO")
            dealToSlot("Deck_RoyalOrder", "Forecast_3_RO")
            
            -- Place Grand Manifest cards
            dealToSlot("Deck_GrandManifest", "GrandManifest")
        end,
        1.0)
        
    -- Popular Support Action Tiles
    Wait.time(function() dealToSlot("Bag_Tile_A", "Tile_A_1", true) end, 1.1)
    Wait.time(function() dealToSlot("Bag_Tile_A", "Tile_A_2", true) end, 1.2)
    Wait.time(function() dealToSlot("Bag_Tile_A", "Tile_A_3", true) end, 1.3)
    Wait.time(function() dealToSlot("Bag_Tile_B", "Tile_B_1", true) end, 1.4)
    Wait.time(function() dealToSlot("Bag_Tile_B", "Tile_B_2", true) end, 1.5)
    Wait.time(function() dealToSlot("Bag_Tile_B", "Tile_B_3", true) end, 1.6)
        
    -- Combine Action Cards into a deck
    Wait.time(
        function()
            createCombinedActionDeck(1)
        end,
        2.2)
    Wait.time(
        function()
            createCombinedActionDeck(2)
        end,
        2.6)
    Wait.time(
        function()
            createCombinedActionDeck(3)
        end,
        3.0)
    
    -- Deal Action Cards
    Wait.time(
        function()
            for i=1,3,1 do
                for y=1,3,1 do
                    dealToSlot("Deck_Action" .. i, "Forecast_" .. i .. "_" .. y)
                end
            end
        end,
        3.5)
    
    -- Deal Manifest and Episode cards to active players 
    Wait.time(
        function()
            -- Find Manifest and Episode decks
            deckEpisodeObj = nil
            deckManifestObj = nil
            
            for _, obj in ipairs(getObjects()) do
                for _, tag in ipairs(obj.getTags()) do
                    if tag == "Deck_Episode" then
                        deckEpisodeObj = obj
                    elseif tag == "Deck_Manifest" then
                        deckManifestObj = obj
                    end
                end
            end
            
            -- Deal cards
            for _, player in ipairs(Player.getPlayers()) do
                if player.seated then
                    if deckManifestObj ~= nil then
                        deckManifestObj.deal(4, player.color, 2)
                    end
                    if deckEpisodeObj ~= nil then
                        deckEpisodeObj.deal(6, player.color, 2)
                    end
                end
            end
          
        end,
        4.0)
end

function dealToSlot(containerTag, slotName, locked)
    baseContainerObj = nil
    destinationSlotObj = nil
    for _, obj in ipairs(getObjects()) do
        for _, tag in ipairs(obj.getTags()) do
            if tag == containerTag then
                baseContainerObj = obj
            elseif tag == "CardSlot" and obj.getGMNotes() == slotName then
                destinationSlotObj = obj
            end
        end
    end

    if baseContainerObj and destinationSlotObj then
        local takenObj = baseContainerObj.takeObject()

        takenObj.setRotation({
            x = destinationSlotObj.getRotation().x,
            y = destinationSlotObj.getRotation().y,
            z = destinationSlotObj.getRotation().z,
        })
        takenObj.setPositionSmooth({
            x = destinationSlotObj.getPosition().x,
            y = destinationSlotObj.getPosition().y + 0.1,
            z = destinationSlotObj.getPosition().z,
            }, false, false)
            
        if locked then
            takenObj.setLock(true)
        end
    end
    
end

function moveToSlot(moveObj, slotName, offset)
    destinationSlotObj = nil
    for _, obj in ipairs(getObjects()) do
        for _, tag in ipairs(obj.getTags()) do
            if tag == "CardSlot" and obj.getGMNotes() == slotName then
                destinationSlotObj = obj
            end
        end
    end

    if moveObj and destinationSlotObj then
        moveObj.setRotation({
            x = destinationSlotObj.getRotation().x,
            y = destinationSlotObj.getRotation().y,
            z = destinationSlotObj.getRotation().z,
        })
        moveObj.setPositionSmooth({
            x = destinationSlotObj.getPosition().x + 0.0 + (offset and offset.x or 0),
            y = destinationSlotObj.getPosition().y + 0.1 + (offset and offset.y or 0),
            z = destinationSlotObj.getPosition().z + 0.0 + (offset and offset.z or 0),
            }, false, false)
    end
end

function createCombinedActionDeck(deckNumber)
    local deckSlotObj = nil
    
    for _, obj in ipairs(getObjects()) do
        for _, tag in ipairs(obj.getTags()) do
            if tag == "CardSlot" and obj.getGMNotes() == ("ActionDeck_" .. deckNumber) then
                deckSlotObj = obj
            end
        end
    end
    
    local requiredCards = getCardsByTagsGlobal({"Piece_Action" .. deckNumber .. "Card"})
    local deckPosition = {
        x = deckSlotObj.getPosition().x,
        y = deckSlotObj.getPosition().y + 0.1,
        z = deckSlotObj.getPosition().z,
    }
    local deckRotation = {
        x = deckSlotObj.getRotation().x,
        y = deckSlotObj.getRotation().y,
        z = deckSlotObj.getRotation().z + 180,
        }
    
    local baseActionDeck = nil
    for _, obj in ipairs(requiredCards) do
        if baseActionDeck == nil then
            baseActionDeck = obj
            
            baseActionDeck.setRotation(deckRotation)
            baseActionDeck.setPosition(deckPosition)
        else
            baseActionDeck = baseActionDeck.putObject(obj)
        end
    end

    baseActionDeck.shuffle()
end



-- CARD SNAPPOINT FUNCTIONS
function setCardSnapPoints()
    -- Royal Orders
    for _, obj in ipairs(getObjectsWithTag("Deck_RoyalOrder")) do
        setSnapPointsToDeckCards(obj, cardSnapPoints["RoyalOrder"])
    end
    
    -- Grand Manifest
    for _, obj in ipairs(getObjectsWithTag("Deck_GrandManifest")) do
        setSnapPointsToDeckCards(obj, cardSnapPoints["GrandManifest"])
    end
    
    -- Grand Manifest
    for _, obj in ipairs(getObjectsWithTag("Deck_Manifest")) do
        setSnapPointsToDeckCards(obj, cardSnapPoints["Manifest"])
    end
end 

function setSnapPointsToDeckCards(deckObj, snapPointData)
    for _, card in pairs(deckObj.getObjects()) do
        local cardObj = deckObj.takeObject({guid=card.guid})
        
        local generatedSnapPoints = {}
        for _, snapPoint in pairs(snapPointData) do
        table.insert(generatedSnapPoints, {
            position = {
                x = snapPoint.x,
                y = (snapPoint.y or 0) + 0.5,
                z = snapPoint.z,
                },
            rotation = snapPoint.rotation and {
                x = 0,
                y = (snapPoint.rotation),
                z = 0,
                } or nil,
            rotation_snap = snapPoint.rotation ~= nil and true or false,
            tags = snapPoint.tags or {}
            })
        end
        
        cardObj.setSnapPoints(generatedSnapPoints)
        
        deckObj.putObject(cardObj)
        cardObj.destruct()
    end
end



-- RESOURCE COUNTER FUNTIONS
function generateCounters()

    -- Look through all objects for objects with a "Func_ResourceCounter".
    for _, obj in ipairs(getObjects()) do
        local targetPlayer = nil
        local targetResource = nil
        for _, tag in ipairs(obj.getTags()) do
            if string.find(tag, "Func_ResourceCounter_") then
                targetResource =  string.sub(tag, 22)
            elseif string.find(tag, "PlayerAssigned_") then
                targetPlayer =  string.sub(tag, 16)
            end
        end
        
        if targetPlayer and targetResource then
            createResourceCounter(obj, targetPlayer, targetResource)
        end
    end
end

function createResourceCounter(obj, targetPlayer, targetResource)
    local currentValue = playerData[targetPlayer].resources[string.lower(targetResource)]
    local labelPos = {0, 0.31, 0.1}
    
    if targetResource == "Money" then
        -- Text shadow! (Weirdly the LAST label is the one rendered on top. TTS, I swear to the Gods.)
        obj.createButton({
          label=tostring(currentValue),
          click_function="none",
          function_owner=self,
          position={
            labelPos[1] + 0.05,
            labelPos[2] - 0.005,
            labelPos[3] + 0.05,
            },
          height=0,
          width=0,
          font_size=750,
          font_color={r=0, g=0, b=0, a=93}, -- Weirdly these are /100 and not /255
          color={r=0, g=0, b=0, a=0}
          })
    end
    -- The actual button.
    obj.createButton({
      label=tostring(currentValue),
      click_function="onClick_resourceCounter" .. obj.getGUID(),
      function_owner=self,
      position=labelPos,
      height=900,
      width=900,
      font_size=750,
      font_color={r=255, g=255, b=255, a=255},
      color={r=0, g=0, b=0, a=0}
      })
      
    -- Wrapper function to allow buttons to pass arguments
    local btnFunction = function(obj, player, alt_click)
        modifyPlayerResource(obj, alt_click, targetPlayer, targetResource)
    end
    
     _G["onClick_resourceCounter" .. obj.getGUID()] = btnFunction
end

function modifyPlayerResource(obj, alt_click, targetPlayer, targetResource)
    local currentValue = playerData[targetPlayer].resources[string.lower(targetResource)]
    currentValue = currentValue + (alt_click and -1 or 1)
    if currentValue < 0 then
        currentValue = 0
    elseif currentValue > 99 then
        currentValue = 99
    end
    
    playerData[targetPlayer].resources[string.lower(targetResource)] = currentValue
    
    updateResourceCounter(targetPlayer, targetResource, currentValue)
        
    onSave()
end

function updateResourceCounter(playerColour, targetResource, value)
    -- Find the relevant counter
    for _, obj in ipairs(getObjectsWithTag("Func_ResourceCounter_" .. targetResource)) do
        for _, tag in ipairs(obj.getTags()) do
            if tag == ("PlayerAssigned_" .. playerColour) then
                obj.editButton({
                    index=0,
                    label=tostring(value),
                    tooltip=tostring(value),
                    })
                if targetResource == "Money" then
                    obj.editButton({
                        index=1,
                        label=tostring(value),
                        tooltip=tostring(value),
                        })
                end
            end
        end
    end
end



-- ALLY CITY COUNTER FUNCTIONS
function generateAllyCityCounters()

    -- Look through all objects for objects with a "Func_AllyCounter".
    for _, obj in ipairs(getObjects()) do
        local targetPlayer = nil
        local targetAllyType = nil
        for _, tag in ipairs(obj.getTags()) do
            if string.find(tag, "Func_AllyCounter_") then
                targetAllyType =  string.sub(tag, 18)
            elseif string.find(tag, "PlayerAssigned_") then
                targetPlayer =  string.sub(tag, 16)
            end
        end
        
        if targetPlayer and targetAllyType then
            createAllyCityCOunter(obj, targetPlayer, targetAllyType)
        end
    end
end

function createAllyCityCOunter(obj, targetPlayer, targetAllyType)
    local currentValue = playerData[targetPlayer].cities[string.lower(targetAllyType)]
    local labelPos = {0, 0.14, 0.1}
    local labelScale = {x=1.32, y=1, z=1.32}
    if targetAllyType == "White" then 
        labelPos = {0, 0.14, -0.2}
        labelScale = {x=1.1, y=1, z=1.1}
    end
    
    -- Text shadow! (Weirdly the LAST label is the one rendered on top. TTS, I swear to the Gods.)
    obj.createButton({
      label=tostring(currentValue),
      click_function="none",
      function_owner=self,
      position={
        labelPos[1] + 0.05,
        labelPos[2] - 0.005,
        labelPos[3] + 0.05,
        },
      height=0,
      width=0,
      font_size=1000,
      font_color={r=0, g=0, b=0, a=93}, -- Weirdly these are /100 and not /255
      color={r=0, g=0, b=0, a=0},
      scale=labelScale,
      })
    -- The actual button.
    obj.createButton({
      label=tostring(currentValue),
      click_function="None",
      function_owner=self,
      position=labelPos,
      height=0,
      width=0,
      font_size=1000,
      font_color={r=255, g=255, b=255, a=255},
      color={r=0, g=0, b=0, a=0},
      scale=labelScale,
      })
end

function updateAllyCityCounter(playerColour, targetAllyType, value)
    -- Find the relevant counter
    for _, obj in ipairs(getObjectsWithTag("Func_AllyCounter_" .. targetAllyType)) do
        for _, tag in ipairs(obj.getTags()) do
            if tag == ("PlayerAssigned_" .. playerColour) then
                obj.editButton({
                    index=0,
                    label=tostring(value),
                    tooltip=tostring(value),
                    })
                obj.editButton({
                    index=1,
                    label=tostring(value),
                    tooltip=tostring(value),
                    })
            end
        end
    end
end

-- [→onCollisionObjectEnter]
-- [→onCollisionObjectExit]
function updateCollisionPlayerAllies(registered_object, collision_info)
    if registered_object ~= tableObjects.ExpeditionBoard then return end
    
    local playerColor = nil
    for _, tag in ipairs(collision_info.collision_object.getTags()) do
        if string.find(tag, "PlayerOwned_") then
            playerColor =  string.sub(tag, 13)
        end
    end
    if playerColor == nil then return end

    updatePlayerAllies(playerColor)
end

function updatePlayerAllies(playerColor)
    local allyCityCounts = tableObjects.ExpeditionBoard.call("countAllyCity", "PlayerOwned_" .. playerColor)
    for allyType, allyCount in pairs(allyCityCounts) do
        updateAllyCityCounter(playerColor, allyType, allyCount)
        playerData[playerColor].cities[string.lower(allyType)] = allyCount
    end
    
    onSave()
end