this.special_undead_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.undead";
		this.m.Name = "The Elite";
		this.m.Description = "";
		this.m.Icon = "status_effect_69.png";
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}
	
	function onUpdate( _properties )
	{
		local type = this.getContainer().getActor().getType();
		
		_properties.FatigueToInitiativeRate *= 0.1;
		_properties.InitiativeAfterWaitMult = 1.0;
		
		if (this.getContainer().getActor().getSkills().hasSkill("effects.riposte") && type == 109)
		{
			_properties.MeleeDefense += 15;
			_properties.RangedDefense += 15;
		}
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		local actor = this.getContainer().getActor();
		local type = actor.getType();
		
		if (_skill.isAttack() && _targetEntity != null && _targetEntity.getID() != actor.getID() && _targetEntity.isAlliedWith(actor) && (type == 106 || type == 107 || type == 108))
		{
			_properties.MeleeSkillMult *= 0.7;
			_properties.RangedSkillMult *= 0.7;
		}
		
		if (_skill.getID() == "actives.puncture" && type == 110)
		{
			_properties.DamageRegularMin += 15;
			_properties.DamageRegularMax += 5;
			_properties.MeleeSkill += 15;
		}
	}
	
	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{		
		local crit = this.Math.rand(0, 100);
		local actor = this.getContainer().getActor();
		local type = actor.getType();
		
		if (type != 110)
		{
			return;
		}
		
		if (crit <= 50)
		{
			this.spawnIcon("perk_14", _targetEntity.getTile());
			this.Tactical.getCamera().quake(this.m.Container.getActor(), _targetEntity, 5.0, 0.16, 0.3);
			this.Sound.play("sounds/m_c/critical_hit.wav", this.Const.Sound.Volume.Inventory * 1.2);
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " has landed a desvastating critical hit");
			_hitInfo.DamageRegular *= 1.5;
			_hitInfo.DamageArmor *= 1.5;
		}
		else
		{
			this.spawnIcon("status_effect_111", _targetEntity.getTile());
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " has missed an opportunity");
			_hitInfo.DamageRegular *= 0.5;
			_hitInfo.DamageArmor *= 0.5;
		}
	}
	
	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		local item = actor.getItems();
		local weapon = item.getItemAtSlot(this.Const.ItemSlot.Mainhand);
		
		if (weapon != null)
		{
			weapon.m.Condition = weapon.m.ConditionMax * 0.6;
		}
	}
	
});