this.nggh_mod_kraken_command_drag_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.kraken_command_drag";
		this.m.Name = "Drag Prey";
		this.m.Description = "Move ensnared prey to your mouth. Can use on yourself to command a random tentacle to drag its ensnared prey to you";
		this.m.Icon = "skills/active_151.png";
		this.m.IconDisabled = "skills/active_151_sw.png";
		this.m.Overlay = "active_151";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/krake_choke_01.wav",
			"sounds/enemies/dlc2/krake_choke_02.wav",
			"sounds/enemies/dlc2/krake_choke_03.wav",
			"sounds/enemies/dlc2/krake_choke_04.wav",
			"sounds/enemies/dlc2/krake_choke_05.wav"
		];
		this.m.SoundVolume = 0.75;
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsRangeLimitsEnforced = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 5;
		this.m.MinRange = 0;
		this.m.MaxRange = 99;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		return this.getDefaultUtilityTooltip();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_targetTile.ID == _originTile.ID)
		{
			return true;
		}

		if (_originTile.getDistanceTo(_targetTile) == 1)
		{
			return false;
		}

		local target = _targetTile.getEntity();
		local skill = target.getSkills().getSkillByID("actives.mod_kraken_move_ensnared");

		if (skill == null)
		{
			return false;
		}

		if (skill.m.ParentID == null || this.getContainer().getActor().getID() != skill.m.ParentID)
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		if (_user.getID() == target.getID())
		{
			foreach (i, a in ::Tactical.Entities.getAllInstancesAsArray()) 
			{
				if (_user.getTile().getDistanceTo(a.getTile()) == 1)
				{
					continue;
				}

				local skill = a.getSkills().getSkillByID("actives.mod_kraken_move_ensnared");

			    if (skill == null)
			    {
			    	continue;
			    }

			    if (skill.m.ParentID != null && this.getContainer().getActor().getID() == skill.m.ParentID)
				{
					target = a;
			    	break;
				}
			}
		}

		local b = target.getAIAgent().getBehavior(::Const.AI.Behavior.ID.Drag);

		if (b == null)
		{
			::Tactical.EventLog.log("[color=" + ::Const.UI.Color.NegativeValue + "]Fail to find a suitable place to drag to[/color]");
			return false;
		}
		
		b.setForcedDrag(true);
		local score = b.onEvaluate(target);

		if (score > ::Const.AI.Behavior.Score.Zero)
		{
			return b.onExecute(target);
		}

		return false;
	}

	function onTargetSelected( _targetTile ) {}
	function getHitFactors( _targetTile ) {return []}

});

