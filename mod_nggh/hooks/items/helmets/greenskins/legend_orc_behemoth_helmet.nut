::mods_hookExactClass("items/helmets/greenskins/legend_orc_behemoth_helmet", function(obj) 
{
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Name = "Behemoth Helm";
		this.m.Description = "A giant helmet make for the toughest, the most badass champion.";
		this.m.InventorySound = this.m.ImpactSound;
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "helmets/inventory_legend_orc_behemoth_helmet_01.png";
    }

    obj.onEquip <- function()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
});