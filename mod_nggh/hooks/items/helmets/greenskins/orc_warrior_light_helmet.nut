::mods_hookExactClass("items/helmets/greenskins/orc_warrior_light_helmet", function(obj) 
{
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Variants = [1, 4];
    	this.m.Name = "Looted Nasal Helmet";
		this.m.Description = "A makeshift helmet crafted from looted nasal helmets, quite light.";
		this.m.InventorySound = this.m.ImpactSound;
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "helmets/inventory_orc_03_helmet_0" + this.m.Variant + ".png";
    }

    obj.onEquip <- function()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
});