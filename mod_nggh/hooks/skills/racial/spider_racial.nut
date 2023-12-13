::mods_hookExactClass("skills/racial/spider_racial", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Webknecht Venom";
		this.m.Description = "A giant spider can be dangerous to play with, especially when it has deadly venom.";
		this.m.Icon = "skills/status_effect_54.png";
		this.m.IconMini = "status_effect_54_mini";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	};
	obj.getTooltip <- function()
	{
		local isSpecialized = this.getContainer().getActor().getCurrentProperties().IsSpecializedInDaggers;
		local poison = 5;

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			poison *= 2;

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
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts [color=" + ::Const.UI.Color.DamageValue + "]" + poison + "[/color] poison damage per turn, for " + (isSpecialized ? 3 : 4) + " turns"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts [color=" + ::Const.UI.Color.DamageValue + "]100%[/color] more direct damage against targets that are [color=" + ::Const.UI.Color.NegativeValue + "]Trapped[/color] in Web, Net, Vines"
			}
		];
	};
	obj.onTargetHit = function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (!_targetEntity.isAlive() || _targetEntity.isDying())
			return;

		if (_targetEntity.getCurrentProperties().IsImmuneToPoison || _targetEntity.getFlags().has("undead"))
			return;
		
		if (_damageInflictedHitpoints < ::Const.Combat.PoisonEffectMinDamage || _targetEntity.getHitpoints() <= 0)
			return;

		if (!_targetEntity.isHiddenToPlayer())
		{
			if (this.m.SoundOnUse.len() != 0)
				::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.RacialEffect * 1.5, _targetEntity.getPos());

			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetEntity) + " is poisoned");
		}

		this.spawnIcon("status_effect_54", _targetEntity.getTile());
		local poison = ::new("scripts/skills/effects/spider_poison_effect");
		poison.m.IsSuperPoison = this.getContainer().getActor().getCurrentProperties().IsSpecializedInDaggers;
		poison.setActorID(this.getContainer().getActor().getID());
		_targetEntity.getSkills().add(poison);

		if (poison.m.IsSuperPoison)
			poison.m.TurnsLeft += 1;
	};
	obj.onUpdate = function( _properties )
	{
		if (!::Tactical.isActive()) return;
		
		_properties.Bravery += (::Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction()).len() - 1) * 3;
	};
	obj.onAnySkillUsed = function( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null) return;
		
		if (_targetEntity.getCurrentProperties().IsRooted)
			_properties.DamageDirectMult *= 2.0;
		else if (_targetEntity.getCurrentProperties().IsStunned)
			_properties.DamageDirectMult *= 1.5;

		if (!_properties.IsSpecializedInDaggers || !_targetEntity.getCurrentProperties().IsWeakenByPoison)
			return;

		local n = _targetEntity.getSkills().getNumOfSkill("effects.spider_poison") + _targetEntity.getSkills().getNumOfSkill("effects.legend_redback_spider_poison");
		_properties.DamageRegularMult *= 1.0 + 0.02 * n;
	};
});