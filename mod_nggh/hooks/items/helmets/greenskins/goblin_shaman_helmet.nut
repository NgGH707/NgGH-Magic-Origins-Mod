::mods_hookExactClass("items/helmets/greenskins/goblin_shaman_helmet", function(obj) 
{
	// need to add set effect
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	this.m.Name = "Ritual Headpiece";
		this.m.Description = "A ceremonial piece for the shaman.";
		this.m.InventorySound = ::Const.Sound.ClothEquip;
		this.m.StaminaModifier = 0;
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "helmets/inventory_goblin_02_helmet_01.png";
    }

    obj.onEquip <- function()
	{
		this.helmet.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return;
		}

		c.getActor().getFlags().add("shaman_helmet");

		if (!c.getActor().getFlags().has("shaman_armor"))
		{
			return;
		}

		local perk = ::new("scripts/skills/perks/perk_legend_mind_over_body");
		perk.m.IsSerialized = false;
		this.addSkill(perk);
	}

	obj.onUnequip <- function()
	{
		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return;
		}

		c.getActor().getFlags().remove("shaman_helmet");

		local perk = c.getActor().getSkills().getSkillByID("perk.legend_mind_over_body");

		if (perk != null && !perk.isSerialized())
		{
			c.getActor().getSkills().remove(perk);
		}

		this.helmet.onUnequip();
	}

	obj.getTooltip <- function()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]+25[/color] Resolve at morale checks against fear, panic or mind control effects."
		});

		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return result;
		}

		if (c.getActor().getFlags().has("shaman_armor"))
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
					text = "Grants [color=" + ::Const.UI.Color.PositiveValue + "]" + ::Const.Strings.PerkName.LegendMindOverBody + "[/color] perk"
				}
			]);
		}

		return result;
	}

	obj.onUpdateProperties <- function( _properties )
	{
		this.helmet.onUpdateProperties(_properties);
		_properties.MoraleCheckBravery[::Const.MoraleCheckType.MentalAttack] += 25;
	}
});