this.nggh_mod_accessory_spider <- ::inherit("scripts/items/item", {
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
		if (this.m.Entity == null)
		{
			return ::Const.Tactical.Actor.Spider;
		}

		return this.m.Entity.getBaseProperties();
	}

	function setEntity( _e )
	{
		this.m.Entity = _e;

		if (_e != null)
		{
			this.setName(_e.getName());
			this.m.IsRedBack = _e.getType() == ::Const.EntityType.LegendRedbackSpider;
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
				this.m.Link = ::WeakTableRef(_s);
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
		this.m.SlotType = ::Const.ItemSlot.Accessory;
		this.m.ItemType = ::Const.Items.ItemType.Accessory;
		this.m.ID = "accessory.temp_spider";
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
		/* old and unused stuffs
		local place = this.new("scripts/skills/actives/place_egg");
		place.setItem(this);
		this.addSkill(place);

		local carry = this.new("scripts/skills/special/egg_attachment");
		carry.setItem(this);
		this.setSkill(carry);
		this.addSkill(carry);
		*/

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

		local c = this.getContainer();
		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().add("has_temp_spider");
		} 
	}

	function onUnequip()
	{
		local c = this.getContainer();
		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().remove("has_temp_spider");
		} 

		this.item.onUnequip();

		if (this.m.ShowOnCharacter)
		{
			local app = this.getContainer().getAppearance();
			app.Accessory = "";
			this.getContainer().updateAppearance();
		}
	}

	function onPlace( _tile )
	{
		local e = this.getEntity();
		local hpPct = this.getLink().getHealthPct();
		::Tactical.addEntityToMap(e, _tile.Coords.X, _tile.Coords.Y);
		::Tactical.getTemporaryRoster().remove(e);
		e.setHitpointsPct(hpPct);
		::Tactical.TurnSequenceBar.updateEntity(e.getID());
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

