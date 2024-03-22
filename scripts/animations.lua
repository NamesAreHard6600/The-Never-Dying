local path = mod_loader.mods[modApi.currentMod].resourcePath
local mod = mod_loader.mods[modApi.currentMod]
local resourcePath = mod.resourcePath

modApi:appendAsset("img/animations/NAH_Protected_Anim.png", resourcePath.."img/animations/NAH_Protected_Anim.png")

ANIMS["NAH_Protected_Anim"] = Animation:new {
  Image = "animations/NAH_Protected_Anim.png",
  NumFrames = 9,
  Time = 0.1,
  PosX = -33,
  PosY = -14,
}
