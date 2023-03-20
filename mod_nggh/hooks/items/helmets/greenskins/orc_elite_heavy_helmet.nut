::mods_hookExactClass("items/helmets/greenskins/orc_elite_heavy_helmet", function(obj) 
{
	// need to add set effect
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Name = "Bloody Metal Plate Helmet";
		this.m.Description = "A makeshift helmet which is dyed in blood. It is stink but has exceptional durability.";
		this.m.InventorySound = this.m.ImpactSound;
		this.m.StaminaModifier = -40;
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "helmets/inventory_orc_elite_helmet_01.png";
    }

    obj.onEquip <- function()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
});