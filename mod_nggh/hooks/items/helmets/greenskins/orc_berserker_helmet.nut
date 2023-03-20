::mods_hookExactClass("items/helmets/greenskins/orc_berserker_helmet", function(obj) 
{
	// need to add set effect
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Name = "Bone Head Gear";
		this.m.Description = "A helmet made out of bones. A precious trophy of a brave warrior.";
		this.m.InventorySound = this.m.ImpactSound;
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "helmets/inventory_orc_02_helmet_01.png";
    }

    obj.onEquip <- function()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().add("berserker_helmet");
		}
	}

	obj.onUnequip <- function()
	{
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			c.getActor().getFlags().remove("berserker_helmet");
		}

		this.helmet.onUnequip();
	}

	obj.getTooltip <- function()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/morale.png",
			text = "Will always start combat at confident morale"
		});

		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return result;
		}

		if (c.getActor().getFlags().has("berserker_armor"))
		{
			result.extend([
				{
					id = 11,
					type = "text",
					text = "[u][size=14]Set effect[/size][/u]"
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Cannot be reduced to [color=" + ::Const.UI.Color.NegativeValue + "]" + ::Const.MoraleStateName[::Const.Orc.BerserkerArmorMoraleThreshold - 1] + "[/color] morale, only [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Const.MoraleStateName[::Const.Orc.BerserkerArmorMoraleThreshold] + "[/color]"
				}
			]);
		}

		return result;
	}

	obj.onUpdateProperties <- function( _properties )
	{
		this.helmet.onUpdateProperties(_properties);
		local actor = this.getContainer().getActor();

		if (!actor.getFlags().has("berserker_armor"))
		{
			return;
		}

		if (actor.getMoraleState() >= ::Const.Orc.BerserkerArmorMoraleThreshold)
		{
			return;
		}

		actor.setMoraleState(::Const.Orc.BerserkerArmorMoraleThreshold);
		actor.setDirty(true);
	}

	obj.onCombatStarted <- function()
	{
		this.helmet.onCombatStarted();
		local actor = this.getContainer().getActor();

		if (actor.getMoraleState() == ::Const.MoraleState.Ignore)
		{
			return;
		}

		actor.setMoraleState(::Const.MoraleState.Confident);
	}
});