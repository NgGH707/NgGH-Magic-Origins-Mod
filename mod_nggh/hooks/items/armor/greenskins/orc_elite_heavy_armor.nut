::mods_hookExactClass("items/armor/greenskins/orc_elite_heavy_armor", function(obj) 
{
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Name = "Bloody Looted Plate Armor";
		this.m.Description = "A makeshift armor made from various armor remains from many battles. It has been dyed red by blood.";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.InventorySound = this.m.ImpactSound;
		//this.m.Condition = 500; // 600
		//this.m.ConditionMax = 500;
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "armor/icon_orc_elite_armor_01.png";
    }

    obj.onEquip <- function()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
});