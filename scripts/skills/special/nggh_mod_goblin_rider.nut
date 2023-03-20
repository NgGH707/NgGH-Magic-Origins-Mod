this.nggh_mod_goblin_rider <- ::inherit("scripts/skills/nggh_mod_rider_skill", {
	m = {},
	function create()
	{
		this.nggh_mod_rider_skill.create();
		this.m.ID = "special.goblin_rider";
		this.m.Name = "Mounting";
		this.m.Description = "Have great mobility and tactical advantages but harder to using most ranged weapon while mounted. Gain a biting attack than can be used for free once per turn.";
		this.m.Icon = "ui/perks/impulse_perk.png";
		this.m.IconMini = "impulse_perk_mini";
	}

	function getDescription()
	{
		if (this.getManager() == null)
		{
			return this.m.Description;
		}
		
		return "You\'re riding on [color=#1e468f]" + this.getManager().getMount().getName() + "[/color]! There are advantages for doing it, mobility for example. But in the end, there is another life for you to worry for.";
	}

});

