this.intimidated_effect <- this.inherit("scripts/skills/skill", {
	m = {
		IsWorsen = false
	},
	function create()
	{
		this.m.ID = "effects.intimidated";
		this.m.Name = "Intimidated";
		this.m.Description = "TODO";
		this.m.Icon = "ui/perks/perk_intimidate.png";
		this.m.IconMini = "perk_intimidate_mini";
		this.m.Overlay = "perk_intimidate";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsStacking = true;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onAdded()
	{
		this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());

		if (this.m.IsWorsen)
		{
			this.m.Name = "Intimidated (extreme)";
		}
	}

	function onUpdate( _properties )
	{
		local mult = this.m.IsWorsen ? 1 : 0.5;
		_properties.MeleeSkillMult *= 1 - (0.1 * mult);
		_properties.RangedSkillMult *= 1 - (0.1 * mult);
		_properties.MeleeDefenseMult *= 1 - (0.1 * mult);
		_properties.MeleeDefenseMult *= 1 - (0.1 * mult);
		_properties.InitiativeMult *= 1 - (0.1 * mult);
		_properties.Bravery *= 1 - (0.1 * mult);
	}

	function onTurnEnd()
	{
		this.removeSelf();
	}

});

