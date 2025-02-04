::Nggh_MagicConcept.HooksMod.hook("scripts/ui/screens/character/character_screen", function( q )
{
	q.onDismissCharacter = @(__original) function( _data )
	{
		local bro = ::Tactical.getEntityByID(_data[0]);

		if (bro != null && bro.getSkills().hasSkill("effects.simp")) {
			bro.getSkills().onDismiss();
			::World.Statistics.getFlags().increment("BrosDismissed");

			if (bro.getSkills().hasSkillOfType(::Const.SkillType.PermanentInjury))
				::World.Statistics.getFlags().increment("BrosWithPermanentInjuryDismissed");

			/*
			if (bro.getLevel() >= 11 && !::World.Statistics.hasNews("dismiss_legend") && ::World.getPlayerRoster().getSize() > 1)
			{
				local news = ::World.Statistics.createNews();
				news.set("Name", bro.getName());
				::World.Statistics.addNews("dismiss_legend", news);
			}
			else if (bro.getDaysWithCompany() >= 50 && !::World.Statistics.hasNews("dismiss_veteran") && ::World.getPlayerRoster().getSize() > 1 && ::Math.rand(1, 100) <= 33)
			{
				local news = ::World.Statistics.createNews();
				news.set("Name", bro.getName());
				::World.Statistics.addNews("dismiss_veteran", news);
			}
			else if (bro.getLevel() >= 3 && bro.getSkills().hasSkillOfType(::Const.SkillType.PermanentInjury) && !::World.Statistics.hasNews("dismiss_injured") && ::World.getPlayerRoster().getSize() > 1 && ::Math.rand(1, 100) <= 33)
			{
				local news = ::World.Statistics.createNews();
				news.set("Name", bro.getName());
				::World.Statistics.addNews("dismiss_injured", news);
			}
			*/

			bro.getItems().transferToStash(::World.Assets.getStash());
			::World.getPlayerRoster().remove(bro);
			if (::World.State.getPlayer() != null)
				::World.State.getPlayer().calculateModifiers();
			
			loadData();
			::World.State.updateTopbarAssets();
		}
		else
		{
			__original(_data);
		}
	}

	q.tactical_onQueryBrothersList = @() function()
	{
		local entities = ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player);
		local pets = ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.PlayerAnimals);

		if (entities != null && entities.len() > 0)
		{
			local activeEntity = ::Tactical.TurnSequenceBar.getActiveEntity();
			local result = [];
			local extra = [];

			foreach( entity in entities )
			{
				if (entity.isSummoned())
				{
					if (entity.isPlayerControlled() && entity.getID() == activeEntity.getID())
					{
						extra.push(entity);
					}

					continue;
				}

				result.push(::UIDataHelper.convertEntityToUIData(entity, activeEntity));
			}

			foreach( entity in pets )
			{
				if (entity.isPlayerControlled())
				{
					if (entity.getID() == activeEntity.getID())
					{
						extra.push(entity);
					}
					else
					{
						extra.insert(0, entity);
					}
				}
			}

			// add any player controled pet to the roster list in battle up to the 27th slot then stop
			// if the active entity is a player pet, it will get he priority to be added first
			foreach( entity in extra ) 
			{
			    if (result.len() >= 27)
			    {
			    	break;
			    }
			    	
			    result.push(::UIDataHelper.convertEntityToUIData(entity, activeEntity));
			}

			return result;
		}

		return null;
	}
});