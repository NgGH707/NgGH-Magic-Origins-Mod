this.nggh_mod_named_ghoul_trophy_item <- ::inherit("scripts/items/accessory/named/nggh_mod_named_accessory", {
	m = {},
	function create()
	{
		this.m.Bravery = 4;
		this.m.DamageMult = 1.05;
		this.nggh_mod_named_accessory.create();
		this.m.ID = "accessory.named_ghoul_trophy";
		this.m.Name = "Nachzehrer Trophy Necklace";
		this.m.DefaultName = "Trophy Necklace";
		this.m.Description = "This necklace fashioned from trophies taken of the strongest Nachzehrer declares the one wearing it a veteran of battle against feral beasts, and not easily daunted.";
		this.m.Icon = "accessory/named_nachzehrer_trophy.png";
		this.m.Sprite = "nachzehrer_trophy";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Value = 3500;
	}

	function getTooltip()
	{
		local result = this.nggh_mod_named_accessory.getTooltip();
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "Reduces the Resolve of any opponent engaged in melee by [color=" + ::Const.UI.Color.NegativeValue + "]-3[/color]"
		});
		return result;
	}

	/*
	function getSellPriceMult()
	{
		return this.World.State.getCurrentTown().getBeastPartsPriceMult();
	}

	function getBuyPriceMult()
	{
		return this.World.State.getCurrentTown().getBeastPartsPriceMult();
	}
	*/

	function onUpdateProperties( _properties )
	{
		this.nggh_mod_named_accessory.onUpdateProperties(_properties);
		_properties.Threat += 3;
	}

});

