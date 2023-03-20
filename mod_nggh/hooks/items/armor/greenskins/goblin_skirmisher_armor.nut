::mods_hookExactClass("items/armor/greenskins/goblin_skirmisher_armor", function(obj) 
{
	// need to add set effect
    local ws_create = obj.create;
    obj.create = function()
    {
    	ws_create();
    	//this.m.Variants = [1, 2, 3];
    	this.m.Name = "Goblin Camouflage Outfit";
		this.m.Description = "A simple leather cloth that has been fashioned to look like bushes.";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Condition = 40;
		this.m.ConditionMax = 40;
		this.m.StaminaModifier = 0;
    }

    local ws_updateVariant = obj.updateVariant;
    obj.updateVariant = function()
    {
    	ws_updateVariant();
    	this.m.Icon = "armor/icon_goblin_04_armor_0" + this.m.Variant + ".png";
    }

    obj.onEquip <- function()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ::Nggh_MagicConcept.isHexeOrigin();
		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return;
		}

		c.getActor().getFlags().add("skirmisher_armor");
	}

	obj.onUnequip <- function()
	{
		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return;
		}

		c.getActor().getFlags().remove("skirmisher_armor");
		this.armor.onUnequip();
	}

	obj.getTooltip <- function()
	{
		local result = this.armor.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/ranged_defense.png",
			text = "[color=" + ::Const.UI.Color.PositiveValue + "]+5[/color] Ranged Defense"
		});

		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return result;
		}

		if (c.getActor().getFlags().has("skirmisher_helmet"))
		{
			result.extend([
				{
					id = 11,
					type = "text",
					text = "[u][size=14]Set effect[/size][/u]"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = "[color=" + ::Const.UI.Color.PositiveValue + "]+5[/color] Ranged Skill"
				},
				{
					id = 6,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = "[color=" + ::Const.UI.Color.PositiveValue + "]+5[/color] Ranged Defense"
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Will always start combat inside a bush"
				}
			]);
		}

		return result;
	}

	obj.onUpdateProperties <- function( _properties )
	{
		this.armor.onUpdateProperties(_properties);
		_properties.RangedDefense += 5;
		_properties.TargetAttractionMult *= 0.9;

		local actor = this.getContainer().getActor();

		if (!actor.getFlags().has("skirmisher_helmet"))
		{
			return;
		}

		_properties.RangedSkill += 5;
		_properties.RangedDefense += 5;
	}

	obj.onCombatStarted <- function()
	{
		this.armor.onCombatStarted();
		local c = this.getContainer();

		if (c == null || c.getActor() == null || c.getActor().isNull())
		{
			return;
		}

		if (!c.getActor().getFlags().has("skirmisher_armor") || !c.getActor().getFlags().has("skirmisher_helmet"))
		{
			return;
		}

		local actor = c.getActor();
		local myTile = c.getActor().getTile();

		if (!::Const.Goblin.SkirmisherArmorSpawnHiding(myTile))
		{
			return;
		}

		actor.updateVisibility(myTile, actor.getCurrentProperties().getVision(), actor.getFaction());
		actor.getSkills().add(::new(::Const.Movement.HiddenStatusEffect));
	}
});