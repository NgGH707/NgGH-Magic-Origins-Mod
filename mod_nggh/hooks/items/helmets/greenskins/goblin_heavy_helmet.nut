::mods_hookExactClass("items/helmets/greenskins/goblin_heavy_helmet", function(obj) 
{
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Variant = 1;
    	this.m.Name = "Goblin Helm";
		this.m.Description = "A helmet made for the elite troops.";
		this.m.InventorySound = this.m.ImpactSound;
		this.updateVariant();
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "helmets/inventory_goblin_01_helmet_02.png";
    }

    obj.onEquip <- function()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
});