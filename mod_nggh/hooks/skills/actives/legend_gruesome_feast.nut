::mods_hookExactClass("skills/actives/legend_gruesome_feast", function ( obj )
{
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
				text = "Restores [color=" + this.Const.UI.Color.PositiveValue + "]50[/color] health points"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Instantly heal all [color=" + this.Const.UI.Color.PositiveValue + "]Injuries[/color]"
			}
		];

		local corpses = this.getCorpseInBag();

		if (corpses.len() > 0)
		{
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "You have [color=" + this.Const.UI.Color.PositiveValue + "]" + corpses.len() + "[/color] corpse(s) in your bag"
			});
		}
		
		return ret;
	};
	obj.onVerifyTarget = function( _originTile, _targetTile )
	{	
		if (_targetTile.IsEmpty)
		{
			return false;
		}

		if (_targetTile.IsCorpseSpawned && _targetTile.Properties.get("Corpse").IsConsumable)
		{
			return true;
		}

		return this.getCorpseInBag().len() > 0;
	}
	obj.onUse = function( _user, _targetTile )
	{
		_targetTile = _user.getTile();

		if (_targetTile.IsVisibleForPlayer)
		{
			if (::Const.Tactical.GruesomeFeastParticles.len() != 0)
			{
				for( local i = 0; i < ::Const.Tactical.GruesomeFeastParticles.len(); ++i )
				{
					::Tactical.spawnParticleEffect(false, ::Const.Tactical.GruesomeFeastParticles[i].Brushes, _targetTile, ::Const.Tactical.GruesomeFeastParticles[i].Delay, ::Const.Tactical.GruesomeFeastParticles[i].Quantity, ::Const.Tactical.GruesomeFeastParticles[i].LifeTimeQuantity, ::Const.Tactical.GruesomeFeastParticles[i].SpawnRate, ::Const.Tactical.GruesomeFeastParticles[i].Stages);
				}
			}

			if (_user.isDiscovered() && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " feasts on a corpse");
			}
		}

		if (this.hasCorpseNearby())
		{
			if (!_user.isHiddenToPlayer())
			{
				::Time.scheduleEvent(::TimeUnit.Virtual, 500, this.onRemoveCorpse, _targetTile);
			}
			else
			{
				this.onRemoveCorpse(_targetTile);
			}
		}
		else
		{
			//this.getCorpseInBag()[0].removeSelf();
		}

		this.spawnBloodbath(_targetTile);
		_user.setHitpoints(::Math.min(_user.getHitpoints() + 50, _user.getHitpointsMax()));
		local skills = _user.getSkills().getAllSkillsOfType(::Const.SkillType.Injury);

		foreach( s in skills )
		{
			s.removeSelf();
			break;
		}

		foreach( a in ::Tactical.Entities.getAlliedActors(_user.getFaction(), _user.getTile(), 4) )
		{
			if (a.getID() == _user.getID())
			{
				continue;
			}

			if (!::MSU.isKindOf("player", a))
			{	
				continue;
			}

			if (a.getSkills().hasSkill("effects.simp"))
			{
				continue;
			}

			if (a.getFlags().has("Hexe") || !a.getFlags().has("human") || a.getMoraleState() == ::Const.MoraleState.Ignore)
			{
				continue;
			}

			if (!a.getCurrentProperties().IsAffectedByDyingAllies || !a.getCurrentProperties().IsAffectedByFleeingAllies || a.getCurrentProperties().getBravery() >= 100)
			{
				continue;
			}

			a.getSkills().add(::new("scripts/skills/effects/legend_baffled_effect"));
			a.worsenMood(1.0, "Witnessed a brother eats a corpse");
		}

		_user.onUpdateInjuryLayer();
		return true;
	};
});