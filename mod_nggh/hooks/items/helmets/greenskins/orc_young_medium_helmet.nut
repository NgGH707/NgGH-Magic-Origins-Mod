::mods_hookExactClass("items/helmets/greenskins/orc_young_medium_helmet", function(obj) 
{
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Name = "Hide Head Gear";
		this.m.Description = "A hide helmet that offers some protection.";
		this.m.InventorySound = this.m.ImpactSound;
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "helmets/inventory_orc_01_helmet_0" + this.m.Variant + ".png";
    }

    obj.onEquip <- function()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
});