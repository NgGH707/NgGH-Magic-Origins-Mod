this.perk_magic_training_1 <- this.inherit("scripts/skills/skill", {
	m = {
		IsGainBuff = false,
	},
	function create()
	{
		this.m.ID = "perk.magic_training_1";
		this.m.Name = this.Const.Strings.PerkName.MC_MagicTraining1;
		this.m.Description = this.Const.Strings.PerkDescription.MC_MagicTraining1;
		this.m.Icon = "ui/perks/perk_magic_training_1.png";
		this.m.IconMini = "perk_magic_training_1_mini";
		this.m.Overlay = "perk_magic_training_1";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsHasMagicTraining = true;

		if (this.m.IsGainBuff)
		{
			_properties.BraveryMult *= 1.25;
		}
	}

	function onTurnStart()
	{
		this.m.IsGainBuff = this.Math.rand(1, 100) <= 10;
		if (this.m.IsGainBuff) this.spawnIcon("perk_magic_training_1", this.getContainer().getActor().getTile());
	}

});

