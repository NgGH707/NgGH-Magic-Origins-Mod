this.blessed_shadow_demon_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2
	},
	function create()
	{
		this.m.ID = "effects.blessed_shadow_demon";
		this.m.Name = "Banned Simp";
		this.m.Icon = "skills/status_effect_85.png";
		this.m.IconMini = "status_effect_85_mini";
		this.m.Overlay = "";
		this.m.SoundOnUse = "";
		this.m.IsHidden = true;
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
	}
	
	//function getDescription()
	//{
	//	return "Due to recent event this character has been through a harsh time. He has been temporarily banned from OnlyFans. Still horny but have no mean to subdue it.";
	//}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
	}

	function onAdded()
	{
		this.onRefresh();
	}

	function onRefresh()
	{
		local actor = this.getContainer().getActor();
		local HP = this.getHitpointsPct();
		local addedHP = this.Math.minf(this.Math.rand(25, 33) * 0.01, 1.0 - HP);

		if (addedHP > 0.0)
		{
			actor.setHitpointsPct(HP + addedHP);
		}
	}

	function onTurnStart()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}
	
	function onUpdate( _properties )
	{
		_properties.DamageTotalMult *= 1.25;
		_properties.DamageReceivedRegularMult *= 0.75;
	}

});

