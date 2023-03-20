::mods_hookExactClass("items/armor/greenskins/legend_orc_behemoth_armor", function(obj) 
{
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.ID = "armor.body.legend_orc_behemoth_armor";
    	this.m.Name = "Looted Reinforced Mail";
		this.m.Description = "A huge armor made for the champion of all orcs.";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.InventorySound = this.m.ImpactSound;
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "armor/icon_legend_orc_behemoth_armour_01.png";
    }

    obj.onEquip <- function()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
});