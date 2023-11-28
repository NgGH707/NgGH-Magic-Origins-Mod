// new type id
::Const.ProjectileType.NggH_Rock <- ::Const.ProjectileSprite.len();
// projectile sprite
::Const.ProjectileSprite.push("projectile_mod_rock");
// detail sprite on the ground when the projectile missed the target then hit the ground
::Const.ProjectileDecals.push([]);
// reset the total count
::Const.ProjectileType.COUNT = ::Const.ProjectileSprite.len();

::logInfo("New Boulder projectile, Type: " + ::Const.ProjectileType.NggH_Rock + ", Sprite len: " + ::Const.ProjectileSprite.len());
