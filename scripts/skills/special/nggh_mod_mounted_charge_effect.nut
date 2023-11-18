this.nggh_mod_mounted_charge_effect <- ::inherit("scripts/skills/skill", {
	m = {
		Stacks = 0,
		BaseBonusMeleeSkill = 4,
		BaseBonusDamage = 0.12,
		BaseBonusDirectDamage = 0.04,
		Requirement = 3,
	},
	function create()
	{
		this.m.ID = "special.nggh_mounted_charge";
		this.m.Name = "Mounted Charge";
		this.m.Icon = "ui/perks/charge_perk.png";
		this.m.IconMini = "charge_perk_mini";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "This character is gaining great speed to prepare for a desvastating mounting charge. Bad terrain, uneven terrain, wait or end turn will reset this effect.";
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

		if (this.m.Stacks >= 0)
		{
			local mult = this.getContainer().getActor().getCurrentProperties().IsSpecializedInMountedCharge ? 1.25 : 1.0;
			local meleeSkill = ::Math.round(this.m.BaseBonusMeleeSkill * mult * this.m.Stacks);
			local meleeDamage = ::Math.round(this.m.BaseBonusDamage * mult * 100 * this.m.Stacks);
			local damgeDirect = ::Math.round(this.m.BaseBonusDirectDamage * mult * 100 * this.m.Stacks); 

			ret.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + meleeSkill + "[/color] Melee Skill"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + meleeDamage + "%[/color] Melee Damage"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/direct_damage.png",
					text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + damgeDirect + "%[/color] Melee Direct Damage"
				},
			]);
		}

		if (this.m.Stacks >= this.m.Requirement)
		{
			ret.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "All active skills cost [color=" + ::Const.UI.Color.PositiveValue + "]1[/color] less AP"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "All active skills build up [color=" + ::Const.UI.Color.PositiveValue + "]25%[/color] less fatigue"
				},
			]);
		}

		return ret;
	}

	function isHidden()
	{
		return this.m.Stacks <= 0;
	}

	function resetCounter()
	{
		this.m.Stacks = -1;
	}

	function onMovementStarted( _tile, _numTiles )
	{
		//this.m.Stacks = _numTiles;
	}

	function onMovementFinished( _tile )
	{
	}

	function onMovementStep( _tile, _levelDifference )
	{
		if (_tile.Type >= ::Const.Tactical.TerrainType.Swamp || _levelDifference != 0)
		{
			this.resetCounter();
			return;
		}
		
		++this.m.Stacks;
	}

	function onWaitTurn()
	{
		this.resetCounter();
	}

	function onTurnEnd()
	{
		this.resetCounter();
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == null || !_skill.isAttack())
			return;

		if (_targetEntity.isAlive() || !_targetEntity.isDying() && this.m.Stacks >= this.m.Requirement)
			this.applyEffect(_targetEntity);

		this.resetCounter();
		this.getContainer().getActor().setDirty(true);
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		if (_skill == null || !_skill.isAttack())
			return;

		this.resetCounter();
		this.getContainer().getActor().setDirty(true);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill != null && _skill.isAttack() && !_skill.isRanged() && this.m.Stacks > 0)
		{
			local mult = _properties.IsSpecializedInMountedCharge ? 1.25 : 1.0;
			_properties.MeleeSkill += ::Math.round(this.m.Stacks * mult * this.m.BaseBonusMeleeSkill);
			_properties.MeleeDamageMult *= 1.0 + this.m.Stacks * mult * this.m.BaseBonusDamage;
			_properties.DamageDirectMult *= 1.0 + this.m.Stacks * mult * this.m.BaseBonusDirectDamage;

			/*
			if (_targetEntity != null)
			{
				local d = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());

				if (d > 1)
				{
					//_properties.MeleeSkill -= this.m.Stacks * this.m.BaseBonusMeleeSkill;
					_properties.MeleeDamageMult /= 1.0 + this.m.Stacks * this.m.BaseBonusDamage;
					_properties.DamageDirectMult /= 1.0 + this.m.Stacks * this.m.BaseBonusDirectDamage;
				}
			}
			*/
		}
	}

	function onAfterUpdate( _properties )
	{
		this.resetField("Requirement");
		this.m.Requirement = _properties.IsSpecializedInMountedCharge ? 3 : 2;

		if (this.m.Stacks >= this.m.Requirement)
		{
			_properties.AdditionalActionPointCost -= 1;
			_properties.FatigueEffectMult *= 0.75;
		}
	}

	function applyEffect( _targetEntity )
	{
		if (_targetEntity.getCurrentProperties().IsImmuneToDaze)
		{
			_targetEntity.getSkills().add(::new("scripts/skills/effects/staggered_effect"));
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetEntity) + " is staggered for one turn");
		}
		else
		{
			_targetEntity.getSkills().add(::new("scripts/skills/effects/dazed_effect"));
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetEntity) + " is dazed for one turn");
		}
	}

});

