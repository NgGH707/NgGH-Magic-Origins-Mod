this.nggh_mod_mind_break_effect <- ::inherit("scripts/skills/skill", {
	m = {
		Count = 1,
		TurnsLeft = 3
	},
	function create()
	{
		this.m.ID = "effects.mind_break";
		this.m.Name = "Mind Broken";
		this.m.Icon = "skills/status_effect_52.png";
		this.m.IconMini = "status_effect_52_mini";
		this.m.Overlay = "status_effect_52";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getName()
	{
		if (this.m.Count <= 1)
		{
			return this.m.Name;
		}
		else
		{
			return this.m.Name + " (x" + this.m.Count + ")";
		}
	}

	function getDescription()
	{
		return "This character\'s mental health is at its worst, being deteriorated by horrified image flashing non-stop in his head. Becoming extremely vulnerable to other mental attacks. Will wear off after [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] turn(s).";
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
				id = 6,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-" + (5 * this.m.Count) + "[/color] Resolve"
			},
		];
	}

	function onAdded()
	{
		this.m.TurnsLeft = ::Math.max(1, this.m.TurnsLeft + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
	}

	function onRefresh()
	{
		++this.m.Count;
		this.m.TurnsLeft = ::Math.min(3, ::Math.max(1, this.m.TurnsLeft + 1 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration));
	}

	function onUpdate( _properties )
	{
		_properties.Bravery -= 5 * this.m.Count;
	}

	function onTurnStart()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}

		this.m.Count = ::Math.max(1, this.m.Count - 1);
	}

});

