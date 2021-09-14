this.manning_siege_weapon_effect <- this.inherit("scripts/skills/skill", {
	m = {
		SiegeWeapon = null
	},
	function create()
	{
		this.m.ID = "effects.manning_siege_weapon";
		this.m.Name = "Manning a ";
		this.m.Icon = "ui/perks/perk_38.png";
		this.m.IconMini = "perk_38_mini";
		this.m.Overlay = "perk_38";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "This character is manning a " + this.m.SiegeWeapon.getName();
	}

	function onAdded()
	{
		this.m.Name = this.m.Name + this.m.SiegeWeapon.getName();
	}

	function onUpdate( _properties )
	{
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
		local skill = this.getContainer().getSkillByID("actives.manning_siege_weapon");
		skill.clear();
	}

	function onTurnStart()
	{
		this.isManningSiegeWeapon();
	}

	function onTurnEnd()
	{
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

