::mods_hookExactClass("items/helmets/barbarians/unhold_helmet_heavy", function(obj) 
{
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Name = "Unhold Metal Helmet";
		this.m.Description = "Heavy metal helmet for a giant, offers great protection.";
		this.m.Icon = "helmets/inventory_armored_unhold_head_01.png";
		this.m.StaminaModifier = -20;
		this.m.Vision = -2;
    }

    obj.onEquip <- function()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
	}
});