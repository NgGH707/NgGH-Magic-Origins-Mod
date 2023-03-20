this.nggh_mod_summon_mirror_image_skill <- ::inherit("scripts/skills/skill", {
	m = {
		IsSpent = false,
	},
	function create()
	{
		this.m.ID = "actives.mirror_image";
		this.m.Name = "Mirror Image";
		this.m.Description = "Create mirror copies of yourself from all over the map to aid for your cause.";
		this.m.Icon = "skills/active_218.png";
		this.m.IconDisabled = "skills/active_218_sw.png";
		this.m.Overlay = "active_218";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/mirror_image_01.wav",
			"sounds/enemies/dlc6/mirror_image_02.wav",
			"sounds/enemies/dlc6/mirror_image_03.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.NonTargeted;
		this.m.Delay = 0;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAudibleWhenHidden = false;
		this.m.IsUsingActorPitch = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
		this.m.MaxLevelDifference = 4;
	}

	function onAdded()
	{
		this.getContainer().getActor().getAIAgent().addBehavior(::new("scripts/ai/tactical/behaviors/nggh_mod_ai_mirror_image_player"));
	}

	function onRemoved()
	{
		this.getContainer().getActor().getAIAgent().removeBehavior(::Const.AI.Behavior.ID.MirrorImage);
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();

		if (this.m.IsSpent)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can only be used once per battle[/color] "
			});
		}

		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.IsSpent;
	}

	function onUse( _user, _targetTile )
	{
		this.m.IsSpent = true;
		::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " transcends time and place!");

		if (!_user.getAIAgent().hasKnownOpponent())
		{
			local strategy = _user.getAIAgent().getStrategy().update();

			do
			{
			}
			while (!resume strategy);
		}

		local b = _user.getAIAgent().getBehavior(::Const.AI.Behavior.ID.MirrorImage);

		if (b != null)
		{
			b.onEvaluate(_user);
			return b.onExecute(_user);
		}

		return true;
	}

	function onCombatStarted()
	{
		this.m.IsSpent = false;
	}

	function onCombatFinished()
	{
		this.m.IsSpent = false;
	}

});

