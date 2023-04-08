this.nggh_mod_attach_egg <- ::inherit("scripts/skills/skill", {
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
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.NonTargeted + 5;
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
		return this.m.IsHidden || this.getContainer().getActor().getItems().getItemAtSlot(::Const.ItemSlot.Accessory) != null;
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
		local _item = ::new("scripts/items/accessory/nggh_mod_accessory_spider");

		/*if (this.Is_AccessoryCompanions_Exist)
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
		_user.equipItem(_item);
		local rider_skill = this.getContainer().getSkillByID("special.egg_rider");
		if (rider_skill != null) rider_skill.setTemporarySpiderMount(e, _item);
		_item.setLink(rider_skill);
		::Tactical.TurnSequenceBar.removeEntity(e);
		::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " takes a ride on " + ::Const.UI.getColorizedEntityName(e));

		// make all fodder spiderlings to become meat shield for the eggs to escape
		if (::Tactical.State.m.IsAutoRetreat)
		{
			foreach (i, a in ::Tactical.Entities.getAllInstancesAsArray())
			{
			    if (a.getFlags().has("Source") && a.getFlags().get("Source") == _user.getID())
			    {
			    	if (a.getID() == e.getID())
					{
						continue;
					}

			    	a.setAIAgent(::new("scripts/ai/tactical/agents/spider_bodyguard_agent"));
					a.getAIAgent().setActor(a);
					a.getAIAgent().removeBehavior(::Const.AI.Behavior.ID.Protect);

			    	local protect = ::new("scripts/ai/tactical/behaviors/ai_protect_person");
			    	protect.setVIP(_user);
			    	a.getAIAgent().addBehavior(protect);
			    }
			}
		}

		::Tactical.getTemporaryRoster().add(e);
		e.removeFromMap();
		return true;
	}

});

