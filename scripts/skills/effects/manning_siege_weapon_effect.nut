this.manning_siege_weapon_effect <- this.inherit("scripts/skills/skill", {
	m = {
		SiegeWeapon = null,
		Turn = 2,
	},
	function create()
	{
		this.m.ID = "effects.manning_siege_weapon";
		this.m.Name = "Manning a ";
		this.m.Icon = "skills/active_maning_mortar.png";
		this.m.IconMini = "active_maning_mortar_mini";
		this.m.Overlay = "active_maning_mortar";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "This character is manning a " + this.m.SiegeWeapon.getName() + ". For every time this character ends turn while having 4 or more AP, his vision range will increase by 1 due to having extra time to lookout. Having \'Lookout\' perk or released falcon will further improve your vision.";
	}

	function getTooltip()
	{
		local accessory = this.getContainer().getActor().getItemAtSlot(this.Const.ItemSlot.Accessory);
		local lookout = this.getContainer.hasSkill("perk.lookout");
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
		];

		if (this.m.Turn > 0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.Turn + "[/color] Vision"
			});
		}

		if (accessory != null && accessory.getID() == "accessory.falcon" && accessory.isReleased())
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] Vision thanks to your falcon"
			});
		}

		return ret;
	}

	function onAdded()
	{
		this.m.Name = this.m.Name + this.m.SiegeWeapon.getName();
	}

	function onUpdate( _properties )
	{
		local accessory = this.getContainer().getActor().getItemAtSlot(this.Const.ItemSlot.Accessory);

		if (accessory != null && accessory.getID() == "accessory.falcon" && accessory.isReleased())
		{
			_properties.Vision += 3;
		}

		if (this.getContainer.hasSkill("perk.lookout"))
		{
			_properties.Vision += 1;
		}

		_properties.Vision += this.m.Turn;
	}

	function isManningSiegeWeapon( _tile = null )
	{
		if (this.m.SiegeWeapon == null)
		{
			this.removeSelf();
			return;
		}

		local actor = this.getContainer().getActor();
		local tile;

		if (_tile != null)
		{
			tile = _tile;
		}
		else 
		{
			tile = actor.getTile();    
		}

		if (tile.getDistanceTo(this.m.SiegeWeapon.getTile()) != 1)
		{
			this.removeSelf();
		}
	}

	function onRemoved()
	{
		this.getContainer().getSkillByID("actives.manning_siege_weapon").clear();
	}

	function onTurnStart()
	{
		this.isManningSiegeWeapon();
	}

	function onTurnEnd()
	{
		if (this.getContainer().getActor().getActionPoints() >= 4)
		{
			++this.m.Turn;
		}

		this.isManningSiegeWeapon();
	}

	function onWaitTurn()
	{
		this.isManningSiegeWeapon();
	}

	function onResumeTurn()
	{
		this.isManningSiegeWeapon();
	}

	function onMovementCompleted( _tile )
	{
		this.isManningSiegeWeapon(_tile);
	}

});

