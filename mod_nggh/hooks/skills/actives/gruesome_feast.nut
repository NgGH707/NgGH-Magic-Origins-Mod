::mods_hookExactClass("skills/actives/gruesome_feast", function ( obj )
{
	obj.m.HP_Gain <- 200;
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Time to eat, you can\'t grow up if you can\'t get enough nutrition from corpses.";
		this.m.Icon = "skills/active_40.png";
		this.m.IconDisabled = "skills/active_40_sw.png";
	};
	obj.getTooltip = function()
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
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Restores [color=" + ::Const.UI.Color.PositiveValue + "]" + this.m.HP_Gain + "[/color] health points"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Instantly heals " + (::Nggh_MagicConcept.IsOPMode ? "every" : "a random") + " [color=" + ::Const.UI.Color.PositiveValue + "]Injury[/color]"
			}
		];

		local corpses = this.getCorpseInBag();

		if (corpses.len() > 0)
		{
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "You have [color=" + ::Const.UI.Color.PositiveValue + "]" + corpses.len() + "[/color] corpse(s) in your bag"
			});
		}
		
		if (!::Nggh_MagicConcept.IsOPMode && this.getContainer().hasSkill("effects.swallowed_whole"))
		{
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]So full right now, can not eat any more corpse[/color]"
			});
		}
		
		return ret;
	};
	obj.hasCorpseNearby <- function()
	{
		return this.getContainer().getActor().getTile().IsCorpseSpawned && this.getContainer().getActor().getTile().Properties.get("Corpse").IsConsumable;
	};
	obj.getCorpseInBag <- function()
	{
		return [];
		/*
		local actor = this.getContainer().getActor();
		local allItems = actor.getItems().getAllItems();
		local ret = [];

		foreach (item in allItems)
		{
			if (item.isItemType(this.Const.Items.ItemType.Corpse) && item.m.IsEdible)
			{
				ret.push(item);
			}
		}

		return ret;
		*/
	}
	obj.isUsable <- function()
	{
		if (!this.skill.isUsable())
			return false;

		if (!this.getContainer().getActor().isPlayerControlled())
			return true;

		if (!::Nggh_MagicConcept.IsOPMode && this.getContainer().hasSkill("effects.swallowed_whole"))
			return false;

		if (this.hasCorpseNearby())
			return true;
		
		return this.getCorpseInBag().len() > 0;
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInShields ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}
	obj.onAdded <- function()
	{
		this.m.HP_Gain = ::Nggh_MagicConcept.IsOPMode ? 200 : 100;
	}
	local ws_onFeasted = obj.onFeasted;
	obj.onFeasted = function( _effect )
	{
		local actor = _effect.getContainer().getActor();

		if (actor.isPlayerControlled())
		{
			_effect.addFeastStack();
			_effect.getContainer().update();
			actor.setHitpoints(::Math.min(actor.getHitpoints() + (::Nggh_MagicConcept.IsOPMode ? 200 : 100), actor.getHitpointsMax()));

			foreach ( injury in _effect.getContainer().getAllSkillsOfType(::Const.SkillType.Injury) )
			{
				injury.removeSelf();

				if (!::Nggh_MagicConcept.IsOPMode)
					break;
			}

			actor.onUpdateInjuryLayer();
		}
		else
		{
			ws_onFeasted(_effect);
		}

		if (_effect.getContainer().hasSkill("perk.nacho_eat"))
			_effect.getContainer().add(::new("scripts/skills/effects/nggh_mod_nacho_eat_effect"));
	};
	obj.onBeforeUse <- function( _user , _targetTile )
	{
		if (!_user.getFlags().has("luft"))
		{
			return;
		}
		
		::Nggh_MagicConcept.spawnQuote("luft_eat_quote_" + ::Math.rand(1, 5), _user.getTile());
	};
	local onUse = obj.onUse;
	obj.onUse = function( _user, _targetTile )
	{
		onUse(_user, _targetTile);
		_user.getFlags().set("has_eaten", true);
		return true;
	}
});