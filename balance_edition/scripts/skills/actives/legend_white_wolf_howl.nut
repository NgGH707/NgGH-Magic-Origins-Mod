this.legend_white_wolf_howl <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.legend_white_wolf_howl";
		this.m.Name = "White Wolf Howl";
		this.m.Description = "A fearsome howl that boosts the fighting spirit of its herd members.";
		this.m.Icon = "skills/active_22.png";
		this.m.IconDisabled = "skills/active_22_sw.png";
		this.m.Overlay = "active_22";
		this.m.SoundOnUse = [
			"sounds/enemies/werewolf_howl.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 20;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getTooltip()
	{
		local p = this.getContainer().getActor().getCurrentProperties();
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
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has an effective range of [color=" + this.Const.UI.Color.PositiveValue + "]6[/color] tiles raidus"
			}
		];
	}

	function raiseMorale( _actor, _tag )
	{
		if (_actor.getFaction() == _tag.Self.getFaction() || _actor.getFlags().has("werewolf"))
		{
			_actor.checkMorale(1, 0);
			_tag.Skill.spawnIcon("status_effect_06", _actor.getTile());
		}
	}

	function onUse( _user, _targetTile )
	{
		local result = {
			Self = _user,
			Skill = this
		};
		
		local myTile = _user.getTile();
		local actors = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());

		foreach( a in actors )
		{
			if (a.getID() == _user.getID())
			{
				continue;
			}

			if (myTile.getDistanceTo(a.getTile()) > 6)
			{
				continue;
			}
			
			a.getSkills().removeByID("effects.sleeping");
			this.raiseMorale(a, result);
		}
		
		
		return true;
	}

});

