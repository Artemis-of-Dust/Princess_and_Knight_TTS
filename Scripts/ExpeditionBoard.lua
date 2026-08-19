-- List of snapPoints to set onto the board. (Note this overrides the old ones with the most recent version.)
expeditionBoardSnapPoints = {
}

local allyCitySnapPoints = {
    slot1 = {x=-0.805, z= 0.320, rotation= 30},
    slot2 = {x=-0.425, z= 0.090, rotation= 15},
    slot3 = {x= 0.000, z= 0.000, rotation= 00},
    slot4 = {x= 0.425, z= 0.090, rotation=-15},
    slot5 = {x= 0.805, z= 0.320, rotation=-30},
    }

local allyCities = {
    whiteCity1 = {x=-1.36, z=-0.79, allyType="White"},
    whiteCity2 = {x=-2.37, z= 2.07, allyType="White"},
    whiteCity3 = {x=-4.18, z=-7.90, allyType="White"},
    whiteCity4 = {x= 2.53, z=-7.89, allyType="White"},
    whiteCity5 = {x= 5.53, z=-7.89, allyType="White"},
    whiteCity6 = {x= 4.19, z=-0.39, allyType="White"},
    whiteCity7 = {x= 6.92, z= 4.34, allyType="White"},
    blueCity1  = {x=-4.59, z= 0.10, allyType="Blue"},
    blueCity2  = {x=-6.71, z=-4.42, allyType="Blue"},
    blueCity3  = {x=-0.85, z=-7.89, allyType="Blue"},
    blueCity4  = {x= 4.62, z=-5.17, allyType="Blue"},
    blueCity5  = {x= 5.56, z= 1.89, allyType="Blue"},
    greenCity1 = {x= 1.22, z= 0.39, allyType="Green"},
    greenCity2 = {x=-7.11, z=-1.53, allyType="Green"},
    greenCity3 = {x=-2.98, z=-5.33, allyType="Green"},
    greenCity4 = {x= 3.21, z=-3.10, allyType="Green"},
    greenCity5 = {x= 7.15, z=-5.64, allyType="Green"},
    redCity1   = {x=-0.41, z=-3.21, allyType="Red"},
    redCity2   = {x=-4.10, z=-2.84, allyType="Red"},
    redCity3   = {x=-7.11, z=-6.77, allyType="Red"},
    redCity4   = {x=-0.12, z=-5.89, allyType="Red"},
    redCity5   = {x= 5.86, z=-2.61, allyType="Red"},
    }

local royalPrestigeCorners = {
    left    = -1.65,
    right   = -6.95,
    up      =  5.22,
    down    =  7.24,
    }

local roundMarkerPositions = {
    left    = -4.22,
    right   = -7.72,
    up      =  1.99,
    down    =  2.98,
    }

function generateSnapPoints()
    for _, city in pairs(allyCities) do
        for _, snappoint in pairs(allyCitySnapPoints) do
            local newSnapPoint = {
                x = city.x + snappoint.x,
                z = city.z + snappoint.z,
                rotation =  snappoint.rotation,
                allyType = city.allyType
                }
            table.insert(expeditionBoardSnapPoints, newSnapPoint)
        end
    end
end

function onLoad()
    generateSnapPoints()
    setSnapPoints()
    
    self.registerCollisions()
end

function setSnapPoints()
    local generatedSnapPoints = {}
    
    -- Ally Cities
    for _, snapPoint in pairs(expeditionBoardSnapPoints) do
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
    
    -- Royal Prestige board
    local horizontalIncrement = (royalPrestigeCorners.right - royalPrestigeCorners.left) / 11
    local verticalIncrement = (royalPrestigeCorners.down - royalPrestigeCorners.up) / 4
    for n=1,5,1 do
        for i=1,12,1 do
            table.insert(generatedSnapPoints, {
            position = {
                x = royalPrestigeCorners.left + horizontalIncrement*(i-1),
                y = 0.5,
                z = royalPrestigeCorners.up + verticalIncrement*(n-1),
                },
            rotation_snap = false,
            tags = {}
            })
        end
        
        table.insert(generatedSnapPoints, {
            position = {
                x = royalPrestigeCorners.right - 0.58,
                y = 0.5,
                z = royalPrestigeCorners.up + verticalIncrement*(n-1),
                },
            rotation_snap = false,
            tags = {}
            })
    end
    
    -- Round Marker / Turn Order positions
    for i=1,6,1 do
        local horizontalIncrement = (roundMarkerPositions.right - roundMarkerPositions.left) / 5
    
        table.insert(generatedSnapPoints, {
            position = {
                x = roundMarkerPositions.left + horizontalIncrement*(i-1),
                y = 0.5,
                z = roundMarkerPositions.up,
                },
            rotation_snap = false,
            tags = {}
            })
        if i ~= 1 then
            table.insert(generatedSnapPoints, {
                position = {
                    x = roundMarkerPositions.left + horizontalIncrement*(i-1),
                    y = 0.5,
                    z = roundMarkerPositions.down,
                    },
                rotation_snap = false,
                tags = {}
                })
        end
    end
    
    -- Set Snap Points
    self.setSnapPoints(generatedSnapPoints)
end

function countAllyCity(objTag)
    
    local allyCount = {
        White = 0,
        Blue  = 0,
        Green = 0,
        Red   = 0,
        }
    
    for _, allyCity in pairs(allyCities) do
        local checkPos = {
            minX = allyCity.x - 1.9,
            maxX = allyCity.x + 1.9,
            minY = 0,
            maxY = 1,
            minZ = allyCity.z - 1.05,
            maxZ = allyCity.z + 1.35,
        }
        for _, obj in pairs(getObjectsWithTag(objTag)) do
            local relativePos = self.positionToLocal(obj.getPosition())
            if relativePos.x > checkPos.minX and
               relativePos.x < checkPos.maxX and
               relativePos.y > checkPos.minY and
               relativePos.y < checkPos.maxY and
               relativePos.z > checkPos.minZ and
               relativePos.z < checkPos.maxZ then
                allyCount[allyCity.allyType] = allyCount[allyCity.allyType] + 1
                break
            end
        end
    end
    
    return allyCount
end