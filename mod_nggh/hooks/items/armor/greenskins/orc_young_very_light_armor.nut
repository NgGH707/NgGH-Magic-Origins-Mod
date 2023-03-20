::mods_hookExactClass("items/armor/greenskins/orc_young_very_light_armor", function(obj) 
{
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Name = "Tattered Hide Armor";
		this.m.Description = "A makeshift hide armor. It looks like garbage.";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 40;
		this.m.ConditionMax = 40;
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "armor/icon_orc_01_armor_03.png";
    }

    obj.onEquip <- function()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
});