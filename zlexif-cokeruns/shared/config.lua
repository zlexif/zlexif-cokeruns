Config = {}

-- NPC Configuration
Config.NPC = {
    coords = vector3(5011.93, -5754.0, 27.9), -- Replace with desired coordinates
    heading = 62.52,  -- Replace with desired heading
    model = 'a_m_m_farmer_01'  -- Replace with the model you want for the NPC
}

-- Burner Phone Configuration
Config.BurnerPhone = 'burnerphone'  -- The item code for the burner phone
Config.OrderCancellationFee = 100   -- Cancellation fee amount


-- Deal Completion Configuration
Config.RewardItem = 'cokebaggy' -- Reward item code, adjust to your item name
Config.RewardAmount = 1 -- Amount of reward item
Config.DealDuration = 16000 -- Duration for discussing deal in milliseconds (16 seconds)

-- Deal Zone Configuration
Config.DealZone = {
    coords = vector3(5256.09, -5431.41, 64.97),  -- Replace with the center of the circle zone you desire
    radius = 100.0,  -- Replace with the radius of the circle zone you desire
    debugPoly = false  -- Set to true to see the zone during development
}



-- Debug Mode for PolyZone (set to `true` for visualizing the zone during development)
Config.Debug = false
