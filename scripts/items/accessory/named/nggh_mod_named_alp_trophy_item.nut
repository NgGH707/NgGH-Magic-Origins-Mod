this.nggh_mod_named_alp_trophy_item <- ::inherit("scripts/items/accessory/named/nggh_mod_named_accessory", {
	m = {},
	function create()
	{
		this.m.Bravery = 5;
		this.m.Initiative = 10;
		this.m.SpecialValue = 15;
		this.nggh_mod_named_accessory.create();
		this.m.ID = "accessory.named_alp_trophy";
		this.m.Name = "Alp Trophy Necklace";
		this.m.DefaultName = "Trophy Necklace";
		this.m.Description = "This necklace fashioned from trophies taken of the most powerful Alp declares the one wearing it a veteran of battle against supernatural nocturnal predators, and not easily daunted.";
		this.m.Icon = "accessory/named_alp_trophy.png";
		this.m.Sprite = "alp_trophy";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Value = 4000;
	}

	function getTooltip()
	{
		local result = this.nggh_mod_named_accessory.getTooltip();
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + this.m.SpecialValue + "[/color] Resolve at morale checks against fear, panic or mind control effects."
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.nggh_mod_named_accessory.onUpdateProperties(_properties);
		_properties.MoraleCheckBravery[::Const.MoraleCheckType.MentalAttack] += this.m.SpecialValue;
	}

});

