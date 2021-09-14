this.charmed_pet_effect <- this.inherit("scripts/skills/skill", {
	m = {
		LootScript = null,
		Master = null,
		TurnsLeft = 10,
	},
	function create()
	{
		this.m.ID = "effects.charmed_pet";
		this.m.Name = "Charmed";
		this.m.Icon = "skills/status_effect_85.png";
		this.m.IconMini = "status_effect_85_mini";
		this.m.Overlay = "status_effect_85";
		this.m.SoundOnUse = [];
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
	}
	
	function getDescription()
	{
		return "This character has been charmed by you. He no longer has any control over his actions and is a puppet that has no choice but to obey his master.";
	}

	function getTooltip()
	{
		local ret = [
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
		];

		return ret;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		//actor.setFaction(this.Const.Faction.PlayerAnimals);
		actor.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 5.0;
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();
		--this.m.TurnsLeft;
		this.Const.HexenOrigin.Magic.SpawnCharmParticleEffect(myTile);
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		actor.setMoraleState(this.Const.MoraleState.Fleeing);

		if (actor.hasSprite("status_charm"))
		{
			local charm = actor.getSprite("status_charm");
			local fadeIn = !charm.Visible;

			if (fadeIn)
			{
				charm.setBrush("bust_captive_charm");
				charm.Alpha = 0;
				charm.Visible = true;
				charm.fadeIn(700);
				actor.setDirty(true);
			}
		}
		else
		{
			local charm = actor.addSprite("status_charm");
			charm.setBrush("bust_captive_charm");
			charm.Alpha = 0;
			charm.Visible = true;
			charm.fadeIn(700);
			actor.setDirty(true);
		}
	}

	function onAfterUpdate( _properties )
	{
		//_properties.Bravery = 999;
		_properties.IsAbleToUseSkills = false;
		_properties.IsImmuneToZoneOfControl = true;
		_properties.BraveryMult /= 0.7;
		_properties.MeleeSkillMult /= 0.7;
		_properties.RangedSkillMult /= 0.7;
		_properties.MeleeDefenseMult /= 0.7;
		_properties.RangedDefenseMult /= 0.7;
	}

	function onCombatFinished()
	{
		local actor = this.getContainer().getActor();

		if (!(this.Tactical.State.m.StrategicProperties != null && this.Tactical.State.m.StrategicProperties.IsArenaMode) && actor.m.WorldTroop != null && ("Party" in actor.m.WorldTroop) && actor.m.WorldTroop.Party != null)
		{
			actor.m.WorldTroop.Party.removeTroop(actor.m.WorldTroop);
		}
	}

	function onAddPetToLoot()
	{
		if (this.Tactical.State.m.StrategicProperties != null && this.m.LootScript != null)
		{
			if (!("Loot" in this.Tactical.State.m.StrategicProperties))
			{
				this.Tactical.State.m.StrategicProperties.Loot <- [];
				
			}
			
			this.logInfo("Adding pet loot");
			this.Tactical.State.m.StrategicProperties.Loot.push(this.m.LootScript);
			this.m.LootScript = null;
		}
	}

	function onDeath()
	{
		return;

		if (this.m.Master != null)
		{
			local self = this;
			this.m.Master.removeSlavePet(self);
		}
	}

	function onMovementCompleted( _tile )
	{
		if (this.getContainer().getActor().isHiddenToPlayer())
		{
			this.getContainer().getActor().retreat();
			return;
		}

		if (this.m.TurnsLeft <= 0)
		{
			this.getContainer().getActor().retreat();
		}
	}

	function isAtMapBorder( _tile )
	{
		for( local i = 0; i < 6; i = ++i )
		{
			if (!_tile.hasNextTile(i))
			{
				return true;
			}
		}

		return false;
	}

});

