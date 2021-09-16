this.accessory_spider <- this.inherit("scripts/items/item", {
	m = {
		StaminaModifier = 0,
		StashModifier = 0,
		AddGenericSkill = true,
		ShowOnCharacter = false,
		Sprite = null,
		SpriteCorpse = null,
		Link = null,
		Entity = null,
		IsRedBack = false,
		Wounds = 0,
	},
	function setWounds( _w )
	{
		this.m.Wounds = _w;
	}

	function getAttributes()
	{
		return this.Const.Tactical.Actor.Spider;
	}

	function setEntity( _e )
	{
		this.m.Entity = _e;

		if (_e != null)
		{
			this.setName(_e.getName());
			this.m.IsRedBack = _e.getType() == this.Const.EntityType.LegendRedbackSpider;
		}
	}

	function getEntity()
	{
		return this.m.Entity;
	}

	function getQuirks()
	{
		return [];
	}

	function setLink( _s )
	{
		if (_s == null)
		{
			this.m.Link = null;
		}
		else 
		{
		    if (typeof _s == "instance")
			{
				this.m.Link = _s;
			}
			else
			{
				this.m.Link = this.WeakTableRef(_s);
			}
		}
	}

	function getLink()
	{
		return this.m.Link;
	}

	function setName( _n )
	{
		this.m.Name = _n;
	}

	function getStaminaModifier()
	{
		return this.m.StaminaModifier;
	}

	function getStashModifier()
	{
		return this.m.StashModifier;
	}

	function create()
	{
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.ItemType = this.Const.Items.ItemType.Accessory;
		this.m.ID = "accessory.tempo_spider";
		this.m.Name = "Webknecht";
		this.m.Description = "A Spider, that\'s all.";
		this.m.Icon = "tools/egg_70x70.png";
		this.m.IsUsable = false;
		this.m.IsAllowedInBag = false;
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = false;
		this.m.IsChangeableInBattle = false;
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
			id = 3,
			type = "image",
			image = this.getIcon()
		});

		return result;
	}

	function onEquip()
	{
		/*
		local place = this.new("scripts/skills/actives/place_egg");
		place.setItem(this);
		this.addSkill(place);

		local carry = this.new("scripts/skills/special/egg_attachment");
		carry.setItem(this);
		this.setSkill(carry);
		this.addSkill(carry);*/

		this.item.onEquip();

		if (this.m.AddGenericSkill)
		{
			this.addGenericItemSkill();
		}

		if (this.m.ShowOnCharacter)
		{
			local app = this.getContainer().getAppearance();
			app.Accessory = this.m.Sprite;
			this.getContainer().updateAppearance();
		}

		if (this.m.StashModifier > 0)
		{
			if (this.World.State.getPlayer() == null)
			{
				return;
			}

			this.World.State.getPlayer().calculateStashModifier();
		}

		local c = this.getContainer();
		if (c != null && c.getActor() != null && !c.getActor().isNull()) this.m.Container.getActor().getFlags().add("has_tempo_spider");
	}

	function onUnequip()
	{
		local c = this.getContainer();
		if (c != null && c.getActor() != null && !c.getActor().isNull()) this.m.Container.getActor().getFlags().remove("has_tempo_spider");
		this.item.onUnequip();

		if (this.m.ShowOnCharacter)
		{
			local app = this.getContainer().getAppearance();
			app.Accessory = "";
			this.getContainer().updateAppearance();
		}

		if (this.World.State.getPlayer() == null)
		{
			return;
		}

		if (this.m.StashModifier > 0)
		{
			this.getContainer().unequipNoUpdate(this);
			this.World.State.getPlayer().calculateStashModifier();
		}
	}

	function onPlace( _tile )
	{
		local e = this.getEntity();
		local hpPct = this.getLink().getHealthPct();
		this.Tactical.addEntityToMap(e, _tile.Coords.X, _tile.Coords.Y);
		this.Tactical.getTemporaryRoster().remove(e);
		e.setHitpointsPct(hpPct);
		this.Tactical.TurnSequenceBar.updateEntity(e.getID());
	}

	function onCombatFinished()
	{
		this.isDone();
	}

	function onActorDied( _onTile )
	{
		if (_onTile != null)
		{
			this.onPlace(_onTile);
		}

		this.isDone();
	}

	function isDone()
	{
		this.getContainer().unequip(this);
	}

	function onUpdateProperties( _properties )
	{
	}

	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.updateVariant();
	}

});

