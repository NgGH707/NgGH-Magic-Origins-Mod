this.legend_greenwood_schrat_racial <- this.inherit("scripts/skills/skill", {
	m = {
		DamRec = 0.3,
		Script = "enemies/legend_greenwood_schrat_small",
	},
	function create()
	{
		this.m.ID = "racial.legend_greenwood_schrat";
		this.m.Name = "Living Wood";
		this.m.Description = "As guardians of the forest, a Greenwood Schrat has an incredibly resilient wooden body. Any part of its broken body part could grow into a living schrat too.";
		this.m.Icon = "skills/status_effect_86.png";
		this.m.IconMini = "status_effect_86_mini";
		this.m.SoundOnUse = [];
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}
	
	function getTooltip()
	{
		local actor = this.getContainer().getActor();
		local isSpecialized = this.getContainer().hasSkill("perk.sapling");
		local hp = this.Math.floor(actor.getHitpointsMax() * 0.067);
		local chance = 25 + (isSpecialized ? 10 : 0);
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
			{
				id = 10,
				type = "text",
				icon = "ui/icons/sturdiness.png",
				text = "Takes [color=" + this.Const.UI.Color.NegativeValue + "]" + (1 - this.m.DamRec) * 100 + "%[/color] less damage if has a shield equipped"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]" + chance + "%[/color] to spawn a Greenwood Sapling when taking at least [color=" + this.Const.UI.Color.PositiveValue + "]" + hp + "[/color] damage"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Resistance against most ranged attacks"
			}
		];

		return ret;
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
		this.m.Script = "minions/special/legend_greenwood_schrat_small_minion";
		this.getContainer().update();
	}

	function isHidden()
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return false;
		}

		return !this.getContainer().getActor().isArmedWithShield();
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();

		if (actor.isArmedWithShield())
		{
			_properties.DamageReceivedTotalMult *= this.m.DamRec;
		}
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_skill == null)
		{
			return;
		}

		if (_skill.getID() == "actives.aimed_shot" || _skill.getID() == "actives.quick_shot" || _skill.getID() == "actives.shoot_bolt" || _skill.getID() == "actives.shoot_stake")
		{
			_properties.DamageReceivedRegularMult *= 0.25;
		}
		else if (_skill.getID() == "actives.throw_javelin")
		{
			_properties.DamageReceivedRegularMult *= 0.5;
		}
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		local actor = this.getContainer().getActor();
		local mult = actor.isPlayerControlled() ? 6.7 : 1.0;
		local isSpecialized = this.getContainer().hasSkill("perk.sapling");

		if (_damageHitpoints >= actor.getHitpointsMax() * 0.01 * mult)
		{
			local candidates = [];
			local myTile = actor.getTile();

			for( local i = 0; i < 6; i = i )
			{
				if (!myTile.hasNextTile(i))
				{
				}
				else
				{
					local nextTile = myTile.getNextTile(i);

					if (nextTile.IsEmpty && this.Math.abs(myTile.Level - nextTile.Level) <= 1)
					{
						candidates.push(nextTile);
					}
				}

				i = ++i;
			}

			local bonus = isSpecialized ? 10 : 0;

			if (candidates.len() != 0)
			{
				if (this.getContainer().getActor().isPlayerControlled() && this.Math.rand(1, 100) > 25 + bonus)
				{
					return;
				}

				local spawnTile = candidates[this.Math.rand(0, candidates.len() - 1)];
				local sapling = this.Tactical.spawnEntity("scripts/entity/tactical/" + this.m.Script, spawnTile.Coords);
				sapling.setFaction(actor.getFaction() == this.Const.Faction.Player ? this.Const.Faction.PlayerAnimals : actor.getFaction());
				sapling.riseFromGround();

				if (isSpecialized)
				{
					sapling.setMaster(actor);
					sapling.setFaction(actor.getFaction());
				}
			}
		}
	}

});

