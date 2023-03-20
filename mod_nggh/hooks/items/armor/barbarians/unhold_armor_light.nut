::mods_hookExactClass("items/armor/barbarians/unhold_armor_light", function(obj) 
{
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Name = "Unhold Restrainting Chain";
		this.m.Description = "Barbarians of the north often use this to restraint their unholds like hound.";
    	this.m.Icon = "armor/icon_armored_unhold_body_02.png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
    }

    obj.onEquip <- function()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
});