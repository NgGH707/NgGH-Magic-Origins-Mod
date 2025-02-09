::Nggh_MagicConcept.HooksMod.hook("scripts/skills/actives/gruesome_feast", function ( q )
{
	q.getHPGain <- function()
	{
		return !::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() ? 200 : 100;
	}

	q.create = @(__original) function()
	{
		__original();
		m.Description = "Time to eat, you can\'t grow up if you can\'t get enough nutrition from corpses.";
		m.Icon = "skills/active_40.png";
		m.IconDisabled = "skills/active_40_sw.png";
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();
		ret.extend([
			{
				id = 4,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Restores [color=" + ::Const.UI.Color.PositiveValue + "]" + getHPGain() + "[/color] health points"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Instantly heals " + (!::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() ? "every" : "a random") + " [color=" + ::Const.UI.Color.PositiveValue + "]Injury[/color]"
			}
		]);

		local corpses = getCorpseInBag();

		if (corpses.len() > 0)
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "You have [color=" + ::Const.UI.Color.PositiveValue + "]" + corpses.len() + "[/color] corpse(s) in your bag"
			});
		
		if (::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() && getContainer().hasSkill("effects.swallowed_whole"))
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]So full right now, can not eat any more corpse[/color]"
			});
		
		return ret;
	}

	q.hasCorpseNearby <- function()
	{
		return getContainer().getActor().getTile().IsCorpseSpawned && getContainer().getActor().getTile().Properties.get("Corpse").IsConsumable;
	}

	q.getCorpseInBag <- function()
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

	q.isUsable = @() function()
	{
		if (!skill.isUsable())
			return false;

		if (!getContainer().getActor().isPlayerControlled())
			return true;

		if (::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue() && getContainer().hasSkill("effects.swallowed_whole"))
			return false;

		return hasCorpseNearby() || getCorpseInBag().len() > 0;
	}

	q.onAfterUpdate <- function( _properties )
	{
		m.FatigueCostMult = _properties.IsSpecializedInShields ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	q.onFeasted = @(__original) function( _effect )
	{
		local actor = _effect.getContainer().getActor();

		if (!::MSU.isKindOf(actor, "player"))
			__original(_effect);
		else {
			_effect.addFeastStack();
			_effect.getContainer().update();
			local skill = _effect.getContainer().getSkillByID("actives.gruesome_feast");
			local hp = skill != null ? skill.getHPGain() : 200;
			actor.setHitpoints(::Math.min(actor.getHitpoints() + hp, actor.getHitpointsMax()));

			foreach ( injury in _effect.getContainer().getAllSkillsOfType(::Const.SkillType.Injury) )
			{
				injury.removeSelf();

				if (::Nggh_MagicConcept.Mod.ModSettings.getSetting("balance_mode").getValue())
					break;
			}

			actor.onUpdateInjuryLayer();
		}

		if (_effect.getContainer().hasSkill("perk.nacho_eat"))
			_effect.getContainer().add(::new("scripts/skills/effects/nggh_mod_nacho_eat_effect"));
	}

	q.use <- function( _targetTile, _forFree = false )
	{
		if (getContainer().getActor().getFlags().has("luft"))
			::Nggh_MagicConcept.spawnQuote("luft_eat_quote_" + ::Math.rand(1, 5), getContainer().getActor().getTile());

		return skill.use(_targetTile, _forFree);
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		_user.getFlags().set("has_eaten", true);
		return __original(_user, _targetTile);;
	}
});