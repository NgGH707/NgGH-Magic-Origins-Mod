this.sweep_zoc_skill <- this.inherit("scripts/skills/skill", {
	m = {
		TilesUsed = []
	},
	function create()
	{
		this.m.ID = "actives.sweep_zoc";
		this.m.Name = "Sweeping Strike";
		this.m.Description = "";
		this.m.KilledString = "Smashed";
		this.m.Icon = "skills/active_112.png";
		this.m.IconDisabled = "skills/active_112.png";
		this.m.Overlay = "active_112";
		this.m.SoundOnUse = [
			"sounds/combat/shatter_01.wav",
			"sounds/combat/shatter_02.wav",
			"sounds/combat/shatter_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/unhold_swipe_hit_01.wav",
			"sounds/enemies/unhold_swipe_hit_02.wav",
			"sounds/enemies/unhold_swipe_hit_04.wav",
			"sounds/enemies/unhold_swipe_hit_05.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.Delay = 0;
		this.m.IsHidden = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = false;
		this.m.IsAOE = false;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.HitChanceBonus = 0;
		this.m.DirectDamageMult = 0.4;
		this.m.ActionPointCost = 99;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 66;
	}
	
	function isUsable()
	{
		return this.m.IsUsable && this.m.Container.getActor().getCurrentProperties().IsAbleToUseSkills && (!this.m.IsWeaponSkill || this.m.Container.getActor().getCurrentProperties().IsAbleToUseWeaponSkills);
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		return ret;
	}

	function applyEffectToTarget( _user, _target, _targetTile )
	{
		if (_target.isNonCombatant())
		{
			return;
		}

		_target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));

		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has staggered " + this.Const.UI.getColorizedEntityName(_target) + " for one turn");
		}
	}

	function onUse( _user, _targetTile )
	{
		this.m.TilesUsed = [];
		this.getContainer().setBusy(true);
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile
		};
		return this.onPerformAttack(tag);
	}

	function onPerformAttack( _tag )
	{
		local _targetTile = _tag.TargetTile;
		local _user = _tag.User;
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSwing);
		local ret = false;
		local ownTile = _user.getTile();
		local dir = ownTile.getDirectionTo(_targetTile);
		ret = this.attackEntity(_user, _targetTile.getEntity());

		if (!_user.isAlive() || _user.isDying())
		{
			return ret;
		}

		if (ret && _targetTile.IsOccupiedByActor && _targetTile.getEntity().isAlive() && !_targetTile.getEntity().isDying())
		{
			this.applyEffectToTarget(_user, _targetTile.getEntity(), _targetTile);
		}

		this.m.TilesUsed = [];
		return ret;
	}

	function getMods()
	{
		local ret = {
			Min = 0,
			Max = 0,
			HasTraining = false
		};
		local actor = this.getContainer().getActor();

		if (actor.getSkills().hasSkill("perk.legend_unarmed_training"))
		{
			local average = actor.getHitpoints() * 0.05;

			ret.Min += average;
			ret.Max += average;
			ret.HasTraining = true;
		}

		ret.Min = this.Math.max(0, this.Math.floor(ret.Min));
		ret.Max = this.Math.max(0, this.Math.floor(ret.Max));
		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill != this)
		{
			return;
		}

		local mods = this.getMods();
		_properties.DamageRegularMin += mods.Min;
		_properties.DamageRegularMax += mods.Max;

		if (mods.HasTraining)
		{
			_properties.DamageArmorMult += 0.1;
		}
	}

});

