::mods_hookExactClass("items/armor/greenskins/orc_warrior_heavy_armor", function(obj) 
{
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	//this.m.Variants = [3, 4, 5];
    	this.m.Name = "Looted Plate Armor";
		this.m.Description = "A makeshift armor made from various armor remains from many battles.";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.InventorySound = this.m.ImpactSound;
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "armor/icon_orc_03_armor_0" + this.m.Variant + ".png";
    }

    obj.onEquip <- function()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
});