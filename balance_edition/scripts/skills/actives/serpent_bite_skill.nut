this.serpent_bite_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.serpent_bite";
		this.m.Name = "Serpent Bite";
		this.m.Description = "A bite from a giant snake can be a little painful";
		this.m.KilledString = "Bitten to bits";
		this.m.Icon = "skills/active_196.png";
		this.m.IconDisabled = "skills/active_196_sw.png";
		this.m.Overlay = "active_196";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/snake_attack_01.wav",
			"sounds/enemies/dlc6/snake_attack_02.wav",
			"sounds/enemies/dlc6/snake_attack_03.wav",
			"sounds/enemies/dlc6/snake_attack_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc6/snake_attack_hit_01.wav",
			"sounds/enemies/dlc6/snake_attack_hit_02.wav",
			"sounds/enemies/dlc6/snake_attack_hit_03.wav",
			"sounds/enemies/dlc6/snake_attack_hit_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.IsSerialized = false;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 500;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 25;
		this.m.ChanceSmash = 0;
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultTooltip();

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInShields)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]2[/color] tiles"
			});
		}

		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 50;
		_properties.DamageRegularMax += 70;
		_properties.DamageArmorMult *= 0.75;
	}
	
	function onAfterUpdate( _properties )
	{
		this.m.MaxRange = _properties.IsSpecializedInShields ? 2 : 1;
		this.m.ActionPointCost = _properties.IsSpecializedInPolearms ? 4 : 5;
		
		if (_properties.IsSpecializedInPolearms)
		{
			_properties.DamageRegularMin += 20;
			_properties.DamageRegularMax += 20;
			_properties.DamageArmorMult += 0.10;
		}
	}

	function onUse( _user, _targetTile )
	{
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile
		};

		if ((!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer) && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == this.getContainer().getActor().getID())
		{
			this.getContainer().setBusy(true);
			local d = _user.getTile().getDirectionTo(_targetTile) + 3;
			d = d > 5 ? d - 6 : d;

			if (_user.getTile().hasNextTile(d))
			{
				this.Tactical.getShaker().shake(_user, _user.getTile().getNextTile(d), 6);
			}

			this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onPerformAttack.bindenv(this), tag);
			return true;
		}
		else
		{
			return this.attackEntity(_user, _targetTile.getEntity());
		}
	}

	function onPerformAttack( _tag )
	{
		this.attackEntity(_tag.User, _tag.TargetTile.getEntity());
		_tag.Skill.getContainer().setBusy(false);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
	    if (_skill == this && _targetEntity != null)
	    {
	    	local d = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());

	    	if (d > 1)
	    	{
	    		_properties.MeleeSkill -= 7 * (d - 1);
	    		_properties.MeleeDamageMult *= 0.75;
	    	}
	    }
	}

});

