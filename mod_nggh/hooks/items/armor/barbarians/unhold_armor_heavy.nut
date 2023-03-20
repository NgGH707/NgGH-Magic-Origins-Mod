::mods_hookExactClass("items/armor/barbarians/unhold_armor_heavy", function(obj) 
{
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Name = "Unhold Plated Battle Gear";
		this.m.Description = "Crude armor made from metal plate for a giant creature, very durable.";
		this.m.Icon = "armor/icon_armored_unhold_body_01.png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
    }

    obj.onEquip <- function()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
});