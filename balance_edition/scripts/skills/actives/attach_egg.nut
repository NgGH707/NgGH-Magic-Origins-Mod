this.attach_egg <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.attach_egg";
		this.m.Name = "Stick on Spider";
		this.m.Description = "Get carried by a friendly spider. Ohh! my eight-leg Uber is here.";
		this.m.Icon = "ui/perks/active_attach_egg.png";
		this.m.IconDisabled = "ui/perks/active_attach_egg_sw.png";
		this.m.Overlay = "active_attach_egg";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/giant_spider_egg_spawn_01.wav",
			"sounds/enemies/dlc2/giant_spider_egg_spawn_02.wav",
			"sounds/enemies/dlc2/giant_spider_egg_spawn_03.wav",
			"sounds/enemies/dlc2/giant_spider_egg_spawn_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.NonTargeted + 5;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsTargetingActor = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function isHidden()
	{
		return this.m.IsHidden || this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Accessory) != null;
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
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local _targetEntity = _targetTile.getEntity();

		if (!_targetEntity.getFlags().has("spider") || !_targetEntity.isAlliedWith(this.getContainer().getActor()))
		{
			return false;
		}

		return _targetEntity.isSummoned();
	}

	function onUse( _user, _targetTile )
	{
		local e = _targetTile.getEntity();
		local _item = this.new("scripts/items/accessory/accessory_spider");

		/*if (this.IsAccessoryCompanionsExist)
		{
			_item = this.new("scripts/items/accessory/wardog_item");
			_item.setType(this.Const.Companions.TypeList.Spider);
			_item.m.Wounds = this.Math.floor((1.0 - e.getHitpointsPct()) * 100.0);

			local target_perks = e.getSkills().query(this.Const.SkillType.Perk);
			foreach(perk in target_perks)
			{
				local quirk = "";
				foreach( i, v in this.Const.Perks.PerkDefObjects )
				{
					if (perk.getID() == v.ID)
					{
						quirk = v.Script;
						break;
					}
				}
				if (quirk != "")
				{
					_item.m.Quirks.push(quirk);
				}
			}

			_item.updateCompanion();
		}*/

		_item.setEntity(e);
		_targetEntity.equipItem(_item);
		local rider_skill = this.getContainer().getSkillByID("special.egg_rider");
		if (rider_skill != null) rider_skill.setTemporarySpiderMount(e, _item);
		_item.setLink(rider_skill);
		this.Tactical.TurnSequenceBar.removeEntity(e);
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " takes a ride on " + this.Const.UI.getColorizedEntityName(_targetEntity));

		if (this.Tactical.State.m.IsAutoRetreat)
		{
			local alive = this.Tactical.Entities.getAllInstancesAsArray();

			foreach (i, a in alive)
			{
			    if (a.getFlags().has("creator") && a.getFlags().get("creator") == _user.getID())
			    {
			    	if (a.getID() == e.getID())
					{
						continue;
					}

			    	a.setAIAgent(this.new("scripts/ai/tactical/agents/spider_bodyguard_agent"));
					a.getAIAgent().setActor(a);
					a.getAIAgent().removeBehavior(this.Const.AI.Behavior.ID.Protect);

			    	local protect = this.new("scripts/ai/tactical/behaviors/ai_protect_person");
			    	protect.setVIP(_targetEntity);
			    	a.getAIAgent().addBehavior(protect);
			    }
			}
		}

		this.Tactical.getTemporaryRoster().add(e);
		e.removeFromMap();
		return true;
	}

});

