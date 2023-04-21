this.nggh_mod_kraken_ensnare_effect <- ::inherit("scripts/skills/skill", {
	m = {
		DamageMult = 1.0,
		Mode = 0,
		LastRoundApplied = 0,
		SpriteScaleBackup = 1.0,
		OnRemoveCallback = null,
		OnRemoveCallbackData = null,
		ParentID = null
	},
	function setOnRemoveCallback( _c, _d )
	{
		this.m.OnRemoveCallback = _c;
		this.m.OnRemoveCallbackData = _d;
	}

	function setMode( _f )
	{
		this.m.Mode = _f;
	}

	function setParentID( _p )
	{
		this.m.ParentID = _p;
	}

	function setDamageMult( _d )
	{
		this.m.DamageMult = _d;
	}

	function create()
	{
		this.m.ID = "effects.kraken_ensnare";
		this.m.Name = "Entangled";
		this.m.Description = "This character is entangled in a giant tentacle, drawing them ever closer to a gaping maw that threatens to devour them whole.";
		this.m.Icon = "skills/status_effect_95.png";
		this.m.IconMini = "status_effect_95_mini";
		this.m.Overlay = "status_effect_95";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/krake_choke_01.wav",
			"sounds/enemies/dlc2/krake_choke_02.wav",
			"sounds/enemies/dlc2/krake_choke_03.wav",
			"sounds/enemies/dlc2/krake_choke_04.wav",
			"sounds/enemies/dlc2/krake_choke_05.wav"
		];
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
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
				text = this.m.Mode == 0 ? this.getDescription() : "This character is entangled in a giant tentacle, drawing them ever closer to a gaping maw that threatens to devour them whole. Each turn, the tentacle threatens to crush them by gripping ever tighter, resulting in the loss of [color=" + this.Const.UI.Color.NegativeValue + "]" + this.Math.floor(this.m.DamageMult * 15) + "[/color] - [color=" + this.Const.UI.Color.NegativeValue + "]" + this.Math.floor(this.m.DamageMult * 20) + "[/color] hitpoints."
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Unable to move[/color]"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Unable to use skills[/color]"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]-50%[/color] Initiative"
			}
		];
	}

	function applyDamage( _isForce = false )
	{
		if (_isForce || this.m.LastRoundApplied != ::Time.getRound())
		{
			local damage = ::Math.rand(35, 55);

			if (!_isForce)
			{
				damage = ::Math.rand(15, 20);
				this.m.LastRoundApplied = ::Time.getRound();
			}

			if (this.m.SoundOnUse.len() != 0)
			{
				::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.0, this.getContainer().getActor().getPos());
			}

			this.spawnIcon("status_effect_95", this.getContainer().getActor().getTile());
			local hitInfo = clone ::Const.Tactical.HitInfo;
			hitInfo.DamageRegular = damage * this.m.DamageMult;
			hitInfo.DamageArmor = hitInfo.DamageRegular * 1.25;
			hitInfo.DamageDirect = 0.3;
			hitInfo.BodyPart = ::Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			this.getContainer().getActor().onDamageReceived(this.getContainer().getActor(), this, hitInfo);
		}
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		local sprite1 = actor.getSprite("status_rooted");
		local sprite2 = actor.getSprite("status_rooted_back");
		this.m.SpriteScaleBackup = sprite1.Scale;
		sprite1.Scale = 1.0;
		sprite2.Scale = 1.0;

		local drag_AI = ::new("scripts/ai/tactical/behaviors/nggh_mod_ai_drag");
		drag_AI.setParentID(this.m.ParentID);
		actor.getAIAgent().addBehavior(drag_AI);

		local drag = ::new("scripts/skills/actives/nggh_mod_kraken_move_ensnared_skill");
		drag.m.ParentID = this.m.ParentID;
		this.getContainer().add(drag);

		::Tactical.TurnSequenceBar.pushEntityBack(this.getContainer().getActor().getID());

		if (this.m.ParentID != null)
		{
			::Tactical.TurnSequenceBar.pushEntityBack(this.m.ParentID);
		}
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		actor.getSprite("status_rooted").Scale = this.m.SpriteScaleBackup;
		actor.getSprite("status_rooted_back").Scale = this.m.SpriteScaleBackup;
		actor.getAIAgent().removeBehavior(::Const.AI.Behavior.ID.Drag);
		this.getContainer().removeByID("actives.kraken_move_ensnared");

		if (this.m.OnRemoveCallback != null && !::Tactical.Entities.isCombatFinished())
		{
			this.m.OnRemoveCallback(this.m.OnRemoveCallbackData);
		}
	}

	function onDeath( _fatalityType )
	{
		if (this.m.OnRemoveCallbackData != null)
		{
			this.m.OnRemoveCallbackData.LoseHitpoints = false;
		}

		this.onRemoved();
	}

	function onUpdate( _properties )
	{
		_properties.IsRooted = true;
		_properties.IsAbleToUseSkills = false;
		_properties.InitiativeMult *= 0.5;
	}

	// don't rememver why i added this
	function onAfterUpdate( _properties )
	{
		_properties.Vision = 7;
	}

	function onNewRound()
	{
		this.getContainer().getActor().getTile().addVisibilityForFaction(::Const.Faction.Player);
	}

	function onTurnEnd()
	{
		this.applyDamage();
	}

	function onWaitTurn()
	{
		this.applyDamage();
	}

});

