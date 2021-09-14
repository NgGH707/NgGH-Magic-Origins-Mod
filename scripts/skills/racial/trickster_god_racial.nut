this.trickster_god_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.trickster_god";
		this.m.Name = "Godly Regeneration";
		this.m.Description = "Such unimaginable scene unfolds before your eyes. Is this regeneration?";
		this.m.Icon = "skills/status_effect_79.png";
		this.m.IconMini = "status_effect_79_mini";
		this.m.SoundOnUse = [
			"sounds/enemies/unhold_regenerate_01.wav",
			"sounds/enemies/unhold_regenerate_02.wav",
			"sounds/enemies/unhold_regenerate_03.wav"
		];
		this.m.Type = this.Const.SkillType.Racial;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}
	
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
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Regenerates [color=" + this.Const.UI.Color.NegativeValue + "]6%[/color] of max health"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has all attacks [color=" + this.Const.UI.Color.PositiveValue + "]Ignore[/color] knock back immunity"
			}
		];
	}
	
	function onAdded()
	{
		if (!this.getContainer().getActor().isPlayerControlled())
		{
			return;
		}
		
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
		this.getContainer().update();
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		local healthMissing = actor.getHitpointsMax() - actor.getHitpoints();
		local healthAdded = this.Math.min(healthMissing, this.Math.floor(actor.getHitpointsMax() * 0.06));

		if (healthAdded <= 0)
		{
			return;
		}

		actor.setHitpoints(actor.getHitpoints() + healthAdded);
		actor.setDirty(true);

		if (!actor.isHiddenToPlayer())
		{
			this.spawnIcon("status_effect_79", actor.getTile());

			if (this.m.SoundOnUse.len() != 0)
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());
			}

			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " heals for " + healthAdded + " points");
		}
	}

});

