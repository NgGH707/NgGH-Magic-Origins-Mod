this.mod_kraken_move_ensnared_skill <- this.inherit("scripts/skills/skill", {
	m = {
		ParentID = null,
	},
	function create()
	{
		this.m.ID = "actives.mod_kraken_move_ensnared";
		this.m.Name = "Drag";
		this.m.Description = "";
		this.m.Icon = "skills/active_147.png";
		this.m.Overlay = "active_147";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/tentacle_disappear_01.wav",
			"sounds/enemies/dlc2/tentacle_disappear_02.wav",
			"sounds/enemies/dlc2/tentacle_disappear_03.wav",
			"sounds/enemies/dlc2/tentacle_disappear_04.wav",
			"sounds/enemies/dlc2/tentacle_disappear_05.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc2/tentacle_appear_01.wav",
			"sounds/enemies/dlc2/tentacle_appear_02.wav",
			"sounds/enemies/dlc2/tentacle_appear_03.wav",
			"sounds/enemies/dlc2/tentacle_appear_04.wav",
			"sounds/enemies/dlc2/tentacle_appear_05.wav"
		];
		this.m.SoundVolume = 0.66;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsHidden = true;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 4;
	}

	function isUsable()
	{
		return this.m.IsUsable;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsEmpty)
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile,
			OnDone = this.onTeleportDone,
			OnTeleportStart = this.onTeleportStart,
			IgnoreColors = false
		};
		local isGhoul = _user.getType() == this.Const.EntityType.Ghoul || _user.getType() == this.Const.EntityType.LegendSkinGhoul;

		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " is dragged towards certain death");
		}

		if (isGhoul && _user.m.Size > 1)
		{
			tag.IgnoreColors = true;
			this.onTeleportStart(tag);
		}
		if (_user.getTile().IsVisibleForPlayer)
		{
			_user.sinkIntoGround(0.75);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 800, this.onTeleportStart, tag);
		}
		else if (_targetTile.IsVisibleForPlayer)
		{
			this.onTeleportStart(tag);
		}
		else
		{
			tag.IgnoreColors = true;
			this.onTeleportStart(tag);
		}

		return true;
	}

	function onTeleportStart( _tag )
	{
		if (!_tag.IgnoreColors)
		{
			_tag.User.storeSpriteColors();
			_tag.User.fadeTo(this.createColor("ffffff00"), 0);
		}

		this.Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, _tag.OnDone, _tag, false, 1000.0);
	}

	function onTeleportDone( _entity, _tag )
	{
		if (!_tag.IgnoreColors)
		{
			_entity.restoreSpriteColors();
		}

		if (!_entity.isHiddenToPlayer() && !_tag.IgnoreColors)
		{
			_entity.riseFromGround(0.75);
		}

		if (_tag.Skill.m.SoundOnHit.len() > 0)
		{
			this.Sound.play(_tag.Skill.m.SoundOnHit[this.Math.rand(0, _tag.Skill.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _entity.getPos());
		}
	}

});

