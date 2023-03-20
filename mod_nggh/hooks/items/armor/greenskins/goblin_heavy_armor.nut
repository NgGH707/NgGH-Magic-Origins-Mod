::mods_hookExactClass("items/armor/greenskins/goblin_heavy_armor", function(obj) 
{
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	//this.m.Variants = [2, 4];
    	this.m.Name = "Goblin Reinforced Leather Armor";
		this.m.Description = "An armor made for the elite troops";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.InventorySound = this.m.ImpactSound;
		this.m.StaminaModifier = -4;
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "armor/icon_goblin_01_armor_0" + this.m.Variant + ".png";
    }

    obj.onEquip <- function()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
});