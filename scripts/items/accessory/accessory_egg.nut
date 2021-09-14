this.accessory_egg <- this.inherit("scripts/items/accessory/accessory", {
	m = {
		Skill = null,
		Entity = null,
	},
	function setEntity( _e )
	{
		this.m.Entity = _e;
		this.setName(_e.getName());
	}

	function getEntity()
	{
		return this.m.Entity;
	}

	function setSkill( _s )
	{
		this.m.Skill = this.WeakTableRef(_s);
	}

	function getSkill()
	{
		return this.m.Skill;
	}

	function setName( _n )
	{
		this.m.Name = _n;
	}

	function create()
	{
		this.accessory.create();
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.ItemType = this.Const.Items.ItemType.Accessory;
		this.m.ID = "accessory.carried_egg";
		this.m.Name = "Webknecht Hive";
		this.m.Description = "Your spider egg friend is on your back.";
		this.m.Icon = "tools/egg_70x70.png";
		this.m.IsUsable = false;
		this.m.IsAllowedInBag = false;
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = false;
		this.m.IsChangeableInBattle = true;
		this.m.Value = 0;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		result.push({
			id = 66,
			type = "text",
			text = "Priceless"
		});
		
		result.push({
			id = 64,
			type = "text",
			text = "Carried on your back"
		});
		
		result.push({
			id = 3,
			type = "image",
			image = this.getIcon()
		});

		return result;
	}

	function onEquip()
	{
		this.accessory.onEquip();
		local place = this.new("scripts/skills/actives/place_egg");
		place.setItem(this);
		this.addSkill(place);

		local carry = this.new("scripts/skills/special/egg_attachment");
		carry.setItem(this);
		this.setSkill(carry);
		this.addSkill(carry);
	}

	function onPlace( _tile )
	{
		local e = this.getEntity();
		local hpPct = this.getSkill().getHealthPct();
		this.Tactical.addEntityToMap(e, _tile.Coords.X, _tile.Coords.Y);
		this.Tactical.getTemporaryRoster().remove(e);
		e.setHitpointsPct(hpPct);
		this.Tactical.TurnSequenceBar.updateEntity(e.getID());
	}

	function onCombatFinished()
	{
		this.onDone();
	}

	function onActorDied( _onTile )
	{
		if (_onTile != null)
		{
			this.onPlace(_onTile);
		}

		this.onDone();
	}

	function onDone()
	{
		this.getContainer().unequip(this);
	}

	function updateVariant()
	{
	}

});

