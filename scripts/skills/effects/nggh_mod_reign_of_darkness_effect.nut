this.nggh_mod_reign_of_darkness_effect <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.reign_of_darkness";
		this.m.Name = "Engulfed By Darkness";
		this.m.Icon = "skills/status_effect_81.png";
		this.m.IconMini = "status_effect_81_mini";
		this.m.Overlay = "status_effect_81";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/nightmare_01.wav",
			"sounds/enemies/dlc2/nightmare_02.wav",
			"sounds/enemies/dlc2/nightmare_03.wav",
			"sounds/enemies/dlc2/nightmare_04.wav",
			"sounds/enemies/dlc2/nightmare_05.wav",
			"sounds/enemies/dlc2/nightmare_06.wav",
			"sounds/enemies/dlc2/nightmare_07.wav",
			"sounds/enemies/dlc2/nightmare_08.wav"
		];
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "This character is consumed by unnatural darkness and is showing signs of fear. As the horrors eat away at his sanity, he would soon be broken.";
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
				id = 9,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-5%[/color] Resolve"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-10%[/color] Initiative"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "More vulnerable against [color=" + ::Const.UI.Color.NegativeValue + "]Nightmare[/color]"
			}
		];
	}

	function onNewRound()
	{
		local myTile = this.getContainer().getActor().getTile();

		if (myTile.Properties.Effect == null || myTile.Properties.Effect.Timeout == ::Time.getRound() || myTile.Properties.Effect.Type != "shadows")
		{
			this.removeSelf();
		}
	}

	function onMovementCompleted( _tile )
	{
		if (_tile.Properties.Effect == null || _tile.Properties.Effect.Type != "shadows")
		{
			this.removeSelf();
		}
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();

		if (actor.hasSprite("status_stunned"))
		{
			actor.getSprite("status_stunned").Visible = false;
		}

		actor.setDirty(true);
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		_properties.BraveryMult *= 0.95;
		_properties.InitiativeMult *= 0.9;

		if (actor.hasSprite("status_stunned"))
		{
			actor.getSprite("status_stunned").setBrush("bust_nightmare");
			actor.getSprite("status_stunned").Visible = true;
			actor.setDirty(true);
		}
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{	
		if (_skill == null)
		{
			return;
		}

		if (_attacker == null)
		{
			return;
		}

		if (_attacker.getFlags().has("shadow"))
		{
		}
		else if (_skill.getID() != "actives.nightmare")
		{
			return;
		}
		
		_properties.DamageReceivedRegularMult *= 1.25;
	}

});

